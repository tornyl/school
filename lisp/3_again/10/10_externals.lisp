;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_externals.lisp - Externí objekty prototypového jazyka
;;;;


#|

Ukázka definice externích objektů: čísel a řetězců

Objekty jsou dodány do jazyka tak, že jsou pro ně přepsány metody
object-plist a (setf object-plist) (druhá jen pro čísla).

Plist objektu totiž nejde ukládat přímo do něj, jak se to dělá 
u standardních objektů. Proto s plist ukládá bokem.

Je třeba nejpve načíst soubory 10_system-1.lisp a 10_system-2.lisp.

Všechny soubory načítejte v pořadí

1. 10_system-1.lisp
2. 10_system-2.lisp
3. 10_externals.lisp
4. 10_syntax.lisp

Nebo použijte soubor load.lisp z adresáře tohoto souboru.

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

(defmethod object-code ((obj number))
  nil)

;; řetězce (nelze jim nastavovat plisty, jen načíst super)

(defvar *string*)
(setf *string* (clone-object *object*))

(add-field *lobby* "STRING" :value *string*)
(add-field *string* "+" :value (lambda (self arg1)
                                 (format nil "~a~a" self arg1)))

(defmethod object-plist ((obj string))
  (list 'super *string*))

(defmethod object-code ((obj string))
  nil)

