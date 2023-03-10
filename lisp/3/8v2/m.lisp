(defclass butt2 (button)
	())

(defmethod initialize-instance ((b butt2) &key)
	(call-next-method)
	(add-event b 'ev-button-text-change 'ev-button-text-change))

(defmethod set-button-text ((b butt2) text)
	(send-event b 'ev-button-text-change b (button-text b) text)
	(call-next-method))
	


(defclass rating-stars (abstract-picture)
	((max-rating :initform 0)
	 (rating :initform 0)))

(defmethod max-rating ((r rating-stars))
	(slot-value r 'max-rating))

(defmethod set-max-rating ((r rating-stars) new-max-rating)
	(send-with-change r 'do-set-max-rating new-max-rating)
	(update-stars r))

(defmethod do-set-max-rating ((r rating-stars) new-max-rating)
	(setf (slot-value r 'max-rating) new-max-rating))

(defmethod rating ((r rating-stars))
	(slot-value r 'rating))

(defmethod set-rating ((r rating-stars) new-rating)
	(send-with-change r 'do-set-rating new-rating)
	(update-stars r)
	(send-event r 'ev-rating-change))

(defmethod do-set-rating ((r rating-stars) new-rating)
	(setf (slot-value r 'rating) new-rating))

(defmethod make-star ((r rating-stars) position scale-coeff blank)
	(move (scale (make-polygon  (list 30 35 60 40 50 30 10 25 0 25) (list 0 20 20 30 60 40 60 30 20 20) t t (if blank :yellow :black)) scale-coeff (make-point 0 0)) (x position) (y position)))

(defmethod make-rating-setter ((r rating-stars))
;;	(move (set-radius (set-filledp (set-color (make-instance 'circle) :black) t) 50) 400 100))
	(add-event (move (set-button-text (make-instance 'button) "Change rating") 400 100) 'ev-button-click 'ev-change-rating))

(defmethod update-stars ((r rating-stars))
	(let ((stars nil)
			(star nil)
			(filled (rating r)))
		(dotimes (i (max-rating r))
			;;(setf star (list (add-event (make-star r (make-point  (* 80 i) 0) 1 (> filled 0)) 'ev-mouse-down 'ev-star-click)))
			(setf stars (append stars (list (add-event (make-star r (make-point  (* 80 i) 0) 1 (> filled 0)) 'ev-mouse-down 'ev-star-click))))
			(setf filled (- filled 1)))
		(do-set-items r (append (list (make-rating-setter r)) stars))))
		

(defmethod ev-star-click ((r rating-stars) sender clicked button position)	
	(let ((index 0))
		(dolist (item (items r))
			(when (eql item sender) 
					(set-rating r index))
			(setf index (1+ index)))))
			

(defmethod ev-change-rating ((r rating-stars) sender)
	(let ((new-val (multiple-value-list	(capi:prompt-for-value "Zadejte nove hodnoceni"))))
		(when (cadr new-val)
			(when (numberp (car new-val))
				(set-rating r (car new-val))))))


(defclass radio-point (abstract-picture)
	((size :initform 0)
	 (active :initform nil)))

(defmethod size ((r radio-point))
	(slot-value r 'size))

(defmethod set-size ((r radio-point) new-size)
	(send-with-change r 'do-set-size new-size)
	(update-items r))

(defmethod do-set-size ((r radio-point) new-size)
	(setf (slot-value r 'size) new-size))

(defmethod active ((r radio-point))
	(slot-value r 'active))

(defmethod set-active ((r radio-point) new-state)
	(send-with-change r 'do-set-active new-state)
	(update-items r))

(defmethod do-set-active ((r radio-point) new-state)
	(setf (slot-value r 'active) new-state))

(defmethod update-items ((r radio-point))
	(let ((items (list (set-color (set-radius (set-filledp (set-thickness (make-instance 'circle) 1) nil) (size r)) :blue))))
		(when (active r)
			(setf items (append items (list (set-color (set-radius (set-filledp (make-instance 'circle) t) (- (size r) (/ (size r) 4))) :blue)))))
		(when (not (null (items r)))
			(dolist (item items)
				(move item (x (center (first (items r)))) (y (center (first (items r)))))))
		(send-with-change r 'do-set-items items)))


(defclass radio-button (abstract-picture)
	((active :initform nil)))

(defmethod initialize-instance ((r radio-button) &key)
	(call-next-method)
	(do-set-items r (list (move (set-size (make-instance 'radio-point) 10) 20 20) (move (set-text (make-instance 'text-shape) "test button") 40 25))))

(defmethod radio-point ((r radio-button))
	(first (items r)))

(defmethod active ((r radio-button))
	(slot-value r 'active))

(defmethod set-active ((r radio-button) new-state)
	(set-active (radio-point r) new-state)
	(send-with-change r 'do-set-active new-state))

(defmethod do-set-active ((r radio-button) new-state)
	(setf (slot-value r 'active) new-state))

(defmethod text ((r radio-button))
	(second (items r)))

(defmethod set-text ((r radio-button) new-text)
	(send-with-change r 'do-set-text new-text))

(defmethod do-set-text ((r radio-button) new-text)
	(set-text (second (items r)) new-text))

(defmethod ev-mouse-down ((r radio-button) sender clicked button position)
	(set-active r (not (active r)))
	(call-next-method))

(defclass radio-group (abstract-picture)
	((r-count :initform 0)
	 (active :initform -1)))

(defmethod active ((r radio-group))
	(slot-value r 'active))

(defmethod set-active ((r radio-group) new-state)
	(set-active (radio-group r) new-state)
	(send-with-change r 'do-set-active new-state))

(defmethod do-set-active ((r radio-group) new-state)
	(setf (slot-value r 'active) new-state))

(defmethod r-count ((r radio-group))
	(slot-value r 'r-count))

(defmethod set-r-count ((r radio-group) new-state)
	(send-with-change r 'do-set-r-count new-state)
	(update-group r))

(defmethod do-set-r-count ((r radio-group) new-state)
	(setf (slot-value r 'r-count) new-state))

(defmethod update-group ((r radio-group))
	(let ((items nil))
		(dotimes (n (r-count r))
			(setf items (append items (list (move (make-instance 'radio-button) 0 (* n 50))))))
		(do-set-items r items)))
			

