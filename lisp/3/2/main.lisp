(defclass databaze ()
	((uzivatele :initform (list))
	(hodnoceni :initform (list))
	(filmy :initform (list))))

(defmethod create-user ((db databaze) jmeno)
	(let ((new-user (make-instance 'uzivatel)))
		
		(setf (slot-value new-user 'jmeno) jmeno
				(slot-value new-user 'databaze) db
			(slot-value db 'uzivatele) (append (slot-value db 'uzivatele) (list new-user)))))

(defmethod list-users ((db databaze))
	(mapcar (lambda (user) (slot-value user 'jmeno)) (slot-value db 'uzivatele)))

(defclass uzivatel ()
	(jmeno
	databaze))

(defclass hodnoceni ()
	(uzivatel
	film
	hodnota))

(defclass film ()
	(jmeno
	zeme
	databaze))
