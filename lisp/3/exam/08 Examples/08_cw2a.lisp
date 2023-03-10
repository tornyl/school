;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 08_cwa.lisp - příklad k přednášce 8
;;;;

#|

Třída circle-with-arrows 
ukázka použití více objektů v obrázku jako tlačítek

Příklad je řešen dvěma způsoby - každý má svou třídu. První pracuje s jednou 
událostí ev-mouse-down, druhý má pro každé tlačítko jinou událost.

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

;;;
;;; Obecná třída cw2a definuje společné části obou tříd.
;;;

(defclass cw2a (abstract-picture)
  ())

(defmethod initialize-instance ((cwa cw2a) &key)
  (call-next-method)
  (do-set-items cwa (cw2a-items :dark-blue))
  cwa)

(defmethod cw2a-circle ((cwa cw2a))
  (first (items cwa)))

(defmethod cw2a-left-arr ((cwa cw2a))
  (second (items cwa)))

(defmethod cw2a-right-arr ((cwa cw2a))
  (third (items cwa)))


;;;
;;; První způsob - třída cw2a-1
;;;
;;; Obrázek reaguje na obecné kliknutí myší a v metodě ev-mouse-down
;;; je rozlišuje.
;;;

(defclass cw2a-1 (cw2a)
  ())

(defmethod ev-mouse-down ((cwa cw2a-1) sender origin button position)
  (call-next-method)
  (when (eql button :left)
    (cond ((eql sender (cw2a-left-arr cwa)) (move (cw2a-circle cwa) -10 0))
          ((eql sender (cw2a-right-arr cwa)) (move (cw2a-circle cwa) 10 0)))))


;;;
;;; Druhý způsob - cw2a-2
;;;
;;; Obrázek definuje pro každou šipku zvláštní událost.
;;;

(defclass cw2a-2 (cw2a)
  ())

(defmethod initialize-instance ((cwa cw2a-2) &key)
  (call-next-method)
  (add-event (cw2a-left-arr cwa) 'ev-mouse-down 'ev-mouse-down-l)
  (add-event (cw2a-right-arr cwa) 'ev-mouse-down 'ev-mouse-down-r)
  cwa)

;; V následujících metodách na konci posíláme manuálně událost ev-mouse-down.
;; V předchozí třídě cw2a-1 se to dělo automaticky v call-next-method
;; metody ev-mouse-down.
(defmethod ev-mouse-down-l ((cwa cw2a-2) sender origin button position)
  (when (eql button :left)
    (move (cw2a-circle cwa) -10 0))
  (send-event cwa 'ev-mouse-down origin button position))

(defmethod ev-mouse-down-r ((cwa cw2a-2) sender origin button position)
  (when (eql button :left)
    (move (cw2a-circle cwa) 10 0))
  (send-event cwa 'ev-mouse-down origin button position))

#|
(setf w (make-instance 'window))
(set-shape w (make-instance 'cw2a-1))
(set-shape w (make-instance 'cw2a-2))
|#