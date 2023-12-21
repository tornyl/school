;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 09_graphics.lisp - příklad k přednášce 9
;;;;

#|

Takto by mohla začít práce na vytváření grafických objektů.
V principu nejde o zdrojový kód, ale záznam akcí, kterými objekty vytváříme
a upravujeme (výrazy by se měly vyhodnocovat jeden po druhém v Listeneru).

|#

(defvar *shape*)

(setf *shape* [*object* clone])
[*shape* add "COLOR" :value :black]
[*shape* add-setter "COLOR"]
[[[*shape* clone] set-color :white] color]
[*shape* add "THICKNESS" :value 1]
[*shape* thickness]
[*shape* remove "THICKNESS"]
[*shape* add "THICKNESS" :value 1]
[*shape* add-setter "THICKNESS"]
[*shape* thickness]

[*shape* name]
[*shape* set-name "SHAPE"]
[*shape* name]

(defvar *point*)
(setf *point* [*shape* clone])
[*point* set-name "POINT"]
[*point* add "X" :value 0]
[*point* add-setter "X"]
[*point* add "Y" :value 0]
[*point* add-setter "Y"]

(setf pt [*point* clone])
[pt x]
[pt set-x 10]
[pt x]
[pt is *point*]
[pt is *shape*]
[pt is-nihil]

[*point* add "MOVE" :value (lambda (self arg1 &key y)
                             [self set-x (+ arg1 [self x])]
                             [self set-y (+ y [self y])])]
[*point* move 10 :y 20]

(defvar *circle*)
(setf *circle* [*shape* clone])
[*circle* set-name "CIRCLE"]
[*circle* add "CENTER" :value [*point* clone]]

[*circle* add "CLONE" :value (lambda (self)
											(let ((c [[self center] clone])
													(new-circle nil))
												[self remove "CENTER"]
												(setf new-circle  [self clone-object])
												[new-circle add "CENTER" :value c]
												new-circle))]
