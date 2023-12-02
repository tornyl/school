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
  :members ("micro-graphics/load" "08" "ex05/05_bounds" "ex07/07_click-circle.lisp" 
            "ex08/08_text-shape" "ex08/08_button" "ex08/08_cwa" 
            "ex08/08_cw2a" "ex08/08_polygon-canvas" "ex08/08_polygon-editor")
  :rules ((:compile :all 
           (:requires (:load :previous)))))

(compile-system 'pp3-08 :load t)
