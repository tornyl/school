(defun last-pair (list)
	(if (eql (cdr list) nil)
		 list
		(last-pair (cdr list))))

(defun my-copy-list (list)
	(if (null list)
		 nil
		(cons (car list) (my-copy-list (cdr list)))))


(defun equal-lists-p (l1 l2)
	(and (eql (car l1) (car l2)) (or (null l1) (equal-lists-p (cdr l1) (cdr l2)))))

(defun remove-nthcdr (list n)
	(if (= n 0)
		 nil
		 (cons (car list) (remove-nthcdr (cdr list) (- n 1)))))


(defun substract-list (l1 l2)
	(if (null l1)
		 nil
		(cons (- (car l1) (car l2)) (substract-list (cdr l1) (cdr l2)))))


(defun each-other (list)
	(each-other-part-two list 0))

(defun each-other-part-two (list n)
	(cond ((null list) nil)
			((evenp n) (cons (car list) (each-other-part-two (cdr list) (+ n 1))))
			(t (each-other-part-two (cdr list) (+ n 1)))))

(defun reverse-iter(list1 list2)
	(if (null list1)
		 list2
		(reverse-iter (cdr list1) (cons (car list1) list2))))
(defun my-reverse (list)
	(reverse-iter list ()))	


(defun factorials (n)
	(if (= n -1)
		 nil
		(cons (fac n) (factorials (- n 1)))))


(defun fac(n)
	(if(= n 0)
		 1
		(* n (fac (- n 1)))))

(defun list-tails (list)
	(if (null list)
		 nil
		(cons list (list-tails (cdr list)))))

(defun list-sum (list)
	(if (null list)
		 0
		(+ (car list) (list-sum (cdr list)))))


 

(defun my-remove (elem list)
	(cond ((null list) nil)
			((= elem (car list)) (my-remove elem (cdr list)))
			(t  (cons (car list) (my-remove elem (cdr list))))))


(defun scalar-product (list1 list2)
	(if (null list1)
		 0
		(+ (* (car list1) (car list2)) (scalar-product (cdr list1) (cdr list2)))))


;(defun vector-length (list)
	;(if (null list)
	;	 0

(defun elemp (elem list)
	(and (not (null list)) (or (= elem (car list)) (elementp elem (cdr list)))))

(defun my-remove-duplicates (list)
	(if (null list)
		 nil
		(if (elemp (car list) (cdr list))
			 (my-remove-duplicates (cdr list))
			(cons (car list) (my-remove-duplicates (cdr list))))))



(defun my-union (list1 list2)
	(cond ( (null list1) nil)
		 	( (= (car list1) (car list2)) (cons (car list1) (my-union (cdr list1) (cdr list2))))
			( t (cons (car list1) (cons (car list2) (my-union (cdr list1) (cdr list2)))))))


(defun equal-sets-p (list1 list2)
	(cond ( (and (null list1) (null list2)) nil)
			( (null list2) nil)
			( (null list1) t)
			( (and (elemp (car list1) list2) (equal-sets-p (cdr list1) list2)) t)
			( t nil)))


(defun my-append (list1 list2)
	(if (null list1)
		 list2
		(cons (car list1) (my-append (cdr list1) list2))))

(defun flatten (list)
	(cond ( (null list) nil)
			( (consp (car list)) (my-append (flatten (car list)) (cdr list)))
			( t (cons (car list) (flatten (cdr list))))))


(defun my-reverse (list  list2)
	(cond ( (null list) list2)
			( t (my-reverse (cdr list) (cons (car list) list2)))))


(defun deep-reverse (list)
	(cond ( (null list) nil)
			( (consp (car list)) (cons (deep-reverse (car list) ) (deep-reverse (cdr list))))
			( t (cons (deep-reverse (cdr list)) (car list)))))



(defun deep-reverse2 (list)
	(cond ( (null list) nil)
			( (consp (car list)) (cons (deep-reverse2 (car list)) (deep-reverse2 (cdr list))))
			( t (my-reverse (cons (car list) (deep-reverse2 (cdr list))) nil))))


(defun dreverse (list)
	(dreverse-iter list '()))

(defun dreverse-iter (list ir)
	(cond ( (null list) ir)
			( (consp (car list)) (dreverse-iter (cdr list) (cons (dreverse-iter (car list) '()) ir)))
			( t (dreverse-iter (cdr list) (cons (car list) ir)))))



;(cons 4 (cons (cons 5 (cons 6 (cons (cons 10 (cons 10 (cons 10 nil))) (cons 7 nil)))) (cons 4 (cons 4 nil))))

