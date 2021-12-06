(defun numer (zlomek)
	(car zlomek))

(defun denom (zlomek)
	(cdr zlomek))

(defun zlomek (a b)
	(cons a b))


(defun rozdil ( a b)
	(cons (- (* (numer a) (denom b)) (* (numer b) (denom a)) ) (* (denom a) (denom b))))


(defun vydel( a b)
	(cons (* (numer a) (denom b)) (* (denom a) (numer b))))

(defun point (a b)
	(cons a b))

(defun point-x (point)
	(car point))

(defun point-y (point)
	(cdr point))

(defun power2 (n)
	(* n n))

(defun point-dist (p1 p2)
	(sqrt (+ (power2 (- (point-x p1) (point-x p2))) (power2 (- (point-y p1) (point-y p2))))))

	

(defun right-triangle-p (p1 p2 p3)
	(let ( (a (point-dist p1 p2))
			(b (point-dist p1 p3))
			(c (point-dist p2 p3)))
		(or (= (power2 a) (+ (power2 b) (power2 c)))
			(= (power2 a) (+ (power2 b) (power2 c)))
			(= (power2 a) (+ (power2 b) (power2 c))))))


(defun interval  (a b)
	(cons a b))

(defun lower-bound (interval)
	(car interval))

(defun upper-bound (interval)
	(cdr interval))

(defun number-in-interval-p (i n)
	(and (< (lower-bound i) n) (> (upper-bound i) n)))

(defun interval-intersection (int1 int2)
	(if (or (< (upper-bound int1) (lower-bound int2)) (< (upper-bound int2) (lower-bound int1)))
		nil
		(cons (if (> (lower-bound int1) (lower-bound int2))
					(lower-bound int1)
					(lower-bound int2))
				(if (< (upper-bound int1) (upper-bound int2))
					(upper-bound int1)
					(upper-bound int2)))))



(defun proper-list-p (my-list)
	(if (eql my-list nil)
		t
		(proper-list-p (cdr my-list))))

(defun my-make-list-iter (length elem ir)
	(if (= length 0)
		ir
		(my-make-list-iter (- length 1) elem (cons elem ir))))

(defun my-make-list (length elem)
	(my-make-list-iter length elem nil))

(defun make-ar-seq-list (start dif n)
	(if (= n 0)
		()
		(cons start (make-ar-seq-list (+ start dif) dif  (- n 1)))))

(defun make-ar-seq-list-iter (start dif n)
	(make-ar-seq-list-iteration start dif n nil))

(defun make-ar-seq-list-iteration (start dif n ir)
	(if (= n 0)
		ir
		(make-ar-seq-list-iteration start  dif (- n 1) (cons (+ start (* dif (- n 1))) ir))))


(defun make-geom-seq-list (start q n)
	(if (= n 0)
		nil
		(cons start (make-geom-seq-list (* start q) q (- n 1)))))

(defun make-geom-seq-list-iter (start q n)
	(make-geom-seq-list-iteration start q n nil))

(defun make-geom-seq-list-iteration (start q n ir)
	(if (= n 0)
		ir
		(make-geom-seq-list-iteration start q (- n 1) (cons (* start (powern q n 1)) ir))))


(defun powern (x n ir)
	(if (= n 0)
		ir
		(powern x (- n 1) (* x x))))









