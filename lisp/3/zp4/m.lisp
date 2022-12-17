[{} force {() ["Test" print]}]

;; ukol 1
[[lobby true] add "NOT" :value false]
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
[cons add "CAR" :value [cons nil]]
[cons add-setter "CAR"]
[cons add "CDR" :value [cons nil]]
[cons add-setter "CDR"]



;;ukol 10
;;[object remove "REC"]
;;[object add "REC" :value {(b) [[b eql "xd"] if-true "yoo" :else [self rec "xd"]]}]

;;pruchod sezname do konce
[cons add "LAST-PAIR" :value {() [[[self cdr] eql nil] if-true self :else [[self cdr] last-pair]]}]
[nil add "LAST-PAIR" :value [nil clone]]

;;; spojovani
[cons add "APPEND" :value {(arg1) [[self last-pair] set-cdr arg1] arg1}] 

;;test spojovani

[lobby add "P1" :value [cons clone]]
[lobby add "P2" :value [cons clone]]
[p1 set-car 5]
[p2 set-car 3]

