;;(setf w (make-instance 'polygon-window))

;;(setf w (make-instance 'circle-with-arrows-window))


(setf w (make-instance 'delete-item-picture-window))

(setf p (make-instance 'picture))
(set-items p (list (move (make-arrow :red) 0 100) (move (make-arrow :red) 100 100) (move (make-arrow :red) 200 100) (move (make-arrow :red) 300 100)))

(set-shape w (move (make-arrow :red) 100 100))
