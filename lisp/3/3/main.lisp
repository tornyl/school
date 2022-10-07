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
(defclass circle ()
	((center :initform (make-instance 'point))
	(radius :initform 1)))

(defun dist (p1 p2)
	(let ((dist-a (- (slot-value p1 'x) (slot-value p2 'x)))
			(dist-b (- (slot-value p1 'y) (slot-value p2 'y))))
		(sqrt (+ (* dist-a dist-a) (* dist-b dist-b)))))


(defclass triangle ()
    ((vertex-a :initform (make-instance 'point))
    (vertex-b :initform (make-instance 'point))
    (vertex-c :initform (make-instance 'point))))
	
(defmethod get-vertex-a ((tr triangle))
	(slot-value tr 'vertex-a)
	tr)
(defmethod get-vertex-b ((tr triangle))
	(slot-value tr 'vertex-b)
	tr)
(defmethod get-vertex-c ((tr triangle))
	(slot-value tr 'vertex-c)
	tr)

(defmethod to-polygon ((tr triangle))
	(let* ((poly (make-instance 'polygon)))
		(set-items poly (list (point-copy (get-vertex-a tr)) (point-copy (get-vertex-b tr)) (point-copy (get-vertex-c tr))))
		poly))

(defmethod point-copy ((pt point))
	(let ((new-pt (make-instance 'point)))
		(set-x new-pt (x pt))
		(set-y new-pt (y pt))
		new-pt))

(defclass picture ()
	((items :initform '())
		(types :initform '())))

(defmethod check-item ((pic picture))
	(dolist (type (slot-value pic 'types))
		(unless (typep type 

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


(defclass ellipse ()
    ((focal-point-1 :initform (make-instance 'point))
    (focal-point-2 :initform (make-instance 'point))
    (major-semiaxis :initform 0)
    (minor-semiaxis :initform 0)))

(defmethod get-fp1 ((ellipse ellipse))
	(slot-value ellipse 'focal-point-1))

(defmethod get-major-semiaxis ((ellipse ellipse))
	(slot-value ellipse 'major-semiaxis))

(defmethod to-ellipse ((circle circle) ellipse)
    (let ((x1 (slot-value (slot-value ellipse 'focal-point-1) 'x))
            (x2 (slot-value (slot-value ellipse 'focal-point-2) 'x)))
    (setf (slot-value circle 'center) (get-fp1 ellipse)
            (slot-value (slot-value circle 'center) 'x) (/ (- x2 x1) 2)
            (slot-value circle 'radius) (get-major-semiaxis ellipse))
    circle))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída polygon
;;;

(defclass polygon ()
  ((items :initform '())))


;;;
;;; Vlastnost items
;;;

(defmethod check-item ((poly polygon) item)
  (unless (typep item 'point) 
    (error "Items of polygon must be points."))
  poly)

(defmethod check-items ((poly polygon) items)
  (dolist (item items)
    (check-item poly item))
  poly)

(defmethod items ((poly polygon)) 
  (copy-list (slot-value poly 'items)))

(defmethod set-items ((poly polygon) value) 
  (check-items poly value)
  (setf (slot-value poly 'items) (copy-list value))
  poly)



