
;; zadne warningy mne to nevypisuje, ani u check-semaphore-phase.

(defclass semaphore (abstract-picture)
	((semaphore-type :initform :pedestrian)	
	 (phase-count :initform 2)
	 (semaphore-phase :initform -1)
	 (stages :initform '( (0 1) (1 0))))
	)

(defmethod initialize-instance ((smp semaphore) &key)
	(call-next-method)
	;;(set-semaphore-type smp :vehicle)
	)

(defmethod check-items ((smp semaphore) item-list)
	(error "menit slot items primozare je zakazano"))

(defmethod check-semaphore-type ((smp semaphore) type)
	(unless (or (eql type :pedestrian) (eql type :vehicle))
		(error "Invalid semaphore type"))
	smp)

(defmethod do-set-semaphore-type ((smp semaphore) type)
	(check-semaphore-type smp type)
	(setf (slot-value smp 'semaphore-type) type)
		smp)

(defmethod set-semaphore-type ((smp semaphore) type)
	(do-set-semaphore-type smp type)
	(make-semaphore smp))

(defmethod make-semaphore ((smp semaphore))
	(when (eql (semaphore-type smp) :pedestrian)
			(set-phase-count smp 2)
			(set-stages smp (list (list 0 1) (list 1 0)))
			(do-make-semaphore smp :red :green))
	(when (eql (semaphore-type smp) :vehicle)
			(set-phase-count smp 4)
			(set-stages smp (list (list 0 0 1) (list 0 1 1) (list 0 1 0) (list 1 0 0) ))
			(do-make-semaphore smp :red :orange :green))	
		(setf (slot-value smp 'semaphore-phase)  -1)
		(next-phase smp)
		smp)

(defmethod semaphore-type ((smp semaphore))
	(slot-value smp 'semaphore-type))

(defmethod check-semaphore-phase ((smp semaphore) phase) 
	(unless (typep phase number)
		(error "phase is not a number"))
	smp)

(defmethod semaphore-phase ((smp semaphore))
	(slot-value smp 'semaphore-phase))

(defmethod set-semaphore-phase ((smp semaphore) phase)
	(setf (slot-value smp 'semaphore-phase) (rem phase (phase-count smp)))
	(change-lights smp))

(defmethod phase-count ((smp semaphore))
	(slot-value smp 'phase-count))

(defmethod set-phase-count ((smp semaphore) phase)
	(setf (slot-value smp 'phase-count) phase))

(defmethod next-phase ((smp semaphore))
	(setf (slot-value smp 'semaphore-phase) (rem (+ 1 (semaphore-phase smp)) (phase-count smp)))
	(change-lights smp))

(defmethod change-lights ((smp semaphore))
	(let ((i 0)
			(new-lights (items smp)))
		(dolist (switch (nth (semaphore-phase smp) (stages smp)))
			(if (= switch 1)
					(turn-on (nth i new-lights))
				(turn-off (nth i new-lights)))
			(setf i (+ i 1)))
		(do-set-items smp new-lights)))	

(defmethod stages ((smp semaphore))
	(slot-value smp 'stages))

(defmethod set-stages ((smp semaphore) stages)
	(setf (slot-value smp 'stages) stages))

(defmethod do-make-semaphore ((smp semaphore) &rest colors)
	(let* ((box (make-instance 'polygon))
			(items '())
			(light-space 10)
			(light-size 15)
			(width (+ (* light-size 2) (* light-space 2)))
			(height (+ (* (length colors) (+ (* light-size 2) light-space)) light-space)))
		(set-items box (list (make-point 0 0) (make-point width 0) (make-point width height) (make-point 0 height)))
		(set-color box :black)
		(set-filledp box t)
		(setf items (cons box items))
		(let ((i 0))
			(dolist (color colors)
				(let ((light (move (set-radius (make-instance 'light) light-size) (/ width 2) (+ light-space light-size (* i (+ light-space (* light-size 2)))))))
					(set-on-color light color)
					(set-off-color light :grey)
					(setf items (cons light items))
					(setf i (+ i 1)))))
		(do-set-items smp items)))

(defun make-point (x y)
	(let ((point (make-instance 'point)))
		(move point x y)
		point))

(defclass crossroads (abstract-picture)
	((crossroads-phase :initform -1)
	 (program :initform '())
	 (items :initform '())))

(defmethod initialize-instance ((cr crossroads) &key)
	(call-next-method))

(defmethod check-items ((cr crossroads) item-list)
	(do-check-items cr item-list))

(defmethod phase-count ((cr crossroads))
	(length (program cr)))

(defmethod set-crossroads-phase ((cr crossroads) phase)
	(setf (slot-value cr 'crossroads-phase) phase))

(defmethod program ((cr crossroads))
	(slot-value cr 'program))

(defmethod do-set-program ((cr crossroads) program)
	(setf (slot-value cr 'program) program))

(defmethod set-program ((cr crossroads) program)
	(do-set-program cr (mapcar #'reverse program))
	(set-crossroads-phase cr -1)
	(next-phase cr))

(defmethod crossroads-phase ((cr crossroads))
	(slot-value cr 'crossroads-phase))

;;(defun flatten (list)
;;	(cond ((consp list) (append (flatten (car list)) (flatten (cdr list))))
;;			((eql list nil) '())
;;			(t (list list))))

(defmethod semaphores ((cr crossroads))
	(let ((objects '()))
		(labels ((find-semaphores (shape)
						(dolist (item (items shape))
							(cond ((typep item 'semaphore) (setf objects (cons item objects)))
									((typep item 'abstract-picture) (find-semaphores item))
									(t t)))))
			(find-semaphores cr))
		objects))

(defmethod next-phase ((cr crossroads))
	(setf (slot-value cr 'crossroads-phase) (rem (+ 1 (crossroads-phase cr)) (phase-count cr)))
	(change-semaphores cr))	

(defmethod change-semaphores ((cr crossroads))
	(let ((semaphores (semaphores cr))
			(stages (nth (crossroads-phase cr) (program cr)))
			(i 0))
		(dolist (semaphore semaphores)
			(set-semaphore-phase semaphore (nth i stages))
			(setf i (+ i 1)))))





