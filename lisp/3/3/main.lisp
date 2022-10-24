(defclass point ()
	((x :initform 0)
	(y :initform 0)))

(defmethod x ((point point))
  (slot-value point 'x))

(defmethod y ((point point))
  (slot-value point 'y))

(defmethod set-x ((point point) value)
  (unless (typep value 'number)
    (error "x coordinate of a point should be a number"))
  (setf (slot-value point 'x) value)
  point)

(defmethod set-y ((point point) value)
  (unless (typep value 'number)
    (error "y coordinate of a point should be a number"))
  (setf (slot-value point 'y) value)
  point)
 
(defmethod move ((pt point) dx dy)
	(set-x pt (+ (x pt) dx))
	(set-y pt (+ (y pt) dy)))


(defmethod point-copy ((pt point))
	(let ((new-pt (make-instance 'point)))
		(set-x new-pt (x pt))
		(set-y new-pt (y pt))
		new-pt))

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

; CLASS TRIANGLE

(defclass triangle ()
    ((vertex-a :initform (make-instance 'point))
    (vertex-b :initform (make-instance 'point))
    (vertex-c :initform (make-instance 'point))))

(defmethod vertex-a ((tr triangle))
	(slot-value tr 'vertex-a))
(defmethod vertex-b ((tr triangle))
	(slot-value tr 'vertex-b))
(defmethod vertex-c ((tr triangle))
	(slot-value tr 'vertex-c))


(defmethod set-triangle ((triangle triangle) a b c)
    (setf (slot-value triangle 'vertex-a) a
          (slot-value triangle 'vertex-b) b
          (slot-value triangle 'vertex-c) c)
    triangle)

(defmethod vertices ((triangle triangle))
    (copy-list (list (slot-value triangle 'vertex-a)
            (slot-value triangle 'vertex-b)
            (slot-value triangle 'vertex-c))))

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

(defmethod to-polygon ((tr triangle))
	(let* ((poly (make-instance 'polygon)))
		(set-items-poly poly (list (point-copy (vertex-a tr)) (point-copy (vertex-b tr)) (point-copy (vertex-c tr))))
		poly))

(defmethod move ((tr triangle) dx dy)
	(move (vertex-a tr) dx dy)
	(move (vertex-b tr) dx dy)
	(move (vertex-c tr) dx dy)
	tr)

; CLASS ELLIPSE

(defclass ellipse ()
	 ((focal-point-1 :initform (make-instance 'point))
	 (focal-point-2 :initform (make-instance 'point))
	 (major-semiaxis :initform 0)))

(defmethod fp1 ((ellipse ellipse))
	(point-copy (slot-value ellipse 'focal-point-1)))

(defmethod fp2 ((ellipse ellipse))
	(point-copy (slot-value ellipse 'focal-point-2)))

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



(defclass picture ()
	((items :initform '())
		(types :initform '())))

(defun list-checker (list item)
	(unless (null list)
		(or (typep item (car list)) (list-checker (cdr list) item))))

(defmethod check-item-pic ((pic picture) item)
	(unless (list-checker (slot-value pic 'types) item)
		(error "Item of pciture is incorrect type"))
	pic)

(defmethod check-items-pic ((pic picture) items)
	(dolist (item items)
		(check-item-pic pic item))
	pic)


(defmethod set-items-pic ((pic picture) value) 
  (check-items-pic pic value)
  (setf (slot-value pic 'items) (copy-list value))
  pic)

(defmethod set-types-pic ((pic picture) value) 
  (setf (slot-value pic 'types) (copy-list value))
  pic)
 
(defmethod items-pic ((pic picture)) 
  (copy-list (slot-value pic 'items)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída polygon
;;;

(defclass polygon ()
  ((items :initform '())))


;;;
;;; Vlastnost items
;;;

(defmethod check-item-poly ((poly polygon) item)
  (unless (typep item 'point) 
    (error "Items of polygon must be points."))
  poly)

(defmethod check-items-poly ((poly polygon) items)
  (dolist (item items)
    (check-item-poly poly item))
  poly)

(defmethod items-poly ((poly polygon)) 
  (copy-list (slot-value poly 'items)))

(defmethod set-items-poly ((poly polygon) value) 
  (check-items-poly poly value)
  (setf (slot-value poly 'items) (copy-list value))
  poly)





