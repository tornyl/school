; UKOL 1, 2
(defclass button2 (button)
	())

(defmethod set-button-text ((b button2) text)
	(send-event b 'ev'button-text-change b (button-text b) text)
	(call-next-method))


; UKOL 3
(defclass test-delegate (omg-object) ())
	(defmethod ev-changing ((d test-delegate) sender origin msg &rest args)
		(format t "~%Proběhne změna.") 
	d)

(defmethod ev-change ((d test-delegate) sender origin msg &rest args)
	(format t "~%Proběhla změna.")
	d)


; UKOL 4

(defparameter *star-split* 12)
(defparameter *star-size*  10)

(defun make-star (r n)
	(let ((x-list '())
			(y-list '()))
		(dotimes (i (- n 0))
			(push  (* (if (evenp i) r (/ r 1.8)) (cos (* (/ (* 2 pi) n) i))) x-list)
			(push  (* (if (evenp i) r (/ r 1.8)) (sin (* (/ (* 2 pi) n) i))) y-list))
		(make-polygon x-list y-list nil t :black)))

(defclass rating-stars (abstract-picture)
	((max-rating :initform 0)
	 (rating :initform 0)
	 (on-color :initform :black)
	 (off-color :initform :lightgrey)
	 (position :initform (make-instance 'point))))

(defmethod max-rating ((rs rating-stars))
	(slot-value rs 'max-rating))

(defmethod check-max-rating ((rs rating-stars) value)
	(unless (and (<= 0 (rating rs) value))
		(error "max-rating cannot be negativ")))

(defmethod do-set-max-rating ((rs rating-stars) value)
	(setf (slot-value rs 'max-rating) value))

(defmethod set-max-rating ((rs rating-stars) value)
	(check-max-rating rs value)
	(send-with-change rs 'do-set-max-rating value)
	(update-stars rs))

(defmethod rating ((rs rating-stars))
	(slot-value rs 'rating))

(defmethod check-rating ((rs rating-stars) value)
	(unless (<= 0 value (max-rating rs))
		(error "value is not withhin range")))

(defmethod do-set-rating ((rs rating-stars) value)
	(setf (slot-value rs 'rating) value))

(defmethod set-rating ((rs rating-stars) value)
	(check-rating rs value)
	(send-with-change rs 'do-set-rating value)
	(send-event rs 'ev-rating-change)
	(update-stars rs))

(defmethod arrange-star ((rs rating-stars) i rating)
	(let ((star nil))	
		(setf star (set-filledp (move (make-star *star-size* *star-split*) (+ (* i *star-size* 2) (* i *star-size* 0.25)) 0) t))
		(move star (x (slot-value rs 'position)) (y (slot-value rs 'position))) 
		(if (< i rating)
			(set-color star (slot-value rs 'on-color))
		 (set-color star (slot-value rs 'off-color)))
		star))

(defmethod update-stars ((rs rating-stars) &optional (r nil))
	(let* ((new-stars '())
			 (max-r (max-rating rs))	
			 (rating (if r r (rating rs))))
		(dotimes (i max-r)	
			(push (arrange-star rs i rating) new-stars))
		(send-with-change rs 'do-set-items (reverse new-stars))))

(defmethod move ((rs rating-stars) dx dy)
	(call-next-method)
	(move (slot-value rs 'position) dx dy))

(defmethod ev-mouse-down ((rs rating-stars) sender origin button position)
	(call-next-method)
	(set-rating rs (+ 1 (position sender (items rs)))))

(defmethod ev-mouse-enter ((rs rating-stars) sender origin button position)
	(call-next-method)
	(update-stars rs (+ 1 (position origin (items rs)))))

(defmethod ev-mouse-leave ((rs rating-stars) sender origin button position)
	(call-next-method)
	(set-rating rs (rating rs)))

(defclass rated-object (abstract-picture)
	())

(defmethod initialize-instance ((ro rated-object) &key)
	(call-next-method)
	(do-set-items ro (list (make-instance 'text-shape) (make-instance 'rating-stars)))
	(add-event (second (items ro)) 'ev-rating-change)
	(scale (set-name ro "default") 10 (make-point 0 0))
	(set-max-rating ro 5)
	(move (second (items ro)) 0 (* 7 (bottom (first(items ro))))))

(defmethod name ((ro rated-object))
	(text (first (items ro))))

(defmethod set-name ((ro rated-object) text)
	(set-text (first (items ro)) text)
	ro)

(defmethod rating ((ro rated-object))
	(rating (second (items ro))))

(defmethod set-max-rating ((ro rated-object) max-rating)
	(set-max-rating (second (items ro)) max-rating)
	ro)

(defmethod set-rating ((ro rated-object) rating)
	(set-rating (second (items ro)) rating)
	ro)

(defmethod ev-rating-change ((ro rated-object) sender)
	(send-event ro 'ev-rating-change))


(defclass film-collection (abstract-picture)
	((max-rating :initform 0)
	 (pos :initform (make-instance 'point))))

(defmethod initialize-instance ((fc film-collection) &key)
	(call-next-method)
	(do-set-items fc (list (set-text (make-instance 'text-shape) "Lowest rated film: Not enough data")
								  (set-text (make-instance 'text-shape) "Average rating : Not enough data")
								  (set-text (make-instance 'text-shape) "Highest rated film: Not enough data")))
	(arrange-statistics fc)
	(setf (slot-value fc 'max-rating) 5))

(defmethod text-lowest ((fc film-collection))
	(first (items fc)))

(defmethod text-average ((fc film-collection))
	(second (items fc)))

(defmethod text-highest ((fc film-collection))
	(third (items fc)))

(defmethod films ((fc film-collection))
	(cdddr (items fc)))

(defmethod pos ((fc film-collection))
	(slot-value fc 'pos))

(defmethod contains-film-p ((fc film-collection) name)
	(find name (mapcar #'name (films fc))))

(defmethod check-film ((fc film-collection) name rating)
	(unless (and (<= 0 rating (slot-value fc 'max-rating)) (not (contains-film-p fc name)))
		(error "film has been already added or rating is out of range")))

(defmethod update-statistics ((fc film-collection))
	(calc-statistics fc)
	(arrange-statistics fc))

(defmethod add-film ((fc film-collection) name rating)
	(let ((film nil)
			(x (if (films fc) (right (car (last (films fc)))) (x (pos fc))))
			(y (if (films fc) (top (car (last (films fc)))) (y (pos fc)))))
		(check-film fc name rating)
		(setf film (set-rating (set-name (set-max-rating (make-instance 'rated-object) (slot-value fc 'max-rating)) name) rating))
		(add-event film 'ev-rating-change)
		(move film x y)
		(send-with-change fc 'do-set-items (append (items fc) (list film)))
		(update-statistics fc)))


(defmethod calc-statistics ((fc film-collection))
	(let ((lw-f nil)
			(avg-r 0)
			(hg-f nil))
		(dolist (film (films fc))
			(when (or (not lw-f) (< (rating film) (rating lw-f))) (setf lw-f film))
			(when (or (not hg-f) (> (rating film) (rating hg-f))) (setf hg-f film))
			(setf avg-r (+ avg-r (rating film))))
		(when (not (= avg-r 0))
			(setf avg-r (/ avg-r (length (films fc)))))
		(set-text (text-lowest fc) (format nil "Lowest rated film is:~s" (name lw-f)))
		(set-text (text-average fc) (format nil "Average film rating is:~s" avg-r))
		(set-text (text-highest fc) (format nil "Highest rated film is:~s" (name hg-f)))))


(defmethod arrange-statistics ((fc film-collection))
	(let ((x (if (films fc) (left (first (films fc))) 0))
			(y (if (films fc) (bottom (car (last (films fc)))) 0)))
		(move (text-lowest fc) x y)
		(move (text-average fc) x (+ y (- (bottom (text-lowest fc)) (top (text-lowest fc)))))
		(move (text-highest fc) x (+ y (- (bottom (text-average fc)) (top (text-lowest fc)))))))


(defmethod ev-rating-change ((fc film-collection) sender)
	(calc-statistics fc))

(defmethod move ((fc film-collection) dx dy)
	(call-next-method)
	(move (pos fc) dx dy))




(defclass mouse-over-test-window (window)
	())

(defmethod ev-mouse-enter ((w mouse-over-test-window) sender origin button position)
	(call-next-method)
	(format t "~s\n" origin))

(defmethod ev-mouse-leave ((w mouse-over-test-window) sender origin button position)
	(call-next-method)
	(format t "~s\n" origin))



	; ukol 7


(defclass radio-button (abstract-picture)
	((active :initform nil)
	 (circle-size :initform 15)))

(defmethod initialize-instance ((rb radio-button) &key)
	(call-next-method)
	(send-with-change rb 'do-set-items (list (make-circle 0 0 (* (circle-size rb) 2/3) (color rb) 1 t)
							  (make-circle 0 0 (circle-size rb) (color rb) 3 nil)
							  (move (set-text  (make-instance 'text-shape) "button") (* (circle-size rb) 2) 5))))

(defmethod active ((rb radio-button))
	(slot-value rb 'active))

(defmethod set-active ((rb radio-button) value)
	(send-with-change rb 'do-set-active value)
	rb)

(defmethod do-set-active ((rb radio-button) value)
	(setf (slot-value rb 'active) value))

(defmethod toggle ((rb radio-button))
	(send-with-change rb 'do-toggle)
	rb)

(defmethod do-toggle ((rb radio-button))
	(setf (slot-value rb 'active) (not (slot-value rb 'active))))

(defmethod set-color ((rb radio-button) color)
	(call-next-method)
	(send-with-change rb 'send-to-items 'set-color color)
	rg)

(defmethod button-text ((rb radio-button))
	(text (car (last (items rb)))))

(defmethod set-button-text ((rb radio-button) text)
	(set-text (car (last (items rb))) text)
	rb)

(defmethod circle-size ((rb radio-button))
	(slot-value rb 'circle-size))

(defmethod set-circle-size ((rb radio-button) value)
	(send-with-change rg 'do-set-circle-size value))

(defmethod do-set-circle-size ((rb radio-button) value)
	(setf (slot-value rb 'circle-size) value))

(defmethod items ((rb radio-button))
	(if (active rb)
		(copy-list (slot-value rb 'items))
	 (copy-list (cdr (slot-value rb 'items)))))

(defmethod do-move ((rb radio-button) dx dy)
	(toggle rb)
	(call-next-method)
	(toggle rb))
	
(defmethod ev-mouse-down ((rb radio-button) sender clicked button positon)
	(call-next-method)
	(send-event rb 'ev-active-change (active rb)))



(defclass radio-group (abstract-picture)
	((buttin-count :initform 2)
	 (pos :initform (make-instance 'point))))

(defmethod initialize-instance ((rg radio-group) &key)
	(call-next-method)
	(send-with-change rg 'do-set-items (make-buttons rg 2)))

(defmethod make-buttons ((rg radio-group) count)
	(let ((buttons nil)
			(button nil)
			(dx 0)
			(dy 0))
		(dotimes (i count)
			(setf button (set-button-text (move (make-instance 'radio-button) 
															(if button (+ (left button) (circle-size button)) 0) 
															(if button (+ (bottom button) (- (bottom button) (top button))) 0))
									(format nil "button ~s" (+ i 1))))
			(add-event button 'ev-active-change)
			(unless buttons 
				(move button (x (pos rg)) (y (pos rg))))
			(setf buttons (append buttons (list button))))
		buttons))
											

(defmethod button-count ((rg radio-group))
	(apply #'+ (mapcar (lambda (x) 
								(if (typep x 'radio-button) 
									1 
								 0)) 
						(items rg))))

(defmethod set-button-count ((rg radio-group) count)
	(send-with-change rg 'do-set-items (make-buttons rg count)))

(defmethod buttons ((rg radio-group))
	(remove-if (lambda (x) (not (typep x 'radio-button))) (items rg)))

(defmethod pos ((rg radio-group))
	(slot-value rg 'pos))

(defmethod do-move ((rg  radio-group) dx dy)
	(call-next-method)
	(move (pos rg) dx dy))

(defmethod ev-active-change ((rg radio-group) sender active)
	(switch rg sender))

(defmethod switch ((rg radio-group) from)
	(unless (active from)
		(toggle from)
		(mapcar (lambda (x) (set-active x nil)) (remove from (buttons rg)))))




; ukol 9
	
(defclass select-window (window)
	((selection :initform nil)
	 (bound :initform (make-instance 'polygon))))

(defmethod initialize-instance  ((w select-window) &key)
	(call-next-method)
	(set-closedp (set-thickness (bound w) 10) t)
	(set-delegate (bound w) w))

(defmethod selection ((w select-window))
	(slot-value w 'selection))

(defmethod do-set-selection ((w select-window) shape)
	(setf (slot-value w 'selection) shape))

(defmethod bound ((w select-window))
	(slot-value w 'bound))

(defmethod bound-thickness ((w select-window))
	(thickness (bound w)))

(defmethod set-bound-thickness ((w select-window) thickness)
	(set-thickness (bound w) thickness))

(defmethod mouse-down-inside-shape ((w select-window)  shape button position)
	(call-next-method)
	(do-set-selection w shape)
	(send-with-change w 'construct-bound shape)
	w)

(defmethod mouse-down-no-shape ((w select-window) button position)
	(send-with-change w 'do-set-selection nil)
	w)

(defmethod construct-bound ((w select-window) shape)
	(let ((x1 (- (left shape) (bound-thickness w)))
			(x2 (+ (right shape) (bound-thickness w)))
			(y1 (- (top shape) (bound-thickness w)))
			(y2 (+ (bottom shape) (bound-thickness w))))
	(set-items (bound w) (mapcar 'make-point (list x1 x1 x2 x2)
														  (list y1 y2 y2 y1))))
	w)

(defmethod redraw ((w select-window))
	(call-next-method)
	(let ((mgw (slot-value w 'mg-window)))
		(when (selection w)
			(draw (bound w) mgw)))
	w)
	

