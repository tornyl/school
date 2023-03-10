
(defclass button-win (window)
	())

(defmethod ev-click ((w window) sender)
	(format t "~%Click! "))

(setf w (make-instance 'button-win))
(setf b (move  (set-button-text (make-instance 'button) "bla bla") 200 100))
(set-shape w b)
(add-event b 'ev-button-click 'ev-click)

(set-shape w (make-instance 'polygon-canvas))
(set-filledp (canvas-polygon (shape w)) t)

(defun make-circle (x y color radius filledp)
	(move (set-radius (set-color (set-filledp (make-instance 'circle) filledp) color) radius) x y))

(defun make-rectangle (x1 y1 x2 y2 x3 y3 x4 y4 filledp closedp color)
	(make-polygon (list x1 x2 x3 x4) (list y1 y2 y3 y4) filledp closedp color))

;;(set-shape w (move (make-arrow :red) 100 200))
(set-shape w (make-circle 100 300 :blue 20 t))
(set-shape w (make-rectangle 20 20 40 2 40 200 20 200 t t :gold))
