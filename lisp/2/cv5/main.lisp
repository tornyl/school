(defun add-after (val after list)
	(cond ((null after) (cons val list))
			(t (setf (cdr after)(cons val (cdr after)))list)))

(defun delete-after (after list)
	(cond ((eql after nil) (cdr list))
			(t (setf (cdr after) (cddr after))list)))

(defun add-element-after (val after list)
	(add-after val (member after list) list))

(defun delete-element (elem list)
	(delete-after (member elem (cdr list)) list))


(defun make-queue ()
	(cons nil nil))


(defun queue-front (q)
	(car q))

(defun (setf queue-front) (front q)
	(setf (car q) front))

(defun queue-rear (q)
	(cdr q))

(defun (setf queue-rear) (rear q)
	(setf (cdr q) rear))

(defun empty-queue-p (q)
	(null (queue-front q)))

(defun dequeue (q)(when (empty-queue-p q)(error "Queue is empty"))(prog1 (car (queue-front q))(setf (queue-front q) (cdr (queue-front q)))))

(defun enqueue (q el)(let ((new (cons el nil)))(if (empty-queue-p q)(setf (queue-front q) new)(setf (cdr (queue-rear q)) new))(setf (queue-rear q) new)el))

(defun queue-front-element (q)
	(if (empty-queue-p q)
			(error "Queue is emepty")
		(car (queue-front q))))

(defun queue-rear-element (q)
	(if (empty-queue-p q)
			(error "Queue is empty")
		(car (queue-rear q))))



(defun make-queue-2 (&rest elements)
	(if (not (null elements))
			(let ((part elements)
					(q (cons nil nil)))
				(setf (queue-front q) part)
				(setf (queue-rear q) (last part))
				q)
		(cons nil nil)))

(defun circlist (&rest list)
	(let ((norm-list list))
		(setf (cdr (last norm-list)) norm-list)))

(defun bidir-cons (val1 val2)
	(cond ((and (consp val1) (consp val2)) 
				(progn
					(setf (next val1) val2)
					(setf (prev val2) val1)
					val1))
			((consp val1)
				(let ((new-pair (list val2 nil nil)))
					(setf (next val1) new-pair)
					(setf (prev new-pair) val1)
					val1))
			((consp val2)
				(let ((new-pair (list val1 nil nil)))
					(setf (next new-pair) val2)
					(setf (prev val2) new-pair)
					new-pair))
			(t
				(let ((new-pair (list val1 nil nil))
						(new-pair2 (list val2 nil nil)))
					(setf (next new-pair) new-pair2)
					(setf (prev new-pair2) new-pair)
					new-pair))))
(defun bidir-cons-2 (val &optional (prev nil) (next nil))
	(list val prev next))


(defun val (pair)
	(car pair))

(defun (setf val) (vall pair)
	(setf (car pair) vall))

(defun prev (pair)
	(cadr pair))

(defun (setf prev) (p-pair pair)
	(setf (cadr pair) p-pair))

(defun next (pair)
	(caddr pair))

(defun (setf next) (n-pair pair)
	(setf (caddr pair) n-pair))

(defun bidir-last (list)
	(if (null (next list))
			list
		(bidir-last (next list))))

(defun list-to-bidir-list (list)
	(labels ((fun (list)
			(if (null list)
					nil
				(bidir-cons (car list) (fun (cdr list))))))
		(let ((b-list (fun list)))
			(cons b-list (bidir-last b-list)))))

(defun bidir-list (&rest elements)
	(list-to-bidir-list elements))


(defun circle-find (elem list)
	(labels ((cp (slow fast)
				(cond ((null fast)nil)
						((or (eql (car slow) elem) (eql (car fast) elem)) elem)
						((eql slow fast)nil)
						(t (cp (cdr slow) (cddr fast))))))
		(cp list (cdr list))))


(defun circle-find-2 (elem list)
	(if (null list)
			nil
		(if (eql (car list) elem)
				(car list)
			(if (circlep (cdr list))
					nil
				(circle-find elem (cdr list))))))
