[{} force {() ["Test" print]}]

;; ukol 1
[true add "NOT" :value false]
[false add "NOT"  :value true]


;; ukol 2
;;myslim ze ano
;; [object add "CLONE" :value {() [{} set-super self]}]


;;ukol 3


;;ukol 4
[lobby remove "ERROR"]
[lobby add "ERROR" :value (lambda  (self msg) (print (format nil "Error: ~a" msg)))]
;;[lobby add "ERROR" :value {(self msg) [["Error" + msg] print]}]


;;ukol 5
[lobby remove "RAND"]
;;[lobby add "RAND" :value #'random]
[lobby add "RAND" :value (lambda (self num) (random num))]


;;ukol 7
[object remove "CONS"]
[object add "CONS" :value [object clone]]
[object remove "NIL"]
[object add "NIL" :value [object clone]]
[nil set-name "NIL"]

[cons set-name "CONS"]
[cons add "CAR" :value nil]
[cons add-setter "CAR"]
[cons add "CDR" :value nil]
[cons add-setter "CDR"]


;;ukol 9

[cons add "LENGTH" :value {() [[[self cdr] length] succ]}]
[nil add "LENGTH" :value zero]


;;ukol 10
;;[object remove "REC"]
;;[object add "REC" :value {(b) [[b eql "xd"] if-true "yoo" :else [self rec "xd"]]}]

;;pruchod sezname do konce
[cons add "LAST-PAIR" :value {() [[[self cdr] eql nil] if-true self :else [[self cdr] last-pair]]}]
[nil add "LAST-PAIR" :value nil]

;;; spojovani
[cons add "APPEND" :value {(arg1) [[self last-pair] set-cdr arg1] arg1}] 

;;test spojovani

[lobby add "P1" :value [cons clone]]
[lobby add "P2" :value [cons clone]]
[p1 set-car 5]
[p2 set-car 3]
[p2 set-cdr [cons clone]]
[[p2 cdr] set-car 88]
[p1 append p2]

;;ukol 11

;;[cons add "BROADCAST" :value {(arg1) [[[self eql nil] not] if-true [[{() [{} arg1 [self car]] [[self cdr] broadcast arg1]}] :else [nil clone]]}]
[cons add "BROADCAST" :value {(arg1) [{} arg1 [self car]] [[self cdr] broadcast {(s) [[{} arg1] s]}]}]
[nil add "BROADCAST" :value {(arg1) nil}]

;;(lobby add "EVEN" :value {() [c



;;[p1 broadcast {(arg1) [arg1 print]}]

[zero add "*" :value {(arg1) one}]
[one add "*" :value {(arg1) [[self super] * [[arg1 succ] + [arg1 clone]]]}]

[[[5 esoteric] * [4 esoteric]] name]


;;ukol 12
[lobby add "EL":value {(arg1) [[[object clone] add "METHOD":value{() [self add "VAR":value [cons clone]] [[self var] set-car arg1] [[self var] set-cdr {() [{} EL [arg1 * 2]]}]}] method ]}]

