;(setf wd (make-instance 'window))

(setf a (make-instance 'point))
(setf b (make-instance 'point))
(setf c (make-instance 'point))

(set-x a 1)
(set-y a 1)
(set-x b 50)
(set-y b 1)
(set-x c 1)
(set-y c 50)

(setf tr (make-instance 'triangle))

(set-triangle tr a b c)

(set-shape wd tr)

(redraw wd)
