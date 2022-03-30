(let ((x 1))
(let ((x x))
(setf x 2)
(print x))
x)

(defmacro my-incf (variable)
    `(setf ,variable (+ ,variable 1)))

(defmacro swap (a b)
	(let ((c (gensym)))
		`(let ((,c  ,a))
     		(setf ,a ,b)
     		(setf ,b ,c))))

(setf a 4)
(print a)
(my-incf a)
(print a)
(setf b 3)
(swap a b)
(print a)
(print b)
(print "haloo")

(defun make-point (x y)
    (lambda (what &optional val)
        (cond ((eql what 'x ) x)
              ((eql what 'y ) y)
              ((eql what 'set-x) (setf x val))
              ((eql what 'set-y) (setf y val))
              ((eql what 'point) t)
              (t nil))))

(defun x (point)
    (funcall point 'x))

(defun y (point)
    (funcall point 'y))

(defun set-x (point val)
    (funcall point 'set-x val))
(defun set-y (point val)
    (funcall point 'set-y val))
(defun pointp (point)
    (funcall point 'point))
(defun distance (point1 point2) 
    (sqrt (+ (expt (- (x point1) (x point2)) 2) (expt (- (y point1) (y point2)) 2))))

(defun make-circle (center radius)
	(lambda (what &optional val)
		(case what 
			(center (cons (x center) (y center)))
			(radius radius)
			(set-radius (setf radius val)))))

(defun center (circle)
	(funcall circle 'center))
(defun radius (circle)
	(funcall circle 'radius))
(defun set-radius (circle val)
	(funcall circle 'set-radius val))


(let ((act_val (gensym)))

	(defun val (&optional (val 0 used))
		 (if used
					(setf act_val val)
			  act_val)))

(defmacro defvalf (name &optional def-value)
	(let ((my-val (gensym)))
		`(let ((,my-val ,def-value))
			(defun ,name (&optional (val 0 used))
				(if used
						(setf ,my-val val)
					,my-val)))))

(setf point (make-point 8 2))
(setf point2 (make-point 3 4))
(print (x point))
(print (set-y point 99))
(print (y point))
(print (distance point point2))
(print (pointp point))
(print (val 3))
(print (val))
(print (val 5))
(print (val))
(print (val))

(defun fib-1 (n)(if (<= n 1)1(+ (fib-1 (- n 1)) (fib-1 (- n 2)))))

(defmacro my-time(&whole whole expression)
	`(let ((t1 (get-internal-run-time)))
		,expression
		(setf t1 (- (get-internal-run-time) t1))
		(format t "Vyhodnoceni vyrazu ~s trvalo ~As" ',whole (/ t1 internal-time-units-per-second))
		(/ t1 internal-time-units-per-second)))
