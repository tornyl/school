;; Načtením tohoto souboru načtete čtyři základní souboru implementace
;; jazyka. Prostředí tak bude připraveno na načítání souboru
;; 10_basics.lisp. Pokud chcete automaticky načítat i ten, přidejte si 
;; ho do seznamu níže.
(in-package "CL-USER")

(set-default-character-element-type 'simple-char)

(defsystem protos_new ()
  :members ("10_system-1" "10_system-2" "10_externals" "10_syntax")
  :rules ((:compile :all 
           (:requires (:load :previous)))))

(compile-system 'protos_new :load t)