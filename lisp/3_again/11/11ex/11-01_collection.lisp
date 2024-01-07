;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Zdrojový soubor k předmětu Paradigmata programování 3
;;;;
;;;; Přednáška 11, Vícenásobná dědičnost
;;;;
;;;; 11-01_collection.lisp - pomocné třídy abstract-collection a collection
;;;;

#|
abstract-collection je třída, jejíž instance uchovávají seznam položek.
Při použití třídy je nutné dodefinovat metody items a do-set-items,
které k seznamu přímo přistupují.

Jinak definuje známé metody: send-to-items, check-item, check-items, 
do-check-items, set-items). Navíc pro zajímavost metodu map-collection,
která používá třídu jako hodnotu.

Je možné použít jejího potomka collection, který definuje i chybějící
metody, nebo použít jako mixin ke třídám, které je definují po svém.

Příklad použití třídy abstract-collection jako mixinu najdete v souboru 
11-05_queue.lisp a v příkladech na konci tohoto souboru.
|#

(defclass abstract-collection ()
  ())

(defmethod send-to-items ((c abstract-collection) 
			  message
			  &rest arguments)
  (dolist (item (items c))
    (apply message item arguments))
  c)

(defmethod map-collection ((c abstract-collection) fun 
                           &optional (new-col-class (type-of c)))
  (set-items (make-instance new-col-class)
             (mapcar fun (items c))))
    
;; Potomek přepíše
(defmethod check-item ((c abstract-collection) item)
  (error "Invalid collection item: ~s" item))

(defmethod do-check-items ((c abstract-collection) items)
  (dolist (item items)
    (check-item c item)))

;; Potomek obvykle přepíše, aby volala do-check-items
(defmethod check-items ((c abstract-collection) items)
  (error "Invalid collection items: ~s" items))

(defmethod set-items ((c abstract-collection) value)
  (check-items c value)
  (do-set-items c value)
  c)

;;;
;;; Slíbená třída collection
;;;

(defclass collection (abstract-collection)
  ((items :initform '())))

(defmethod items ((c collection)) 
  (copy-list (slot-value c 'items)))

(defmethod do-set-items ((c collection) value)
  (setf (slot-value c 'items) 
        (copy-list value)))

#|

;; Příklad: kolekce čísel

(defclass number-collection (collection)
  ())

(defmethod check-items ((col number-collection) items)
  (do-check-items col items))

(setf col (set-items (make-instance 'number-collection) '(1 2 3)))
(setf col (set-items (make-instance 'number-collection) "abc"))

(defmethod check-item ((col number-collection) elem)
  (unless (numberp elem)
    (error "Item of ~s should be a number, not ~s. " col elem)))

(setf col (set-items (make-instance 'number-collection) '(a b c)))
(setf col (set-items (make-instance 'number-collection) '(1 2 3)))

(send-to-items col #'print)
(send-to-items (map-collection col #'1+) #'print)
|#