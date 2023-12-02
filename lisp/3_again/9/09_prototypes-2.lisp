;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 09_prototypes-2.lisp
;;;;
;;;; Zdrojový soubor k předmětu Paradigmata programování 3
;;;;
;;;; Přednáška 9, Prototypy 1
;;;;

#|

Soubor obsahuje druhou část zdrojového kódu prototypového systému popsaného na 
přednášce a v textu. Pokud chcete zapnout syntax s hranatými závorkami, načtěte 
navíc soubor 09_syntax.lisp.

Ve fázi 5 a 6 se již vytvářejí a upravují základní objekty systému, nejprve
prostředky Lispu a pak posíláním zpráv.

|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fáze 5. Základní objekty a zprávy 1
;;

(defvar *object*)
(setf *object* (make-object))

(setf *nihil* (clone-object *object*))

(add-field *object* "ADD" :value #'add-field)
(send *object* 'add "REMOVE" :value #'remove-field)
(send *object* 'add "ADD-SETTER" :value #'add-setter-field)
(send *object* 'add "CLONE" :value #'clone-object)

(send *object* 'add "EQUALS" 
      :value (lambda (self arg1)
               (eql self arg1)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fáze 6. Základní objekty a zprávy 2
;;

(send *object* 'add "SUPER" :value *nihil*)
(send *object* 'add-setter "SUPER")

(send *object* 'add "NAME" :value "OBJECT")
(send *object* 'add-setter "NAME")


#|
(send *object* 'name)
(send *nihil* 'name)
(send *nihil* 'test)
|#

(send *nihil* 'set-name "NIHIL")

(send *object* 'add "IS-NIHIL" :value nil)
(send *nihil* 'add "IS-NIHIL" :value t)


#|
(send *nihil* 'name)
(send *object* 'is-nihil)
(send *nihil* 'is-nihil)

(send (send *nihil* 'super) 'name)
|#

(send *object* 'add "IS"
      :value (lambda (self arg1)
               (let ((super (send self 'super)))
                 (or (send self 'equals arg1)
                     (and (not (send super 'is-nihil))
                          (send super 'is arg1))))))

                                    
#|
(send *object* 'equals *object*)
(send *nihil* 'equals *nihil*)
(send *nihil* 'equals *object*)
(setf obj1 (send (send *object* 'clone) 'set-name "NEW-OBJECT"))
(send obj1 'name)
(send obj1 'remove "NAME")
(send obj1 'name)
(send (send *object* 'clone) 'is *object*)
(send *nihil* 'is *nihil*)
(setf obj2 (send *object* 'clone))
(send obj2 'is *object*)
(setf obj3 (send *object* 'clone))
(send obj3 'is obj2)
|#



