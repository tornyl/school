(defmacro and-2 (cond1 cond2)
	(list 'if cond1 cond2 'nil))

(defmacro and-2-b (cond1 cond2)
	`(if ,cond1 (if ,cond2 t nil) nil))

(defmacro or-2 (cond1 cond2)
	(list 'if cond1 't (list 'if cond2 't 'nil)))

(defmacro or-2-b (cond1 cond2)
	`(if ,cond1 t ,cond2))

(defmacro if-zero (con a b)
	(list 'if (list '= con '0) a b))

(defmacro my-unless (condition &rest expressions)
	`( if ,condition nil (progn ,@expressions)))

(defmacro my-when (condition &rest expressions)`(if ,condition (progn ,@expressions)nil))

(defmacro my-unless-2 (condition &rest expressions)
	`(my-when ,(not condition) ,@expressions))

(defmacro whenb ( sym condition &rest expressions)
	`(let ((,sym ,condition))
		(when condition ,@expressions)))
;;(defmacro whenb (var condition &rest expressions)
;;	`(let* ((x ,var))
;;			(if ,x (progn ,@expressions) nil)))
(defun my-mapcar (list)
	(if (null list)
			'()
		(cons (eval (car list)) (my-mapcar (cdr list)))))
(defmacro reverse-progn (&rest expressions)
	`(progn ,@(reverse expressions)))


(defmacro my-let(bindings &body body)
	(labels ((getSymbols (bindings)
					(if (null bindings)
							'()
						(cons (caar bindings) (getSymbols (cdr bindings)))))
				(getValues (bindings)
					(if (null bindings)
							'()
						(cons (cadar bindings) (getValues (cdr bindings))))))
		`(funcall (lambda ,(getSymbols bindings) ,@body) ,@(getValues bindings))))

(defmacro my-let2 (bindings &body body)
	`(funcall (lambda (mapcar #'car ,bindings) ,@body) ,@(mapcar #'cadr bindings))) 
