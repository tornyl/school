(defun foldr(fun list init)
	(if (null list)
			init
		(funcall fun (car list) (foldr fun (cdr list) init))))

(defun selection-sort (list)
	(if (null list)
			'()
		(let ((minval (foldr #'min list (car list) )))
			(cons minval (selection-sort (remove minval list :count 1))))))


(defun my-find (item sequence &key (test-fun nil test) (from-end nil))
	(labels ((fun (list)
					(if test
							(cond ((null list) nil)
									((funcall test-fun item (car list)) (car list))
									(t (fun (cdr list))))
						(cond ((null list) nil)
								((eql item (car list)) item)))))
		(if from-end
				(fun (reverse sequence))
			(fun sequence))))


(defmacro and-2 (a b)
	`(if ,a ,b nil))

(defmacro or-2 (a b)
	`(if ,a t ,b))

(defmacro whenb (sym condition &rest expressions)
	`(let ((,sym ,condition))
		(if ,sym
				(progn ,@expressions)
			nil)))

(defmacro reverse-progn (&rest expressions)
	`(progn ,@(reverse expressions)))

(defmacro my-let (bindings &body body)
	`(funcall (lambda ,(mapcar #'car bindings) ,@body) ,(mapcar #'cadr bindings)))

(defmacro awhen (condition &body body)
	`(let ((it ,condition))
		(when it
			,@body)))

(defmacro my-prog1 (first-form &rest forms)
	(let ((my-sym (gensym)))
		`(let ((,my-sym ,first-form))
			,@forms
			,my-sym)))

(defmacro test ( expression)
	(format t "vyhodnoceny vyraz je  ~s" expression)
	(let ((sym (gensym)))
		`(let ((,sym ,expression))
			(format t "hodnota vyrazu je ~s" ,sym)
			,sym)))

(defmacro my-and (&rest forms)(if forms`(when ,(car forms) (my-and ,@(cdr forms)))t))
	


(defmacro my-let* (bid &body body)
	(if bid
		`(let (,(car bid))
			(my-let* ,(cdr bid) ,@body))
		`(funcall (lambda () ,@body))))


(defmacro doatoms (list &body body)
	`(cond ((null ,(cadr list)) nil)
			((consp ,(cadr list)) (progn
									(doatoms ,(cons (car list) (cadr list)) ,@body)
									(doatoms  ,(cons (car list) (cddr list)) ,@body)))
			(t (funcall (lambda (,(car list))  ,@body) ,(cadr list)))))

(defmacro my-incf(val)
	`(setf ,val (+ ,val 1)))


(defun test10 (a)(setf a 2))(defun test20 (a)(test10 a)a)

(defun add-after (val after list)(cond ((null after) (cons val list))(t (setf (cdr after)(cons val (cdr after)))list)))(defun delete-after (after list)(cond ((eql after nil) (cdr list))(t (setf (cdr after) (cddr after))list)))

(defun add-element-after(elem after list)
	(setf (cdr (member after list)) (cons elem (cdr (member after list))))
	list)

(defun delete-element (elem list)
	(setf (member elem list) (cdr (member elem list)))
	list)

(defun make-promise (fun)
	(list 'promise nil nil fun))

(defmacro delay (exprs)
	`(make-promise (lambda () ,exprs)))

(defun validp (promise)
	(second promise))

(defun force (promise)
	(unless (validp promise)
		(setf (third promise) (funcall (fourth promise))
				(second promise) t))
	(third promise))

(defun invalidate (promise)
	(setf (second promise ) nil))

(defun list-average (list)(/ (apply #'+ list)(length list)))
(defun elist-list (elist)
	(second elist))

(defun (setf elist-list) (new-list elist)
	(invalidate (third elist))
	(invalidate (fourth elist))
	(invalidate (fifth elist))
	(invalidate (sixth elist))	
	(setf (second elist) new-list))

(defun list-median (list)(let ((sorted (sort (copy-list list) #'<))(length (length list))(tail nil))(cond ((oddp length) (nth (/ (1- length) 2) sorted))(t (setf tail (nthcdr (1- (/ length 2)) sorted))(/ (+ (pop tail) (pop tail)) 2)))))(defun elist-median (elist)(list-median (elist-list elist)))

(defun list-min (list)
	(apply #'min list))

(defun list-max (list)
	(apply #'max list))


(defun elist-average (elist)
	(force (third elist)))

(defun elist-median (elist)
	(force (fourth elist)))

(defun elist-min (elist)
	(force (fifth elist)))

(defun elist-max (elist)
	(force (sixth elist)))

(defun make-elist (&rest elements)
	(let ((res (list 'elist (copy-list elements) nil nil nil nil)))
			(setf (third res) (delay (list-average (elist-list res)))
					(fourth res) (delay (list-median (elist-list res)))
					(fifth res) (delay (list-min (elist-list res)))
					(sixth res) (delay (list-max (elist-list res))))
			res))

(defun elist-add-after (elist value cons)
	(invalidate (third elist))
	(invalidate (fourth elist))
	(invalidate (fifth elist))
	(invalidate (sixth elist))
	(setf (elist-list elist)
			(add-after value cons (elist-list elist)))
	elist)

(defun elist-delete-after (elist cons)
	(invalidate (third elist))
	(invalidate (fourth elist))
	(invalidate (fifth elist))
	(invalidate (sixth elist))
	(setf (elist-list elist)
			(delete-after cons (elist-list elist)))
	elist)


(defun my-find (item list)
	(when (reduce (lambda (x y)
						(if x
								x
							(when (eql item y)
								t)))
							list :initial-value nil)
			item))

(defmacro cons-stream (a b)
	`(cons ,a (delay ,b)))

(defun car-stream (stream)
	(car stream))	

(defun cdr-stream (stream)
	(force (cdr stream)))

(defmacro stream (&rest exprs)
	(if (null exprs)
			'()
		`(cons-stream ,(car exprs) 
						(stream ,@(cdr exprs)))))

(defun zeroone ()
	(cons-stream 0 (cons-stream 1 (zeroone))))

(defun stream-ref (stream index)
	(if (= index 0)
			(car-stream stream)
		(stream-ref (cdr-stream stream) (1- index))))


(defun multiplier (x)(lambda (y)(* y x)))

(defmacro toggle(expr)
	(list (quote setf) expr (list (quote not) expr)))

(defmacro my-and (&rest forms)
	`(if ,(not (null forms))
			(when  ,(car forms) (my-and ,@(cdr forms)))
		t))


(defmacro my-andd (&rest forms)
	(if forms
			`(when  ,(car forms) (my-and @,(cdr forms)))
		t))


(defun distance (x1 y1 x2 y2)
	(sqrt (+ (* (- x1 x2) (x1 x2)) (* (- y1 y2) (- y1 y2)))))

(defun make-circle(c-x c-y r)
	(lambda (x y)
		(if (< (distance c-x c-y x y) r)
				1
			0)))
