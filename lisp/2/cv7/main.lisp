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

(defun stream-to-list (stream &optional max-count)(if (or (null stream)(eql max-count 0))'()(cons (stream-car stream)(stream-to-list (stream-cdr stream)(when max-count (- max-count 1))))))

(defmacro stream (&rest exprs)(if (null exprs)'()`(cons-stream ,(car exprs) (stream ,@(cdr exprs)))))

(defun naturals (&optional (from 0))
	(cons-stream from (naturals (1+ from))))

(defun stream-ref (stream index)
	(if (= index 0)
			(stream-car stream)
		(stream-ref (stream-cdr stream) (1- index))))

(defun stream-heads (stream)
	(if (null (stream-cdr stream))
			(cons-stream (stream-car stream) nil)
		(cons-stream (stream-car stream) (stream-heads (cons-stream
																	(+ (stream-car stream)
																		(stream-car (stream-cdr stream)))
																	(stream-cdr (stream-cdr stream)))))))


(defun stream-remove-if (test stream)
  (cond ((null stream) '())
        ((funcall test (stream-car stream))
         (stream-remove-if test (stream-cdr stream)))
        (t (cons-stream (stream-car stream) 
                        (stream-remove-if test (stream-cdr stream))))))

(defun stream-map (f s)
  (if (null s)
      '()
    (cons-stream
      (funcall f (stream-car s))
      (stream-map f (stream-cdr s)))))

(defun stream-each-other (stream)
  (when stream
    (let ((car (stream-car stream))
          (cdr (stream-cdr stream)))
      (if cdr
          (cons-stream car (stream-each-other (stream-cdr cdr)))
        (cons-stream car nil)))))

(defun dividesp (m n)
  (= (rem n m) 0))

(defun sieve (stream)
  (let ((car (stream-car stream))
        (cdr (stream-cdr stream)))
    (cons-stream car
                 (sieve (stream-remove-if (lambda (n)
                                            (dividesp car n))
                                          cdr)))))

(defun eratosthenes ()
  (sieve (naturals 2)))


(defun prime-twins (&optional (stream (eratosthenes)))
	(if (= (stream-car stream) (stream-ref stream 2)) 
			(cons-stream (cons (stream-car stream) (stream-ref stream 2)) (prime-twins (stream-cdr (stream-cdr stream)) ))
		(prime-twins (stream-cdr (stream-cdr stream)))))


(defun stream-cust (stream)
	(stream-heads (stream-map (lambda (x) (* x x x)) (stream-each-other stream))))


(defun naturals (&optional (start 1))
	(cons-stream start (naturals (+ start 1))))


(defun next (gen)
	(funcall gen))

(defun stream-sqrta (a &optional (x 1))
	(cons-stream (/ (+ x (/ a x)) 2) (stream-sqrta a (/ (+ x (/ a x)) 2))))

(defun gen-sqrta ()
	(let ((s (stream-sqrta 2)))
		(lambda ()
			(prog1 
				(stream-car s)
				(setf s (stream-cdr s))))))

