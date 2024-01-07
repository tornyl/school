
(defmacro test-weird (expr)
	(format t "E: ~A~%" expr)
	(print expr)
	(list 'print expr))

(defmacro test (expr)
	`(progn (format t "E: ~A~%~A~%" ',expr ,expr)))

;;(test (setf b 4))
;;(macroexpand '(test (setf b 4)))
