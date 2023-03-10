;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 08_button.lisp - příklad k přednášce 8
;;;;

#|

Tlačítko s textem (vlastnost button-text). Po kliknutí levým tlačítkem myši
generuje událost ev-button-click.

Kromě standardních souborů vyžaduje načíst soubory 05_bounds.lisp 
a 08_text-shape.lisp

|#

(defclass button (abstract-picture)
  ())

;; Aby tlačítko dostávalo zprávu mouse-down
(defmethod solidp ((b button))
  t)

;; Kromě klasického ev-mouse-down ve zděděné metodě generujeme novou událost
;; ev-button-click, pokud se kliklo levým myšítkem. Událost nemá parametry.
(defmethod mouse-down ((b button) mouse-button position)
  (call-next-method)
  (when (eql mouse-button :left)
    (send-event b 'ev-button-click))
  b)


(defmethod button-text-shape ((b button))
  (first (items b)))

(defmethod button-text ((b button))
  (text (button-text-shape b)))

(defmethod recomp-frame ((b button))
  (set-items (second (items b)) (but-poly-items b))
  (set-items (third (items b)) (but-poly-items b))
  b)

(defmethod set-button-text ((b button) text)
	;;(send-event b 'ev-button-text-change b (button-text b) text)
  (set-text (button-text-shape b) text)
  (recomp-frame b))

;;Vytvoření seznamu rohů vzhledem k textu
(defmethod but-poly-items ((b button))
  (let ((left (- (left (button-text-shape b)) 5))
        (right (+ (right (button-text-shape b)) 5))
        (top (- (top (button-text-shape b)) 5))
        (bottom (+ (bottom (button-text-shape b)) 5)))
    (mapcar (lambda (x y)
              (move (make-instance 'point) x y))
            (list left right right left)
            (list top top bottom bottom))))

(defmethod initialize-instance ((b button) &key)
  (call-next-method)
  (do-set-items b (list (make-instance 'text-shape)
                        (set-closedp (make-instance 'polygon) t)
                        (set-color
                         (set-filledp (make-instance 'polygon) t)
                         :light-blue)))
  (recomp-frame b) ;tohle i vyvolá změnu
  ;;(add-event b 'ev-button-text-change 'ev-button-text-change) 
  b)


(defmethod mouse-down ((b button) mouse-button position)
  (call-next-method)
  (when (eql mouse-button :left)
    (send-event b 'ev-button-click))
  b)


(defclass button-window (window)
  ())

(defmethod ev-click ((w window) sender)
  (format t "~%Click! "))

#|
(setf w (make-instance 'button-window))
(setf b (move (make-instance 'button) 50 50))
(set-shape w b)
(set-button-text b "Storno")
(set-button-text b "")
(set-button-text b (format nil "Text~%na~%více~%řádků"))

(add-event b 'ev-button-click 'ev-click)

|#


