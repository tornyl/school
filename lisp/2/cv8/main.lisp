(defvar *bm-height* 250)
(defvar *bm-width* 250)

(defun bm-black-bitmap ()
  (make-array (list *bm-width* *bm-height*) 
              :initial-element nil))

(defun bm-bitmap-from-array (array)
  array)

(defun bm-bit (bm x y)
  (aref bm x y))

(defun bm-bits (bm)
  bm)

(defun (setf bm-bit) (value bm x y)
  (setf (aref bm x y) value))

(defun bm-not (bm)
  (let ((result (bm-black-bitmap)))
    (dotimes (y *bm-height*)
      (dotimes (x *bm-width*)
        (setf (bm-bit result x y)
              (not (bm-bit bm x y)))))
    result))

(defun bm-and-2 (bm1 bm2)
  (let ((result (bm-black-bitmap)))
    (dotimes (y *bm-height*)
      (dotimes (x *bm-width*)
        (setf (bm-bit result x y)
              (and (bm-bit bm1 x y) (bm-bit bm2 x y)))))
    result))

(defun bm-or-2 (bm1 bm2)
  (let ((result (bm-black-bitmap)))
    (dotimes (y *bm-height*)
      (dotimes (x *bm-width*)
        (setf (bm-bit result x y)
              (or (bm-bit bm1 x y) (bm-bit bm2 x y)))))
    result))

#|
(defun foldr (fun list init)
  (if (null list)
      init
    (funcall fun (car list) (foldr fun (cdr list) init))))
|#


(defun bm-and (bm1 &rest bitmaps)
  (reduce #'bm-and-2 bitmaps :initial-value bm1))

(defun bm-or (bm1 &rest bitmaps)
  (reduce #'bm-or-2 bitmaps :initial-value bm1))

(defun bm-shift (bm dx dy)
  (let ((result (bm-black-bitmap)))
    (dotimes (y *bm-height*)
      (dotimes (x *bm-width*)
        (setf (bm-bit result x y)
              (if (and (< -1 (- x dx) *bm-width*)
                       (< -1 (- y dy) *bm-height*))
                  (bm-bit bm (- x dx) (- y dy))
                nil))))
    result))


(defun bm-diff (bm1 bm2)
  (bm-and bm1 (bm-not bm2)))

(defun bm-top-edge (bm)
  (bm-diff bm (bm-shift bm 0 5)))

(defun bm-edges (bm)
  (bm-or (bm-diff bm (bm-shift bm 0 5))
         (bm-diff bm (bm-shift bm 0 -5))
         (bm-diff bm (bm-shift bm 5 0))
         (bm-diff bm (bm-shift bm -5 0))))

#|

;; Testy
;; Načtěte soubor bitmap-viewer.lisp

(setf v (display-bitmap-viewer))

;; Načíst obrázek do okna (tlačítkem Open...)

(setf jj (bm-bitmap-from-array (bitmap-viewer-bitmap v)))
(setf shift (bm-shift jj 0 -10))
(set-bitmap-viewer-bitmap v (bm-bits shift))
(setf shift (bm-shift jj 0 10))
(setf shift (bm-shift jj 10 0))
(setf shift (bm-shift jj -10 0))
(setf edge (bm-top-edge jj))
(set-bitmap-viewer-bitmap v (bm-bits edge))
(setf edges (bm-edges jj))
(set-bitmap-viewer-bitmap v edges)

|#

(defvar *lbm-width* 250)
(defvar *lbm-height* 250)

(defun lbm-black-bitmap ()
  (lambda (x y)
    (declare (ignore x y))
    nil))

(defun lbm-bitmap-from-array (arr)
  (lambda (x y)
    (aref arr x y)))

(defun lbm-bit (lbm x y)
  (funcall lbm x y))

(defun lbm-bits (lbm)
  (let ((result (make-array (list *lbm-width* *lbm-height*))))
    (dotimes (y *lbm-width*)
      (dotimes (x *lbm-height*)
        (setf (aref result x y)
              (lbm-bit lbm x y))))
    result))

(defun lbm-not (lbm)
  (lambda (x y)
    (not (lbm-bit lbm x y))))

(defun lbm-and-2 (lbm1 lbm2)
  (lambda (x y)
    (and (lbm-bit lbm1 x y)
         (lbm-bit lbm2 x y))))

(defun lbm-or-2 (lbm1 lbm2)
  (lambda (x y)
    (or (lbm-bit lbm1 x y)
        (lbm-bit lbm2 x y))))

(defun lbm-and (lbm1 &rest bitmaps)
  (reduce #'lbm-and-2 bitmaps :initial-value lbm1))

(defun lbm-or (lbm1 &rest bitmaps)
  (reduce #'lbm-or-2 bitmaps :initial-value lbm1))

(defun lbm-shift (lbm dx dy)
  (lambda (x y)
    (let ((old-x (- x dx))
          (old-y (- y dy)))
      (if (and (< -1 old-x *lbm-width*)
               (< -1 old-y *lbm-height*))
          (lbm-bit lbm old-x old-y)
        nil))))

(defun lbm-diff (lbm1 lbm2)
  (lbm-and lbm1 (lbm-not lbm2)))

(defun lbm-top-edge (lbm)
  (lbm-diff lbm (lbm-shift lbm 0 5)))

(defun lbm-edges (lbm)
  (lbm-or (lbm-diff lbm (lbm-shift lbm 0 5))
          (lbm-diff lbm (lbm-shift lbm 0 -5))
          (lbm-diff lbm (lbm-shift lbm 5 0))
          (lbm-diff lbm (lbm-shift lbm -5 0))))

#|
(setf v (display-bitmap-viewer))

;; Otevřít v prohlížeči obrázek
(setf ljj (lbm-bitmap-from-array (bitmap-viewer-bitmap v)))
(setf edges (lbm-edges ljj))
(set-bitmap-viewer-bitmap v (lbm-bits edges))

|#

(defun bm-edges-test (bm)
  (bm-bits (bm-edges bm)) 
  nil)

(defun lbm-edges-test (lbm)
  (lbm-bits (lbm-edges lbm)) 
  nil)

#|

;; Porovnání:

(time (bm-edges-test jj))

(time (lbm-edges-test ljj))

|#

(defun bm-xor (bm1 bm2)
	(bm-diff (bm-and-2 bm1 bm2) (bm-or-2 bm1 bm2)))

