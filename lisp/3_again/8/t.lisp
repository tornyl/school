; 07 click circle test
#|
(defun make-test-click-circle ()
  (set-filledp (set-radius (make-instance 'click-circle)
                           45)
               t))

(setf w (make-instance 'window))
(setf c (move (make-test-click-circle) 148 100))
;; Klikejte do kolečka:
(set-shape w c)
|#


; 08 test text-shape

#|
(setf ts (make-instance 'text-shape))
(set-text ts "ahoj")
(move ts 100 100)
(scale ts 2 (move (make-instance 'point) 100 100))

(setf w (make-instance 'window))
(set-shape w ts)
|#

; 08 test button

#|
(setf w (make-instance 'button-window))
(setf b (move (make-instance 'button) 50 50))
(set-shape w b)
(set-button-text b "Storno")
(add-event b 'ev-button-click)
|#

; 08 cw test

#|
(setf cwa (make-instance 'circle-with-arrow))

(setf w (make-instance 'window))
(set-shape w cwa)
;;(klikat lze na šipku i kolečko)

(setf pic (set-items (make-instance 'picture)
                     (list (make-instance 'circle-with-arrow)
                           (move (make-instance 'circle-with-arrow) -100 0)
                           (move (make-instance 'circle-with-arrow)  100 0))))

(set-shape w pic)
|#

; 08 cw2 test
#|
(setf w (make-instance 'window))
(set-shape w (make-instance 'cw2a))
|#

; 08 polygon canvas test

#|
(setf w (make-instance 'window))

(set-shape w (make-instance 'polygon-canvas))
|#

; 08 polygon editor test

;(setf w (make-instance 'window))

;(set-shape w (make-instance 'polygon-editor))

; test f.lisp
#|
(setf w (make-instance 'window))
(setf p (make-instance 'picture))
(set-shape w p)
(set-items p (list (make-triangle1) (move (make-square1) 100 0) (move (make-circle1) 200 0)))
|#


;(test (setf test-pic (make-instance 'picture)))


;(test (setf test-window (make-instance 'window)))
;(set-shape test-window test-pic)

;;;;;;;;;;;;;;;;;;;;;; ukol 3
#|
(setf w (make-instance 'window))
(setf square 
	(set-items 
		(make-instance 'polygon) 
		(list  
			(make-instance 'point) 
			(move (make-instance 'point) 10 0) 
			(move (make-instance 'point) 10 10) 
			(move (make-instance 'point) 0 10))))

(setf delegate-1 (make-instance 'test-delegate))
(set-delegate square delegate-1)
;(rotate square pi (make-instance 'point))

|#

; rating-stars test

;(setf w (make-instance 'window))
;(setf w (make-instance 'mouse-over-test-window))
#|
(set-shape w (move (make-star 40 12) 100 100))

(setf rs (make-instance 'rating-stars))
(set-max-rating rs 10)
(set-rating rs 6)
(move rs 100 100)
(set-shape w rs)
|#

; rated-object test
;(setf ro (make-instance 'rated-object))
;(set-shape w ro)
;(move ro 100 100)

; film collection test
#|
(setf fc (make-instance 'film-collection))
(set-shape w fc)
(move fc 100 100)
(add-film fc "Indiana Jones" 3)
|#

; radio-group test

;(setf rb (make-instance 'radio-button))
#|
(setf rg (make-instance 'radio-group))
(set-shape w rg)
(move rg 100 100)
|#

; ukol 9 test

#|
(setf w (make-instance 'select-window))

(setf rg (make-instance 'radio-group))
(setf p (make-instance 'picture))
(set-items p (list (make-triangle1) (move (make-square1) 100 300) (move (make-circle1) 200 300) rg))
(set-shape w p)
(move rg 100 100)

|#

; u3 test

(setf rw (make-instance 'inspector-window))
(setf dw (make-instance 'inspected-window))

(set-inspected-window rw dw)
;(print (delegate dw))

;(add-property (shape rw) "My test 1 is here" 'set-color nil)
;(add-property (shape rw) "POs x" 'set-color t)
;(add-property (shape rw) "Digmulium: gfgdfg" 'set-color nil)

(setf rg (make-instance 'radio-group))
(setf cwa (make-instance 'circle-with-arrow))
(setf pic (make-instance 'picture))
(set-items pic (list cwa rg))
(set-shape dw pic)

