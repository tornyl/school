;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_externals.lisp - Externí objekty prototypového jazyka
;;;;


#|

Ukázka definice externích objektů: čísel a řetězců

Objekty jsou dodány do jazyka tak, že jsou pro ně přepsány metody
object-plist a set-object-plist (druhá jen pro čísla).

Plist objektu totiž nejde ukládat přímo do něj, jak se to dělá 
u standardních objektů. Proto s plist ukládá bokem.

Je třeba nejpve načíst soubor 10_system.lisp 

|#

;; Čísla

(add-field *lobby* "NUMBER" :value (clone-object *object*))

(defvar *number*)
(setf *number* (field-value *lobby* 'number))

(defvar *number-plists*)
(setf *number-plists* nil)

(defmethod object-plist ((obj number))
  (let ((plist (getf *number-plists* obj)))
    (unless plist (setf plist (list 'super *number*)))
    plist))

(defmethod (setf object-plist) (value (obj number))
  (setf (getf *number-plists* obj) value))

;; řetězce (nelze jim nastavovat plisty, jen načíst super)

(defvar *string*)
(setf *string* (clone-object *object*))

(add-field *lobby* "STRING" :value *string*)
(add-field *string* "+" :value (lambda (self arg1)
                                 (format nil "~a~a" self arg1)))

(defmethod object-plist ((obj string))
  (list 'super *string*))

