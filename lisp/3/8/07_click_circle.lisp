;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 07_click-circle.lisp - příklad ke kapitole 7
;;;;

#|

Třída click-circle. Kolečko po kliknutí změní barvu.

|#

(defun random-color () 
  (color:make-rgb (random 1.0)
                  (random 1.0)
                  (random 1.0)))


(defclass click-circle (circle) ())

(defmethod mouse-down ((circ click-circle) button position)
  (call-next-method)
  (set-color circ (random-color)))


#|

(defun make-test-click-circle ()
  (set-filledp (set-radius (make-instance 'click-circle)
                           45)
               t))

(setf w (make-instance 'window))
(setf c (move (make-test-click-circle) 148 100))
;; Klikejte do kolečka:
(set-shape w c)

(setf circles (make-instance 'picture))
(set-items circles
           (list (move (make-test-click-circle) 103 55)
                 (move (make-test-click-circle) 193 55)
                 (move (make-test-click-circle) 103 145)
                 (move (make-test-click-circle) 193 145)))
;; Klikejte do koleček:
(set-shape w circles)

|#
