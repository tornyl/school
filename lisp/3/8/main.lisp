(defclass polygon-window (abstract-window)
())

(defmethod initialize-instance ((w polygon-window) &key)
	(call-next-method)
	(do-set-shape w (make-instance 'polygon)))

(defmethod window-mouse-down ((w polygon-window) button position)
	(when (eql button :left)
		(set-items (shape w)  (cons position (items (shape w)))))
	(when (eql button :right)
		(set-items (shape w) '())))



(defclass circle-with-arrows-window (abstract-window)
())

(defmethod initialize-instance ((w circle-with-arrows-window) &key)
	(call-next-method)
	(do-set-shape w (make-instance 'picture))
	(set-items (shape w) (list (set-filledp (move (set-radius (make-instance 'circle) 50) 200 300) t) (move (make-arrow :red) 30 30) (rotate (move (make-arrow :red) 200 30) PI (make-point 200 30)))))

(defmethod ev-mouse-down ((w circle-with-arrows-window) shape button position)
	(when (eql  shape (second (items (shape w))))
		(move (first (items (shape w))) -50 0))
	(when (eql  shape (third (items (shape w))))
		(move (first (items (shape w))) 50 0)))



(defclass delete-item-picture-window (window)
	())

(defmethod ev-mouse-down ((w delete-item-picture-window) shape button pos)
	(when (typep (shape w) 'picture)
		(set-items (shape w) (remove shape (items (shape w))))))
