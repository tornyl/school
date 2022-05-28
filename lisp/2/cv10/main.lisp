;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; 11_stacks_1.lisp - Zásobníkové programování
;;;
;;; Jazyk pro myšlený zásobníkový stroj.
;;; fáze 1 - základy
;;;

;;
;; Hlavní zásobníky
;;

;; Datový zásobník (Result Stack) bude v proměnné *rslt*
;; Programový zásobník (Execution Stack) bude v proměnné *exec*
;; Kvůli pohodlnějšímu ladění budou zastíněny v hlavní funkci execute.
;; (Aby byly zásobníky snadno vidět ve stepperu.)
 
(defvar *rslt*)

(defvar *exec*)

;; Slovník je zásobník párů (klíč . hodnota)
;; práce se slovníky:

(defun dict-find (key dict)
  (let ((pair (find key dict :key #'car)))
    (unless pair (error "Key not found in dictionary: ~s" key))
    (cdr pair)))

(defmacro dict-push (key val dict)
  `(push (cons ,key ,val) ,dict))

;; Slovník definic slov. Každá definice je pár (slovo . kód).
;; Kód je buď lispová funkce (vestavěné slovo), nebo kód našeho jazyka
;; v seznamu (uživatelsky definované slovo).

(defvar *word*)

;; 
;; Slova
;;

;; Slova jsou lispovské klíče
(defun wordp (el)
  (keywordp el))

(defun word-code (w)
  (dict-find w *word*))

;; Vykonání slova (je-li na vrcholu programového zásobníku)
(defun exec-word (word)
  (let ((code (word-code word))) 
    (if (functionp code)
        (built-in-exec code)
      (user-exec code))))

(defun built-in-exec (fun)
  (funcall fun))

(defun user-exec (uc)
  (setf *exec* (append uc *exec*)))

;;
;; Základní vestavěná slova:
;;

(setf *word*
      (list ;; (a b -- součet a + b)
            (cons :+ 
                  (lambda () 
                    (push (+ (pop *rslt*) (pop *rslt*)) *rslt*))) 
            ;; (a b -- rozdíl a - b)
            (cons :-
                  (lambda ()
                    (let ((arg (pop *rslt*)))
                      (push (- (pop *rslt*) arg) *rslt*))))
            ;; (a b -- součin a * b)
            (cons :* 
                  (lambda () 
                       (push (* (pop *rslt*) (pop *rslt*)) 
                             *rslt*)))
            ;; (a b -- podíl a / b)
            (cons :/ 
                  (lambda ()
                    (let ((arg (pop *rslt*)))
                      (push (/ (pop *rslt*) arg) *rslt*))))
            ;; (a b -- log. hodnota a = b)
            (cons := 
                  (lambda () 
                    (push (= (pop *rslt*) (pop *rslt*)) *rslt*)))))

;; Další vytvoříme pomocí funkce define-word
(defun define-word (name code)
  (dict-push name code *word*))

;; (a b -- b a) 
(define-word :swap (lambda ()
                     (setf *rslt* (append (list (second *rslt*)
                                                (first *rslt*))
                                          (cddr *rslt*)))))

;; (a b c -- b c a) 
(define-word :rot (lambda ()
                    (setf *rslt* (append (list (third *rslt*)
                                               (first *rslt*)
                                               (second *rslt*))
                                         (cdddr *rslt*)))))

;; (a -- )
(define-word :drop (lambda ()
                     (pop *rslt*)))

;; (a -- a a)
(define-word :dup (lambda ()
                    (push (car *rslt*) *rslt*)))

;; (a b -- a b a)
(define-word :over (lambda ()
                     (push (second *rslt*) *rslt*)))



;; Slovo :if pracuje tak, že upravuje vrchol zásobníku exec.
;; Používá pomocné funkce tail a stack-if.
(defun tail (elem stack)
  "Vrací pokračování seznamu stack začínající prvkem elem. Přeskakuje bloky :if-:else-:then"
  (cond ((null stack) (error "Empty stack. "))
        ((eql (car stack) elem) stack)
        ((eql (car stack) :if) (tail elem 
                                     (cdr (tail :then 
                                                (cdr stack)))))
        (t (tail elem (cdr stack)))))

#|
(tail :then '( 1 2 :if 3 4 :else 5 6 :then 7 8 :else :if 9 10 :else 11 12 :then 13 :then 14 15))
(tail :else '( 1 2 :if 3 4 :else 5 6 :then 7 8 :else :if 9 10 :else 11 12 :then 13 :then 14 15))
|#

(defun stack-if (val stack)
  (let* ((else-tail (tail :else stack))
         (then-tail (tail :then else-tail)))
    (append (if val 
                (ldiff (cdr else-tail) then-tail)
              (ldiff stack else-tail))
            (cdr then-tail))))

#|
(stack-if t '(1 2 :+ :else 3 4 :+ :then a b))
(stack-if nil '(1 2 :+ :else 3 4 :+ :then a b))
|#

(define-word :if (lambda ()
                   (setf *exec* (stack-if (pop *rslt*) *exec*))))


;; Slovo :def definuje nové slovo
(define-word :def (lambda ()
                    (define-word (pop *exec*)
                                 *exec*)
                    (setf *exec* nil)))

;;
;; Spuštění programu.
;;
;; Jeden krok

(defun exec-step ()
  (let ((elem (pop *exec*)))
    (cond ((wordp elem) (exec-word elem))
          ((or (numberp elem) (stringp elem)) (push elem *rslt*))
          (t (error "Unknown element on exec stack: ~s" elem)))))

;; Celý program
;; Tady vytváříme vazby proměnných *rslt* a *exec*.
;; Vazby budou dynamické.
(defun execute (&rest code)
  (let ((*rslt* '())
        (*exec* code))
    (loop (when (null *exec*) (return))
          (exec-step))
    (pop *rslt*)))


#|

;; Výrazy je dobré vyhodnocovat v Listeneru a ne tady přes F8.
;; Když se rekurzivní výraz zacyklí, je pak snadné ho zastavit tlačítkem Break.
;; Vždy je dobré dělat to přes breakpoint, jak jsem ukazoval na přednášce.
;; Tak vidíte, jak se postupně vykonávají jednotlivé kroky výpočtu
;; a můžete sledovat stav obou zásobníků.

(execute 1)
(execute 3 2 :- 4 :*)

(execute 1 2 :swap :drop)

;; Výpočet 4*(4 + 5):
(execute 4 5 :over :+ :*)

(execute 0 1 := :if 2 5 :* :else 2 10 :* :then)
(execute 1 1 := :if 2 5 :* :else 2 10 :* :then)

;; Tohle povede k chybě, protože symbol na zásobník s kódem (zatím) nepatří:
(execute 'a)

;; Definice nového slova v jazyce:
(execute :def :sqr :dup :*)

|#

;; REPL

(defun read-string ()
  (let ((line (read-line)))
    ;; Po načtení všech řádků doplníme na konec tečku
    ;; jako značku konce.
    (if (eql (length line) 0)
        " ."
      (format nil "~a ~a" line (read-string)))))

(defun read-code ()
  ;; Takto uděláme z řetězce vráceného funkcí read-string
  ;; vstupní proud, na který lze aplikovat funkce readeru.
  (with-input-from-string (stream (read-string))
    ;; Načítáme seznam až po tečku.
    (read-delimited-list #\. stream)))

(defun repl ()
  (loop (format t "~%~%stacks > ") 
        (handler-case (princ (apply #'execute 
                                    (prog1 (read-code)
                                      (fresh-line))))
          (error (err) (format t "Chyba: ~a" err)))))


#|

;; Další testy už vkládejte do REPLu:

:def :fact
     :dup 0 := :if :dup 1 :- :fact :* :else
                   :drop 1 :then

5 :fact

;; Iterativní faktoriál. Porovnejte, co se děje se zásobníkem proti
;; předchozí verzi.

;; pomocné slovo :factiter (vzpomeňte si, že u iterativní rekurze jsme
;; obvykle potřebovali napsat pomocnou funkci)
;; Na vrcholu zásobníku očekává už vypočítaný součin, pod ním číslo
;; udávající, kolikrát je ještě třeba násobit.

:def :factiter :over :dup 1 := :if :* :swap 1 :- :swap :factiter :else
                                   :drop :swap :drop :then

:def :ifact 1 :factiter

5 :ifact

|#

;; Šikovná pomůcka (a další ukázka uživatelsky definovaného slova): 
;; rotace opačným směrem.

#|
:def :rot- :rot :rot
|#

#|

;; n-té Fibonacciho číslo počínaje n = 1

:def :fib 0 1 :rot :xfib

:def :xfib
     :dup 1 := :if :rot- :dup :rot :+ :rot 1 :- :xfib :else
                   :drop :swap :drop :then

5 :fib

|#



(define-word :hyp (lambda ()
							(let ((b (pop *rslt*))
									(a (pop *rslt*)))
								(push  (sqrt (+ (* a a) (* b b))) *rslt*))))


(define-word :discr (lambda ()
							(let ((c (pop *rslt*))
									(b (pop *rslt*))
									(a (pop *rslt*)))
								(push (sqrt (- (* b b) (* 4 a c))) *rslt*))))


(define-word :not (lambda ()
							(push (not (pop *rslt*)) *rslt*)))

(define-word :and (lambda ()
							(let ((b (pop *rslt*))
									(a (pop *rslt*)))
								(push (and a b) *rslt*))))

(define-word :or (lambda ()
							(let ((b (pop *rslt*))
									(a (pop *rslt*)))
								(push (or a b) *rslt*))))


(define-word :+n (lambda ()
							(let ((sum 0))
								(dotimes (x (pop *rslt*))
									(setf sum (+ sum (pop *rslt*))))
								(push sum *rslt*))))



(define-word :avgn  (lambda ()
								(setf *exec*  (cons :/ *exec*))
								(push (first *rslt*) *exec*)
								(push :+n *exec*)))
