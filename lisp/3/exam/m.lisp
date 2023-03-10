(defclass masked-shape ()
	((mask :initform nil)))

(defmethod checka-item ((msh masked-shape) item)
	(unless (or (typep item 'polygon) (eql item nil))
		(error "maska by mela byt tridy polygon nebo nil"))
	item)

(defmethod prepare ((msh masked-shape) polygon)
		(flatten (mapcar (lambda (p) (list (x p) (y p))) (items polygon))))

(defmethod set-mask ((msh masked-shape) mask)
	(setf (slot-value msh 'mask) (checka-item msh mask))
	msh)

(defmethod set-mg-params ((msh masked-shape) mgw)
	(call-next-method)
	(if (mask msh)
			(mg:set-param mgw :mask  (prepare msh (slot-value msh 'mask)))
		(mg:set-param mgw :mask  (slot-value msh 'mask)))
	msh)

(defmethod mask ((msh masked-shape))
	(slot-value msh 'mask))

(defmethod do-move ((msh masked-shape) dx dy)
	(when (mask msh)
		(do-move (mask msh) dx dy))
	(call-next-method))

(defmethod do-rotate ((msh masked-shape) angle center)
	(when (mask msh)
		(do-rotate (mask msh) angle center))
	(call-next-method))

(defmethod do-scale ((msh masked-shape) ceoff center)
	(when (mask msh)
		(do-scale (mask msh) coeff center))
	(call-next-method))

(defclass masked-point (masked-shape point)
	())

(defclass masked-circle (masked-shape circle)
	())

(defclass masked-polygon (masked-shape polygon)
	())

(defun flatten (l)
  (cond ((null l) nil)
        ((atom l) (list l))
        (t (loop for a in l appending (flatten a)))))
