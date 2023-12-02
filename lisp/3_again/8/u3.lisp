
(defparameter *frame-size* 1)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída omg-object
;;;

(defmethod ev-mouse-double-click ((object omg-object) sender clicked button position)
	(send-event object 'ev-mouse-double-click clicked button position))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída abstract-window
;;;

(defmethod mg-window ((w abstract-window))
	(slot-value w 'mg-window))

(defmethod properties ((w abstract-window))
	(list (list 'background t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída shape
;;;

(defmethod mouse-double-click ((s shape) button position)
	(send-event s 'ev-mouse-double-click s button position)
	(print "doublke clicks"))

(defmethod properties ((s shape))
	(list (list 'color t) (list 'thickness t) (list 'filledp t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída property-box
;;;

(defclass property-box (abstract-picture)
	((offset :initform 5)))

(defmethod initialize-instance ((p property-box) &key)
	(call-next-method)
	(send-with-change p 'do-set-items (create-default-box p)))

(defmethod offset ((p property-box))
	(slot-value p 'offset))

(defmethod set-offset ((p property-box) value)
	(do-set-offset p value)
	(send-with-change p 'do-set-items (create-default-box p)))

(defmethod do-set-offset ((p property-box) value)
	(setf (slot-value p 'offset) value))

(defmethod outer ((p property-box))
	(nth (- (length (items p)) 1) (items p)))

(defmethod inner ((p property-box))
	(nth (- (length (items p)) 2) (items p)))

(defmethod properties ((p property-box))
	(butlast (items p) 2))

(defmethod add-property ((p property-box) name msg setp)
	(let ((new-property (set-setp (set-message (set-text (make-instance 'property) (format nil "~s" name)) msg) setp)))
		(add-event new-property 'ev-set-property)
		(do-set-items p (append (properties p) (list new-property (inner p) (outer p))))
		(send-with-change p 'update-position)))

(defmethod remove-all-properties ((p property-box))
	(send-with-change p 'do-set-items (list (inner p) (outer p))))

(defmethod update-position ((p property-box))
	(let ((prop-width (apply #'max (mapcar (lambda (x) (- (right x) (left x))) (properties p))))
			(prop-height (- (bottom (first (properties p))) (top (first (properties p)))))
			(y-pos nil)
			(property (car (last (properties p)))))
		(set-y (second (items (outer p))) (+ (y (first (items (outer p)))) (* (length (properties p)) prop-height) (* (offset p) 2)))
		(set-x (fourth (items (outer p))) (+ (x (first (items (outer p)))) (+ (* (offset p) 2) prop-width)))
		(set-x (set-y (third (items (outer p))) (y (second (items (outer p))))) (x (fourth (items (outer p)))))
		(align-inner p)
		;(setf y-pos (if y-pos (+ y-pos prop-height) (+ (y (first (items (inner p)))) (/ prop-height 2) 10)))
		(setf y-pos (if (= (length (properties p)) 1) 
							(+ prop-height (y (first (items (inner p)))))
						 (+ (bottom (nth (- (length (properties p)) 2) (properties p))) (/ prop-height 2))))
		(move property (x (first (items (inner p)))) y-pos)))

(defmethod align-inner ((p property-box))
		(set-y (second (items (inner p))) (- (y (second (items (outer p)))) (offset p)))
		(set-x (fourth (items (inner p))) (- (x (fourth (items (outer p)))) (offset p)))
		(set-x (set-y (third (items (inner p))) (y (second (items (inner p))))) (x (fourth (items (inner p))))))

(defmethod create-default-box ((p property-box))
	(let* ((outer-x-list '(0 0 50 50))
			(outer-y-list '(0 100 100 0))
			(diff (offset p))
			(inner-x-list (list diff diff (- 50 diff) (- 50 diff)))
			(inner-y-list (list diff (- 100 diff) (- 100 diff) diff))
			(outer (set-filledp (make-instance 'polygon) t))
			(inner (set-color (set-filledp (make-instance 'polygon) t) :lightblue)))
		(set-items outer (mapcar #'make-point outer-x-list outer-y-list))
		(set-items inner (mapcar #'make-point inner-x-list inner-y-list))
		(list inner outer)))

(defmethod ev-set-property ((p property-box) sender origin msg args)
	(send-event p 'ev-set-property origin msg args))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída property
;;;

(defclass property (text-shape)
	((msg :initform nil)
	 (setp :initform nil)))

(defmethod message ((p property))
	(slot-value p 'msg))

(defmethod set-message ((p property) value)
	(send-with-change p 'do-set-message value))

(defmethod do-set-message ((p property) value)
	(setf (slot-value p 'msg) value))

(defmethod setp ((p property))
	(slot-value p 'setp))

(defmethod set-setp ((p property) value)
	(send-with-change p 'do-set-setp value))

(defmethod do-set-setp ((p property) value)
	(setf (slot-value  p 'setp) value))

(defmethod mouse-double-click ((p property) button position)
	(call-next-method)
	(when (setp p)
		(let ((prompt (multiple-value-list (capi:prompt-for-value "Zadejte novou hodnotu"))))
			(when (cadr prompt)
				(send-event p 'ev-set-property p (message p) (list (car prompt)))))))  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída abstract-window
;;;

(defclass inspector-window (abstract-window)
	((inspected-window :initform nil)
	 (inspected-object :initform nil)))

(defmethod initialize-instance ((w inspector-window) &key)
	(call-next-method)
	(do-set-shape w (make-instance 'property-box))
	(add-event (shape w) 'ev-set-property)
	(set-inspected-window w nil))

(defmethod install-callbacks ((w inspector-window))
	(call-next-method)
	(install-double-click-callback w))

(defmethod install-double-click-callback ((w inspector-window))
	(mg:set-callback
		(mg-window w)
		:double-click (lambda (mgw button x y)
			(declare (ignore mgw))
			(window-double-click
				w 
				button
				(move (make-instance 'point) x y))))
	w)

(defmethod width ((w inspector-window))
	(car (mg:get-size (mg-window w))))

(defmethod height ((w inspector-window))
	(cadr (mg:get-size (mg-window w))))

(defmethod property-box ((w inspector-window))
	(shape w))

(defmethod inspected-window ((w inspector-window))
	(slot-value w 'inspected-window))

(defmethod set-inspected-window ((w inspector-window) value)
	(send-with-change w 'do-set-inspected-window value)
	(when value
		(set-delegate value w)
		(add-event value 'ev-mouse-down-on-object))
	(update-info w value))

(defmethod do-set-inspected-window ((w inspector-window) value)
	(setf (slot-value w 'inspected-window) value))

(defmethod inspected-object ((w inspector-window))
	(slot-value w 'inspected-object))

(defmethod update-info ((w inspector-window) object)
	(remove-all-properties (property-box w))
	(if object
		(update-info-object w object)
	 (update-info-no-object w)))

(defmethod update-info-object ((w inspector-window) object)
	(add-property (property-box w) (type-of object) nil nil)
	(dolist (property (properties object))
		(let ((mgs (if (> (length property) 2) (caddr property) (setter-name (car property))))
				(name (format nil "~s: ~s" (car property) (funcall (car property) object))))
			(add-property (property-box w) name  mgs (cadr property)))))

(defmethod update-info-no-object ((w inspector-window))
	(add-property (property-box w) "No window selected" nil nil))
 
(defmethod construct-property-box ((w inspector-window))
	(let ((p (make-instance 'picture))
			(frame (construct-frame w)))
		(set-items p (list frame))
		(move p (/ (width w) 2) (/ (height w) 2))
		p))

(defmethod construct-frame ((w inspector-window))
	(set-filledp (make-square1) t))

(defmethod window-double-click ((w inspector-window) button position)
	(let ((shape (find-clicked-shape w position)))
		(when shape
			(mouse-double-click shape button position))))

(defmethod ev-mouse-down-on-object ((w inspector-window) sender object)
	(setf (slot-value w 'inspected-object) object)
	(send-with-change w 'update-info object))

(defmethod ev-set-property ((w inspector-window) sender origin msg args)
	(apply msg (slot-value w 'inspected-object)  args))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída abstract-window
;;;

(defclass inspected-window (window)
	())

(defmethod mouse-down-no-shape ((w inspected-window) button position)
	(call-next-method)
	(send-event w 'ev-mouse-down-on-object w)
	w)

(defmethod mouse-down-inside-shape ((w inspected-window) shape button position)
	(call-next-method)
	(send-event w 'ev-mouse-down-on-object shape)
	w) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun setter-name (prop)
	(values (find-symbol (format nil "SET-~a" prop))))
