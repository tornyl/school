
(defmethod set-window ((c circle) value)
	(call-next-method)
	(set-window (center c) value))

(defclass triangle (abstract-polygon) ())

(defmethod check-items ((tr triangle) items)
	(do-check-items tr items))

(defmethod vertex-a ((tr triangle))
	(first (items tr)))
(defmethod vertex-b ((tr triangle))
	(second (items tr)))
(defmethod vertex-c ((tr triangle))
	(third (items tr)))


(defmethod set-triangle ((triangle triangle) a b c)
	(set-items triangle (list a b c)))

(defmethod vertices ((triangle triangle))
	(items triangle))

(defmethod perimeter ((triangle triangle))
    (let ((a (dist (vertex-a triangle) (vertex-b triangle)))
        (b (dist (vertex-b triangle ) (vertex-c triangle)))
        (c (dist (vertex-c triangle ) (vertex-a triangle))))
        (+ a b c)))

(defmethod right-triangle-p ((triangle triangle))
    (let ((a (dist (vertex-a triangle) (vertex-b triangle)))
        (b (dist (vertex-b triangle) (vertex-c triangle)))
        (c (dist (vertex-c triangle) (vertex-a triangle))))
        (or (= (* a a) (+ (* b b) (* b b))) 
		  		(= (* a a) (+ (* a a) (* c c))) 
				(= (* c c) (+ (* b b) (* a a))))))

(defclass ellipse (shape)
	 ((focal-point-1 :initform (make-instance 'point))
	 (focal-point-2 :initform (make-instance 'point))
	 (major-semiaxis :initform 0)
	 (phi :initform 0)))

(defmethod fp1 ((ellipse ellipse))
	(slot-value ellipse 'focal-point-1))

(defmethod fp2 ((ellipse ellipse))
	(slot-value ellipse 'focal-point-2))

(defmethod set-fp1 ((ellipse ellipse) point)
	(setf (slot-value ellipse 'focal-point-1) point))

(defmethod set-fp2 ((ellipse ellipse) point)
	(setf (slot-value ellipse 'focal-point-2) point))

(defmethod major-semiaxis ((ellipse ellipse))
	(slot-value ellipse 'major-semiaxis))

(defmethod set-major-semiaxis ((ellipse ellipse) val)
	(setf (slot-value ellipse 'major-semiaxis) val))

(defmethod phi ((el ellipse))
	(slot-value el 'phi))

(defmethod set-phi ((el ellipse) val)
	(setf (slot-value el 'phi) val)
	el)

(defmethod center ((el ellipse))
	(let ((s make-instance 'point))	
		(set-x s (/ (+ (x (fp1 el)) (x (fp2 el))) 2))
		(set-y s (/ (+ (y (fp1 el)) (y (fp2 el))) 2))
		s))

(defmethod minor-semiaxis ((el ellipse))
	(let* ((s (center el)))
		(sqrt (- (* (major-semiaxis el) (major-semiaxis el)) (* (dist s (fp1 el)) (dist s (fp1 el)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; vykreslovani

;(defmethod do-draw ((el ellipse) mgw)
;	(mg:draw-ellipse mgw (x (center el)) (y (center el)) (major-semiaxis el)  (minor-semiaxis el)  (phi el))
;	el)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; geometricke transofrmace

(defmethod move ((el ellipse) dx dy)
	(move (fp1 el) dx dy)
	(move (fp2 el) dx dy)
	el)

(defmethod rotate ((el ellipse) angle center)
	(rotate (fp1 el) angle center)
	(rotate (fp2 el) angle center)
	el)

(defmethod scale ((el ellipse) coeff center)
	(scale (fp1 el) coeff center)
	(scale (fp2 el) coeff center)
	(set-major-semiaxis el (* (major-semiaxis el) coeff))
	el)


(defun darken-color (color)(let ((color-spec (color:get-color-spec color)))(color:make-hsv (color:color-hue color-spec)(color:color-saturation color-spec)(/ (color:color-value color-spec) 2))))

(defclass sim-window (window)
 ())

 (defmethod ev-changing ((w sim-window) shape)
	(set-background w (darken-color (color shape))))

(defclass w2-window (window)
	((last-color :initform nil)
  	(last-shape :initform nil)))

(defmethod ev-changing ((w2 w2-window) shape)
	(when (slot-value w2 'last-shape)
		(print "chango")
		(do-set-color (slot-value w2 'last-shape) (slot-value w2 'last-color)))
	(setf (slot-value w2 'last-color) (color shape))
	(setf (slot-value w2 'last-shape) shape)
	(do-set-color shape :red))

;;(defmethod ev-change ((w2 w2-window) shape)
;;	(call-next-method)


(defclass w3-window (window)
	())

(defmethod ev-changing ((w3 w3-window) shape)
	(unless (capi:confirm-yes-or-no "Umožnit změnu?")
		(error "erorr here")))
