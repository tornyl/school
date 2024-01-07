;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Příklad: 11-05_queue.lisp
;;;;

#|

Implementace fronty jako standardního objektu.

Příklad použití abstract-collection jako mixinu mimo naši grafickou knihovnu.

Třída používá třídu abstract-collection, takže na frontu lze hledět jako na kolekci prvků.
V běžných jazycích by abstract-collection bylo rozhraní, ale tím bychom se připravili
o možnost, aby v ní byla implementace (čehož tady podstatně využíváme). 

Vyžaduje načtení souborů 11-01_collection.lisp a 11-02_my-pair.lisp

|#

(defclass queue (my-pair abstract-collection)
  ())

(defun make-queue ()
  (make-instance 'queue))

;; Pomocné metody (neprozradíme uživateli):
(defmethod queue-front ((q queue))
  (my-car q))

(defmethod set-queue-front ((q queue) front)
  (set-my-car q front))

(defmethod queue-rear ((q queue))
  (my-cdr q))

(defmethod set-queue-rear ((q queue) rear)
  (set-my-cdr q rear))

(defmethod empty-queue-p ((q queue))
  (null (queue-front q)))

;; Veřejné funkce

(defmethod dequeue ((q queue))  
  (when (empty-queue-p q)
    (error "Queue is empty"))
  (prog1 (car (queue-front q))
    (set-queue-front q (cdr (queue-front q)))))

(defmethod enqueue ((q queue) el)
  (let ((new (cons el nil)))
    (if (empty-queue-p q)
        (set-queue-front q new)
      (setf (cdr (queue-rear q)) new))
    (set-queue-rear q new)
    el))

#|
Teď přijde část související s abstract-collection.
Implementujeme metodu items (všimněte si, že items jsou jinde než ve 
slotu stejného jména).
Nastavovat items bychom mohli zakázat, ale zvolíme liberálnější přístup
(někdy se může hodit inicializovat frontu naráz)

Zachováme ochranu kopírováním seznamu.
|#

(defmethod items ((q queue))
  (copy-list (queue-front q)))

;; Povolujeme nastavit items na cokoli:
(defmethod check-items ((q queue) items)
  t)

(defmethod do-set-items ((q queue) value)
  (set-my-car q (copy-list value))
  (set-my-cdr q (last (my-car q))))

#|

(setf q (make-queue))
(set-items q '(1 2 3 4))
(items q)
(dequeue q)
(items q)
(enqueue q 5)
(items q)

|#