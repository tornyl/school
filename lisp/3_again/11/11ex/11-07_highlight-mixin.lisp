;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 11-07_highlight_mixins.lisp
;;;;
;;;; Příklad mixinů
;;;;
;;;; Je třeba načíst knihovnu micro-graphics a soubor 08.lisp
;;;;

#|
Typické vlastnosti mixinů:

- nemají přímé instance
- volají a částečně implementují metody, které patří jiným třídám (zde to jsou metody
  send-event, add-event, items, color, mouse-down, set-items)

Účelem mixinů je přimícháním k jiným třídám pomocí vícenásobné dědičnosti přidat nějakou 
novou funkčnost.
|#

;;;
;;; Třídy highlight-item-mixin a highlight-container-mixin, které společně 
;;; přidávají k objektům možnost označování.
;;;
;;; highlight-item-mixin je třeba přimíchat ke třídám 
;;; grafických objektů, highlight-container-mixin ke třídám objektů, které je 
;;; obsahují (obvykle picture)
;;;

(defvar *highlight-color* :limegreen)

(defclass highlight-item-mixin ()
  ((highlightedp :initform nil)))

(defmethod do-set-highlightedp ((shape highlight-item-mixin) value)
  (setf (slot-value shape 'highlightedp) value))

(defmethod set-highlightedp ((shape highlight-item-mixin) value)
  (send-with-change shape
                    'do-set-highlightedp
                    'set-highlightedp
                    value)
  (when value
    (send-event shape 'ev-highlight))
  shape)

(defmethod highlightedp ((shape highlight-item-mixin))
  (slot-value shape 'highlightedp))

;; Změna barvy, aniž by byla uložená ve slotu.
;; Metoda je také zajímavá podmíněným voláním funkce call-next-method.
;; Kvůli této metodě musí být ve vícenásobné dědičnosti náš mixin první
;; (opravíme na příští přednášce)
(defmethod color ((shape highlight-item-mixin))
  (if (highlightedp shape)
      *highlight-color*
    (call-next-method)))

(defmethod mouse-down ((shape highlight-item-mixin) button where)
  (call-next-method)
  (set-highlightedp shape t))

(defclass highlight-container-mixin ()
  ())

(defmethod do-set-items ((shape highlight-container-mixin) items)
  (call-next-method)
  (send-to-items shape 'add-event 'ev-highlight))

(defmethod ev-highlight ((shape highlight-container-mixin) sender)
  (dolist (item (items shape))
    (when (and (typep item 'highlight-item-mixin)
               (not (eql item sender))
               (highlightedp item))
      ;; Toto generuje zbytečně moc hlášení změn. Lze optimalizovat:
      (set-highlightedp item nil))))

;;;
;;; přimíchání:
;;;

;;mixin musí jít jako první
(defclass highlight-circle (highlight-item-mixin circle)
  ())

(defclass highlight-polygon (highlight-item-mixin polygon)
  ())

(defclass highlight-container-picture (highlight-container-mixin picture)
  ())

#|

;; Test:

(defun make-point (x y)
  (set-x (set-y (make-instance 'point)
                y)
         x))

;; Kolečko vpravo dole není highlight-item-mixin, takže nefunguje
(setf p
      (set-items (make-instance 'highlight-container-picture)
                 (list (set-filledp (set-radius (move (make-instance 'highlight-circle) 50 50)
                                                40)
                                    t)
                       (set-items (set-filledp (make-instance 'highlight-polygon)
                                               t)
                                  (mapcar #'make-point '(20 80 80 20) '(120 120 180 180)))
                       (set-items (set-filledp (make-instance 'highlight-polygon)
                                               t)
                                  (mapcar #'make-point '(100 180 140) '(10 10 90)))
                       (set-filledp (set-radius (move (make-instance 'circle) 140 150)
                                                40)
                                    t))))


(set-shape (make-instance 'window) p)
|#

