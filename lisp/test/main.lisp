(write-line "Hello, World")


(defun absolute (n)
	(sqrt (* n n))
)

(defun mocnina ( cislo n)
	(
	if (= n 0) 1 (* cislo (mocnina cislo (- n 1)))

	)

)

(defun signum_ (n)
	(if (> n 0) 1 (if (= n 0) 0	-1) )


)

( defun my-positive-p (n)
	(> n 0)
)

(defun hypotenuse ( a b )
	(sqrt (+ (* a a) (* b b) )  ) 

)


(defun point-distance ( a-x a-y b-x b-y)
 	(let ( 
		(x-leg (- a-x b-x))
		(y-leg (- a-y b-y))

		)
		( hypotenuse x-leg y-leg)
 			


 )

)


(defun trianglep (a b c)

	(and (> (+ a b) c) (> (+ a c) b) (> (+ b c) a)) 

)

(defun my-gcd(a b)
	(cond
		( (= b 0) a)
		( t (my-gcd b (rem a b)))

	)

)

(defun heron-sqrt-iter ( a x epsilon)
	(if (approx (* x x) a epsilon)
		x
		( heron-sqrt-iter a (/ (+ x (/ a x)) 2) epsilon)
	)
)

(defun heron-sqrt (a epsilon) 
	(heron-sqrt-iter a a epsilon)
)

(defun approx (a b epsilon)
	(<= (abs ( - a b)) epsilon)

)


;(defun sum (a b)
;	(let ( (a (+ a 1)) (b (- b 1)))
;		(if (= a b )
;			(+ a b)
;			(+ a b (sum a b))
;		)
;	)
;)


(defun sum (a b)
	(if (= (+ a 1) b)
		0
		(+ a 1  (sum (+ a 1) b))
	)
)

(defun sum-iter (a b v)
 	(if (= (+ a 1) b)
	v
	(sum-iter (+ a 1) b (+ a 1 v))
	)

)

(defun sum2 (a b)
	(sum-iter a b 0)

)


(defun power (a n)
	(power-iter a n 1)
)

(defun power-iter (a n val )
	(if (= n 0)
		val
		(power-iter a (- n 1) (* a val))
	)

)

;(defun div9p (a)
;	(let (( sum (sum-digit a (digit-count a))))	
;		(= (/ sum 9) 0)))
;
;(defun sum-digit (a n)
;	(+ (digit a n) (sum-digit a (- n 1))))


(defun leibniz (epsilon)
	(leibniz3 epsilon 0 4))

(defun leibniz2 (epsilon  n x)
	(let ( (v (- x (/ 1 (+ 3 n)))))
		(if (approx pi (* v 4) epsilon)
			(* v 4)
			(leibniz2 epsilon (+ n 2) v))))

(defun leibniz3 (epsilon n x)
	(let ( (v (+ (- x (/ 4 (+ 3 n))) (/ 4 (+ 3 (+ n 2))))))
		(if (approx v pi epsilon)
			v
			(leibniz3 epsilon (+ n 4) v))))
