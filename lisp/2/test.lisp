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

