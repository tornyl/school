;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 08_cwa.lisp - příklad k přednášce 8
;;;;

#|

Třída circle-with-arrows 
ukázka použití více objektů v obrázku jako tlačítek

Kromě standardních souborů je třeba načíst soubor 07_click-circle.lisp

|#

;;;
;;; Pomocné funkce.
;;; Stejné jako v 08_cwa.lisp. Může tedy dojít k warningům.
;;;

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
#|
;; jak vypadá šipka?

(setf w (make-instance 'window))
(set-shape w (make-arrow :black))
(move (shape w) 100 100)

;; Mimochodem:

(mg:get-size (slot-value w 'mg-window))
|#

(defun cw2a-items (arr-color)
  (let ((arr1 (make-arrow arr-color))
        (arr2 (make-arrow arr-color))
        (circ (make-instance 'click-circle)))
    (move arr1 90 150)
    (rotate arr2 pi (make-instance 'point))
    (move arr2 207 150)
    (set-radius circ 50)
    (move circ 148 60)
    (set-filledp circ t)
    (list circ arr1 arr2)))

#|
;; test cw2a-items
(setf w (make-instance 'window))
(set-shape w (set-items (make-instance 'picture)
                        (cw2a-items :black)))
|#

(defclass cw2a (abstract-picture)
  ())

(defmethod initialize-instance ((cwa cw2a) &key)
  (call-next-method)
  (do-set-items cwa (cw2a-items :dark-blue))
  cwa)

(defmethod cwa-circle ((cwa cw2a))
  (first (items cwa)))

(defmethod cwa-left-arr ((cwa cw2a))
  (second (items cwa)))

(defmethod cwa-right-arr ((cwa cw2a))
  (third (items cwa)))

(defmethod ev-mouse-down ((cwa cw2a) sender origin button position)
  (call-next-method)
  (when (eql button :left)
    (cond ((eql sender (cwa-left-arr cwa)) (move (cwa-circle cwa) -10 0))
          ((eql sender (cwa-right-arr cwa)) (move (cwa-circle cwa) 10 0)))))


#|
(setf w (make-instance 'window))
(set-shape w (make-instance 'cw2a))
|#