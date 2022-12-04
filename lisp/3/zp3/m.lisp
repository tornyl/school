(defclass inspector-window (abstract-window)
	((inspected-window :initform nil)
	 (inspected-object :initform nil)))

(defmethod initialize-instance ((w inspector-window) &key)
	(call-next-method)
	(display-window-info w))

(defmethod check-shape ((w inspector-window) shape)
	t)

(defmethod inspected-object ((w inspector-window))
	(slot-value w 'inspected-object))

(defmethod set-inspected-object ((w inspector-window) value)
	(setf (slot-value w 'inspected-object) value))

(defmethod inspected-window ((w inspector-window))
	(slot-value w 'inspected-window))

(defmethod set-inspected-window ((w inspector-window) win)
	(do-set-inspected-window w win)
	(display-window-info w))

(defmethod do-set-inspected-window ((w inspector-window) win)
	(setf (slot-value w 'inspected-window) win)
	(when win 
		(set-delegate win w)
		(add-event win 'ev-mouse-down 'ev-iw-inspect-object)
		(add-event win 'ev-mouse-down-no-shape 'ev-iw-inspect-window)))

(defmethod display-window-info ((w inspector-window))
	(if (inspected-window w)
			(do-display-info-about-window w)
		(do-display-info-no-window w)))

(defmethod do-display-info-no-window ((w inspector-window))
	(set-shape w (make-window-info w "Neni nastaveno zadne okno k prohlizeni")))

(defmethod do-display-info-about-window ((w inspector-window))	
	(set-shape w (make-window-info w (format nil "okno  s ~a objekty" (solid-shapes-count (inspected-window w))))))

(defmethod make-window-info ((w inspector-window) text)
	(make-window-info-text  w text 400 10 10))

(defmethod make-window-info-text ((w inspector-window) text x y scale-coeff)
	(scale (move (set-text (make-instance 'text-shape-w-prop) text) x y ) scale-coeff (move (make-instance 'point) x y)))	

(defmethod ev-iw-inspect-object ((w inspector-window) sender object button position)
	(let* ((props (object-properties w object))
			 (pairs (mapcar (lambda(x) (cons x (funcall x object))) props))
			 (pic (make-instance 'picture))
			 (window-info (make-window-info w (format nil "okno s ~a objekty" (solid-shapes-count (inspected-window w)))))
			 (i 0))
		(set-inspected-object w object)
		(dolist (item pairs)
			(setf text (make-window-info-text w (format nil "~a ~a" (car item) (cdr item)) 300 (+ 300 (* i (- (bottom window-info) (top window-info)))) 10))
			(set-prop text (car item))
			(set-delegate text pic)
			(set-items pic (cons text (items pic)))
			(setf i (+ i 1)))
		(set-delegate pic w)
		(add-event pic 'ev-mouse-down 'ev-property-click)
		(set-items pic (cons window-info (items pic)))
		(set-shape w pic)))

(defmethod ev-iw-inspect-window ((w inspector-window) sender button position)
	(display-window-info w))

(defmethod object-properties ((w inspector-window) object)
	(let ((shape (list 'color 'thickness 'filledp))
			(point (list 'x 'y 'phi))
			(circle (list 'radius 'center))
			(compound-shape (list 'items))
			(polygon (list  'closedp)))
		(cond ((eql (type-of object) 'shape) shape)
				((eql (type-of object) 'point) (append shape point))
				((eql (type-of object) 'circle) (append shape circle))
				((eql (type-of object) 'picture) (append shape compound-shape))
				((eql (type-of object) 'polygon) (append shape compound-shape polygon)))))

(defmethod ev-property-click ((w inspector-window) sender clicked button position)
	(let ((new-val (multiple-value-list(capi:prompt-for-value "Zadejte novou hodnotu"))))
		(when (cadr new-val)
			(print (prop clicked))
			(print (car new-val))
			(print (setter-name (prop clicked)))
			(funcall (setter-name (prop clicked)) (inspected-object w) (car new-val))
			(set-text clicked (format nil "~a ~a" (prop clicked) (car new-val))))))

(defclass inspected-window (window)
	())

(defmethod mouse-down-no-shape ((w inspected-window) button  position)
	(ev-mouse-down-no-shape w button position))

(defmethod ev-mouse-down-no-shape ((w inspected-window) button position)
  (send-event w 'ev-mouse-down-no-shape button position))
 
(defmethod solid-shapes-count ((w inspected-window))
	(if (shape w)
			(length (solid-shapes (shape w)))
		0))

(defclass text-shape-w-prop (text-shape)
 ((prop :initform nil)))

(defmethod prop ((ts text-shape-w-prop))
	(slot-value ts 'prop))

(defmethod set-prop ((ts text-shape-w-prop) value)
	(setf (slot-value ts 'prop) value))

(defun setter-name (prop)
	(values (find-symbol (format nil "SET-~a" prop))))
