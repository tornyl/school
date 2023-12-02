[*shape* add "FILLEDP" :value nil]
[*shape* add-setter "FILLEDP"]
[*shape* add "SET-MG-PARAMS" :value (lambda (self arg1)
													(mg:set-param arg1 :foreground [self color])
													(mg:set-param arg1 :filledp [self filledp])
													(mg:set-param arg1 :thickness [self thickness])
													self)]

[*shape* add "DRAW" :value (lambda (self arg1)
										[self set-mg-params arg1]
										[self do-draw arg1]
										self)]

(setf *window* [*object* clone])
[*window* add "SHAPE" :value nil]
[*window* add-setter "SHAPE"]
[*window* add "BACKGROUND" :value :black]
[*window* add-setter "BACKGROUND"]
[*window* add "REDRAW" :value (lambda (self)
											(let ((mgw [self mg-window]))
												(mg:set-param mgw :background [self background])
												(mg:clear mgw)
												(when [self shape]
													[[self shape] draw mgw])
												self))]



[*circle* add "RADIUS" :value 10]
[*circle* add-setter "RADIUS"]
;[*point* add "SCALE" :value  (lambda (self arg1 &key center)
										;	(let ((cx [center x])
										;		  (cy [center y]))
										;		[self move (- cx) :y (-cy)]
;												[


