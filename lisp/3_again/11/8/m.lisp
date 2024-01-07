;ukol 2
(defclass bounds ()
	())


(defmethod left-top ((b bounds))
	(make-point (left b) (top b)))

(defmethod left-bottom ((b bounds))
	(make-point (left b) (bottom b)))

(defmethod right-top ((b bounds))
	(make-point (right b) (top b)))

(defmethod right-bottom ((b bounds))
	(make-point (right b) (bottom b)))


;ukol 3
(defclass bounds2 ()
	((left-top :initform (make-instance 'point))
	 (left-bottom :initform (make-instance 'point))
	 (right-top :initform (make-instance 'point))
	 (right-bottom :initform (make-instance 'point))
	 (bounds-offset :initform 0)))

(defmethod bounds-offset ((b bounds2))
	(slot-value b 'bounds-offset))

(defmethod set-bounds-offset ((b bounds2) value)
	(send-with-change b 'do-set-bounds-offset value))

(defmethod do-set-bounds-offset ((b bounds2) value)
	(setf (slot-value b 'bounds-offset) value))

(defmethod left ((b bounds2))
	(- (call-next-method) (bounds-offset b)))

(defmethod right ((b bounds2))
	(+ (call-next-method) (bounds-offset b)))

(defmethod top ((b bounds2))
	(- (call-next-method) (bounds-offset b)))

(defmethod bottom ((b bounds2))
	(+ (call-next-method) (bounds-offset b)))

(defmethod left-top ((b bounds2))
	(slot-value b 'left-top))

(defmethod left-bottom ((b bounds2))
	(slot-value b 'left-bottom))

(defmethod right-top ((b bounds2))
	(slot-value b 'right-top))

(defmethod right-bottom ((b bounds2))
	(slot-value b 'right-bottom))

(defmethod change ((b bounds2)  origin msg &rest args)
	(call-next-method)
	(setf (slot-value b 'left-top) (make-point (left b) (top b)))
	(setf (slot-value b 'left-bottom) (make-point (left b) (bottom b)))
	(setf (slot-value b 'right-top) (make-point (right b) (top b)))
	(setf (slot-value b 'right-bottom) (make-point (right b) (bottom b)))
	b)

(defclass masked-shape ()
	((mask :initform nil)))

(defmethod extract-coordinates ((m masked-shape))
	(let ((coordinates))
		(when (mask m)
			(dolist (point (items (mask m)))
				(setf coordinates (cons (y point) coordinates))
				(setf coordinates (cons (x point) coordinates))))
		coordinates))

(defmethod set-mg-params ((m masked-shape) mgw)
	(call-next-method)
	(mg:set-param mgw :mask (extract-coordinates m)))

(defmethod mask ((m masked-shape))
	(slot-value m 'mask))

(defmethod check-mask ((m masked-shape) value)
	(unless (or (eql value nil) (typep value 'polygon))
		(error "mask has to be poylgon"))
	m)

(defmethod set-mask ((m masked-shape) value)
	(check-mask m value)
	(send-with-change m 'do-set-mask value)
	m)

(defmethod do-set-mask ((m masked-shape) value)
	(setf (slot-value m 'mask) value))

(defclass point1 (bounds2 circle masked-shape)
	())

(defclass circle1 (bounds2 masked-shape circle)
	())

(defclass polygon1 (bounds2 circle masked-shape)
	())



(setf w (make-instance 'window))
(setf c1 (move (set-filledp (set-color (set-radius (make-instance 'circle1) 50) :green) t) 50 100))
(setf m1 (set-closedp (set-items (make-instance 'polygon) (mapcar 'make-point (list 0 0 100 100) (list 0 100 100 0))) t))
(set-shape w c1)
