(defun rot-right (list)
	(append (list (nth (- (length list) 1) list))  (butlast list 1)))

(defun pythagorean-equation-p (a b c)
	(= (expt c 2) (+ (expt a 2) (expt b 2))))

(defun make-point (x y)
	(set-x (set-y (make-instance 'point) y) x))

