;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 07_click-test.lisp - příklad ke kapitole 7
;;;;

#|

Třída click-test-window. 
Tiskne údaje o klikání do okna.

Přepisuje metodu window-mouse-down s voláním zděděné metody, takže okno navíc
zpracovává klikání standardním způsobem (posílá mouse-down objektu, na který 
se kliklo)

|#

(defclass click-test-window (window)
  ())

(defmethod window-mouse-down ((w click-test-window) button position)
  (call-next-method)
  (format t "~%Tlačítko: ~s. Souřadnice: (~s,~s)." 
          button 
          (x position)
          (y position)))

#|

(make-instance 'click-test-window)
;; klikejte a dívejte se do Outputu

|#