;; 08.load

#|
Načtením tohoto souboru načtete všechny soubory potřebné k práci 
s knihovnou OMG ve verzi z 8. přednášky včetně příkladů.

Organizace adresářů: v adresáři, kde je tento 
soubor, musí být 

soubor "08.lisp"

a následující adresáře:

"micro-graphics" s knihovnou micro-graphics
"05 Examples" se souborem "05_bounds.lisp"
"07 Examples" s "07_click-circle.lisp"
"08 Examples" se všemi příklady k přednášce 8.

Pokud máte už načtenou jinou verzi knihovny, nejprve ukončete LispWorks.
|#

(in-package "CL-USER")

(set-default-character-element-type 'simple-char)

(defsystem pp3-08 ()
  :members ("micro-graphics/load" "08" "05 Examples/05_bounds" "07 Examples/07_click-circle.lisp" 
            "08 Examples/08_text-shape" "08 Examples/08_button" "08 Examples/08_cwa" 
            "08 Examples/08_cw2a" "08 Examples/08_polygon-canvas" "08 Examples/08_polygon-editor")
  :rules ((:compile :all 
           (:requires (:load :previous)))))

(compile-system 'pp3-08 :load t)