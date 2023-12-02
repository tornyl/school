;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_basics.lisp - základní definice v prototypovém jazyce
;;;;

;; Zdrojový kód prototypového jazyka. Je třeba načíst soubory 10_system.lisp,
;; 10_externals.lisp a 10_syntax.lisp.
;; Zde jsou už všechny definice napsané buď v našem jazyce, nebo jako primitiva.

;; Soubor také obsahuje příklady a testy.

;; (Vše dávat postupně do Listeneru nebo vyhodnotit naráz celý soubor)

;; Slot name:
[object add "NAME" :value "OBJECT"]
[object add-setter "NAME"]

[nihil set-name "NIHIL"]
[lobby set-name "LOBBY"]

#|
[object name]
[nihil name]
[[nihil super] name]
[lobby name]

[object clone]
[[[object clone] super] name]
[[[object clone] set-name "OBJECT-1"] name]
|#

#|
;; Test vytváření inline objektů
{(a b c) [a m]}
|#


;; Logika
[lobby add "TRUE" :value [object clone]]
[true set-name "TRUE"]
[true add "IF-TRUE" :value {(arg1 else) arg1}]
[lobby add "FALSE" :value [object clone]]
[false set-name "FALSE"]
[false add "IF-TRUE" :value {(arg1 else) else}]

[true add "AND" :value {(arg1) arg1}]
[false add "AND" :value false]

#|
[[lobby true] name]
[true name]
[false name]

[true if-true 1 :else 0]
[false if-true 1 :else 0]

[[true and true] name]
[[true and false] name]
[[false and true] name]
[[false and false] name]
|#

[nihil add "IS-NIHIL" :value true]
[object add "IS-NIHIL" :value false]

#|
[[lobby is-nihil] name]
|#

;; Primitivum na tisk

[object add "PRINT" :value #'print]

#|
["Hello World" print]
[true if-true {() [1 print] 10} :else {() [2 print] 11}]
[false if-true {() [1 print] 10} :else {() [2 print] 11}]
|#

;; Vynucení spuštění metody bez argumentu:
[lobby add "FORCE" :value {(arg1) arg1}]

#|
[{} force {() ["Test" print]}]
|#

;; return-first - vyhodnotí dva výrazy, vrátí výsledek prvního
;; první možnost:
[lobby add "RETURN-FIRST"
           :value {(arg1 arg2) 
                    [{} force [{(var) arg2 var} set-var arg1]]}]

;; Druhá možnost:
[lobby add "RETURN-FIRST"
           :value {(arg1 arg2 vars)
                   [vars add "VAR" :value arg1]
                   arg2
                   [vars var]}]


#|
;; Pokaždé můžeme otestovat takto:
[{} return-first 1 :arg2 {() [2 print]}]
|#

;; eql: primitivum na porovnávání objektů
;; níže ale uvidíme, že porovnávání lze napsat i čistě prostředky jazyka
;; Vidíme, že uvnitř externího kódu můžeme použít opět kód našeho jazyka.
[object add "EQL" :value (lambda (self arg1)
                           (if (eql self arg1) [{} true] [{} false]))]

#|
[[object eql object] name]
[[nihil eql nihil] name]
[[lobby eql nihil] name]
|#


;; is

[object add "IS" 
        :value {(arg1) [object add "IS-MARK" :value false]
                       [arg1 add "IS-MARK" :value true]
                       [{} return-first [self is-mark] 
                                        :arg2 {() [arg1 remove "IS-MARK"]
                                                  [object remove "IS-MARK"]}]}]
#|
[[lobby is object] name]
[[object is object] name]
[[object is lobby] name]
[[[lobby clone] is lobby] name]
[[true is lobby] name]
[[object is [lobby clone]] name]
|#

;; equals

[object add "EQUALS" 
            :value {(arg1) [[arg1 is self] and [self is arg1]]}]

#|
[[object equals object] name]
[[nihil equals nihil] name]
[[nihil equals object] name]
|#


;; Čísla jako externí objekty

[number set-name {() [[self eql number] if-true "NUMBER" :else self]}]

#|
[number name]
[[0 super] name]
[[0 is number] name]
[[0 is 0] name]
[[number is 0] name]
[[10 equals 10] name]

[0 name]
[1000 name]

*number-plists*
|#

[number add "+" :value #'+]
[number add "-" :value #'-]
[number add "*" :value #'*]
[number add "/" :value #'/]

#|
[1 + 1]
|#

;; Opět nemusíme použít if-true:
[number add "!" :value {() [self * [[self - 1] !]]}]
[0 add "!" :value 1]

#|
[0 !]
[2 !]
[3 !]
[10 !]
|#

#|

;; Řetězce

["Hello " + "World"]

|#

[string set-name {() [[self eql string] if-true "STRING" :else self]}]

#|
[string name]
["Ahoj" name]
|#

#|
;; Volání zděděné metody:

[lobby add "TEST" :value [object clone]]
[test set-name {() ["CHILD OF " + [[owner super] name]]}]

[test name]
[[test clone] name]

[lobby add "TEST2" :value [object clone]]
[test2 set-name {() ["CHILD OF " + [[self super] name]]}]
[test2 name]
[[test2 clone] name]

|#

;; Metoda jako argument:
[lobby add "SEND-TO-3" :value {(arg1 obj1 obj2 obj3)
                               [{} arg1 obj1]
                               [{} arg1 obj2]
                               [{} arg1 obj3]}]

#|
[{} send-to-3 {(arg1) [arg1 print]} :obj1 1 :obj2 2 :obj3 3]
|#

;; esoterická čísla
;; jsou to čísla vytvořená čistě prostředky jazyka

[lobby add "ZERO" :value [object clone]]
[zero add "NEXT-NUMBER" :value nihil]
[zero add-setter "NEXT-NUMBER"]
[zero set-name 0]

;; succ vrací následníka čísla. next-number je pomocný slot, který
;; následníka obsahuje, pokud už byl vytvořen 
[zero add "SUCC" :value {() [[[self next-number] eql nihil] 
                             if-true {() [self set-next-number [self clone]]
                                         [[self next-number] set-next-number nihil]
                                         [[self next-number] set-name [[self name] + 1]]}
                             :else nihil]
                            [self next-number]}]

[lobby add "ONE" :value [zero succ]]

#|
[one name]
[[one super] name]
[[[[[one succ] succ] succ] succ] name]
[[[[[[[[one succ] succ] succ] succ] super] super] super] name]
|#

;; převod externích čísel na esoterická (převod zpět už máme pomocí name):

[0 add "ESOTERIC" :value zero]
[number add "ESOTERIC" :value {() [[[self - 1] esoteric] succ]}]

#|

[[0 esoteric] name]
[[[1 esoteric] equals one] name]
[[3 esoteric] name]

|#

;; Sčítání esoterických čísel:

[zero add "+" :value {(arg1) arg1}]
[one add "+" :value {(arg1) [[self super] + [arg1 succ]]}]


#|
[[[2 esoteric] + [3 esoteric]] name]
|#