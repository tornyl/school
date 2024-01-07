;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Příklad: 11-02_my-pair.lisp
;;;;
;;;; my-pair: pomocná třída. Implementuje pár jako standardní objekt.
;;;;


(defclass my-pair ()
  ((car :initform nil)
   (cdr :initform nil)))

;; Za týden se těchto čtyř definic zbavíme:
(defmethod my-car ((p my-pair))
  (slot-value p 'car))

(defmethod my-cdr ((p my-pair))
  (slot-value p 'cdr))

(defmethod set-my-car ((p my-pair) value)
  (setf (slot-value p 'car) value)
  p)

(defmethod set-my-cdr ((p my-pair) value)
  (setf (slot-value p 'cdr) value)
  p)

;; Funkce na vytvoření páru. Nepovinný parametr použijeme později.
(defun my-pair (car cdr &optional (class-name 'my-pair))
  (set-my-cdr
   (set-my-car (make-instance class-name) 
               car)
   cdr))

(defun my-pair-to-cons (my-pair)
  (cons (my-car my-pair) 
        (my-cdr my-pair)))

#|

(setf pair (my-pair 1 2))
(my-pair-to-cons pair)
(set-my-car pair 3)
(my-pair-to-cons pair)

|#
