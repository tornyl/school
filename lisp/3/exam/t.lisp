

(defun make-circle (x y color radius filledp)
	(move (set-radius (set-color (set-filledp (make-instance 'masked-circle) filledp) color) radius) x y))

(defun make-rectangle (x1 y1 x2 y2 x3 y3 x4 y4 filledp closedp color)
	(make-polygon (list x1 x2 x3 x4) (list y1 y2 y3 y4) filledp closedp color))


(setf w (make-instance 'window))
;;(setf c (make-circle 50 50 :blue 200 t))
(setf c2 (make-circle 50 50 :blue 200 t))
(setf p2 (make-polygon '(20 100 100 20) '(20 20 100 100) nil t :red))
;;(setf p3 (set-closedp (set-filledp (set-color (set-items (make-instance 'masked-polygon) (mapcar 'make-point '(40 30 200 120 300) '(20 20 100 100 150))) :green) t) t))
(print "ugo")
(print c2)
(set-mask c2 p2)
;;(set-mask c '(20 20  100 20 100 100 20 100))
(setf pol (make-rectangle 20 20 300 20 300 200 20 200 t t :gold))
;;(mg:set-param (slot-value w 'mg-window) :mask '(50 50  80 100 30 100))
(set-shape w c2)

