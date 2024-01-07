;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Příklad: 11-04_my-pair-ev.lisp
;;;;
;;;; Ukázka použití třídy events nezávisle na grafických objektech - pár, který hlásí změnu
;;;; v car a cdr, a to i rekurzivně.
;;;;
;;;; Současně je to příklad úplné (neopakované) vícenásobné dědičnosti, kdy dědíme ze dvou 
;;;; nezávislých úplných tříd.
;;;;
;;;; Vyžaduje načtení souborů 11-02_my-pair a 11-03_events.lisp
;;;;

#|
Toto je úplná vícenásobná dědičnost. Nová třída dědí ze dvou nezávislých
úplných tříd.

Novými metodami jejich funkčnost spojujeme.
|#

(defclass my-pair-ev (my-pair events)
  ())

;; Těmito dvěma metodami zajistíme, že při nastavení car nebo cdr našeho páru
;; se hlásí změny.
;; Metody dále zařídí, že libovolná instance třídy events uložená v car či cdr 
;; našeho páru hlásí změnu našemu páru.
;; changing a change voláme manuálně (send-with-change se tady nehodí).
;; To napravíme příště.
(defmethod set-my-car ((p my-pair-ev) value)
  (changing p p 'set-my-car value)
  (unwind-protect 
      (progn (call-next-method)
        (when (eventsp value)
          (set-delegate value p)))
    (change  p p 'set-my-car value))
  p)

(defmethod set-my-cdr ((p my-pair-ev) value)
  (changing p p 'set-my-cdr value)
  (unwind-protect 
      (progn (call-next-method)
        (when (eventsp value)
          (set-delegate value p)))
    (change  p p 'set-my-cdr value))
  p)

#|

(defclass test-delegate (events)
  ())

(defmethod ev-changing ((td test-delegate) sender origin msg &rest args)
  (format t "~%Changing ~s. Message: ~s, arguments: ~s ... " origin msg args))

(defmethod ev-change ((td test-delegate) sender origin msg &rest args)
  (format t "~%... changed ~s. Message: ~s, arguments: ~s ... " origin msg args))

(setf td (make-instance 'test-delegate))

(setf p (set-delegate (my-pair 1 2 'my-pair-ev)
                      td))

;; Dívat se do výstupu:
(set-my-car p 3)
(set-my-cdr p (my-pair 4 5 'my-pair-ev))
(set-my-cdr (my-cdr p) 6)

|#