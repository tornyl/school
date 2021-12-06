(defun pscl (a b)
	(cond ((or (= b 0) (= b a)) 1)
		((or (< b 0) (> b a)) 0)
		(t (+ (pscl (- a 1) (- b 1)) (pscl (- a 1) b)))))


(defun fib-iter (n ir)
	(cond ( (= n 0) 1)
			( (= n 1) 1)
			(t (fib-iter (- n 1) (+ ir 

(defun fib (n)
	(fib-iter(n 0))) 
