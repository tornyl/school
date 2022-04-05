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

(defun zero-one ()
	(cons-stream 0 (cons-stream 1 (zero-one))))


; bonus ukol
; powers - strem funkci x^0 , x^1, x^2, x^3.....
; (stream-f-map powers 2 5)
;  (1 2 4 8 16)
