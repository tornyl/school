(setf wnd (make-instance 'window))
(setf smp (make-instance 'semaphore))
(setf cr (make-instance 'crossroads))

(set-shape wnd cr)
