;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Paradigmata programování 2
;;;;
;;;; Přednáška 9, Normální vyhodnocovací model
;;;; Interpret líného Scheme
;;;;

#|
Všechny zakomentované testy si vyzkoušejte (F8)
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Výrazy
;;
;; Výrazy jsou jména, proměnné, abstrakce, aplikace a externí data nebo funkce.
;; Jména ale vyřešíme až poté, co budeme umět hledat volné proměnné.
;;

;;
;; Proměnné
;;

(defun variablep (expr)
  (and (symbolp expr) (not (namep expr))))

#|
(variablep 'x)
|#

;;
;; Abstrakce
;;

;; Typový predikát
(defun abstractionp (expr)
  (and (listp expr)
       (eql (car expr) 'lambda)))

#|
(abstractionp 'x)
(abstractionp '(lambda (x) y))
(abstractionp '(lambda (x y z) y))
|#

;; Selektory

(defun abstr-params (abs)
  (second abs))

(defun abstr-body (abs)
  (third abs))

;; Konstruktor
(defun abstraction (parameters body)
  `(lambda ,parameters ,body))

#|
(abstraction '(x y) '(x y))
(abstraction '() '(x y))
(abstr-params '(lambda (x y) (x z)))
(abstr-body '(lambda (x y) (x z)))
|#

;;
;; Aplikace
;;

;; Aplikace je libovolný seznam výrazů, který není abstrakce.
;; Má hlavu a argumenty.

;; Konstruktor:
(defun application (head args)
  (cons head args))

;; Selektory:

(defun appl-head (appl)
  (car appl))

(defun appl-args (appl)
  (cdr appl))

(defun appl-list (appl)
  appl)

;; Typový predikát:
(defun applicationp (expr)
  (and (consp expr)
       (not (abstractionp expr))))

#|
(application 'x '(y))
(appl-head (application 'x '(y)))
(appl-args (application 'x '(y)))
(appl-list (application 'x '(y)))
(applicationp (application 'x '(y)))
|#

;;
;; Externí data a funkce
;;

(defun external-data-p (expr)
  (and (not (symbolp expr))
       (not (consp expr))))

(defun external-function-p (expr)
  (functionp expr))
            

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Volné proměnné ve výrazech: funkce expr-free-vars
;;

#|
Pojem volné proměnné by měl být intuitivně jasný. Definici najdete v textu
k přednášce.

Funkce expr-free-vars vrací seznam volných proměnných daného výrazu.
|#

#|

Funkce remove-duplicates a mapcan si můžete najít ve standardu. Stručně:

remove-duplicates odstraní ze seznamu duplicitní hodnoty (otestujte):

(remove-duplicates '(1 2 1 3 3 2 4 2))

mapcan funguje jako mapcar, ale výsledné hodnoty spojí jako seznamy:

(mapcar #'reverse '((1 2 3) (4 5 6) (7 8 9 10)))
(mapcan #'reverse '((1 2 3) (4 5 6) (7 8 9 10)))

|#



(defun expr-free-vars (expr)
  (cond ((namep expr) '())
        ((variablep expr) (list expr))
        ((applicationp expr) (remove-duplicates 
                              (mapcan #'expr-free-vars (appl-list expr))))
        ((abstractionp expr) (set-difference 
                              (expr-free-vars (abstr-body expr))
                              (abstr-params expr)))
        ((external-data-p expr) '())))

#|
(expr-free-vars '((lambda (x y) (x y z))
                  u))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Jména
;;

(defvar *names* '())

(defun name-pair (name)
  (find name *names* :key #'car))

#|
(name-pair '+)
(name-pair 'nic)
|#

(defun namep (name)
  (name-pair name))

(defun name-value (name)
  (let ((pair (name-pair name)))
    (unless pair (error "Name ~s not defined. " name))
    (cdr pair)))

#|
(name-value '+)
|#

(defun add-name (name value)
  (when (not (null (expr-free-vars value)))
    (error "Cannot name an expression with free variables: ~s. "
           value))
  (setf *names* (remove name *names* :key #'car))
  (push (cons name value) *names*))

;; Všechna jména přidáváme pomocí add-name, aby se zkontrolovala
;; správnost (výrazy nesmějí mít volné proměnné)
(add-name 'true '(lambda (x y) x))
(add-name 'false '(lambda (x y) y))
(add-name 'if '(lambda (p c a) (p c a)))
(add-name 'cons '(lambda (x y z) (z x y)))
(add-name 'car '(lambda (p) (p true)))
(add-name 'cdr '(lambda (p) (p false)))
(add-name '+ `(lambda (x y) (,#'+ x y)))
(add-name '- `(lambda (x y) (,#'- x y)))
(add-name '* `(lambda (x y) (,#'* x y)))
(add-name '/ `(lambda (x y) (,#'/ x y)))
;; Pokud tomuto nerozumíte, napište si druhý lambda-výraz
;; bokem jako funkci Lispu:
(add-name '= `(lambda (x y) (,(lambda (x y)
                                (if (= x y) 'true 'false))
                             x
                             y)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Substituce volných proměnných daného výrazu danými hodnotami: 
;; funkce expr-subst
;;
;; Tato funkce i tři pomocné funkce mají lambda-seznam (val var expr), kde
;; - val je nová hodnota dosazená místo proměnné
;; - var proměnná, místo které se hodnota dosazuje
;; - expr výraz, ve kterém se to děje
;;

(defun var-subst (val var orig-var)
  (if (eql orig-var var)
      val
    orig-var))

(defun appl-subst (val var appl)
  (application (expr-subst val var (appl-head appl))
               (mapcar (lambda (subexpr)
                         (expr-subst val var subexpr))
                       (appl-args appl))))

#|
Substituce v abstrakci (lambda-výrazu) je principiálně jednoduchá.
Je prostě třeba substituovat v jejím těle všechny volné výskyty symbolu.

Situaci ale komplikuje konflikt proměnných:
Při substituci výrazu y za proměnnou x ve výrazu (lambda (y) (y x))
je třeba nejdřív přejmenovat parametr y. Prostým nahrazením bychom
dostali nesprávný výsledek (lambda (y) (y y)).

Tato situace nastane, když jsou volné proměnné dosazovaného výrazu (zde y) 
současně parametry abstrakce, do které dosazujeme. Pak přejmenujeme parametr, 
zde změníme původní výraz na (lambda (z) (z x)). Substituce pak dopadne
dobře: (lambda (z) (z y)).
|# 

(defun abstr-subst (val var abstr)
  (let ((params (abstr-params abstr)))
    (if (find var params)
        abstr
      (let ((new-abstr (abstr-rename 
                        abstr 
                        (intersection params (expr-free-vars val)))))
        (abstraction (abstr-params new-abstr)
                     (expr-subst val var (abstr-body new-abstr)))))))

(defun abstr-rename (abstr params)
  (if (null params)
      abstr
    (abstr-rename (abstr-rename-1 abstr (car params))
                  (cdr params))))

(defun rename-param (p)
  (gensym (symbol-name p)))

(defun abstr-rename-1 (abstr param)
  (let ((new-param (rename-param param)))
    (abstraction (substitute new-param param (abstr-params abstr))
                 (expr-subst new-param param (abstr-body abstr)))))

#|
(abstr-subst 'y 'x '(lambda (y) (y x)))
(abstr-subst 'y 'x '(lambda (z) (z x)))
|#

#|

val:  nová hodnota
var:  proměnná, která se nahradí novou hodnotou
expr: výraz, ve kterém se náhrada provede

|#

(defun expr-subst (val var expr)
  (cond ((namep expr) expr)                         ;jméno nemá volné proměnné
        ((variablep expr) (var-subst val var expr))
        ((applicationp expr) (appl-subst val var expr))
        ((abstractionp expr) (abstr-subst val var expr))
        ((external-data-p expr) expr)
        (t (error "Unknown expression type: ~s. " expr))))

#|

(expr-subst 'y 'x 'x)
(expr-subst 'y 'x 'z)
(expr-subst 'y 'x '(x z x))
(expr-subst 'y 'x '(lambda (z) (z x)))
(expr-subst 'y 'x '(lambda (x) (z x)))
(expr-subst 'y 'x '(lambda (y) (y x)))
(expr-subst '(x y) 'x '((lambda (x) (x x))
                        (lambda (y) (x y))))

|#

#|
beta-redukce, tedy redukce aplikace. Jako parametry máme 
hlavu a argumenty. Když je hlava abstrakce, volá se beta,
pro externí funkci ext-beta.
|#

(defun beta (head args)
  (let ((params (abstr-params head))
        (body (abstr-body head)))
    (cond ((and (null params) (null args)) body)
          ((null params) (application body args))
          ((null args) head)
          (t (beta-1 head args)))))

(defun beta-1 (head args)
  (application 
   ;; Nejprve odstraníme z abstrakce první parametr
   ;; a až pak substituujeme. je to schválně, opačné
   ;; pořadí netestuje chybu substituce v abstrakci.
   (expr-subst (car args)
               (car (abstr-params head))
               (abstraction (cdr (abstr-params head))
                            (abstr-body head)))
   (cdr args)))

(defun ext-beta (head args)
  (apply head (mapcar #'do-eval args)))


#|
Funkce reduction vykoná redukci (jeden krok vyhodnocení).
Už víme, že redukci lze vykonat.
Funkce zjistí, zda jde o aplikaci, nebo jméno a podle toho
se zachová.
|#

(defun reduction (expr)
  (cond ((namep expr) (expansion expr))
        ((applicationp expr) (appl-reduction expr))
        (t (error "~s is not name or application. " expr))))

#|
Expanze proměnné
|#

(defun expansion (name)
  (name-value name))

#|
Redukce aplikace. 
Víme, že nějakou redukci ještě lze provést.
|#

(defun appl-reduction (app)
  (let ((head (appl-head app))
        (args (appl-args app)))
    (cond ((abstractionp head) (beta head args))
          ((external-function-p head) (ext-beta head args))
          (t (application (reduction head) args)))))

#|
(reduction '(lambda (x) x)
           'a)

(reduction
 (reduction '(lambda (x) (lambda (y) (x y)))
            'y)
 'z)

|#

#|
Funkce eval-end-p
Vrací pravdu, když už nelze výraz dále redukovat
|#

(defun eval-end-p (expr)
  (or (variablep expr)
      (abstractionp expr)
      (external-data-p expr)
      (and (applicationp expr)
           (not (abstractionp (appl-head expr)))
           (not (external-function-p (appl-head expr)))
           (eval-end-p (appl-head expr)))))

#|
(eval-end-p 'x)
(eval-end-p '(lambda (x) y))
(eval-end-p '(x y))
(eval-end-p '((lambda (x y) y) x))
(eval-end-p '(((lambda (x) (x x)) a)
              ((lambda (x) (x x)) b)))
(eval-end-p '((lambda (x) (x x))
              (lambda (x) (x x))))

(eval-end-p '(x ((lambda (x y) y) x)))

(eval-end-p #'car)

|#

#|
Vyhodnocování výrazů jako série redukcí, jak bylo popsáno
na přednášce.
Pokud výraz nelze dále redukovat (zjistí se funkcí eval-end-p),
vrátí ho jako výsledek.
Jinak vykoná jednu redukci a na výsledek opět zavolá sama sebe. 
|#

(defun do-eval (expr)
  (if (eval-end-p expr) 
      expr
    (do-eval (reduction expr))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Vstupní body interpretu: funkce ls-eval, ls-repl
;;
;; ls-eval:  zavedení nového jména nebo vyhodnocení výrazu.
;;           Ve druhém případě volá do-eval.
;;
;; ls-repl:  spustí repl líného Scheme.
;;


#|

Funkce ls-eval
--------------

Akceptuje výraz našeho jazyka nebo speciální výraz (define name expr).

Výraz jazyka vyhodnotí líným způsobem a vrátí výsledek.
U speciálního výrazu zavede pojmenování výrazu expr jménem name.

|#

(defun special-expr-p (expr)
  (and (consp expr) (eql (first expr) 'define)))

(defun ls-eval (expr)
  (if (special-expr-p expr)
      (add-name (second expr) (third expr))
    (do-eval expr)))

;; Testy jsou dole v replu.

#|

Funkce ls-repl
--------------

Spuštění replu. Ukončit jde vyvoláním chyby nebo zavřením Listeneru.

|#

(defun ls-repl ()
  (loop (format t "~%~%ls > ") 
        (handler-case (princ (ls-eval (prog1 (read) (fresh-line))))
          (error (err) (format t "Chyba: ~a" err)))))

#|

;; Testy v ls-replu (jednotlivě do něj kopírovat)

x
(x y)
((lambda (x) (x y)) z)
((lambda (x) (x y)) x)

((lambda (x) (x y)) (x y))
((lambda (x y) (x y)) (x y) (x y))

;; currying:
((lambda (x y z) (z x y)) u v)
((lambda (x y) (x y)) a)
((lambda (x y) (x y)) (x y))

;; Bylo nutné zredukovat hlavu, ale výsledek (a a) není abstrakce,
;; takže další redukce se neprovedla:
(((lambda (x) (x x)) a)
 ((lambda (x) (x x)) a))

;; Toto se zacyklí:
((lambda (x) (x x))
 (lambda (x) (x x)))

;; Toto se nezacyklí!
((lambda (x y) y)
 ((lambda (x) (x x))
  (lambda (x) (x x))))

;; Jména:
true
false
if

;; Větvení
(if true a b)
(if false a b)

;; Páry
(car (cons a b))
(cdr (cons a b))

;; Externí data a funkce
(car (cons 1 2))
(+ 1 2)
(+ 1)
((+ 1) 2)
(= 1)
;; Tohle je false:
((= 1) 2)

;; Definice pomocí define a zátěžový test:
(define fact 0) ;Trik pro rekurzivní definice.
(define fact (lambda (n)
               (if (= n 0)
                   1
                 (* n (fact (- n 1))))))

(fact 5)

;; Konečné seznamy
(define empty (lambda (x) true))
(define null (lambda (p) (p (lambda (x y) false))))

(null empty)
(null (cons 1 empty))

(define nth 0)
(define nth (lambda (n list)
              (if (= n 0)
                  (car list)
                (nth (- n 1) (cdr list)))))

;; Nekonečné líné seznamy
(define ones 1)
(define ones (cons 1 ones))
(car ones)
(car (cdr ones))
(nth 5 ones)

;; Součet seznamů 
(define sum-list 0)
(define sum-list (lambda (list1 list2)
                   (if (null list1)
                       empty
                     (cons (+ (car list1)
                              (car list2))
                           (sum-list (cdr list1)
                                     (cdr list2))))))



(define l1 (sum-list (cons 1 (cons 2 empty)) (cons 3 (cons 4 empty))))
(car l1)
(car (cdr l1))
(null (cdr (cdr l1)))
                 
;; Fibonacciho posloupnost  
(define fib 0)

(define fib (cons 1 (cons 1 (sum-list fib (cdr fib)))))

(nth 5 fib)

;; Map
(define map 0)
(define map (lambda (f l)
              (if (null l)
                  empty
                (cons (f (car l))
                      (map f (cdr l))))))


;; Currying
(define l2 (map (+ 1) (cons 1 (cons 2 empty))))
(car l2)
(car (cdr l2))


(define map-succ (map (+ 1)))

(define l3 (map-succ (cons 1 (cons 2 empty))))
(car l3)
(car (cdr l3))
|#
