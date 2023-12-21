;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_system.lisp - Prototypy: všechno je objekt
;;;;

#|

Interpret úplného důsledně objektového prototypového jazyka. Všechny prvky
prvního řádu v jazyce (first-order elements) jsou objekty a veškeré výpočty
probíhají prostřednictvím zasílání zpráv.

Soubor vznikl úpravou souboru 09_prototypes-2.lisp. Dokumentaci najdete v textu 
k přednášce.

Tento soubor obsahuje druhou část definic základů jazyka (fáze 5 a 6). Další 
definice jsou v souborech 10_externals.lisp a 10_basics.lisp. V posledně 
jmenovaném souboru jsou i příklady.

Soubory načítejte v pořadí:

1. 10_system-1.lisp
2. 10_system-2.lisp
3. 10_externals.lisp
4. 10_syntax.lisp

Nebo použijte soubor load.lisp z adresáře tohoto souboru.

|#

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
