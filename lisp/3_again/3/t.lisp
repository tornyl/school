
(test (setf tr (make-instance 'triangle)))
(test (set-x (vertex-b tr) 5))
(test (set-y (set-x (vertex-c tr) 5) 8))
(test (perimeter tr))
(test (right-triangle-p tr))
(test (setf el1 (make-instance 'ellipse)))
(test (set-major-semiaxis el1 4))
(test (set-x (focal-point-1 el1) -2.62))
(test (set-x (focal-point-2 el1) 4.62))
(test (minor-semiaxis el1))
(test (setf c1 (make-instance 'circle)))
(test (set-radius c1 9))
(test (set-x (set-y (center c1) 4) 13))
(test (setf el2 (to-ellipse c1)))
(test (x (focal-point-1 el2) ))
(test (y (focal-point-1 el2) ))
(test (x (focal-point-2 el2) ))
(test (y (focal-point-2 el2) ))
(test (major-semiaxis el2))
(test (setf pl (to-polygon tr)))
(test (items pl))
(test (set-minor-semiaxis el1 2))
(test (set-minor-semiaxis el1 8))


(test (setf el2 (make-instance 'ellipse)))
(test (set-major-semiaxis el2 8))
(test (set-x (focal-point-1 el2) 1))
(test (set-x (focal-point-2 el2) 5))
(test (minor-semiaxis el2))
(test (set-minor-semiaxis el2 10))
(test (x (focal-point-2 el2)))
(test (y (focal-point-2 el2)))
(test (minor-semiaxis el2))
(test (major-semiaxis el2))

(test (setf items1 (list (make-triangle 0 0 50 50 100 50 :black 2 nil) (make-triangle 0 0 50 50 100 50 :black 2 nil) (make-triangle 0 0 50 50 100 50 :black 2 nil))))
(test (move (second items1) 100 0))
(test (move (third items1) 300 0)) 
(test (setf pic1 (make-instance 'picture)))
(test (set-items pic1 (list (to-polygon (first items1)) (to-polygon (second items1)) (to-polygon (third items1)))))

(test (setf full-shape1 (make-instance 'full-shape)))
(test (set-shape full-shape1 (make-triangle 50 50 50 200 300 200 (color:make-rgb 0.5 0.5 0.5) 3 t)))

(test (move el2 100 100))
(test (set-major-semiaxis el2 70))
;(test (move (focal-point-1 el2) -20 0))
;(test (move (focal-point-2 el2) 80 0))

;(test (setf w (make-instance 'window)))
;(test (set-shape w el2))
;(test (redraw w))

(test (setf w2 (display-halloween-window 50)))






