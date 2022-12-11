(setf w (make-instance 'window))
(setf bc (make-instance 'bp-circle))

(move (set-radius bc 100) 200 300)

(setf p (make-instance 'picture))

(set-items p (list  (make-bounding-rectangle bc) bc))

(set-shape w p)
