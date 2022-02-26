(defmacro and-2 (cond1 cond2)
	(list 'if cond1 (list 'if cond2 't 'nil) 'nil))

(defmacro and-2-b (cond1 cond2)
	`(if ,cond1 (if ,cond2 t nil) nil))

(defmacro or-2 (cond1 cond2)
	(list 'if cond1 't (list 'if cond2 't 'nil)))

(defmacro or-2-b (cond1 cond2)
	`(if ,cond1 t (if ,cond2 t nil) nil))

(defmacro if-zero (con a b)
	(list 'if (list '= con '0) a b))

(defmacro my-unless (condition &rest expressions)
	`( if ,condition nil (progn ,@expressions)))

(defmacro my-when (condition &rest expressions)`(if ,condition (progn ,@expressions)nil))

(defmacro my-unless-2 (condition &rest expressions)
	`(my-when ,(not condition) ,@expressions))

;;(defmacro whenb (var condition &rest expressions)
;;	`(let* ((x ,var))
;;			(if ,x (progn ,@expressions) nil)))
