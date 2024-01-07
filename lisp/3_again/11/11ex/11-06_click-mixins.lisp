;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 11-06_click_mixins.lisp
;;;;
;;;; Příklad mixinu.
;;;;
;;;; Je třeba načíst knihovnu micro-graphics a soubor 08.lisp
;;;;

#|
Typické vlastnosti mixinů:

- nemají přímé instance
- volají a částečně implementují metody, které patří jiným třídám

Účelem mixinů je přimícháním k jiným třídám pomocí vícenásobné dědičnosti přidat nějakou 
novou funkčnost.
|#

(defun random-color () 
  (color:make-rgb (random 1.0)
                  (random 1.0)
                  (random 1.0)))

(defclass click-mixin ()
  ())

(defmethod mouse-down ((shape click-mixin) button where)
  (call-next-method)
  (set-color shape (random-color)))

;; mixin musí být v seznamu první, jinak by se nezavolala
;; předchozí metoda (vyzkoušejte)
;; Toto omezení opravíme v další přednášce
(defclass click-circle (click-mixin circle)
  ())

#|
(setf shape (move (set-radius (set-filledp (make-instance 'click-circle)
                                           t)
                              40)
                  122
                  100))

(setf w (make-instance 'window))

(set-shape w shape)

;; (a klikejte)
|#



#|
Definovaný mixin lze bez problémů přimíchat k jiným
třídám (v tomhle případě k třídě star, jež je potomkem třídy abstract-polygon).
|#

(defvar *golden-cut* (/ (- (sqrt 5) 1) 2))

(defun star-points ()
  (let ((result '())
        (origin (make-instance 'point)))
    (dotimes (i 5)
      (let ((pt1 (move (make-instance 'point) 0 -1))
            ;; Vnitřní a vnější pětiúhelník mají délky stran v poměru
            ;; 1 minus zlatý řez
            (pt2 (move (make-instance 'point) 0 (- 1 *golden-cut*))))
        (rotate pt1 (* pi 2/5 i) origin)
        (rotate pt2 (* pi 2/5 (+ i 2)) origin)
        (setf result (cons pt1 (cons pt2 result)))))
    result))

(defclass star (abstract-polygon) 
  ())

(defmethod initialize-instance ((star star) &key)
  (call-next-method)
  (set-filledp (move (scale (do-set-items star (star-points)) 100 (make-instance 'point))
                     120 120)
               t))


(defclass click-star (click-mixin star)
  ())

#|
(set-shape w (make-instance 'click-star))

;; (a klikejte)

|#

