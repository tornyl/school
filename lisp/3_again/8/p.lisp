(defclass switchable-shape (compound-shape)
	((items :initform nil)
	 (active-item-index :initform nil)))

(defmethod  check-item ((ss switchable-shape) item)
	(unless (typep item 'shape)
		(error "wrong item type")))

(defmethod check-items ((ss switchable-shape) items)
	(do-check-items ss items))

(defmethod active-item-index ((ss switchable-shape))
	(slot-value ss 'active-item-index))

(defmethod check-active-item-index ((ss switchable-shape) value)
	(unless (or (not value) (<= 0 value (length (items ss))))
		(error "wrong index")))

(defmethod set-active-item-index ((ss switchable-shape) value)
	(check-active-item-index ss value)
	(send-event ss 'ev-active-item-change value)
	(send-with-change ss 'do-set-active-item-index value))

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


(defclass tab-shape (abstract-picture)
	((tab-on-color :initform :dark-blue)
	 (tab-off-color :initform :light-blue)))

(defmethod initialize-instance ((ts tab-shape) &key)
	(call-next-method)
	(do-set-items ts (list (make-instance 'switchable-shape)))
	(move (first (items ts)) 0 100))

(defmethod tab-on-color ((ts tab-shape))
	(slot-value ts 'tab-on-color))

(defmethod tab-off-color ((ts tab-shape))
	(slot-value ts 'tab-off-color))

(defmethod add-tab ((ts tab-shape) button-text shape)
	(move shape 100 100)
	(set-items (first (items ts)) (append (items (first (items ts))) (list shape)))
	(let ((b (make-instance 'button)))
		(add-event b 'ev-button-click)
		(set-button-text b button-text)
		(if (<= (length (items ts)) 1)
			(move b 10 20)
		 (move b (+ (right (car (last (items ts)))) 10) 20))
		(send-with-change ts 'do-set-items (append (items ts) (list b)))))

(defmethod change-active-tab ((ts tab-shape) index)
	(set-active-item-index (first (items ts)) index)
	(mapcar (lambda (button) (set-color button (tab-off-color ts))) (remove index (cdr (items ts))))
	(set-color (nth index (cdr (items ts))) (tab-on-color ts)))

(defmethod tabs ((ts tab-shape))
	(mapcar (lambda (button shape) 
					(cons (button-text button) shape))
		
		(cdr (items ts))
		(items (first (items ts)))))

(defmethod ev-button-click ((ts tab-shape) sender)
	(change-active-tab ts (- (position sender (items ts)) 1)))

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
(setf ss1 (make-instance 'switchable-shape))
;(set-items ss1 (list pol1 pol2 c1))
;(set-shape w ss1)
(setf ts (make-instance 'tab-shape))
(set-shape w ts)

(add-tab ts "poly1" pol1)
(add-tab ts "poly2" pol2)
(add-tab ts "circle1" c1)


;(mapcar #'slot-definition-name
;                      (class-direct-slots (class-of (make-instance 'shape))))


;ukol cliboard-picture


(defun setter-name (prop)
	(values (find-symbol (format nil "SET-~a" prop))))


(defmethod duplicate2 ((s shape))
	(let* ((new-s (make-instance (type-of s)))
			(slots (mapcar #'slot-definition-name
                      (class-slots (class-of new-s))))
			(setter nil))
		(print slots)
		(print (type-of (first slots)))
		;(format "sis ~a" (first slots))
		(dolist (slot slots)
			(print "a")
			(setf setter (setter-name slot))
			(when setter 
				(print "b")
				(ignore-errors (funcall setter new-s (funcall slot s)))))
		new-s))

(defmethod duplicate ((s shape))
	(let* ((new-s (make-instance (type-of s)))
			(slot-names (mapcar #'slot-definition-name
                      (class-slots (class-of new-s)))))
		(dolist (slot-name slot-names)
			(setf (slot-value new-s slot-name) (slot-value s slot-name)))
		new-s))

(setf ts2 (duplicate2 ts))
(set-shape w ts2)
