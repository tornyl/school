;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_syntax.lisp - Prototypy: všechno je objekt
;;;;

#|

Implementace kompilátoru našeho jazyka. Funguje tak, že nejprve pomocí definovaných
makroznaků #\[ a #\{ reader načte zdrojový kód do symbolických výrazů Lispu.
V nich jsou použita makra send-expand a object-expand, jejichž expanzí
vznikne čistý lispový kód. O jeho kompilaci do strojového kódu procesoru
se už postará kompilátor LispWorks.

Podrobnosti implementace jen pro vážné zájemce o zajímavá zákoutí Common Lispu.

Soubory načítejte v pořadí:
1. 10_system-1.lisp
2. 10_system-2.lisp
3. 10_externals.lisp
4. 10_syntax.lisp

Nebo použijte soubor load.lisp z adresáře tohoto souboru.

|#

;; Modifikace syntaxe Lispu, aby rozuměl hranatým a složeným závorkám.
;; výraz [obj message x y z ...] se přečte jako (send-expand obj message x y z ...),
;; kde vnitřní podvýrazy se rekurzivně opět přečtou readerem
;; Je ale třeba vyhodnocovat v Listeneru, F8 apod. na tyto výrazy nefunguje.
(defun left-brack-reader (stream char)
  (declare (ignore char))
  (cons 'send-expand (read-delimited-list #\] stream t)))

(set-macro-character #\[ 'left-brack-reader)

(defun right-paren-reader (stream char)
  (declare (ignore stream))
  (error "Non-balanced ~s encountered." char))

(set-macro-character #\] 'right-paren-reader)

;; Expanze zaslání zprávy: unární zprávy převede na složené,
;; ostatní nemění
(defun expand-unary (expr)
  (if (symbolp expr)
      `(send %receiver ',expr)
    expr))

#|

(expand-unary '(cokoliv))
(expand-unary 'cokoliv)

|#

;; Expanze případných unárních zaslání zpráv na každém
;; druhém místě seznamu počínaje prvním.
(defun expand-unary-lst (list)
  (when list
    (cons (expand-unary (car list))
          (when (cdr list)
            (cons (cadr list)
                  (expand-unary-lst (cddr list)))))))

#|

(expand-unary-lst '(obj :arg2 10 :arg3 arg3 :arg4 (cokoliv) :arg5 #'print))

|#

(defmacro send-expand (obj message &rest args)
  `(send ,(expand-unary obj)
         ',message
         ,@(expand-unary-lst args)))

#|

(macroexpand-1
 '(send-expand obj message arg1 :arg2 10 :arg3 arg3 :arg4 (cokoliv) :arg5 #'print))

'[obj message 10 :arg2 10 :arg3 arg3 :arg4 (cokoliv) :arg5 #'print]

|#

;; Složené závorky 
;; načtou se jako inline objekt
(defun left-brace-reader (stream char)
  (declare (ignore char))
  (cons 'object-expand (read-delimited-list #\} stream t)))

(set-macro-character #\{ 'left-brace-reader)
(set-macro-character #\} 'right-pb-reader)

(defun obj-fields-expand (fields)
  (mapcan (lambda (field)
            (list `(add-field result ',field :value (clone-object *object*))
                  `(add-setter-field result ',field)))
          fields))

#|
(obj-fields-expand '(a b c d e))
|#

(defmacro object-expand (&optional fields &rest code)
  `(let ((result (clone-object %receiver)))
     ,@(obj-fields-expand fields)
     ,(when code
        `(setf (object-code result)
               (lambda (%receiver)
                 ;; podobné jako (declare (ignore %receiver))
                 ;; podrobnosti vysvětlím zájemcům osobně
                 (declare (ignorable %receiver))
                 ,@(mapcar #'expand-unary code))))
     result))

#|

(macroexpand-1
 '(object-expand (a b) code1 code2))

|#

#|
;; Testy čtení (vyhodnocovat v Listeneru)
(macroexpand-1
 '[a b])
(macroexpand-1
 '[[a b] c {() d [e {(f) g h}]}])
|#

;; Nastavení globální hodnoty symbolu %receiver
;; Podobné jako (setf %receiver *lobby*), ale nevyvolává warning
;; Podrobnosti vysvětlím osobně.
(define-symbol-macro %receiver *lobby*)

;; Hack, aby editor rozuměl hranatým a složeným závorkám
(editor::set-vector-value
 (slot-value editor::*default-syntax-table* 'editor::table) '(#\[ #\{) 2)
(editor::set-vector-value
 (slot-value editor::*default-syntax-table* 'editor::table) '(#\] #\}) 3)