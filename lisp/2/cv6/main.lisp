(defun make-elist (&rest elements)
  (list 'elist
        (copy-list elements)
        nil
        nil
		  nil
		  nil))

(defun clear-cache (elist)
  (setf (third elist) nil
        (fourth elist) nil
		  (fifth elist) nil
		  (sixth elist) nil))

(defun elist-list (elist)
  (second elist))

(defun (setf elist-list) (new-list elist)
  (clear-cache elist)
  (setf (second elist) new-list))

(defun list-average (list)
  (/ (apply #'+ list) 
     (length list)))

(defun elist-average (elist)
  (when (null (third elist))
    (setf (third elist)
          (list-average (elist-list elist))))
  (third elist))

(defun list-median (list)
  (let ((sorted (sort (copy-list list) #'<))
        (length (length list))
        (tail nil))
    (cond ((oddp length) (nth (/ (1- length) 2) sorted))
          (t (setf tail (nthcdr (1- (/ length 2)) sorted))
             (/ (+ (pop tail) (pop tail)) 2)))))

(defun elist-median (elist)
  (when (null (fourth elist))
    (setf (fourth elist)
          (list-median (elist-list elist))))
  (fourth elist))

(defun add-after (val after list)
  (cond ((null after) (cons val list))
        (t (setf (cdr after) 
                 (cons val (cdr after))) 
           list)))

(defun elist-add-after (elist value cons)
  (clear-cache elist)
  (setf (elist-list elist)
        (add-after value cons (elist-list elist)))
  elist)

(defun delete-after (after list)
  (cond ((eql after nil) (cdr list))
        (t (setf (cdr after) (cddr after))
           list)))

(defun elist-delete-after (elist cons)
  (clear-cache elist)
  (setf (elist-list elist)
        (delete-after cons (elist-list elist)))
  elist)

(defun list-min (list)
	(apply #'min list))

(defun elist-min (elist)
	(cond ((null (fifth elist))
				(setf (fifth elist) (list-min (elist-list elist))))
			(t (fifth elist))))

(defun list-max (list)
	(apply #'max list))

(defun elist-max (elist)
	(cond ((null (sixth elist))
				(setf (sixth elist) (list-max (elist-list elist))))
			(t (sixth elist))))

#|
;;; testy (vyhodnocujte v Listeneru)

(setf el (make-elist))
(elist-list el)
(setf (elist-list el) (list 1 2 4 9))
(elist-list el)
(elist-average el)
el
(elist-median el)
el

(setf cons (cddr (elist-list el)))
(elist-add-after el 5 cons)
(elist-delete-after el (cdr cons))
(elist-add-after el 3 (cdr (elist-list el)))
|#



