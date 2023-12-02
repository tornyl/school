;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_system.lisp - Prototypy: všechno je objekt
;;;;

#|

Interpret úplného důsledně objektového prototypového jazyka. Všechny prvky
prvního řádu v jazyce (first-order elements) jsou objekty a veškeré výpočty
probíhají prostřednictvím zasílání zpráv.

Soubor vznikl úpravou souboru 09_prototypes-1.lisp. Dokumentaci najdete v textu 
k přednášce.

Tento soubor obsahuje první část definic základů jazyka (fáze 0 až 4). Další 
definice jsou v souborech 10_system-2.lisp, 10_externals.lisp a 10_basics.lisp. 
V posledně jmenovaném souboru jsou i příklady.

Soubor občas používá operátory Lispu, které neznáte
Najděte si je ve standardu.

Soubory načítejte v pořadí:
1. 10_system-1.lisp
2. 10_system-2.lisp
3. 10_externals.lisp
4. 10_syntax.lisp

Nebo použijte soubor load.lisp z adresáře tohoto souboru.

|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fáze 0. Datová reprezentace objektu
;;

;; Zkrácení dlouhých seznamů při tisku, například v listeneru.
(setf *print-length* 10)
(setf *print-level* 5)
(setf *print-circle* t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fáze 1. Přístupové funkce datové struktury objektu
;;

;; Konstruktory objektu
(defun make-object ()
  (list 'object nil))

(defun clone-object (obj)
  (list 'object (second obj) 'super obj))

;; Přístup k plistu slotů a hodnot objektu, operátor je definován jako místo.
;; Na rozdíl od verze v souboru 09_prototypes.lisp jsou funkce napsány jako 
;; metody, abychom je mohli definovat i pro jiné reprezentace objektů.
;; Využíváme toho, že i typ list a další vestavěné typy jsou třídy a lze tedy 
;; pro ně psát metody. (Jde o tzv. system-class, instance nejsou "standardní", 
;; nemají sloty a nevytvářejí se pomocí make-instance, nicméně lze pro ně 
;; psát metody. Detaily na některé z dalších přednášek.)
(defmethod object-plist ((obj list))
  (cddr obj))

;; Třídu můžeme specifikovat u jiného než prvního parametru metody.
;; Podrobnosti na jedné z následujících přednášek.
(defmethod (setf object-plist) (new-plist (obj list))
  (setf (cddr obj) new-plist))

;; Pomocné metody, vracejí resp. nastavují kód objektu.
(defmethod object-code ((obj list))
  (second obj))

(defmethod (setf object-code) (code (obj list))
  (setf (second obj) code))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fáze 2. Práce se sloty a kódem objektu
;;

(defvar *field-not-found* (gensym "FIELD-NOT-FOUND"))

(defun field-value-1 (obj field)
  (getf (object-plist obj) field *field-not-found*))

(defun super-object (obj)
  (field-value-1 obj 'super))

;; Globální proměnné pro objekty Nihil a Lobby:
(defvar *nihil*)
(defvar *lobby*)

;; Zjištění hodnoty slotu field včetně rekurzivního hledání v předcích
;; ("lookup").
(defun field-value (obj field)
  (let ((result (field-value-1 obj field))
        (super (super-object obj)))
    (cond ((not (eql result *field-not-found*)) result)
          ((not (eql super *nihil*)) (field-value super field))
          (t (error "Field ~s not found." field)))))

;; Nastavování hodnoty slotu. Nastavuje se přímo v objektu obj, takže se slot 
;; předka přepíše. Neexistuje-li, slot se vytvoří.
;; Malý trik, který ulehčí ladění: má-li objekt slot name, necháme ho
;; jako první.
(defun set-field-value (obj field value)
  (if (and (eql (car (object-plist obj)) 'name)           ;toto
           (not (eql field 'name)))                       ;a toto
      (setf (getf (cddr (object-plist obj)) field) value) ;a toto je trik
    (setf (getf (object-plist obj) field) value)))        ;toto stačí

;; Nastavení hodnot více slotů. fields-and-values je plist názvů slotů
;; a hodnot.
(defun set-field-values (obj &rest fields-and-values)
  (when fields-and-values
    (set-field-value obj 
                     (field-name (first fields-and-values))
                     (second fields-and-values))
    (apply #'set-field-values obj (cddr fields-and-values))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fáze 3. Posílání zpráv
;;

;; Zjištění názvu slotu objektu (tj. symbolu) na základě řetězce
;; nebo symbolu a zjištění názvu setteru.
(defun field-name (field-name-str)
  (intern (format nil "~a" field-name-str)))

(defun setter-name (field-name-str)
  (intern (format nil "SET-~a" field-name-str)))

#|
(field-name "FIELD")
(field-name :field)
(setter-name "FIELD")
(setter-name 'field)
|#

;; Metoda je objekt, který má kód
(defun methodp (obj)
  (not (null (object-code obj))))

(defun send (receiver message &rest args)
  (let ((value (field-value receiver message)))
    (cond ((functionp value) (apply value receiver args)) ;primitivum
          ((methodp value) (call-standard-method value receiver args))
          (t value))))

(defun call-standard-method (method self args)
  (let ((clone (clone-object method))) ;naklonujeme metodu
    ;; jde-li o metodu v datovém objektu, nastavíme self.
    (unless (methodp self)
      (set-field-value clone 'self self))
    (when args
      ;; Nastavení slotů naklonované metody na argumenty
      ;; Pokud chybí arg1 a při volání je použit, přidá se zde
      (apply #'set-field-values clone (arg1-field method) (car args) (cdr args)))
    (funcall (object-code clone) clone)))

(defun plist-prop-names (plist)
  (when plist
    (cons (car plist) (plist-prop-names (cddr plist)))))

#|
(plist-prop-names '(1 2 3 4 5 6 7 8 9))
(plist-prop-names '(1 2 3 4 5 6 7 8 9 10))
|#

;; Vrátí název slotu pro první argument. Slot se pozná tak,
;; že jeho název začíná na "ARG1". Pokud takový slot nenajde, 
;; vrátí symbol arg1 
(defun arg1-field (method)
  (let ((prop (find-if (lambda (prop)
                         ;; funkce search vrací index, na kterém 
                         ;; najde podřetězec (u nás "ARG1")
                         (eql (search "ARG1" (symbol-name prop)) 0))
                       (plist-prop-names (object-plist method)))))
    (if prop prop 'arg1)))

#|
(arg1-field '(object nil arg1 1 arg2 2 arg3 3)) 
(arg1-field '(object nil arg2 2 arg3 3))
(arg1-field '(object nil arg2 2 arg3 3 arg1-test 4))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fáze 4. Metody k práci se sloty
;;


;; Funkce add-field a remove-field budou použity 
;; i jako metody

;; Přidání slotu do objektu s hodnotou.
(defun add-field (obj field-name-str &key (value *nihil*))
  (set-field-value obj (field-name field-name-str) value)
  obj)

;; odstranění slotu z objektu
(defun remove-field (obj field-name-str)
    (remf (object-plist obj)
          (field-name field-name-str))
    obj)

;; Vytvoří metodu (primitivum) pro nastavení slotu jménem field-name-str (řetězec)
;; Je to metoda s argumenty self (příjemce) a arg1, což je nastavovaná hodnota
;; Přidání setter-slotu pro slot daného názvu pak realizuje metoda
;; add-setter-field.
(defun setter-method (field-name-str)
  (let ((field-name (field-name field-name-str)))
    (lambda (self arg1)
      (set-field-value self field-name arg1)
      self)))

(defun add-setter-field (obj field-name-str)
  (set-field-value obj
                   (setter-name field-name-str)
                   (setter-method field-name-str))
  obj)


