(defclass switchable-shape (compound-shape)
  ((items :initform nil)
   (active-item-index :initform nil)))

(defmethod  check-item ((ss switchable-shape) item)
  (unless (typep item 'shape)
    (error "invalid item type"))
  ss)

(defmethod check-items ((ss switchable-shape) items)
  (do-check-items ss items)
  ss)

(defmethod active-item-index ((ss switchable-shape))
  (slot-value ss 'active-item-index))

(defmethod check-active-item-index ((ss switchable-shape) value)
  (unless (or (not value) (<= 0 value (length (items ss))))
    (error "index out of bounds"))
  ss)

(defmethod set-active-item-index ((ss switchable-shape) value)
  (check-active-item-index ss value)
  (send-with-change ss 'do-set-active-item-index value)
  (send-event ss 'ev-active-item-index-change value)
  ss)

(defmethod do-set-active-item-index ((ss switchable-shape) value)
  (setf (slot-value ss 'active-item-index) value))

(defmethod active-item ((ss switchable-shape))
  (when (active-item-index ss)
    (nth (active-item-index ss) (items ss))))

(defmethod draw ((ss switchable-shape) mgw)
  (when (active-item-index ss)
    (draw (active-item ss) mgw)))

(defmethod solidp ((ss switchable-shape))
  nil)

(defmethod solid-subshapes ((ss switchable-shape))
  (when (active-item-index ss)
    (solid-shapes (active-item ss))))

(defmethod contains-point-p ((ss switchable-shape) point)
  (when (active-item-index ss)
    (contains-point-p (active-item ss))))


(defparameter *intab-shape-position* (make-point 100 100))

(defclass tab-shape (abstract-picture)
  ())
(defmethod initialize-instance ((ts tab-shape) &key)
  (call-next-method)
  (do-set-items ts (list (make-instance 'switchable-shape)
                         (make-instance 'tab-buttons)))
  (move (tab-contents ts) 100 100)
  (add-event (tab-buttons ts) 'ev-tab-click))

(defmethod active-tab-button-color ((ts tab-shape))
  (active-color (tab-buttons ts)))

(defmethod set-active-tab-button-color ((ts tab-shape) value)
  (set-active-color (tab-buttons ts) value)
  ts)

(defmethod inactive-tab-button-color ((ts tab-shape))
  (inactive-color (tab-buttons ts)))

(defmethod set-inactive-tab-button-color ((ts tab-shape) value)
  (set-inactive-color (tab-buttons ts) value)
  ts)

(defmethod tab-contents ((ts tab-shape))
  (first (items ts)))

(defmethod tab-buttons ((ts tab-shape))
  (second (items ts)))

(defmethod add-tab ((ts tab-shape) button-text shape)
  (move shape (x *intab-shape-position*) (y *intab-shape-position*))
  (set-items (tab-contents ts) (append (items (tab-contents ts)) 
                                       (list shape)))
  (add-button (tab-buttons ts) 'button button-text))

(defmethod remove-tab ((ts tab-shape) index)
  (set-items  (tab-contents ts) (remove (nth index (items (tab-contents ts))) (items (tab-contents ts))))
  (remove-button (tab-buttons ts) index))

(defmethod change-active-tab ((ts tab-shape) index)
  (set-active-item-index (tab-contents ts) index)
  (set-active-button (tab-buttons ts) index))

(defmethod tabs ((ts tab-shape))
  (mapcar (lambda (button shape) 
            (cons (button-text button) shape))	
          (items (tab-buttons ts))
          (items (tab-contents ts))))

(defmethod ev-tab-click ((ts tab-shape) sender origin index)
  (change-active-tab ts index))


(defclass tab-buttons (abstract-picture)
  ((active-color :initform :dark-blue)
   (inactive-color :initform :light-blue)))

(defmethod check-item ((tb tab-buttons) item)
  (unless (typep item 'button)
    (error "Invalid item type")))

(defmethod active-color ((tb tab-buttons))
  (slot-value tb 'active-color))

(defmethod set-active-color ((tb tab-buttons) value)
  (send-with-change tb 'do-set-active-color value)
  (update-color tb)
  tb)

(defmethod do-set-active-color ((tb tab-buttons) value)
  (setf (slot-value tb 'active-color) value))

(defmethod inactive-color ((tb tab-buttons))
  (slot-value tb 'inactive-color))

(defmethod set-inactive-color ((tb tab-buttons) value)
  (send-with-change tb 'do-set-inactive-color value)
  (udpate-color tb)
  tb)

(defmethod do-set-inactive-color ((tb tab-buttons) value)
  (setf (slot-value tb 'inactive-color) value))

(defmethod update-color ((tb tab-buttons))
	;je potreba dodelat
  ) 

(defmethod set-active-button ((tb tab-buttons) index)
  (mapcar (lambda (button) (set-color button (inactive-color tb))) 
          (remove index (items tb)))
  (set-color (nth index (items tb)) (active-color tb)))

(defmethod place ((tb tab-buttons) button)	
  (if (= (length (items tb)) 0)
      (move button 10 20)
    (move button (+ (right (car (last (items tb)))) 10) 20))
  button)

(defmethod add-button ((tb tab-buttons) type text)
  (let ((button (make-instance type)))
    (check-item tb button)
    (add-event button 'ev-button-click)
    (set-button-text button text)
    (place tb button)
    (send-with-change tb 'do-set-items (append (items tb) (list button)))))

(defmethod remove-button ((tb tab-buttons) index)
  (let ((buttons (nthcdr index (items tb)))
        (dx (- (right (nth index (items tb))) (left (nth index (items tb))))))
    (send-with-change tb 'do-set-items (remove (nth index (items tb)) (items tb)))
    (dolist (button buttons)
      (move button (- 0 dx) 0))))

(defmethod ev-button-click ((tb tab-buttons) sender)
  (send-event tb 'ev-tab-click sender (position sender (items tb))))


(defun make-polygon (x-list y-list filledp closedp color)
  (set-closedp (set-filledp
                (set-color
                 (set-items (make-instance 'polygon)
                            (mapcar 'make-point x-list y-list))
                 color)
                filledp)
               closedp))

;;; test

(setf w (make-instance 'window))
(setf pol1 (make-polygon (list 200 200 300 300) (list 300 350 350 300) nil t :red ))
(setf pol2 (make-polygon (list 0 0 100 100) (list 0 100 100 000) nil t :black ))
(setf c1 (move (set-radius (set-color (set-filledp (make-instance 'circle) t) :purple) 40) 400 20))
(setf ts (make-instance 'tab-shape))
(set-shape w ts)

(add-tab ts "poly1" pol1)
(add-tab ts "poly2" pol2)
(add-tab ts "circle1" c1)
;(remove-tab ts 1)
