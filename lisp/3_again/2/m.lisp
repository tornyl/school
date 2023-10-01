;; classs POINT
;; operace s points
(defmethod distance ((p1 point) p2)
	(let ((difference-x (expt (- (x p1) (x p2)) 2))
			(difference-y (expt (- (y p1) (y p2)) 2)))
	 	(sqrt (+ difference-x difference-y))))

(defmethod make-copy ((p point))
	(let ((new-point (make-instance 'point)))
		(set-x new-point (x p))	
		(set-y new-point (y p))
		new-point))

(defmethod modify-by-object ((p point) object fun &optional (copy nil))
	(if copy
		(identify-object (make-copy p) object fun)
	 (identify-object p object fun)))

(defmethod identify-object ((p point) object fun)
	(when (numberp object) (do-modify-by-number p object fun))
	(when (typep object 'point) (do-modify-by-point p object fun))
	p)

(defmethod do-modify-by-number ((p point) value fun)
	(set-x p (funcall fun (x p) value))
	(set-y p (funcall fun (y p) value))
	p)

(defmethod do-modify-by-point ((p point) p2 fun)
	(set-x p (funcall fun (x p) (x p2)))
	(set-y p (funcall fun (y p) (y p2)))
	p)

(defmethod add ((p point) object &optional (copy nil))
	(modify-by-object p object #'+ copy))

(defmethod sub ((p point) object &optional (copy nil))
	(modify-by-object p p2 #'- copy))

(defmethod mult ((p point) object &optional (copy nil))
	(modify-by-object p object #'* copy))

(defmethod div ((p point) object &optional (copy nil))
	(interact p p2 #'/ copy))


(defclass triangle ()
	((vertex-a :initform (make-instance 'point)) 
	 (vertex-b :initform (make-instance 'point))
	 (vertex-c :initform (make-instance 'point))))	  

(defmethod vertex-a ((tri triangle))
	(slot-value tri 'vertex-a))

(defmethod set-vertex-a ((tri triangle) point)
	(setf (slot-value tri 'vertex-a) point)
	tri)

(defmethod vertex-b ((tri triangle))
	(slot-value tri 'vertex-b))

(defmethod set-vertex-b ((tri triangle) point)
	(setf (slot-value tri 'vertex-b) point)
	tri)

(defmethod vertex-c ((tri triangle))
	(slot-value tri 'vertex-c))

(defmethod set-vertex-c ((tri triangle) point)
	(setf (slot-value tri 'vertex-c) point)
	tri)

(defmethod vertices ((tri triangle))
	(list (vertex-a tri) (vertex-b tri) (vertex-c tri)))   

(defmethod perimeter ((tri triangle))
	(let ((line-segment-a (distance (vertex-b tri) (vertex-c tri)))
			(line-segment-b (distance (vertex-a tri) (vertex-c tri)))
			(line-segment-c (distance (vertex-a tri) (vertex-b tri))))
	  (+ line-segment-a line-segment-b line-segment-c)))
	

(defmethod right-triangle-p ((tri triangle))
	(let ((line-segment-a (distance (vertex-b tri) (vertex-c tri)))
			(line-segment-b (distance (vertex-a tri) (vertex-c tri)))
			(line-segment-c (distance (vertex-a tri) (vertex-b tri))))
	  (or (pythagorean-equation-p line-segment-a line-segment-b line-segment-c)
	  		(pythagorean-equation-p line-segment-c line-segment-b line-segment-a)
			(pythagorean-equation-p line-segment-a line-segment-c line-segment-b))))


(defmethod to-polygon ((tri triangle))
	(let ((poly (make-instance 'polygon)))
		(set-items poly (copy-list (vertices tri)))))


(defun pythagorean-equation-p (a b c)
	(= (expt c 2) (+ (expt a 2) (expt b 2))))

;; trida ELLIPSE
(defclass ellipse ()
	((focal-point-1 :initform (make-instance 'point))
	 (focal-point-2 :initform (make-instance 'point))
	 (major-semiaxis :initform 1)
	 (direction :initform 'horizontal)))

(defmethod focal-point-1 ((el ellipse))
	(slot-value el 'focal-point-1))

(defmethod focal-point-2 ((el ellipse))
	(slot-value el 'focal-point-2))


(defmethod recalculate-focal-points ((el ellipse) value)	
	(let* ((center (mult (add (focal-point-1 el) (focal-point-2 el) t) 0.5))
			 (excentricity (sqrt (- (expt value 2) (expt (minor-semiaxis el) 2)))))
		(if (eql (ell-direction el) 'horizontal)
			(horizontal-focal-points-recalculation el center excentricity)
		 (vertical-focal-points-recalculation el center excentricity))))

(defmethod horizontal-focal-points-recalculation ((el ellipse) center excentricity)
	(set-x (set-y (focal-point-1 el) (y center)) (+ (x center) excentricity))
	(set-x (set-y (focal-point-2 el) (y center)) (- (x center) excentricity))
	el)

(defmethod vertical-focal-points-recalculation ((el ellipse) center excentricity)
	(set-y (set-x (focal-point-1 el) (x center)) (+ (y center) excentricity))
	(set-y (set-x (focal-point-2 el) (x center)) (- (y center) excentricity))
	el)

(defmethod ell-direction ((el ellipse))
	(slot-value el 'direction))

(defmethod flip-direction ((el ellipse))
	(if (eql (ell-direction el) 'horizontal)
		(setf (slot-value el 'direction) 'vertical)
	 (setf (slot-value el 'direction) 'horizontal)))

(defmethod major-semiaxis ((el ellipse))
	(slot-value el 'major-semiaxis))

(defmethod set-major-semiaxis ((el ellipse) value)
	(when (< value (minor-semiaxis el) (flip-direction el)))
	(recalculate-focal-points el value)
	(setf (slot-value el 'major-semiaxis) value)
	el)

(defmethod minor-semiaxis ((el ellipse))
	(let* ((center (mult (add (focal-point-1 el) (focal-point-2 el) t) 0.5))
			 (excentricity (distance center (focal-point-1 el))))
		(sqrt (- (expt (major-semiaxis el) 2) (expt excentricity 2)))))

(defmethod set-minor-semiaxis ((el ellipse) value)
	(if (> value (major-semiaxis el))
		(progn (flip-direction el)
				 (set-major-semiaxis el value))
	 (recalculate-focal-points-by-minor-semiaxis el value)))

(defmethod recalculate-focal-points-by-minor-semiaxis ((el ellipse) value)	
	(let* ((center (mult (add (focal-point-1 el) (focal-point-2 el) t) 0.5))
			 (excentricity (sqrt (-  (expt (major-semiaxis el) 2) (expt value 2)))))
		(if (eql (ell-direction el) 'horizontal)
			(horizontal-focal-points-recalculation el center excentricity)
		 (vertical-focal-points-recalculation el center excentricity))))

(defmethod to-ellipse ((c circle))
	(let ((el (make-instance 'ellipse)))
		(set-x (focal-point-1 el) (x (center c)))
		(set-y (focal-point-1 el) (y (center c)))
		(set-x (focal-point-2 el) (x (center c)))
		(set-y (focal-point-2 el) (y (center c)))
		(set-major-semiaxis el (radius c))))

