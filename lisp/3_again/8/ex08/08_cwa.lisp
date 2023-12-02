;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 08_cwa.lisp - příklad k přednášce 8
;;;;

#|

Třída circle-with-arrow. 
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

;; Společné rysy obou tříd dáme do společného předka:

(defclass circle-with-arrow (abstract-picture)
  ())

(defmethod initialize-instance ((pic circle-with-arrow) &key)
  (call-next-method)
  (do-set-items pic (cwa-items))
  pic)

(defmethod cwa-circle ((p circle-with-arrow))
  (first (items p)))

(defmethod cwa-arrow ((p circle-with-arrow))
  (second (items p)))

(defmethod ev-mouse-down ((p circle-with-arrow) sender origin button position)
  (when (eql origin (cwa-arrow p))
    (move (cwa-circle p) 0 -10))
  (call-next-method))



#|

(setf cwa (make-instance 'circle-with-arrow))

(setf w (make-instance 'window))
(set-shape w cwa)
;;(klikat lze na šipku i kolečko)

(setf pic (set-items (make-instance 'picture)
                     (list (make-instance 'circle-with-arrow)
                           (move (make-instance 'circle-with-arrow) -100 0)
                           (move (make-instance 'circle-with-arrow)  100 0))))

(set-shape w pic)
|#




