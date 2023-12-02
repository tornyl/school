;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 09_prototypes-1.lisp
;;;;
;;;; Zdrojový soubor k předmětu Paradigmata programování 3
;;;;
;;;; Přednáška 9, Prototypy 1
;;;;

#|

Soubor obsahuje první část zdrojového kódu prototypového systému popsaného na 
přednášce a v textu. Pokud chcete zapnout syntax s hranatými závorkami, načtěte 
navíc soubor
09_syntax.lisp.

|#

#|

Objektové rozšíření Lispu založené na prototypovém přístupu. S objekty se 
komunikuje zásadně posíláním zpráv. Nové objekty se vytvářejí klonováním
existujících a automaticky se stávají jejich přímými potomky.

Objekty mají ve slotech hodnoty nebo metody. Zprávy zasílané objektům musejí mít
stejné jméno jako některý ze slotů objektu nebo nějakého jeho předka. Pokud je
ve slotu hodnota, je výsledkem zaslání zprávy objektu tato hodnota (parametry
zprávy se ignorují). Je-li ve slotu metoda, je výsledkem zaslání zprávy hodnota
vrácená metodou (spuštěnou s argumenty zprávy).

Pro sloty používáme název "field", abychom se vyhli konfliktu s lispovými 
funkcemi, které v názvu používají slovo "slot".

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

;; přístup k plistu slotů a hodnot objektu, operátor je definován jako místo
(defun object-plist (obj)
  (cddr obj))

(defun (setf object-plist) (new-plist obj)
  (setf (cddr obj) new-plist))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fáze 2. Práce se sloty objektu
;;

(defvar *field-not-found* (gensym "FIELD-NOT-FOUND"))

(defun field-value-1 (obj field)
  (getf (object-plist obj) field *field-not-found*))

;; Globální proměnná pro objekt Nihil:
(defvar *nihil*)

;; Zjištění hodnoty slotu field včetně rekurzivního hledání v předcích.
(defun field-value (obj field)
  (let ((result (field-value-1 obj field))
        (super (field-value-1 obj 'super)))
    (cond ((not (eql result *field-not-found*)) result)
          ((not (eql super *nihil*)) (field-value super field))
          (t (error "Field ~s not found." field)))))

;; Nastavování hodnoty slotu. Nastavuje se přímo v objektu obj, takže se slot 
;; předka přepíše. Neexistuje-li, slot se vytvoří.
(defun set-field-value (obj field value)
  (setf (getf (object-plist obj) field) value))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fáze 3. Posílání zpráv
;;

(defun methodp (value)
  (typep value 'function))

(defun send (receiver message &rest args)
  (let ((value (field-value receiver message)))
    (if (methodp value)
        (apply value receiver args)
      value)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fáze 4. Metody k práci se sloty
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

;; Funkce add-field a remove-field budou použity 
;; i jako metody

;; Přidání slotu do objektu s hodnotou.
(defun add-field (obj field-name-str &key value)
  (set-field-value obj (field-name field-name-str) value)
  obj)

;; odstranění slotu z objektu
(defun remove-field (obj field-name-str)
    (remf (object-plist obj) 
          (field-name field-name-str))
    obj)

;; Vytvoří metodu pro nastavení slotu jménem field-name-str (řetězec)
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

