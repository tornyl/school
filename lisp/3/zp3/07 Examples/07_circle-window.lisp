;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 07_circle-window.lisp - příklad ke kapitole 7
;;;;

#|

Třída circle-window: po kliknutí se kolečko přesune pod myš

Přepisuje metodu window-mouse-down, takže okno nepokračuje
ve standardním zpracování kliknutí (neposílá se zpráva mouse-down,
negeneruje se událost ev-mouse-down).

|#

(defun make-test-circle ()
  (move (set-radius (set-thickness (set-color 
                                    (make-instance 'circle)
                                    :darkslategrey)
                                   30)
                    55)
        148 
        100))

(defclass circle-window (abstract-window)
  ())

(defmethod initialize-instance ((w circle-window) &key)
  (call-next-method)
  (do-set-shape w (make-test-circle))
  (invalidate w))

(defmethod window-mouse-down 
           ((w circle-window) button position)
  (when (eql button :left)
    (let ((circle (shape w)))
      (move circle 
            (- (x position) (x (center circle)))
            (- (y position) (y (center circle))))))
  w)


#|

(make-instance 'circle-window)

|#