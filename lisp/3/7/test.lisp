;;(setf wn (make-instance 'window))

(setf c (make-instance 'circle))

;(set-shape wn c)
(set-radius c 50)
(set-color c :green)
(set-filledp c t)
(move c 300 200)
;(do-draw c)

(setf bul (make-instance 'bulls-eye))
(set-radius bul 80)
(set-circle-count bul 10)

(setf tr (make-instance 'triangle))
(set-filledp tr t)
(set-color tr :blue)
(set-triangle tr (move (make-instance 'point) 50 50) (move (make-instance 'point) 50 100) (move (make-instance 'point) 100 80))


;;(setf sw (make-instance 'sim-window))

;;(setf w2 (make-instance 'w2-window))

(setf w3 (make-instance 'w3-window))



(setf im (make-instance 'picture))

(set-items im (list c tr bul))


(set-shape w3 im)


;;;;;;;;;;;;;;;;;;(set-shape wn tr)

