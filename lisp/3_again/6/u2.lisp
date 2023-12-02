

; list ve tvaru (typ barvy program)
(defparameter *semaphore-types* (list (list :vehicle (list :red :orange :green) (list (list 1 0 0) (list 1 1 0)  (list 0 1 0) (list 0 0 1)))
											  (list  :pedestrian (list :red :green) (list  (list 1 0) (list 0 1)))))

(defparameter *semaphore-size* 1)
(defparameter *semaphore-background* :black)
(defparameter *semaphore-width* 80)
(defparameter *light-size* 30)


(defclass semaphore (abstract-picture)
	((semaphore-type :initform :vehicle)
	 (semaphore-phase :initform 0)))
	
(defmethod initialize-instance ((smp semaphore) &key)
	(call-next-method)
	(set-semaphore-type smp :vehicle))

(defmethod check-semaphore-type ((smp semaphore) value)
	(unless (find value (mapcar #'car *semaphore-types*))
		(error "invalid semaphore type"))
	smp)

(defmethod semaphore-type ((smp semaphore))
	(slot-value smp 'semaphore-type))

(defmethod do-set-semaphore-type ((smp semaphore) value)
	(setf (slot-value smp 'semaphore-type) value))

(defmethod set-semaphore-type ((smp semaphore) value)
	(check-semaphore-type smp value)
	(changing smp)
	(do-set-semaphore-type smp value)
	(create smp)
	(set-semaphore-phase smp 0)
	(change smp)
	smp)

(defmethod info ((smp semaphore))
	(find-if (lambda (list) (eql (car list) (semaphore-type smp))) *semaphore-types*))

(defmethod semaphore-phase ((smp semaphore))
	(slot-value smp 'semaphore-phase))

(defmethod check-semaphore-phase ((smp semaphore) value)
	(unless (<= 0 value (phase-count smp))
		(error "wrong phase"))
	smp)

(defmethod do-set-semaphore-phase ((smp semaphore) value)
	(setf (slot-value smp 'semaphore-phase) value))

(defmethod set-semaphore-phase ((smp semaphore) value)
	(check-semaphore-phase smp value)
	(changing smp)
	(do-set-semaphore-phase smp value)
	(update-view smp)
	(change smp)
	smp)

(defmethod update-view ((smp semaphore))
	(let* ((setting (nth (semaphore-phase smp) (third (info smp))))
			 (i 0))
		(dolist (item setting)
			(if (= item 1)
				(turn-on (nth i (items smp)))
			 (turn-off (nth i (items smp))))
			(setf i (+ i 1)))
		smp))

(defmethod phase-count ((smp semaphore))
	(length (third (info smp))))

(defmethod create ((smp semaphore))
	(let* ((lights-count (length (second (info smp))))
			 (box (create-box smp lights-count))
			 (lights (create-lights smp lights-count (second (info smp)))))
		(scale (do-set-items smp (append lights (list box))) *semaphore-size* (make-point 0 0))
		smp))

(defmethod create-box ((smp semaphore) lights-count)
	(let  ((x-list (list 0 0 *semaphore-width* *semaphore-width*))
			(y-list (list 0 (+ (+ *light-size* 20) (* lights-count (* *light-size* 2))) (+ (+ *light-size* 20) (* lights-count (* *light-size* 2))) 0)))
		(set-filledp (set-color (set-items (make-instance 'polygon) (mapcar #'make-point x-list y-list)) *semaphore-background*) t)))

(defmethod create-lights ((smp semaphore) lights-count colors)
	(let ((lights '())
			(light nil))
		(dotimes (i lights-count)
			(setf light (move (set-radius (set-off-color (set-on-color (make-instance 'light) (nth i colors)) :grey) *light-size*) (+ *light-size* (/ *light-size* 3)) (+ *light-size* (/ *light-size* 3) (* i (+ *light-size* 43)))))
			(setf lights (append lights (list light))))
		lights))

(defmethod next-phase ((smp semaphore))
	(set-semaphore-phase smp (rem (+ (semaphore-phase smp) 1) (phase-count smp)))
	smp)





(defclass crossroads (picture)
	((program :initform nil)
	 (crossroads-phase :initform 0)))

(defmethod program ((cr crossroads))
	(slot-value cr 'program))

(defmethod check-program ((cr crossroads) value)
	(unless (and (listp value) (apply #'= (mapcar #'length value)))
		(error "This is not a program"))
	cr)

(defmethod do-set-program ((cr crossroads) value)
	(setf (slot-value cr 'program) value)
	cr)

(defmethod set-program ((cr crossroads) value)
	(check-program cr value)
	(do-set-program cr value)
	(set-crossroads-phase cr 0)
	cr)

(defmethod semaphores ((cr crossroads))
	(labels ((f (item-list)
						(apply #'append
							(mapcar (lambda (item) 
											(cond ((typep item 'semaphore) (list item))
											((typep item 'abstract-picture) (f (items item)))
											(t '()))) 
									item-list))))
		(f (items cr))))

(defmethod crossroads-phase ((cr crossroads))
	(slot-value cr 'crossroads-phase))

(defmethod do-set-crossroads-phase ((cr crossroads) value)
	(setf (slot-value cr 'crossroads-phase) value)
	cr)

(defmethod check-crossroads-phase ((cr crossroads) value)
	(unless (<= 0 value (phase-count cr))
		(error "Invalid phase"))
	cr)

(defmethod set-crossroads-phase ((cr crossroads) value)
	(check-crossroads-phase cr value)
	(changing cr)
	(do-set-crossroads-phase cr value)
	(update-view cr)
	(change cr))

(defmethod phase-count ((cr crossroads))
	(length (program cr)))

(defmethod check-view ((cr crossroads))	
	(unless (= (length (semaphores cr)) (length (first (program cr))))
		(error "Program does not match number of semaphores in items"))
	cr)

(defmethod update-view ((cr crossroads))
	(when (check-view cr)
		(dotimes (i (length (first (program cr))))
			(set-semaphore-phase (nth i (semaphores cr)) (nth i (nth (crossroads-phase cr) (program cr))))))
	cr)
		
(defmethod next-phase ((cr crossroads))
	(set-crossroads-phase cr (rem (+ (crossroads-phase cr) 1) (phase-count cr))))


