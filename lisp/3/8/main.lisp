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

(defmethod initialize-instance ((w circle-with-arrows-window))
	(do-set-shape  (make-instance 'pciture))
	(set-items (shape w) (list (set-filledp (move (set-radius (make-instance 'circle) 50) 200 200) t) (move (make-arrow 

(defmethod window-mouse-down ((w circle-with-arrows-window))
	(

