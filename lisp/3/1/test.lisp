(setf a (make-instance 'point))
(setf b (make-instance 'point))
(setf c (make-instance 'point))

(set-x a 1)
(set-y a 1)
(set-x b 5)
(set-y b 1)
(set-x c 1)
(set-y c 4)

(setf tr (make-instance 'triangle))
(set-triangle tr a b c)

(right-triangle-p tr)

(perimeter tr)

(setf el (make-instance 'ellipse))
(set-fp1 el a)
(set-fp2 el b)
(set-major-semiaxis el 5)

(major-semiaxis el)
(minor-semiaxis el)

(setf cir (make-instance 'circle))
(setf (slot-value cir 'center) c)

(to-ellipse cir)

