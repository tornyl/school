;ukol 1
[true add "NOT" :value false]
[false add "NOT" :value true]

[true add "OR" :value true]
[false add "OR" :value {(arg1) arg1}]

;ukol 2

[string add "ERROR" :value #'error ]



; ukol 3

[number add "RANDOM" :value #'random ]


; ukol 4

[lobby add "SHAPE" :value [object clone]]
[shape set-name "SHAPE"]
[shape add "COLOR" :value 'black]
[shape add-setter "COLOR"]
[shape add "THICKNESS" :value 1]
[shape add-setter "THICKNESS"]

[lobby add "POINT" :value [shape clone]]
[point set-name "POINT"]
[point add "X" :value 0]
[point add-setter "X"]
[point add "Y" :value 0]
[point add-setter "Y"]
[point add "MOVE" :value {(arg1 y) 
									[self set-x [[self x] + arg1]]
									[self set-y [[self y] + y]]}]

[lobby add "CIRCLE" :value [shape clone]]
[circle set-name "CIRCLE"]
[circle add "CENTER" :value [point clone]]

[circle add "CLONE" :value {() [[[[self super] clone] add "CENTER" :value [[self center] clone]] set-super self]}]


;ukol 5
[lobby add "EMPTY-PAIR" :value [object clone]]
[empty-pair set-name "EMPTY-PAIR"]
[lobby add "PAIR" :value [{(car cdr)} set-super object]]
[pair set-name "PAIR"]

[lobby add "CONS" :value {(arg1 cdr) [[[pair clone] set-car arg1] set-cdr cdr]}]

;ukol 6
[object add "IS-LIST" :value false]
[empty-pair add "IS-LIST" :value true]
;[pair add "IS-LIST" :value true]
[pair add "IS-LIST" :value {() [[self cdr] is-list]}]

;[lobby remove pair-1]
[lobby add "PAIR-1" :value  [lobby cons 1 :cdr [lobby cons 2 :cdr [lobby cons 3 :cdr [empty-pair clone]]]]]
[lobby add "PAIR-5" :value  [lobby cons 1 :cdr [lobby cons 2 :cdr [lobby cons 3 :cdr 6]]]]

;ukol 7

[empty-pair add "LENGTH" :value zero]
[pair add "LENGTH" :value {() [[[self cdr] length] succ]}]

; ukol 8

;vrati posledni par
[pair add "LAST-PAIR" :value {() [[[self cdr] eql empty-pair] if-true self :else [[self cdr] last-pair]]}]
[empty-pair add "LAST-PAIR" :value empty-pair]

;spojeni
[pair add "APPEND" :value {(arg1) [[self last-pair] set-cdr arg1]}]
[empty-pair add "APPEND" :value {(arg1) arg1}]

;test par pro spojeni
[lobby add "PAIR-2" :value [{} cons 8 :cdr [{} cons 75 :cdr empty-pair]]]


;prohledavani

[pair add "FIND" :value {(arg1) [[[self car] eql arg1] if-true arg1 :else [[self cdr] find arg1]]}]
[empty-pair add "FIND" :value {(arg1) [[arg1 eql self] if-true arg1 :else false]}]


; ukol 10 
[lobby add "EL":value {(arg1) [[[object clone] add "METHOD":value{() [self add "VAR":value [cons clone]] [[self var] set-car arg1] [[self var] set-cdr {() [{} EL [arg1 + 2]]}]}] method ]}]

[lobby add "EVEN-LIST" :value {() [{} el 2]}]

