(defun approx-= (a b epsilon)(<= (abs (- a b)) epsilon))

(defun func-fixpoint-iter (func x epsilon)
	(let ( (y (funcall func x)))
		(if (approx-= x y epsilon)
				y
			(func-fixpoint-iter func y epsilon))))

(defun func-fixpoint (func x epsilon)
	(func-fixpoint-iter func x epsilon))

(defun foldr (fun list init)(if (null list)init(funcall fun (car list) (foldr fun (cdr list) init))))

(defun one (val val2)
	(+ 1 val2))

(defun my-length (list)
	(foldr #'one list 0))

(defun my-make-list (length elem)
	(labels ( (iter (length elem ir)
					(if (= length 0)
								ir
							(iter (- length 1) elem (cons elem ir)))))
			(iter length elem '())))



(defun my-member (func elem list)
	(cond ( (null list) nil)
			( (funcall func elem (car list)) list)
			( t (my-member func elem (cdr list)))))


(defun my-mapcar (func list)
	(labels ( (iter (val1 val2)
					(cons (funcall func val1) val2)))
		(foldr #'iter list '())))


;(defun foldl (fun list init)
;	(labels ((
;	(if (null list)
;		'()


(defun arithmetic-mean (num1 &rest nums)
	(/ (foldr #'+ (append (list num1) nums) 0)
		(my-length (append (list num1) nums))))


(defun equal-lists-p (list1 list2 &rest lists)
	(labels ( (my-equal (l1 l2)
						(or (null l1) (and (eql (car l1) (car l2)) (my-equal (cdr l1) (cdr l2)))))
				 (prefol (l1 p)
				 	(and (my-equal list1 l1) p)))
			(foldr #'prefol (append (list list2) lists) t)))


(defun foldl (fun list init)
	(labels ((iter (func ir list init)
					(if (null list)
							ir
						(iter fun (cdr list) (funcall fun ir (cdr list))))))
			(iter fun list init)))



(defun my-mapcar-g (fun list &rest lists)
	(labels ((apply-fun (list)
						(if (null list)
								'()
							(cons (funcall fun (car list)) 
									(apply-fun (cdr list)))))
				(stack (list lists)
					(cons (apply-fun list)
							lists)))
		(foldr #'stack (append (list list) lists) '())))
