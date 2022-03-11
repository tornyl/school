(defun random-case-help (body)(if (null body)'()(cons (cons (- (length body) 1) (car body))(random-case-help (cdr body)))))(defmacro random-case-1 (&body body)`(case (random (length',body)),@(random-case-help body)))(defmacro random-case-2 (&body body)`(case (random ,(length body)),@(random-case-help body)))(defmacro random-case-3 (&body body)`(case ,(random (length body)),@(random-case-help body)))

(defun test ()
	(random-case-3 
		("jedna")
		("dve")
		("tri")))


(defmacro awhen (condition &body body)
	`(let ((it ,condition))
		(when it
			,@body)))

(defun test-number-help (value val-minus val-zero val-plus)
	(cond ((< value 0) (funcall val-minus))
			((= value 0) (funcall val-zero))
			((> value 0) (funcall val-plus))))

(defmacro test-number (number minus zero plus)
	`(test-number-help ,number (lambda () ,minus) (lambda () ,zero) (lambda () ,plus)))

(defmacro my-prog1 (first-form &rest forms)
	(let ((my-sym (gensym))
			(my-fun (gensym)))
		`(let ((,my-sym ,first-form)
				 (,my-fun (lambda () ,@forms)))
			(funcall ,my-fun)
			,my-sym)))



(defmacro test-2 ( expression)
	(format t "~%Expanduje se vyraz ~s" expression)
	`(print ,expression))

(defmacro my-and (&rest forms)
	(if forms
			`(when ,(car forms) (my-and ,@(cdr forms)))
		t))

(defmacro my-and-2 (&optional (first-form t) &rest forms)
	(if forms
			`(when ,first-form (my-and-2 ,(car forms) ,@(cdr forms)))
		first-form))

(defmacro my-or (&optional (first-form nil) &rest forms)
	(if forms
			`(unless ,first-form (my-or ,(car forms) ,@(cdr forms)))
		first-form))

(defmacro my-or (&optional (first-form nil) &rest forms)
	(let ((sym (gensym)))
		(if forms
				`(let ((,sym ,first-form))
					(if ,sym
							,sym
						(my-or ,(car forms) ,@(cdr forms))))
			first-form)))

(defmacro my-let* (bindings &body body)
	(if bindings
			`(let ((,(caar bindings) ,(cadar bindings)))
				(my-let* ,(cdr bindings) ,@body))
		`(funcall (lambda () ,@body))))

(defmacro doatoms (list &body body)
	(labels ((norm (list)
					(cond ((null list) '())
							((consp list) (append (norm (car list)) (norm (cdr list))))
							(t (cons list '())))))
		`(mapcar (lambda (,(car list)) ,@body) (norm ,(cadr list)))))


(defun ggs (list)
	(cond ((null list) '())
			((consp list) (append (norm (car list)) (norm (cdr list))))
			(t (cons list '()))))


(defmacro all-cond (&body forms)
	`(if ,(null forms) 
			nil
		(if ,(caar forms) 
				(progn ,(cadar forms) (all-cond ,@(cdr forms)))
			(all-cond ,@(cdr forms)))))


(defmacro op-alias (name shortcut)
	`(defvar ,shortcut ',name))
