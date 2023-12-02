;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 09_syntax.lisp
;;;;
;;;; Zdrojový soubor k předmětu Paradigmata programování 3
;;;;
;;;; Přednáška 9, Prototypy 1 
;;;;

#|

Po načtení souboru bude možné posílat zprávy v syntaxi

[obj message arg1 ...]

místo

(send obj 'message arg1 ...)

Je ale třeba vyhodnocovat v Listeneru, F8 apod. na tyto výrazy nefunguje
(editor neumí detekovat výraz ohraničený hranatými závorkami).
V principu to jde v LispWorks opravit, protože editor je programovatelný, 
ale nebudeme to dělat.

Implementaci není nutné chápat (jde o lispové specifikum).

Na konci jsou některé testy z 09_prototypes.lisp přepsané do nové syntaxe
(vyžadují načtený soubor 09_prototypes.lisp).


|#

;; Modifikace syntaxe Lispu (rozšíření readeru), aby rozuměl hranatým závorkám.
;; výraz [obj message x y z ...] se přečte jako (send obj 'message x y z ...)
(defun left-brack-reader (stream char)
  (declare (ignore char))
  (let* ((list (read-delimited-list #\] stream t))
         (object (first list))
         (message (second list))
         (arguments (cddr list)))
    (list* 'send object (list 'quote message) arguments)))

(set-macro-character #\[ 'left-brack-reader)

(defun right-brack-reader (stream char)
  (declare (ignore stream char))
  (error "Non-balanced #\\] encountered."))

(set-macro-character #\] 'right-brack-reader)

#|
;;Test:
'[a b c d]
|#

;; Hack, aby editor rozuměl hranatým závorkám
;; (děkuji anonymnímu studentovi)
(editor::set-vector-value
 (slot-value editor::*default-syntax-table* 'editor::table) '(#\[) 2)
(editor::set-vector-value
 (slot-value editor::*default-syntax-table* 'editor::table) '(#\]) 3)



#|
(send *object* 'name)
[*nihil* name]
[*nihil* test]

'[[*nihil* super] name]
[[*nihil* super] name]
|#

                                       
#|
[*object* equals *object*]
[*nihil* equals *nihil*]
[*nihil* equals *object*]
(setf obj1 [[*object* clone] set-name "NEW-OBJECT"])
[obj1 name]
[obj1 remove "NAME"]
[obj1 name]
[[*object* clone] is *object*]
[*nihil* is *nihil*]
(setf obj2 [*object* clone])
[obj2 is *object*]
(setf obj3 [*object* clone])
[obj3 is obj2]
|#

