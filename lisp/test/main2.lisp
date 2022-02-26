(defun sum-digits (n)
	(if (= n 0)
			0
		(+ (rem n 10) (sum-digits (floor n 10)))))


(defun even-elements (list)
	(cond ( (null list) '())
			( (evenp (car list)) (cons (car list) (even-elements (cdr list))))
			(t (even-elements (cdr list)))))


(defun  my-set-intersection-2 (l1 l2)
	(cond 	((or (null l1) (null l2)) '())
				((= (car l1) (car l2)) (cons (car l1) (my-set-intersection-2 (cdr l1) (cdr l2))))
				((< (car l1) (car l2)) (my-set-intersection-2 (cdr l1) l2))
				(t (my-set-intersection-2 l1 (cdr l2)))))


(defun mfs (l1 l2 &rest other)
	(let ( (lists (append (list l1) (list l2) other)))
		(foldr #'my-set-intersection-2 lists nil)))

(defun mem (seq n)
	(funcall seq n))

(defun seq-to-list (seq n)
	(labels ((fun (seq k)
					(if (= n k)
							nil
						(cons (mem seq k) (fun seq (+ k 1))))))
			(fun seq 1)))

(defun seq-interleave (seq1 seq2)
	(lambda (n)
		(if (evenp n)
				(mem seq2 (floor n 2))
			(mem seq1 (floor n 2)))))


(defun tr-depth (tree)
		(cons (car tree) (tr-breath-ch (cdr tree))))

(defun tr-depth-ch (tree)
	(if (null tree)
			'()
		(append (tr-breath (car tree)) (tr-breath-ch (cdr tree)))))


(defun check-if (list)
	(cond ( (null list) nil)
			( (eql (car list) nil) (check-if (cdr list)))
			( t (car list))))


(defun find-path (tree val)
	(fun1 tree val '()))

(defun fun1 (tree val ir)
	(if (eql (car tree) val)
			(append ir (list (car tree) ))
		(fun2 (cdr tree) val (append ir (list (car tree))))))

(defun fun2 (tree val ir)
	(if (null tree)
			'()
		(append (fun1 (car tree) val ir) (fun2 (cdr tree) val ir))))



