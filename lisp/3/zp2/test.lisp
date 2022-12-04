(setf wnd (make-instance 'window))
(setf smp (make-instance 'semaphore))
(setf cr (make-instance 'crossroads))

(let ((smp1 (move (set-semaphore-type (make-instance 'semaphore) :vehicle) 0 0))
			(smp2 (move (set-semaphore-type (make-instance 'semaphore) :pedestrian) 100 0))
			(smp3 (move (set-semaphore-type (make-instance 'semaphore) :vehicle) 200 0))
			(smp4 (move (set-semaphore-type (make-instance 'semaphore) :vehicle) 400 0)))
	(set-items cr (list smp1 (make-instance 'circle) smp2 smp3 smp4))
	(set-program cr (list (list 1 0 1 1) (list 5 0 1 2) (list 3 1 1 3))))


(set-shape wnd cr)
