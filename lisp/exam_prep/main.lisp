(defun point-distance (A-x A-y B-x B-y)
	(let ((difa (- A-x B-x))
			(difb (- A-y B-y)))
		(sqrt (+ (* difa difa) (* difb difb)))))


(defun heron-cart (A-x A-y B-x B-y C-x C-y)
	(let ((a (point-distance A-x A-y B-x B-y))
			(b (point-distance C-x C-y B-x B-y))
			(c (point-distance A-x A-y C-x C-y)))
		(let ((s (/ (+ a b c) 2)))
			(sqrt (* s (- s a) (- s b) (- s c))))))


(defun approx-= (a b epsilon)
	(<= (abs (- a b)) epsilon))

(defun powern-iter (val n ir)
	(if (= n 0)
			ir
		(powern-iter val (- n 1) (* val ir))))
(defun powern (val n)
	(powern-iter val n 1))


(defun my-gcd (a b)
	(if (= b 0)
			a
		(my-gcd b (rem a b))))

(defun perfect-sum (num n) 
	(cond ((= n 1) 0)
			((= (rem num n) 0) (+ n (perfect-sum num (- n 1))))
			(t (perfect-sum num (- n 1)))))

(defun perfectp (num)
	(= (+ 1 (perfect-sum num (round (/ num 2)))) num))


(defun pascal (n m)
	(if (or (= m 0) (= m n))
			1
		(+ (pascal (- n 1) (- m 1)) (pascal (- n 1) m))))


(defun fib-iter (n ir1 ir2)
	(cond ((<= n 2) (+ ir1 ir2))
			(t (fib-iter (- n 1) ir2 (+ ir1 ir2)))))

(defun fib (n)
	(fib-iter (- n 1) 0 1))

(defun proper-list-p (list)
	(if (consp list)
			(proper-list-p (cdr list))
		(eql list nil)))

(defun make-geom-seq-list-it (start q n)
	(make-geom-seq-list-iter start q n nil))

(defun make-geom-seq-list-iter (start q n ir)
	(if (= n 0)
		(cons start ir)
		(make-geom-seq-list-iter start q (- n 1) (cons (* start (powern q n)) ir))))

(defun equal-lists-p (l1 l2)
	(or (null l1) (and (eql (car l1) (car l2)) (equal-lists-p (cdr l1) (cdr l2)))))


(defun factorials-help (k n ir)
	(cond ((> k n) '())
			(t (cons ir (factorials-help (+ k 1) n (* k ir))))))

(defun factorials (n)
	(factorials-help 1 n 1))


(defun list-tails (list)
	(if (null list)
		 (cons list '())
		(cons list (list-tails (cdr list)))))

(defun elemp (elem list)
	(and (not (null list)) (or (= elem (car list)) (elemp elem (cdr list)))))

(defun my-remove-duplicates (list)
	(if (null list)
		 nil
		(if (elemp (car list) (cdr list))
			 (my-remove-duplicates (cdr list))
			(cons (car list) (my-remove-duplicates (cdr list))))))


(defun my-union2 (list1 list2)
	(cond ( (null list1) nil)
		 	( (= (car list1) (car list2)) (cons (car list1) (my-union (cdr list1) (cdr list2))))
			( t (cons (car list1) (cons (car list2) (my-union (cdr list1) (cdr list2)))))))


(defun my-union (list1 list2)
	(cond ((null list1) list2)
			((not (elemp (car list1) list2)) (cons (car list1) (my-union (cdr list1) list2)))
			(t (my-union (cdr list1) list2))))


(defun flatten (list)
	(cond ( (null list) nil)
			( (consp (car list)) (append (flatten (car list)) (flatten (cdr list))))
			( t (cons (car list) (flatten (cdr list))))))

(defun deep-reverse-iter (l ir)
	(cond ((null l) ir)
			((consp (car l)) (deep-reverse-iter (cdr l) (cons (deep-reverse-iter (car l) '()) ir)))
			(t (deep-reverse-iter (cdr l) (cons (car l) ir)))))

(defun deep-reverse (l)
	(deep-reverse-iter l '()))


(defun node-value (node)
	(car node))

(defun node-children (node)
	(cdr node))

(defun tree-values-dfs (val roots)
	(if (null roots)
		 '()
		(if (or (eql (tree-find val (car roots)) val) (eql (tree-values-dfs val (cdr roots)) val))
			 val
			nil)))

(defun tree-find (val tree)
	(cond ((null tree) nil)
			((eql (node-value tree) val) val)
			(t  (tree-values-dfs val (node-children tree)))))

(defun tr-find (val tree)
	(if (= val (node-value tree))
			(list val)
		(tree-v-d-m val (node-children tree))))

(defun tree-v-d-m (val roots)
	(if (null roots)
			nil
		(append (tr-find val (car roots))
				  (tree-v-d-m val (cdr roots)))))

(defun max-paths-dfs (tree ir)
	(cons (cons (node-value tree) ir)
			  (max-paths-multi (node-children tree) (cons (node-value tree) ir))))
			

(defun max-paths-multi (roots ir)
	(if (null roots)
			nil
		(append (max-paths-dfs (car roots) ir) (max-paths-multi (cdr roots) ir))))


(defun foldr (fun list init)
	(if (null list)
			init
		(funcall fun (car list) (foldr fun (cdr list) init))))

(defun foldl (fun list init)
	(labels ((iter (fun list ir)
					(if (null list)
							ir
						(iter fun (cdr list) (funcall fun (car list) ir)))))
		(iter fun list init)))

(defun ff1 (tree)
	(+ 1 (ff2 (node-children tree))))

(defun ff2 (roots)
	(if (null roots)
			-1
		(if (>= (ff1 (car roots)) (ff2 (cdr roots)))
				(ff1 (car roots))
			(ff2 (cdr roots)))))


(defun count-change (amount)(cc amount 6))(defun cc (amount kinds)(cond ((= amount 0) 1)((or (< amount 0) (= kinds 0)) 0)(t (+ (cc amount (- kinds 1))(cc (- amount (first-denom kinds)) kinds)))))

(defun first-denom (kinds)(cond ((= kinds 1) 1)((= kinds 2) 2) ((= kinds 3) 5) ((= kinds 4) 10)((= kinds 5) 20)((= kinds 6) 50))) 


(defun proper-list-p (list)
	(or (eql list nil)
		 (and (consp list) (proper-list-p (cdr list)))))

(defun my-nth (n list)
	(if (= n 0)
			(car list)
		(my-nth (- n 1) (cdr list))))
	
(defun facc (m n ir)
	(cond ((or (= m 0) (= m 1)) (cons 1 (facc (+ m 1) n 1)))
			((= m n) '())
			(t (cons (* m ir) (facc (+ m 1) n (* m ir))))))

(defun faccof (n)
	(facc 0 n 0))

(defun deep-reverse-iter2 (list ir)
	(cond ((null list) ir)
			((consp (car list)) (deep-reverse-iter2 (cdr list) (cons (deep-reverse-iter2 (car list) '()) ir)))
			(t (deep-reverse-iter2 (cdr list) (cons (car list) ir)))))

(defun deep-reverse2 (list)
	(deep-reverse-iter2 list '()))


(defun tree-find2 (val tree)
	(if (eql val (node-value tree))
			val
		(tree-find-mfs2 val (node-children tree))))

(defun  tree-find-mfs2 (val roots)
	(if (null roots)
			'()
		(if (or (eql (tree-find2 val (car roots)) val) 
				  (eql (tree-find-mfs2 val (cdr roots)) val))
				  val
			nil)))


(defun tree-m-p-2 (tree ir)
	(if (null tree)
			ir
		(cons (tree-m-p-2 (node-children tree) (cons (node-value tree) ir))
				  (tree-m-p-2 (cddr tree) ir))))

(defun tmp2 (tree ir)
	(cons (cons (node-value tree) ir) 
			(tmpm2 (node-children tree) (cons (node-value tree) ir))))

(defun tmpm2 (roots ir)
	(if (null roots)
			nil
		(append (tmp2 (car roots) ir)
				(tmpm2 (cdr roots) ir))))

(defun trh (tree ir)
	(if (null tree)
			ir
		(if (> (trh (cdar tree) (+ ir 1)) (trh (cdr tree) ir))
				(trh (cdar tree) (+ ir 1))
			(trh (cdr tree) ir))))


(defun my-member (x list)
	(cond ((null list) ())
			((funcall x (car list)) list)
			(t (my-member x (cdr list)))))


(defun my-mapcaro (fun list1 &rest lists)
	(labels ((mapcaro1 (list)
					(if (null list)
							'()
						(cons (funcall fun (car list))
								(mapcaro1 (cdr list)))))
				(fun1 (l1 l2)
					(cons (mapcaro1 l1) l2)))
		(foldr #'fun1 (append (list list1) lists) '())))


(defun accumulate (seq from to combiner null-val)(if (< to from)null-val(funcall combiner(mem seq from)(accumulate seq (1+ from) to combiner null-val))))

(defun mem (seq index)
	(funcall seq index))

(defun constant-seq-p (seq n)
	(labels ((acum (seq from to)
					(if (>= from to)
							t
						(and (eql (mem seq (- from 1)) (mem seq from)) (acum seq (1+ from) to)))))
		(acum seq 1 n)))


(defun even-members (seq)
	(lambda (n) (mem seq (* n 2))))

(defun seq-interleave (seq1 seq2)
	(lambda (n) (if (evenp n)
							(mem seq1  (/ n 2))
						(mem seq2 (/ n 2)))))

(defun tree-dup-multi (roots)
	(if (null roots)
			t
		(if (eql (tree-dup-multi (cdr roots)) t)
				(tree-dup (car roots))
			(not (eql (tree-dup-multi (cdr roots)) (tree-dup (car roots)))))))

(defun tree-dup (tree)
	(if (eql (tree-dup-multi (node-children tree)) t)
			(node-value tree)
		(not (eql (tree-dup-multi (node-children tree)) (node-value tree)))))


(defun comb (n list)
	(cond ((null list) 1)
			((= n 0) 1)
			((< n 0) 0)
			(t (+ (comb n (cdr list))
					(comb (- n (car list)) list)))))
