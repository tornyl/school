
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

(test (print "tringle pos"))
(test (list (x (vertex-a tr)) (y (vertex-a tr)) (x (vertex-b tr)) (y (vertex-b tr)) (x (vertex-c tr)) (y (vertex-c tr))))
(test (left tr))
(test (right tr))
(test (top tr))
(test (bottom tr))

(test (print "circle pos"))
(test (list (x (center c1)) (y (center c1)) (radius c1)))
(test (left c1))
(test (right c1))
(test (top c1))
(test (bottom c1))


;(test (left (shape w2)))
;(test (right (shape w2)))
;(test (top (shape w2)))
;(test (bottom (shape w2)))

(test (setf g (move (make-ghost :red 0.5) 300 160)))
(test (left g))
(test (right g))
(test (top g))
(test (bottom g))

(test (setf ep (make-instance 'extended-picture)))
(test (set-items ep (list (make-circle 50 50 80 :green 1 t) (make-triangle 200 200 400 200 300 400 :yellow 1 t ) (make-triangle 50 300 150 300 200 600 :brown 1 5) )))

(test (setf disc1 (move (set-radius (set-inner-radius (set-color (set-inner-color (make-instance 'disc) :blue) :green) 70) 100) 300 300)))

(test (setf hp1 (make-instance 'hideable-picture)))
(test (set-all-items hp1 (list (make-circle 50 50 80 :green 1 t) (make-triangle 200 200 400 200 300 400 :yellow 1 t ) (make-triangle 50 300 150 300 200 600 :brown 1 5) )))
(test (set-show-items hp1 (list t t nil)))
(test (all-items hp1))
(test (show-items hp1))
(test (items hp1))

(test (setf c2 (make-circle 200 200 80 :black 1 t))) 
(test  (setf be (set-radius (set-circle-count (move (make-instance 'bulls-eye) 145 97) 7) 80)))

;(test (setf dw (make-instance 'darken-window)))
;(test (set-shape dw c2))

;(test (setf rw (make-instance 'r-window)))
;(test (set-shape rw c2))

;(test (setf r2w (make-instance 'r2-window)))
;(test (set-shape r2w ep))

;(test (setf cw (make-instance 'confirm-window)))
;(test (set-shape cw ep))

; u2 testy
(test (setf tsmp1 (move (make-instance 'semaphore) 100 100)))
(test (setf tsmp2 (move (set-semaphore-type (make-instance 'semaphore) :pedestrian) 300 100)))
(test (setf tsmp3 (move (set-semaphore-type (make-instance 'semaphore) :vehicle) 400 100)))
(test (setf tsmp4 (move (set-semaphore-type (make-instance 'semaphore) :pedestrian) 500 200)))
(test (setf tsmp5 (move (set-semaphore-type (make-instance 'semaphore) :vehicle) 600 200)))
(test (setf crs2 (set-program (set-items (make-instance 'crossroads) (list tsmp4 tsmp5 ep c2)) (list (list  0 0) (list 1 1) (list 2 0) (list 3 0)))))
(next-phase tsmp1)
(test (setf crs (set-program (set-items (make-instance 'crossroads) (list tsmp1 tsmp2 crs2 ep c2)) (list (list  0 0 0 0) (list 1 1 0 0) (list 2 0 1 2) (list 3 0 1 2)))))

;(test (set-items crs (append (items crs) (list tsmp3))))
;(next-phase crs)
;(set-program crs (list (list 0 0 1) (list 3 1 3) (list 2 0 1)))

(test (setf w (make-instance 'window)))
(test (set-shape w crs))
;(test (redraw w))

;(test (setf w2 (display-halloween-window 50)))


