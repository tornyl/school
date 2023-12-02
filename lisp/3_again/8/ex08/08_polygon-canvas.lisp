;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 08_polygon-canvas.lisp - příklad k přednášce 8
;;;;

;; Mimo jiné ukazuje definici vlastní události

(defclass polygon-canvas (abstract-picture)
  ())

(defmethod canvas-polygon ((c polygon-canvas))
  (first (items c)))

(defmethod canvas-background ((c polygon-canvas))
  (second (items c)))

(defmethod solidp ((c polygon-canvas))
  t)

(defun make-canvas ()
  (set-items (set-filledp (set-color (make-instance 'polygon)
                                     :light-blue)
                          t)
             (mapcar (lambda (x y)
                       (move (make-instance 'point)
                             x
                             y))
                     '(0 200 200 0)
                     '(0 0 150 150))))

(defmethod initialize-instance ((c polygon-canvas) &key)
  (call-next-method)
  (do-set-items c (list (set-closedp (make-instance 'polygon) nil)
                        (make-canvas))))

(defmethod ev-change  ((c polygon-canvas) sender origin msg &rest args)
  (call-next-method)
  (send-event c 'ev-poly-change))

(defmethod mouse-down ((c polygon-canvas) button where)
  (call-next-method)
  (when (eql button :left)
    (set-items (canvas-polygon c)
               (cons where (items (canvas-polygon c))))))

#|

(setf w (make-instance 'window))

(set-shape w (make-instance 'polygon-canvas))

;; Klikejte do obdélníka

(set-filledp (canvas-polygon (shape w)) t)
(set-color (canvas-polygon (shape w)) :brown)

(set-items (canvas-polygon (shape w)) '())
|#
