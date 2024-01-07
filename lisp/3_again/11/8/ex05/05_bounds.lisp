;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 05_bounds.lisp - příklad k přednášce 5
;;;;


#|

Rozšíření potomků třídy shape o metody left, top, right, bottom.

|#

(defmethod left ((shape point))
  (x shape))

(defmethod top ((shape point))
  (y shape))

(defmethod right ((shape point))
  (x shape))

(defmethod bottom ((shape point))
  (y shape))

(defmethod left ((shape circle))
  (- (x (center shape)) (radius shape)))

(defmethod top ((shape circle))
  (- (y (center shape)) (radius shape)))

(defmethod right ((shape circle))
  (+ (x (center shape)) (radius shape)))

(defmethod bottom ((shape circle))
  (+ (y (center shape)) (radius shape)))

(defun min-or-nil (&optional a b)
  (cond ((and a b) (min a b))
        (a a)
        (b b)
        (t nil)))

(defun max-or-nil (&optional a b)
  (cond ((and a b) (max a b))
        (a a)
        (b b)
        (t nil)))

;; reduce je zde jako foldl
(defmethod left ((shape compound-shape))
  (reduce #'min-or-nil (mapcar #'left (items shape))))

(defmethod top ((shape compound-shape))
  (reduce #'min-or-nil (mapcar #'top (items shape))))

(defmethod right ((shape compound-shape))
  (reduce #'max-or-nil (mapcar #'right (items shape))))

(defmethod bottom ((shape compound-shape))
  (reduce #'max-or-nil (mapcar 'bottom (items shape))))

