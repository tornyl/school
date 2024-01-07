;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Příklad: 11-03 events.lisp
;;;;
;;;; events: pomocná třída. Obsahuje funkčnost související s událostmi.
;;;;

#|
Instance třídy events jsou objekty, které umí hlásit nadřízenému objektu
a přijímat od podřízeného objektu speciální typ zpráv, tzv. události.
Obsahují funkčnost, která byla v knihovně OMG uložena ve třídě 
omg-object.

Je to plnohodnotná třída, lze jí přímo vytvářet instance. Příklad
11-04_my-pair-ev.lisp také ukazuje, jak ji lze plnohodnotnou vícenásobnou 
dědičností s jinou třídou použít k vytvoření objektu s událostmi.
|#

(defclass events () 
  ((delegate :initform nil)
   (change-level :initform 0)
   (events :initform '(ev-changing ev-change))))

;; Typový predikát na events
(defmethod eventsp (obj)
  nil)

(defmethod eventsp ((obj events))
  t)

(defmethod delegate ((obj events))
  (slot-value obj 'delegate))

(defmethod set-delegate ((obj events) delegate)
  (setf (slot-value obj 'delegate) delegate)
  obj)

(defmethod change-level ((obj events))
  (slot-value obj 'change-level))

(defmethod inc-change-level ((obj events))
  (incf (slot-value obj 'change-level))
  obj)

(defmethod dec-change-level ((obj events))
  (decf (slot-value obj 'change-level))
  obj)


;; Vlastnost events nastavuje delegát. Tím určí, jaké události
;; mu má objekt posílat.
(defmethod events ((obj events))
  (slot-value obj 'events))

(defmethod add-event ((obj events) event)
  (unless (find event (events obj))
    (setf (slot-value obj 'events)
          (cons event (events obj))))
  obj)

(defmethod remove-event ((obj events) event)
  (setf (slot-value obj 'events)
        (remove event (events obj))))

;; posílání událostí: send-event

(defmethod send-event ((object events) event &rest event-args)
  (let ((delegate (delegate object)))
    (when (and delegate (find event (events object)))
      (apply event delegate object event-args))
    object))

(defmethod changing ((object events) origin msg &rest args)
  (when (zerop (change-level object))
    (apply 'send-event object 'ev-changing origin msg args))
    (inc-change-level object))

(defmethod change ((object events) origin msg &rest args)
  (dec-change-level object)
  (when (zerop (change-level object))
    (apply 'send-event object 'ev-change origin msg args)))

;; Metodu send-with-change nedefinujeme, u vícenásobné dědičnosti
;; je vhodné jiné řešení. Vytvoříme ho na příští přednášce.

;; základní události

(defmethod ev-changing ((obj events) sender origin message 
                                         &rest msg-args)
  (apply 'changing obj origin message msg-args))

(defmethod ev-change ((obj events) sender origin message 
                                       &rest msg-args)
  (apply 'change obj origin message msg-args))

