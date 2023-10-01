
(test (setf tr (make-instance 'triangle)))
(test (set-vertex-b tr (set-x (make-instance 'point) 5)))
(test (set-vertex-c tr (set-y (set-x (make-instance 'point) 5) 8)))
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






