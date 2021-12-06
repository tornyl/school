(defun mem (seq n)
	(funcall seq n))


(defun accumulate (seq from to combiner null-val)(if (< to from)null-val(funcall combiner(mem seq from)(accumulate seq (1+ from) to combiner null-val))))


(defun biggest-seq (seq from to)
	(accumulate seq from to (lambda (x y) (if (> x y) x y)) (mem seq from)))


(defun constant-seq-p (seq k)
	(labels ((func (seq n k)
						(or (= k 1)
							 (and (eql (mem seq n) (mem seq (- n 1))) (func seq (+ n 1) (- k 1))))))
			(func seq 1 k)))
	

(defun increasing-seq-p (seq k)
	(labels ((func (seq n k)
						(or (= k 1)
							 (and (> (mem seq n) (mem seq (- n 1))) (func seq (+ n 1) (- k 1))))))
			(func seq 1 k)))


(defun even-members (seq)
	(lambda (n) (mem seq (* n 2))))

(defun zero-row-p (fun row)
	(accumulate (lambda (n) (funcall tbl row n)) 0 9 #'eql 0))

(defun transpose-table (fun)
	(lambda (row column) (funcall fun column row)))
