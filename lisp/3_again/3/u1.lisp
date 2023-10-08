(defun make-bottom (color)
	(let ((poly (make-instance 'polygon)))
		(set-filledp poly t)
		(set-thickness poly 1)
		(set-closedp poly t)
		(set-color poly color)
		(set-items poly (list (make-point 0 0)
									 (make-point 0 40)
									 (make-point 25 2)
									 (make-point 50 40)
									 (make-point 75 2)
									 (make-point 100 40)
									 (make-point 125 2)
									 (make-point 150 40)
									 (make-point 150 0)))
		poly))


(defun make-body  (color)
	(let ((poly (make-instance 'polygon)))
		(set-filledp poly t)
		(set-thickness poly 1)
		(set-closedp poly t)
		(set-color poly color)
		(set-items poly (list (make-point 0 0)
									 (make-point 0 85)
									 (make-point 150 85)
									 (make-point 150 0)))
		poly))

(defun make-head (color)
	(make-circle 0 0 75 color 1 t)) 

(defun make-eye  (&key pupil-position)
	(let ((eye (make-instance 'picture))
			(iris (make-circle 0 0 25 :white 1 t))
			(pupil (make-circle 0 0 8 :black 1 t)))
		(set-items eye (list pupil iris ))
		(move pupil (x pupil-position) (y pupil-position))
		eye))

(defun make-ghost (color scale-coeff)
	(let ((ghost (make-instance 'picture))
			(pupil-position (make-point (+ -8.5 (random 17.0)) (+ -8.5 (random 17.0)))))
		(setf bottom (move (make-bottom color) 0 85)) 
		(setf body (make-body color))
		(setf head (move (make-head color) 75 0))
		(setf left-eye (move (make-eye :pupil-position pupil-position) 45 0))
		(setf right-eye (move (make-eye :pupil-position pupil-position) 110 0))
		(set-items ghost (list left-eye right-eye bottom head body))
		(move ghost -75 -25)
		(scale ghost scale-coeff (make-point 0 0))))

(defun make-ghosts (ghost-count)
	(let ((ghosts '())
			(width 700)
			(height 500))
		(dotimes (i ghost-count t)
			(setf color (color:make-rgb (random 1.0) (random 1.0) (random 1.0)))
			(setf scale-coeff (+ 1/4 (random 0.25)))
			(setf ghost (make-ghost color scale-coeff))
			(move (rotate ghost (random (* pi)) (make-instance 'point)) (random width)  (random height)) 
			(setf ghosts (cons ghost ghosts)))
		ghosts))

(defun display-halloween-window (ghost-count)
	(let ((ghosts-picture (make-instance 'picture))
			(window (make-instance 'window)))
		(set-items ghosts-picture (make-ghosts ghost-count))
		(set-background window :black)
		(set-shape window ghosts-picture)
		(redraw window)))
