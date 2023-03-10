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

(defclass abstract-cwa (abstract-picture)
  ())

(defmethod initialize-instance ((pic abstract-cwa) &key)
  (call-next-method)
  (do-set-items pic (cwa-items))
  pic)

(defmethod cwa-circle ((p abstract-cwa))
  (first (items p)))

(defmethod cwa-arrow ((p abstract-cwa))
  (second (items p)))

;; První možnost řešení události ev-mouse-down u šipky:
(defclass circle-with-arrow-1 (abstract-cwa)
  ())

(defmethod ev-mouse-down ((p circle-with-arrow-1) sender origin button position)
  (when (eql origin (cwa-arrow p))
    (move (cwa-circle p) 0 -10))
  (call-next-method))

;; Druhá možnost řešení události ev-mouse-down u šipky:
(defclass circle-with-arrow-2 (abstract-cwa)
  ())

(defmethod initialize-instance ((cwa circle-with-arrow-2) &key)
  (call-next-method)
  (add-event (cwa-arrow cwa) 'ev-mouse-down 'ev-arrow-click))

(defmethod ev-arrow-click ((cwa circle-with-arrow-2) sender origin button position)
  (move (cwa-circle cwa) 0 -10)
  (send-event cwa 'ev-mouse-down origin button position))

#|
;; Příklady fungují stejně na obě možnosti:

(setf cwa (make-instance 'circle-with-arrow-1))
;;nebo
(setf cwa (make-instance 'circle-with-arrow-2))

(setf w (make-instance 'window))
(set-shape w cwa)
;;(klikat lze na šipku i kolečko)

(setf pic (set-items (make-instance 'picture)
                     (list (make-instance 'circle-with-arrow-1)
                           (move (make-instance 'circle-with-arrow-2) -100 0)
                           (move (make-instance 'circle-with-arrow-2)  100 0))))

(set-shape w pic)
|#




