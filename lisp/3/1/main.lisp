(defclass point ()
	((x :initform 0)
	(y :initform 0)))

(defmethod set-x ((pt point) val)
	(setf (slot-value pt 'x) val)
	pt)

(defmethod set-y ((pt point) val)
	(setf (slot-value pt 'y) val)
	pt)

(defmethod x ((pt point))
	(slot-value pt 'x))

(defmethod y ((pt point))
	(slot-value pt 'y))

(defclass circle ()
	((center :initform (make-instance 'point))
	(radius :initform 1)))

(defmethod center ((circle circle))
	(slot-value circle 'center))

(defmethod r ((circle circle))
	(slot-value circle 'radius))

(defmethod to-ellipse ((circle circle))
    (let (( el (make-instance 'ellipse))
	 		(sec-point (make-instance 'point)))
	 	(set-fp1 el (center circle))
		(set-x sec-point (x (center circle)))
		(set-y sec-point (y (center circle)))
	 	(set-fp2 el sec-point)
		(set-major-semiaxis el (r circle))
		el))

(defun dist (p1 p2)
	(let ((dist-a (- (slot-value p1 'x) (slot-value p2 'x)))
			(dist-b (- (slot-value p1 'y) (slot-value p2 'y))))
		(sqrt (+ (* dist-a dist-a) (* dist-b dist-b)))))


(defclass triangle ()
    ((vertex-a :initform (make-instance 'point))
    (vertex-b :initform (make-instance 'point))
    (vertex-c :initform (make-instance 'point))))

(defmethod set-triangle ((triangle triangle) a b c)
    (setf (slot-value triangle 'vertex-a) a
          (slot-value triangle 'vertex-b) b
          (slot-value triangle 'vertex-c) c)
    triangle)

(defmethod vertices ((triangle triangle))
    (list (slot-value triangle 'vertex-a)
            (slot-value triangle 'vertex-b)
            (slot-value triangle 'vertex-c)))

(defmethod perimeter ((triangle triangle))
    (let ((a (dist (slot-value triangle 'vertex-a) (slot-value triangle 'vertex-b)))
        (b (dist (slot-value triangle 'vertex-a) (slot-value triangle 'vertex-c)))
        (c (dist (slot-value triangle 'vertex-b) (slot-value triangle 'vertex-c))))
        (+ a b c)))

(defmethod right-triangle-p ((triangle triangle))
    (let ((a (dist (slot-value triangle 'vertex-a) (slot-value triangle 'vertex-b)))
        (b (dist (slot-value triangle 'vertex-a) (slot-value triangle 'vertex-c)))
        (c (dist (slot-value triangle 'vertex-b) (slot-value triangle 'vertex-c))))
        (or (= (* a a) (+ (* b b) (* b b))) 
		  		(= (* a a) (+ (* a a) (* c c))) 
				(= (* c c) (+ (* b b) (* a a))))))


(defclass ellipse ()
    ((focal-point-1 :initform (make-instance 'point))
    (focal-point-2 :initform (make-instance 'point))
    (major-semiaxis :initform 0)))

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

(defmethod minor-semiaxis ((el ellipse))
	(let* ((s (make-instance 'point)))
		(set-x s (/ (+ (x (fp1 el)) (x (fp2 el))) 2))
		(set-y s (/ (+ (y (fp1 el)) (y (fp2 el))) 2))
		(sqrt (- (* (major-semiaxis el) (major-semiaxis el)) (* (dist s (fp1 el)) (dist s (fp1 el)))))))

