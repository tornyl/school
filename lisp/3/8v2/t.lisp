
(defclass button-win (window)
	())


(defmethod ev-click ((w window) sender)
	(format t "~%Click! "))

(setf w (make-instance 'button-win))
(set-background w :grey)
(setf b (move  (set-button-text (make-instance 'butt2) "bla bla") 200 100))
(defmethod ev-button-text-change ((w button-win) sender but old-t new-t)
	(print old-t)
	(print new-t))
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
(set-shape w b)

 (setf square(set-items(make-instance'polygon)(list(make-instance'point)(move (make-instance'point) 10 0)(move (make-instance'point) 10 10)(move (make-instance'point) 0 10))))

 (set-delegate square w)

 (rotate square pi (make-instance'point))

(setf m-pic (make-instance 'picture))

 (setf rs (make-instance 'rating-stars))
 (set-max-rating rs 5)
(set-rating rs 3)


(setf rb (make-instance 'radio-button))
(setf rg (make-instance 'radio-group))

(set-items m-pic (list rs rb rg))
(set-shape w m-pic)
 (move rs 100 100)
 (move rb 100 200)
 (move rg 100 400)
(set-r-count rg 4)

