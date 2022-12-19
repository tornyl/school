;; kdyby inspector informace nebyly videt je treba trosku zvetsit okno
;; zadny warning mi to nevypisuje, ale dival jsem se na nej a stale nevim cim to je.
(defclass inspector-window (abstract-window)
	((inspected-window :initform nil)
	 (inspected-object :initform nil)
	 (object-properties-list :initform nil)))

(defmethod initialize-instance ((w inspector-window) &key)
	(call-next-method)
	(let ((shape (list 'color 'thickness 'filledp))
			(point (list 'x 'y 'phi))
			(circle (list 'radius))
			(compound-shape (list 'items))
			(polygon (list  'closedp)))
		(add-object-properties w 'shape shape)
		(add-object-properties w 'point (append shape point))
		(add-object-properties w 'circle (append shape circle))
		(add-object-properties w 'picture (append shape compound-shape))
		(add-object-properties w 'polygon (append shape compound-shape polygon)))
	(display-window-info w))


(defmethod install-callbacks ((w inspector-window))
  (call-next-method)
  (install-double-click-callback w))

(defmethod install-mouse-down-callback ((w inspector-window))
	(mg:set-callback (slot-value w 'mg-window)
		:mouse-down nil))

(defmethod install-double-click-callback ((w inspector-window))
  (mg:set-callback 
   (slot-value w 'mg-window) 
   :double-click (lambda (mgw button x y)
		 (declare (ignore mgw))
		 (window-mouse-down 
                  w
                  button 
                  (move (make-instance 'point) x y)))))

(defmethod check-shape ((w inspector-window) shape)
	t)



(defmethod object-properties-list ((w inspector-window))
	(slot-value w 'object-properties-list))

(defmethod add-object-properties ((w inspector-window) object-type properties-list)
	(setf (slot-value w 'object-properties-list) (append (object-properties-list w) (list (cons object-type properties-list)))))

(defmethod inspected-object ((w inspector-window))
	(slot-value w 'inspected-object))

(defmethod set-inspected-object ((w inspector-window) value)
	(setf (slot-value w 'inspected-object) value))

(defmethod inspected-window ((w inspector-window))
	(slot-value w 'inspected-window))

(defmethod set-inspected-window ((w inspector-window) win)
	(clear-inspected-delegate w)
	(do-set-inspected-window w win)
	(display-window-info w))

(defmethod do-set-inspected-window ((w inspector-window) win)
	(setf (slot-value w 'inspected-window) win)
	(when win 
		(set-delegate win w)
		(add-event win 'ev-mouse-down 'ev-iw-inspect-object)
		(add-event win 'ev-mouse-down-no-shape 'ev-iw-inspect-window)))

(defmethod clear-inspected-delegate ((w inspector-window))
	(when (inspected-window w)
		(set-delegate (inspected-window w) nil)))

(defmethod display-window-info ((w inspector-window))
	(if (inspected-window w)
			(do-display-info-about-window w)
		(do-display-info-no-window w)))

(defmethod do-display-info-no-window ((w inspector-window))
	(set-shape w (make-window-info w 'text-shape-w-prop "Neni nastaveno zadne okno k prohlizeni")))

(defmethod do-display-info-about-window ((w inspector-window))	
	(let ((pic (make-instance 'picture))
			(object-count (make-window-info w 'text-shape-nosolid (format nil "okno obsahuje  s ~a objekty" (solid-shapes-count (inspected-window w)))))
			(b-color (make-window-info-text w 'text-shape-w-prop (format nil "barva okna je ~a" (background (inspected-window w))) 10 70 10)))
		(add-event pic 'ev-mouse-down 'ev-property-click)
		(set-prop b-color 'w-background)
		(set-items pic (list object-count b-color))
		(set-shape w pic)))

(defmethod make-window-info ((w inspector-window) type text)
	(make-window-info-text w type text 10 30 10))

(defmethod make-window-info-text ((w inspector-window) type text x y scale-coeff)
	(scale (move (set-text (make-instance type) text) x y ) scale-coeff (move (make-instance 'point) x y)))	

(defmethod ev-iw-inspect-object ((w inspector-window) sender object button position)
	(let* ((props (object-properties w object))
			 (pairs (mapcar (lambda(x) (cons x (funcall x object))) props))
			 (pic (make-instance 'picture))
			 (window-info (make-window-info w 'text-shape-nosolid (format nil "informace o ~a" (type-of object))))
			 (i 2)
			 (default-props (list 'scale 'rotate 'move-x 'move-y)))
		(set-inspected-object w object)
		(dolist (item pairs)
			(setf text (make-window-info-text w 'text-shape-w-prop (format nil "~a ~a" (car item) (cdr item)) 50 (+ 150 (* i (+ 20 (- (bottom window-info) (top window-info))))) 10))
			(set-prop text (car item))
			(set-delegate text pic)
			(set-items pic (cons text (items pic)))
			(setf i (+ i 1)))
		(when (typep object 'shape)
			(dolist (item default-props)
				(setf text (make-window-info-text w 'text-shape-w-prop (format nil "~a " item) 50 (+ 150 (* (+ i 1) (+ 20 (- (bottom window-info) (top window-info))))) 10))
				(set-prop text item)
				(set-delegate text pic)
				(set-items pic (cons text (items pic)))
				(setf i (+ i 1))))
		(set-delegate pic w)
		(add-event pic 'ev-mouse-down 'ev-property-click)
		(set-items pic (cons window-info (items pic)))
		(set-shape w pic)))

(defmethod ev-iw-inspect-window ((w inspector-window) sender button position)
	(display-window-info w))

(defmethod object-properties ((w inspector-window) object)
	(let ((prop-list nil))
		(dolist (object-type-list (object-properties-list w))
			(when (eql (type-of object) (car object-type-list))
				(setf prop-list (cdr object-type-list))))
		prop-list))

(defmethod ev-property-click ((w inspector-window) sender clicked button position)
	(let ((new-val (multiple-value-list(capi:prompt-for-value "Zadejte novou hodnotu"))))
		(when (cadr new-val)
			(cond ((eql (prop clicked) 'scale) (scale (inspected-object w) (car new-val) (make-instance 'point))) 
					((eql (prop clicked) 'rotate) (rotate (inspected-object w) (car new-val) (make-instance 'point)))
					((eql (prop clicked) 'move-x) (move (inspected-object w) (car new-val) 0))
					((eql (prop clicked) 'move-y) (move (inspected-object w) 0 (car new-val)))
					((eql (prop clicked) 'w-background) (set-background (inspected-window w)(car new-val)))
					(t (progn (funcall (setter-name (prop clicked)) (inspected-object w) (car new-val))
								 (set-text clicked (format nil "~a ~a" (prop clicked) (car new-val)))))))))

(defclass inspected-window (window)
	())


;;(defmethod mouse-down-no-shape ((w inspected-window) button  position)
;;	(ev-mouse-down-no-shape w button position))
(defmethod mouse-down-no-shape ((w inspected-window) button  position)
  (send-event w 'ev-mouse-down-no-shape button position))

(defmethod ev-mouse-down-no-shape ((w inspected-window) button position)
	w)
 
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


(defclass text-shape-nosolid (text-shape)
	())

(defmethod solidp ((ts text-shape-nosolid))
	nil)

(defmethod solid-subshapes ((ts text-shape-nosolid))
	nil)

(defmethod contains-point-p ((ts text-shape-nosolid) point)
	nil)
;; Pkud uzivatel bude chtit pridat dalsi typ objektu staci zavolat funkci add-object-properties, kde uvede typ objktu a seznam vsench nastavitelnych vlastnosti

