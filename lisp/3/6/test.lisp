(setf w (make-instance 'window))
(set-background w :white)

(setf d (make-instance 'disc))
(set-radius d 100)
(set-inner-radius d 50)
(set-color d :red)
(set-inner-color d :black)
(move d 100 100)

(setf testc (move (set-radius (set-filledp (make-instance 'circle) t) 50) 100 100))

(setf hp (make-instance 'hideable-picture))


(setf cc1 (move (set-radius (set-filledp (make-instance 'circle) t) 50) 100 100))
(setf cc2 (move (set-radius (set-filledp (make-instance 'circle) t) 50) 200 100))
(setf cc3 (move (set-radius (set-filledp (make-instance 'circle) t) 50) 300 100))
(set-all-items hp (list  cc1 cc2 cc3))
(set-show-items hp (list t nil t))

)(set-shape w hp)

(redraw w)
