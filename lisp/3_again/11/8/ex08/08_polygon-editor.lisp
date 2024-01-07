;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 08_polygon-editor.lisp - příklad k přednášce 8
;;;;

#|

polygon-editor - příklad komplexnějšího použití knihovny omg

Kromě standardních souborů vyžaduje načíst soubory:
- 08_polygon-canvas.lisp
- 05_bounds.lisp
- 08_text-shape.lisp
- 08_button.lisp
- 07_click-circle.lisp


|#

(defclass polygon-editor (abstract-picture)
  ())

(defmethod editor-canvas ((e polygon-editor))
  (first (items e)))

(defmethod editor-polygon ((e polygon-editor))
  (canvas-polygon (editor-canvas e)))

(defmethod info-text ((e polygon-editor))
  (second (items e)))

(defmethod closedp-button ((e polygon-editor))
  (third (items e)))

(defmethod filledp-button ((e polygon-editor))
  (fourth (items e)))

(defmethod color-button ((e polygon-editor))
  (fifth (items e)))

(defmethod clear-button ((e polygon-editor))
  (sixth (items e)))

(defmethod buttons ((e polygon-editor))
  (cddr (items e)))

(defmethod update-info-text ((e polygon-editor))
  (let ((p (editor-polygon e)))
    (set-text (info-text e)
              (format nil 
                      "Počet bodů: ~s; closedp: ~s; filledp: ~s; bounds: ~s~%color: ~s"
                      (length (items p))
                      (closedp p)
                      (filledp p)
                      (list (left p) (top p) (right p) (bottom p))
                      (color p)))
    e))

(defmethod initialize-instance ((e polygon-editor) &key)
  (call-next-method)
  (do-set-items e
                (list
                 (scale (make-instance 'polygon-canvas) 2.5 (make-instance 'point))
                 (make-instance 'text-shape)
                 (make-instance 'button)
                 (make-instance 'button)
                 (make-instance 'button)
                 (make-instance 'button)))
  (set-button-text (closedp-button e) "Přepnout closedp")
  (add-event (closedp-button e) 'ev-button-click)
  (set-button-text (filledp-button e) "Přepnout filledp")
  (add-event (filledp-button e) 'ev-button-click)
  (set-button-text (color-button e) "Změnit barvu")
  (add-event (color-button e) 'ev-button-click)
  (set-button-text (clear-button e) "Vymazat")
  (add-event (clear-button e) 'ev-button-click)
  (update-buttons e)
  (update-info-text e)
  (update-info-position e)
  (add-event (editor-canvas e) 'ev-poly-change)
  e)

(defun update-ed-button (button prev-button canvas)
  (let ((c-bottom (bottom canvas)))
    ;; Vždy rozdíl nová-pozice - stará-pozice
    (move button
          (- (+ (if prev-button (right prev-button) 0)
                5)
             (left button))
          (- (+ c-bottom 5)
             (top button)))))

(defmethod update-buttons ((e polygon-editor))
  (let ((c (editor-canvas e)))
    (update-ed-button (closedp-button e) nil c)
    (update-ed-button (filledp-button e) (closedp-button e) c)
    (update-ed-button (color-button e) (filledp-button e) c)
    (update-ed-button (clear-button e) (color-button e) c)
    (update-ed-button (info-text e) (clear-button e) c))
  e)

(defmethod update-info-position ((e polygon-editor))
  (let ((text (info-text e))
        (btn (closedp-button e)))
    (move text
          (- (left btn) (left text))
          (- (+ (bottom btn) 5)
             (top text))))
  e)

(defmethod ev-button-click ((e polygon-editor) sender)
  (cond ((eql sender (closedp-button e))
         (set-closedp (editor-polygon e)
                      (not (closedp (editor-polygon e)))))
        ((eql sender (filledp-button e))
         (set-filledp (editor-polygon e)
                      (not (filledp (editor-polygon e)))))
        ((eql sender (color-button e))
         (set-color (editor-polygon e)
                    (random-color)))
        ((eql sender (clear-button e))
         (set-items (editor-polygon e) '()))))

(defmethod ev-poly-change ((e polygon-editor) poly)
  (update-info-text e))


#|

(setf w (make-instance 'window))

(set-shape w (make-instance 'polygon-editor))

|#


