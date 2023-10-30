
(defun make-point (x y)
  (move (make-instance 'point) x y))


(defun make-circle (x y r color thickness filledp) 
  (let ((circle (make-instance 'circle)))
    (move (center circle) x y)
    (set-radius circle r)
    (set-color circle color)
    (set-thickness circle thickness)
    (set-filledp circle filledp)))

(defun make-points (coordinates)
  (let ((points '()))
    (dotimes (i (/ (length coordinates) 2))
      (setf points (append points (list (make-point (nth (* i 2) coordinates) (nth (+ (* i 2) 1) coordinates))))))
    points))

(defun make-bottom (color)
  (let ((poly (make-instance 'polygon))
        (coordinates (list 0 0 0 40 25 2 50 40 75 2 100 40 125 2 150 40 150 0)))
    (set-filledp poly t)
    (set-thickness poly 1)
    (set-closedp poly t)
    (set-color poly color)
    (set-items poly (make-points coordinates))
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
  (let* ((ghost (make-instance 'picture))
         (pupil-position (make-point (+ -8.5 (random 17.0)) (+ -8.5 (random 17.0))))
         (bottom (move (make-bottom color) 0 85)) 
         (body (make-body color))
         (head (move (make-head color) 75 0))
         (left-eye (move (make-eye :pupil-position pupil-position) 45 0))
         (right-eye (move (make-eye :pupil-position pupil-position) 110 0)))
    (set-items ghost (list left-eye right-eye bottom head body))
    (move ghost -75 -25)
    (scale ghost scale-coeff (make-point 0 0))
    ghost))

(defun make-ghosts (ghost-count)
  (let ((ghosts '())
        (width 700)
        (height 500))
    (dotimes (i ghost-count t)
      (let* ((color (color:make-rgb (random 1.0) (random 1.0) (random 1.0)))
             (scale-coeff (+ 1/4 (random 0.25)))
             (ghost (make-ghost color scale-coeff)))
        (move (rotate ghost (random (* pi)) (make-instance 'point)) (random width)  (random height)) 
        (setf ghosts (cons ghost ghosts))))
    ghosts))

(defun make-ghost-picture (ghost-count)
  (let ((ghost-picture (make-instance 'picture)))	
    (set-items ghost-picture (make-ghosts ghost-count))
    ghost-picture))

(defun display-halloween-window (ghost-count)
  (let ((window (make-instance 'window)))
    (set-background window :black)
    (set-shape window (make-ghost-picture ghost-count))
    (redraw window)
    window))


