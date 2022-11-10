(defclass semaphore (abstract-picture)
	((semaphore-type :initform :pedestrian)	
	 (phase-count :initform 2)
	 (semaphore-phase :initform -1)
	 (stages :initform '()))
	)

(defmethod initialize-instance ((smp semaphore) &key)
	(call-next-method)
	(set-semaphore-type smp :vehicle))

(defmethod check-items ((smp semaphore) item-list)
	(do-check-items smp item-list))

(defmethod check-semaphore-type ((smp semaphore) type)
	(unless (or (eql type :pedestrian) (eql type :vehicle))
		(error "Invalid semaphore type"))
	smp)

(defmethod set-semaphore-type ((smp semaphore) type)
	(check-semaphore-type smp type)
	(setf (slot-value smp 'semaphore-type) type)
	(when (eql (semaphore-type smp) :pedestrian)
		(set-phase-count smp 2)
		(setf (slot-value smp 'stages)  (list (list 0 1) (list 1 9)))
		(make-semaphore smp :red :green))
	(when (eql (semaphore-type smp) :vehicle)
		(set-phase-count smp 4)
		(setf (slot-value smp 'stages) (list (list 0 0 1) (list 0 1 1) (list 0 1 0) (list 1 0 0) ))
		(make-semaphore smp :red :orange :green))
	
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
	(setf (slot-value smp 'semaphore-phase) phase)
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
		(set-items smp new-lights)))

		

(defmethod stages ((smp semaphore))
	(slot-value smp 'stages))

(defmethod make-semaphore ((smp semaphore) &rest colors)
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
		(set-items smp items)))


(defun make-point (x y)
	(let ((point (make-instance 'point)))
		(move point x y)
		point))

(defclass crossroads (abstract-picture)
	((crossroads-phase :initform -1)
	 (program :initform '())
	 (items :initform (list (make-instance 'semaphore) (move (make-instance 'semaphore) 100 0) (move (make-instance 'semaphore) 200 0)))))

(defmethod initialize-instance ((cr crossroads) &key)
	(call-next-method)
;;	(let ((smp1 (set-semaphore-type (make-instance 'semaphore) :vehicle))
;;			(smp2 (set-semaphore-type (make-instance 'semaphore) :vehicle))
;;			(smp3 (set-semaphore-type (make-instance 'semaphore) :vehicle)))
	(print "xd")
	(set-program cr (list (list 1 0 2) (list 3 0 1) (list 3 3 1)))
	(next-phase cr))


(defmethod check-items ((cr crossroads) item-list)
	(do-check-items cr item-list))

;;(defmethod set-items ((cr crossroads) items)
;;	(call-next-method))

(defmethod phase-count ((cr crossroads))
	(length (program cr)))

(defmethod program ((cr crossroads))
	(slot-value cr 'program))

(defmethod set-program ((cr crossroads) program)
	(setf (slot-value cr 'program) program))

(defmethod crossroads-phase ((cr crossroads))
	(slot-value cr 'crossroads-phase))

(defmethod semaphores ((cr crossroads))
	(let ((objects '()))
	(dolist (item (items cr))
		(when (typep item 'semaphore)
			(setf objects (cons item objects))))
	objects))

(defmethod next-phase ((cr crossroads))
	(setf (slot-value cr 'crossroads-phase) (rem (+ 1 (crossroads-phase cr)) (phase-count cr)))
	(change-semaphores cr))	

(defmethod change-semaphores ((cr crossroads))
	(let ((semaphores (semaphores cr))
			(stages (nth (crossroads-phase cr) (program cr)))
			(i 0))
		(print (length semaphores))
		(dolist (semaphore semaphores)
			(set-semaphore-phase semaphore (nth i stages))
			(setf i (+ i 1)))))





