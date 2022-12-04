(defun make-circle (color x y)
	(move (set-radius (set-filledp (set-color (make-instance 'circle) color) t) 30) x y))

(setf ins-w (make-instance 'inspected-window))
(setf ior-w (make-instance 'inspector-window))

(setf p (make-instance 'picture))
(set-items p (list (make-circle  :red 100 100) (make-circle  :blue 300 100)))

(set-shape ins-w p)
(set-inspected-window ior-w ins-w)

(print (solid-shapes-count ins-w))



