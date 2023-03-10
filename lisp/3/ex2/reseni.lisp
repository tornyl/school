(defclass image (omg-object)
  ((image-path :initform nil)
   (position :initform nil)))

(defmethod initialize-instance ((i image) &key)
  (call-next-method)
  (do-set-image-position i (make-instance 'point)))


(defmethod image-path ((i image))
  (slot-value i 'image-path))

(defmethod set-image-path ((i image))
  (let ((path (capi:prompt-for-file "Otevrit obrazek")))
    (unless path
      (error "Nepodarilo se nacist obrzek"))
    (send-with-change i 'do-set-image-path path)))

(defmethod do-set-image-path ((i image) path)
  (setf (slot-value i 'image-path) path))

(defmethod image-position ((i image))
  (slot-value i 'position))

(defmethod set-image-position ((i image) new-position)
  (send-with-change i 'do-set-image-position new-position))

(defmethod do-set-image-position ((i image) new-position)
  (setf (slot-value i 'position) new-position))

(defmethod solidp ((i image))
  nil)

(defmethod solid-shapes ((i image))
  nil)

(defmethod draw ((i image) mgw)
  (when (image-path i)
    (do-draw i mgw)))

(defmethod do-draw ((i image) mgw)
  (mg:draw-image mgw (image-path i) 
                 (x (image-position i)) 
                 (y (image-position i)))
  i)


(defmethod move ((i image) dx dy)
  (set-image-position i (make-point dx dy)))


(defclass controls (abstract-picture)
  ())

(defmethod initialize-instance ((c controls) &key)
  (call-next-method)
  (let ((left-arrow (move (rotate (make-arrow :blue) 0 (make-point 0 0)) 250 900))
        (right-arrow (move (rotate (make-arrow :blue) PI (make-point 0 0)) 400 900))
        (add-button (move (set-button-text (make-instance 'button) "+") 300 900))
        (remove-button (move (set-button-text (make-instance 'button) "-") 350 900)))
    (add-event left-arrow 'ev-mouse-down 'ev-left-arrow-click) 
    (add-event right-arrow 'ev-mouse-down 'ev-right-arrow-click) 
    (add-event add-button 'ev-button-click 'ev-add-button-click) 
    (add-event remove-button 'ev-button-click 'ev-remove-button-click) 
    (do-set-items c (list left-arrow add-button remove-button right-arrow))))


(defmethod ev-left-arrow-click ((c controls) sender clicked button position)
  (send-event c 'ev-go-left)
  (send-event c 'ev-mouse-down clicked button position))

(defmethod ev-right-arrow-click ((c controls) sender clicked button position)
  (send-event c 'ev-go-right)
  (send-event c 'ev-mouse-down clicked button position))

(defmethod ev-add-button-click ((c controls) sender)
  (send-event c 'ev-add-image))

(defmethod ev-remove-button-click ((c controls) sender)
  (send-event c 'ev-remove-image))


(defclass album (abstract-picture)
  ((active-image-index :initform -1)
   (images :initform '())))

(defmethod initialize-instance ((a album) &key)
  (call-next-method)
  (let ((controls (make-instance 'controls)))
    (add-event controls 'ev-go-left 'ev-go-left)
    (add-event controls 'ev-go-right 'ev-go-right)
    (add-event controls 'ev-add-image 'ev-add-image)
    (add-event controls 'ev-remove-image 'ev-remove-image)
    (do-set-items a (list controls))))

(defmethod active-image-index ((a album))
  (slot-value a 'active-image-index))

(defmethod set-active-image-index ((a album) new-index)
  (send-with-change a 'do-set-active-image-index new-index))

(defmethod do-set-active-image-index ((a album) new-index)
  (setf (slot-value a 'active-image-index) new-index))

(defmethod images ((a album))
  (slot-value a 'images))

(defmethod set-images ((a album) images)
  (send-with-change a 'do-set-images images))

(defmethod do-set-images ((a album) images)
  (setf (slot-value a 'images) images))

(defmethod ev-go-left ((a album) sender)
  (change-active-image-index a -1))

(defmethod ev-go-right ((a album) sender)
  (change-active-image-index a 1))

(defmethod change-active-image-index ((a album) direction)
  (let ((new-index (+ (active-image-index a) direction)))
    (when (and (> new-index -1) 
               (< new-index (- (length (images a)) 1)))
      (set-active-image-index a new-index)
      (update-visible-items a))))

(defmethod ev-add-image ((a album) sender)
  (add-image a))

(defmethod add-image ((a album))
  (let ((new-image (make-instance 'image)))
    (when (set-image-path new-image)
      (set-active-image-index a (+ (active-image-index a) 1))
      (send-with-change a 'do-add-image new-image)
      (update-visible-items a))))

(defmethod do-add-image ((a album) image)
  (set-images a (list-insert-at (images a) (active-image-index a) image)))

(defmethod ev-remove-image ((a album) sender)
  (remove-image a))

(defmethod remove-image ((a album))
  (when (> (active-image-index a) -1)
    (print (active-image-index a))
    (send-with-change a 'do-remove-image)	
    (set-active-image-index a (- (active-image-index a) 1))
    (update-visible-items a)))

(defmethod do-remove-image ((a album))
  (set-images a (remove-nth (active-image-index a) (images a))))

(defmethod update-visible-items ((a album))
  (if (> (active-image-index a) -1)
      (send-with-change a 'do-set-items (list (first (items a) ) (nth (active-image-index a) (images a))))
    (send-with-change a 'do-set-items (list (first (items a) )))))


(defun list-insert-at (lst index new-value)
  (let ((retval nil))
    (loop for i from 0 to (- (length lst) 1) do
            (when (= i index)
              (push new-value retval))
            (push (nth i lst) retval))
    (when (>= index (length lst))
      (push new-value retval))
    (nreverse retval)))

(defun remove-nth (n list)
  (declare
   (type (integer 0) n)
   (type list list))
  (if (or (zerop n) (null list))
      (cdr list)
    (cons (car list) (remove-nth (1- n) (cdr list)))))


