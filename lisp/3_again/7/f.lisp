(defun rot-right (list)
	(append (list (nth (- (length list) 1) list))  (butlast list 1)))

(defun pythagorean-equation-p (a b c)
	(= (expt c 2) (+ (expt a 2) (expt b 2))))

(defun make-point (x y)
	(set-x (set-y (make-instance 'point) y) x))

(defun make-triangle (x1 y1 x2 y2 x3 y3 color thickness filledp )
	(let ((triangle (make-instance 'triangle)))
		(set-x (set-y (vertex-a triangle) y1) x1)
		(set-x (set-y (vertex-b triangle) y2) x2)
		(set-x (set-y (vertex-c triangle) y3) x3)
		(set-color triangle color)
		(set-thickness triangle thickness)
		(set-filledp triangle filledp)
		triangle))

(defun make-circle (x y r color thickness filledp) 
	(let ((circle (make-instance 'circle)))
		(set-x (center circle) x)
		(set-y (center circle) y)
		(set-radius circle r)
		(set-color circle color)
		(set-thickness circle thickness)
		(set-filledp circle filledp)))


(defun make-points (coordinates)
	(let ((points '()))
		(dotimes (i (/ (length coordinates) 2))
			(setf points (append points (list (make-point (nth (* i 2) coordinates) (nth (+ (* i 2) 1) coordinates))))))
		points))

