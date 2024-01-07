(defun rot-right (list)
	(append (list (nth (- (length list) 1) list))  (butlast list 1)))

(defun pythagorean-equation-p (a b c)
	(= (expt c 2) (+ (expt a 2) (expt b 2))))

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
		(move circle x y)
		(set-radius circle r)
		(set-color circle color)
		(set-thickness circle thickness)
		(set-filledp circle filledp)))


(defun make-points (coordinates)
	(let ((points '()))
		(dotimes (i (/ (length coordinates) 2))
			(setf points (append points (list (make-point (nth (* i 2) coordinates) (nth (+ (* i 2) 1) coordinates))))))
		points))

(defun make-point (x y)
  (move (make-instance 'point) x y))

(defun make-polygon (x-list y-list filledp closedp color)
  (set-closedp (set-filledp
                (set-color
                 (set-items (make-instance 'polygon)
                            (mapcar 'make-point x-list y-list))
                 color)
                filledp)
               closedp))

(defun make-arrow (color)
  (make-polygon '(0 0 30 30 0 0 -30)
                '(-30 -15 -15 15 15 30 0)
                t
                t
                color))


(defun make-triangle1 ()
	(make-polygon (list 0  0 100) (list 0 50 50) nil t :black))

(defun make-square1 ()
	(make-polygon (list 0 0 100 100) (list 0 100 100 0) nil t :black))

(defun make-circle1 ()	
	(make-circle  0 0 50 :black 1 nil))
