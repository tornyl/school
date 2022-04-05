#include <stdio.h>
#include <stdlib.h>
#define ENG 0
#define  CZ 0
#define FR 1

 #if defined(ENG) && ENG 
 	#define ERROR "error"
 #elif defined(CZ) && CZ
 	#define ERROR "chyba"
 #elif defined(FR) && FR
 	#define ERROR "Erreur"
 #elif defined(DE) && DE
 	#define ERROR "Fehler"
 #else
 	#define ERROR "error"
#endif

#if !defined(CZ)
	#define CZ 0
#elif !defined(FR)
	#define FR 0
#elif !defined(DE)
	#define DE 0
#elif !defined(EN)
	#define EN 0
#else 
	#define EN 1
#endif

#define power_3(x) (x) * (x) * (x)

#define small_letter(c)  (c >= 'a' && c<= 'z')

#define NAME "anicka"

int main(){

	printf(ERROR);
	printf("\n");
	int i = 2;
	int j = 4;
	printf("%d %d %d %d\n", power_3(3), power_3(i), power_3(2 + 3), power_3(i * j + 2));
	printf("small letter: %d\n", small_letter('G'));
	printf("Ahoj moej jmeno je: %s\n", NAME);
	return 0;

}
