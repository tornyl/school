;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_system.lisp - Prototypy: všechno je objekt
;;;;

#|

Interpret úplného důsledně objektového prototypového jazyka. Všechny prvky
prvního řádu v jazyce (first-order elements) jsou objekty a veškeré výpočty
probíhají prostřednictvím zasílání zpráv.

Soubor vznikl úpravou souboru 09_prototypes.lisp. Dokumentaci najdete v textu 
k přednášce.

Tento soubor obsahuje definice základů jazyka. Další definice jsou v souborech
10_externals.lisp a 10_basics.lisp. V posledně jmenovaném souboru jsou i příklady.

Soubor občas používá operátory Lispu, které neznáte
Najděte si je ve standardu.

Soubory načítejte v pořadí:

1. 10_system.lisp
2. 10_externals.lisp
3. 10_basics.lisp

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
  (list 'object nil 'super obj))

;; Přístup k plistu slotů a hodnot objektu, operátor je definován jako místo.
;; Na rozdíl od verze v souboru 09_prototypes.lisp jsou funkce napsány jako 
;; metody, abychom je mohli definovat i pro jiné reprezentace objektů.
;; Využíváme možnosti Lispu, v němž i typ list a další vestavěné typy
;; jsou třídy a lze tedy pro ně psát metody. (Jde o tzv. system-class,
;; instance nejsou "standardní", nemají sloty a nevytvářejí se pomocí 
;; make-instance, nicméně lze pro ně psát metody.)
(defmethod object-plist ((obj list))
  (cddr obj))

;; Třídu můžeme specifikovat u jiného než prvního parametru metody.
;; Podrobnosti na jedné z následujících přednášek.
(defmethod (setf object-plist) (new-plist (obj list))
  (setf (cddr obj) new-plist))

;; Pomocné metody, vracejí resp. nastavují kód objektu.
(defmethod obj-code ((obj list))
  (second obj))

(defmethod (setf obj-code) (code (obj list))
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

;; Hledání (lookup) kódu objektu (kód se taky dědí)
(defun object-code (obj)
  (let ((result (obj-code obj))
        (super (super-object obj)))
    (cond (result result)
          ((eql super *lobby*) (error "Method without code"))
          ((eql super *nihil*) nil)
          (t (object-code super)))))

;; Nastavení kódu objektu
(defun set-object-code (obj code)
  (setf (obj-code obj) code)
  obj)


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

;; Metoda je objekt, který je potomkem Lobby
(defun methodp (obj)
  (and (not (eql obj *nihil*))
       (or (eql (super-object obj) *lobby*)
           (methodp (super-object obj)))))

(defun send (receiver message &rest args)
  (let ((value (field-value receiver message)))
    (cond ((functionp value) (apply value receiver args)) ;primitivum
          ((methodp value) (call-standard-method value receiver args))
          (t value))))

(defun call-standard-method (method self args)
  (let ((clone (clone-object method))) ;naklonujeme metodu
    ;; jde-li o metodu v datovém objektu vyjma lobby, 
    ;; nastavíme self.
    (when (and (not (methodp self))
               (not (eql self *lobby*)))
      (set-field-value clone 'self self))
    ;; Nastavení slotů naklonované metody na argumenty
    ;; Pokud chybí arg1 a při volání je použit, přidá se zde
    (init-method-slots clone (arg1-field method) (car args) (cdr args))
    (funcall (object-code clone) clone)))

;; Inicializace metody před jejím voláním. Sloty metody se nastaví na
;; argumenty volání
(defun init-method-slots (method arg1-field arg1 args)
  (when arg1       ;volána s prvním argumentem
    (set-field-value method arg1-field arg1))
  (set-field-values method args))   ;nastavení slotů pro další argumenty

;; Nastavení hodnot více slotů. fields-and-values je plist názvů slotů
;; a hodnot.
(defun set-field-values (obj fields-and-values)
  (when fields-and-values
    (set-field-value obj 
                     (field-name (first fields-and-values))
                     (second fields-and-values))
    (set-field-values obj (cddr fields-and-values))))

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

;; odstranění slotu z objektu včetně setteru
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fáze 5. Základní objekty a zprávy 1
;;

(defvar *object*)
(setf *object* (make-object))

(setf *nihil* (clone-object *object*))
(setf *lobby* (clone-object *object*))

(add-field *object* "ADD" :value #'add-field)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fáze 6. Základní objekty a zprávy 2
;;

(send *object* 'add "REMOVE" :value #'remove-field)
(send *object* 'add "ADD-SETTER" :value #'add-setter-field)
(send *object* 'add "CLONE" :value #'clone-object)

(send *object* 'add "SUPER" :value *nihil*)
(send *object* 'add-setter "SUPER")

(send *lobby* 'add "LOBBY" :value *lobby*)
(send *lobby* 'add "OBJECT" :value *object*)
(send *lobby* 'add "NIHIL" :value *nihil*)

(send *lobby* 'add "OWNER" :value *nihil*)
(send *lobby* 'add-setter "OWNER")
(send *lobby* 'add "SELF" :value *nihil*)
(send *lobby* 'add-setter "SELF")
