(setf wn (make-instance 'window))

(setf c (make-instance 'circle))

(set-shape wn c)
(set-radius c 50)
(set-color c :red)
;(set-filledp c t)
(move c 100 100)
;(do-draw c)

(setf tr (make-instance 'triangle))

(set-shape wn tr)

