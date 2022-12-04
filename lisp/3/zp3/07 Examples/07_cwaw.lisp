;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 07_cwaw.lisp - příklad ke kapitole 7
;;;;

#|

Třída circle-with-arrow-window. 
Jednoduchá ukázka použití objektu jako tlačítka a události ev-mouse-down.

Kromě standardních souborů je třeba načíst soubor 07_click-circle.lisp

|#

(defun make-point (x y)
  (move (make-instance 'point) x y))

(defun make-polygon (x-list y-list filledp closedp color)
  (set-closedp (set-filledp
                (set-color
                 (set-items (make-instance 'polygon)
                            (mapcar 'make-point x-list y-list))
                 color)
                filledp)
               closedp))

(defun make-arrow (color)
  (make-polygon '(0 0 30 30 0 0 -30)
                '(-30 -15 -15 15 15 30 0)
                t
                t
                color))

(defun cwa-items ()
  (list (move (set-filledp (set-radius (make-instance 'click-circle)
                                       40)
                           t)
              148
              60)
        (move (rotate (make-arrow :blue)
                      (/ pi 2)
                      (make-instance 'point))
              148
              150)))

(defun cwa-pic ()
  (set-items (make-instance 'picture) (cwa-items)))

(defclass cwa-window (abstract-window)
  ())

(defmethod initialize-instance ((w cwa-window) &key)
  (call-next-method)
  (do-set-shape w (cwa-pic))
  (invalidate w))

(defmethod cwa-circle ((w cwa-window))
  (first (items (shape w))))

(defmethod cwa-arrow ((w cwa-window))
  (second (items (shape w))))

(defmethod ev-mouse-down ((w cwa-window) shape button position)
  (when (eql shape (cwa-arrow w))
    (move (cwa-circle w) 0 -10))
  (call-next-method))

#|
(setf cwa (make-instance 'cwa-window))
;;(klikat lze na šipku i kolečko)
|#