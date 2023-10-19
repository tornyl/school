
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; trida SHAPE
;;;

(defmethod left ((s shape))
	s)

(defmethod right ((s shape))
	s)

(defmethod top ((s shape))
	s)

(defmethod bottom ((s shape))
	s)

;----------------------------------------------------------------------




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; trida POINT
;;;

;;;
;;; vlastnosti:
;;;
	;;perimeter -cteni

(defmethod perimeter ((p point))
	0)

(defmethod left ((p point))
	(x p))

(defmethod right ((p point))
	(x p))

(defmethod top ((p point))
	(y p))

(defmethod bottom ((p point))
	(y p))

;;;
;;; uzitecne metody:
;;;

(defmethod distance ((p1 point) p2)
	(let ((difference-x (expt (- (x p1) (x p2)) 2))
			(difference-y (expt (- (y p1) (y p2)) 2)))
	 	(sqrt (+ difference-x difference-y))))

(defmethod copy ((p point))
	(let ((new-point (make-instance 'point)))
		(set-x new-point (x p))	
		(set-y new-point (y p))
		new-point))

(defmethod modify-by-object ((p point) object fun &optional (copy nil))
	(if copy
		(identify-object (copy p) object fun)
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
	(modify-by-object p object #'- copy))

(defmethod mult ((p point) object &optional (copy nil))
	(modify-by-object p object #'* copy))

(defmethod div ((p point) object &optional (copy nil))
	(interact p object #'/ copy))
;----------------------------------------------------------------------


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; trida TRIANGLE
;;;

(defclass triangle (polygon)
	())

(defmethod initialize-instance ((tri triangle) &key)
	(call-next-method)
	(set-items tri (list (make-instance 'point) (make-instance 'point) (make-instance 'point))))

;;;
;;; vlastnosti: 
;;;
	;vertex-a -cteni 
	;vertex-b -cteni 
	;vertex-c -cteni
	;perimeter -cteni
	;right-triangle-p -cteni

(defmethod vertex-a ((tri triangle))
	(first (items tri)))

(defmethod vertex-b ((tri triangle))
	(second (items tri)))

(defmethod vertex-c ((tri triangle))
	(third (items tri)))

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


;;;
;;; Vlastnosti související s kreslením:
;;;

;;;
;;; Kresleni
;;;

;;;
;;; Geometrické transformace
;;;

;;;
;;;uzitecne metody:
;;;

(defmethod vertices ((tri triangle))
	(list (copy (vertex-a tri)) (copy (vertex-b tri)) (copy (vertex-c tri))))   

(defmethod to-polygon ((tri triangle))
	(let ((poly (make-instance 'polygon)))
		(set-items poly (vertices tri))))

(defmethod left ((tri triangle))
	(min (x (vertex-a tri)) (x (vertex-b tri)) (x (vertex-c tri))))

(defmethod right ((tri triangle))
	(max (x (vertex-a tri)) (x (vertex-b tri)) (x (vertex-c tri))))

(defmethod top ((tri triangle))
	(min (y (vertex-a tri)) (y (vertex-b tri)) (y (vertex-c tri))))

(defmethod bottom ((tri triangle))
	(max (y (vertex-a tri)) (y (vertex-b tri)) (y (vertex-c tri))))

;-------------------------------------------------------


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; trida TRIANGLE2 (potomek shape)
;;;

(defclass triangle-2(shape)
	((vertex-a :initform (make-instance 'point)) 
	 (vertex-b :initform (make-instance 'point))
	 (vertex-c :initform (make-instance 'point))))
;;;
;;; vlastnosti: 
;;;
	;vertex-a -cteni 
	;vertex-b -cteni 
	;vertex-c -cteni
	;perimeter -cteni
	;right-triangle-p -cteni

(defmethod vertex-a ((tri triangle-2))
	(slot-value tri 'vertex-a))

(defmethod vertex-b ((tri triangle-2))
	(slot-value tri 'vertex-b))

(defmethod vertex-c ((tri triangle-2))
	(slot-value tri 'vertex-c))

(defmethod perimeter ((tri triangle-2))
	(let ((line-segment-a (distance (vertex-b tri) (vertex-c tri)))
			(line-segment-b (distance (vertex-a tri) (vertex-c tri)))
			(line-segment-c (distance (vertex-a tri) (vertex-b tri))))
	  (+ line-segment-a line-segment-b line-segment-c)))

(defmethod right-triangle-p ((tri triangle-2))
	(let ((line-segment-a (distance (vertex-b tri) (vertex-c tri)))
			(line-segment-b (distance (vertex-a tri) (vertex-c tri)))
			(line-segment-c (distance (vertex-a tri) (vertex-b tri))))
	  (or (pythagorean-equation-p line-segment-a line-segment-b line-segment-c)
	  		(pythagorean-equation-p line-segment-c line-segment-b line-segment-a)
			(pythagorean-equation-p line-segment-a line-segment-c line-segment-b))))


;;;
;;; Vlastnosti související s kreslením:
;;;

;;;
;;; Kresleni
;;;

(defmethod set-mg-params ((tri triangle-2) mgw)
	(call-next-method)
	(mg:set-param mgw :closedp t)
	tri)

(defmethod triangle-coordinates ((tri triangle-2))	
  (let (coordinates)
    (dolist (point (reverse (vertices tri)))
      (setf coordinates (cons (y point) coordinates)
            coordinates (cons (x point) coordinates)))
    coordinates))

(defmethod do-draw ((tri triangle-2) mg-window)
	(mg:draw-polygon mg-window
						  (triangle-coordinates tri))
	tri)

;;;
;;; Geometrické transformace
;;;

(defmethod move ((tri triangle-2) dx dy)
	(move (vertex-a tri) dx dy)
	(move (vertex-b tri) dx dy)
	(move (vertex-c tri) dx dy)
	tri)

(defmethod rotate ((tri triangle-2) angle center)
	(rotate (vertex-a tri) angle center)
	(rotate (vertex-b tri) angle center)
	(rotate (vertex-c tri) angle center)
	tri)

(defmethod scale ((tri triangle-2) coeff center)
	(scale (vertex-a tri) coeff center)	
	(scale (vertex-b tri) coeff center)	
	(scale (vertex-c tri) coeff center)	
	tri)

;;;
;;;uzitecne metody:
;;;

(defmethod vertices ((tri triangle-2))
	(list (copy (vertex-a tri)) (copy (vertex-b tri)) (copy (vertex-c tri))))   

(defmethod to-polygon ((tri triangle-2))
	(let ((poly (make-instance 'polygon)))
		(set-items poly (vertices tri))))

(defmethod left ((tri triangle-2))
	(min (x (vertex-a tri)) (x (vertex-b tri)) (x (vertex-c tri))))

(defmethod right ((tri triangle-2))
	(max (x (vertex-a tri)) (x (vertex-b tri)) (x (vertex-c tri))))

(defmethod top ((tri triangle-2))
	(min (y (vertex-a tri)) (y (vertex-b tri)) (y (vertex-c tri))))

(defmethod bottom ((tri triangle-2))
	(max (y (vertex-a tri)) (y (vertex-b tri)) (y (vertex-c tri))))
;-------------------------------------------------------



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; trida ELLIPSE
;;;
(defclass ellipse (shape)
	((focal-point-1 :initform (make-instance 'point))
	 (focal-point-2 :initform (make-instance 'point))
	 (major-semiaxis :initform 1)
	 (direction :initform 'horizontal)))
;;;
;;;vlastnosti:
;;;

	;focal-point-1 -cteni
	;focal-point-2 -cteni
	;major-semiaxis -cteni, zapis
	;minor-semiaxis -cteni, zapis
	;center -cteni

(defmethod focal-point-1 ((el ellipse))
	(slot-value el 'focal-point-1))

(defmethod focal-point-2 ((el ellipse))
	(slot-value el 'focal-point-2))

(defmethod major-semiaxis ((el ellipse))
	(slot-value el 'major-semiaxis))

(defmethod set-major-semiaxis ((el ellipse) value)
	(when (< value (minor-semiaxis el) (flip-direction el)))
	(setf (slot-value el 'major-semiaxis) value)
	(recalculate-focal-points el value)
	el)

(defmethod minor-semiaxis ((el ellipse))
	(let* ((center (mult (add (focal-point-1 el) (focal-point-2 el) t) 0.5))
			 (excentricity (distance center (focal-point-1 el))))
		(print (y (focal-point-2 el)))
		(sqrt (- (expt (major-semiaxis el) 2) (expt excentricity 2)))))

(defmethod set-minor-semiaxis ((el ellipse) value)
	(if (> value (major-semiaxis el))
		(progn (flip-direction el)
				 (set-major-semiaxis el value))
	 (recalculate-focal-points-by-minor-semiaxis el value)))

(defmethod center ((el ellipse))
	(mult (add (focal-point-1 el) (focal-point-2 el) t) 0.5))

;;;
;;; potrebne metody k vlastnostem
;;;

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

(defmethod recalculate-focal-points-by-minor-semiaxis ((el ellipse) value)	
	(let* ((center (mult (add (focal-point-1 el) (focal-point-2 el) t) 0.5))
			 (excentricity (sqrt (-  (expt (major-semiaxis el) 2) (expt value 2)))))
		(if (eql (ell-direction el) 'horizontal)
			(horizontal-focal-points-recalculation el center excentricity)
		 (vertical-focal-points-recalculation el center excentricity))))

;;;
;;; Vlastnosti související s kreslením:
;;;

;;;
;;; Kresleni
;;;

(defmethod do-draw ((el ellipse) mg-window)
	(mg:draw-ellipse mg-window
							(x (center el))
							(y (center el))
							(major-semiaxis el)
							(minor-semiaxis el)
							0)
	el)

;;;
;;; Geometrické transformace
;;;

(defmethod move ((el ellipse) dx dy)
	(move (focal-point-1 el) dx dy)
	(move (focal-point-2 el) dx dy)
	el)

(defmethod rotate ((el ellipse) angle center) 
	(rotate (focal-point-1 el) angle center)
	(rotate (focal-point-2 el) angle center)
	el)

(defmethod scale ((el ellipse) coeff center)
	(scale (focal-point-1 el) coeff center)
	(scale (focal-point-2 el) coeff center)
	(set-major-semiaxis el (* (major-semiaxis el) coeff))
	el)

;----------------------------------------------------------------------


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;trida CIRCLE
;;;


;;;
;;;vlastnosti:
;;;
			;;perimeter -cteni

(defmethod perimeter ((c circle))
	(* 2 (* (radius c) pi)))

;;;
;;; uzitecne metody
;;;

(defmethod left ((c circle))
	(- (x (center c)) (radius c)))

(defmethod right ((c circle))
	(+ (x (center c)) (radius c)))

(defmethod top ((c circle))
	(- (y (center c)) (radius c)))

(defmethod bottm ((c circle))
	(+ (y (center c)) (radius c)))

(defmethod to-ellipse ((c circle))
	(let ((el (make-instance 'ellipse)))
		(set-x (focal-point-1 el) (x (center c)))
		(set-y (focal-point-1 el) (y (center c)))
		(set-x (focal-point-2 el) (x (center c)))
		(set-y (focal-point-2 el) (y (center c)))
		(set-major-semiaxis el (radius c))))

;----------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;trida POLYGON
;;;

;;;
;;;vlastnosti:
;;;
			;;perimeter -cteni

(defmethod perimeter ((poly polygon))
	(mapcar #'+ (mapcar #'distance (items poly) (rot-right (items poly)))))

;;;
;;; uzitecne metody
;;;

;----------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;trida PICTURE
;;;

;;;
;;;vlastnosti
;;;
			;;perimeter -cteni

(defmethod perimeter ((pic picture))
	(mapcar #'+ (mapcar (lambda (item) (perimeter item))(items pic))))

;----------------------------------------------------------------------


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;trida COMPOUND-SHAPE
;;;

;;;
;;; uzitecne metody
;;;

(defmethod left ((s compound-shape))
	(apply #'min (mapcar #'left (items s))))

(defmethod right ((s compound-shape))
	(apply #'max (mapcar #'right (items s))))

(defmethod top ((s compound-shape))
	(apply #'min (mapcar #'top (items s))))

(defmethod bottom ((s compound-shape))
	(apply #'max (mapcar #'bottom (items s))))

;----------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;trida FULL-SHAPE
;;;

(defclass full-shape ()
  ((shape :initform (set-filledp (make-instance 'circle) t))))


;;;
;;; Vlastnost shape
;;;

(defmethod check-shape ((s full-shape) item)
  (unless (or (typep item 'circle) 
              (typep item 'polygon)
				  (typep item 'triangle)
				  (typep item 'ellipse))
    (error "Invalid full-shape element type."))
  s)

(defmethod shape ((s full-shape)) 
  (slot-value s 'shape))

(defmethod set-shape ((s full-shape) value) 
  (check-shape s value)
  (setf (slot-value s 'shape) value)
  s)


;;;
;;; Kreslení
;;;

(defmethod draw ((s full-shape) mg-window)
    (draw (shape s) mg-window)
  s)


;;;
;;; Geometrické transformace
;;;

(defmethod move ((s full-shape) dx dy)
	(move (shape s) dx dy)
  s)

(defmethod rotate ((s full-shape) angle center)
    (rotate (shape s) angle center)
  s)

(defmethod scale ((s full-shape) coeff center)
    (scale (shape s) coeff center)
  s)
 

;----------------------------------------------------------------------



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;trida EMPTY-SHAPE
;;;


(defclass empty-shape ()
  ((shape :initform (make-instance 'picture))))


;;;
;;; Vlastnost shape
;;;

(defmethod check-shape ((s empty-shape) item)
  (unless (and (or (typep item 'picture)))
    (error "Invalid empty-shape element type."))
  s)

(defmethod shape ((s empty-shape)) 
  (slot-value s 'shape))

(defmethod set-shape ((s empty-shape) value) 
  (check-shape s value)
  (setf (slot-value s 'shape) value)
  s)


;;;
;;; Kreslení
;;;

(defmethod draw ((s empty-shape) mg-window)
  s)


;;;
;;; Geometrické transformace
;;;

(defmethod move ((s empty-shape) dx dy)
	(move (shape s) dx dy)
  s)

(defmethod rotate ((s empty-shape) angle center)
    (rotate (shape s) angle center)
  s)

(defmethod scale ((s empty-shape) coeff center)
    (scale (shape s) coeff center)
  s)
 
;----------------------------------------------------------------------


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;trida EMPTY-SHAPE
;;;

(defclass extended-picture (picture)
	((propagate-color-p :initform nil)))

(defmethod propagate-color-p ((pic extended-picture))
	(slot-value pic 'propagate-color-p))

(defmethod set-propagate-color-p ((pic extended-picture) value)
	(setf (slot-value pic 'propagate-color-p) value))

(defmethod set-color ((pic extended-picture) value)
	(call-next-method)
	(send-to-items pic 'set-color value))

;----------------------------------------------------------------------
