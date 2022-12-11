(defclass bounds ()
	((top-left (make-instance 'point)
	 (top-right (make-instance 'point))))
	 (bottom-left (make-instance 'point))
	 (bottom-right (make-instance 'point))	

(defmethod top-left ((b bounds))
	(make-point (left b) (top b)))

(defmethod top-right ((b bounds))
	(make-point (right b) (top b)))

(defmethod bottom-left ((b bounds))
	(make-point (left b) (bottom b)))

(defmethod bottom-right ((b bounds))
	(make-point (bottom b) (bottom b)))

(defmethod make-bounding-rectangle ((b bounds))
	(set-items (make-instance 'polygon) (list (top-left b) (top-right b) (bottom-right b) (bottom-left b))))

(defclass bp-circle (bounds circle)
	())
