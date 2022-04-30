(defun max-points (students)
	(reduce #'max 
		(mapcar (lambda (list) (reduce #'+ list :initial-value (car list)))
			(point-lists 
				(successful students))) 
		:initial-value 0))


(defun best-student (students)
	(let ((my-max (max-points students)))
		(car (remove-if-not (lambda (x) (= (reduce #'+ (point-list x)) my-max)) 
			(successful students)))))

;verze 2
;  point-lists students

(defun best-student2 (students)
	(reduce (lambda (x y)
					(let ((px (point-sum x))
							(py (point-sum y)))
						(cond ((> px py) x)
								((= px py) (cons px (cons y (cdr x))))
								((< px py) (cons py y))))) :initial-value (cons -1 nil)))
(defun make-promise (fun)
  (list 'promise nil nil fun))

(defmacro delay (expr)
  `(make-promise (lambda () ,expr)))

(defun validp (promise)
  (second promise))

(defun force (promise)
  (unless (validp promise)
    (setf (third promise) (funcall (fourth promise))
          (second promise) t))
  (third promise))
 
(defun invalidate (promise)
  (setf (second promise) nil))

(defmacro cons-stream (a b)
  `(cons ,a (delay ,b)))

(defun stream-car (s)
  (car s))

;; stream-cdr provede pomocí force výpočet pokračování proudu.
(defun stream-cdr (s)
  (force (cdr s)))

(defun zero-one ()
	(cons-stream 0 (cons-stream 1 (zero-one))))


; bonus ukol
; powers - strem funkci x^0 , x^1, x^2, x^3.....
; (stream-f-map powers 2 5)
;  (1 2 4 8 16)
(defun next (gen)
	(funcall gen))

(defun gen-zero-one ()
	(let ((a (zero-one)))
		(lambda () 
			(setf a (stream-cdr a))
			(stream-car a))))

(defun gen-zero-one-2 ()
	(let ((n 0))
		(lambda ()
			(incf n)
			(rem n 2))))

