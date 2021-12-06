#include <stdio.h>

int main(){

	int cislo;
	printf("zadej cislo ");
	scanf("%d", &cislo);
	
	if( !(cislo % 2) && !(cislo % 3)){
		printf("cislo %d je delitelne 2 a 3\n", cislo);
	}else if ( !(cislo % 2) ){
		printf("cislo %d je delitelne 2\n", cislo);
		
	}else if ( !(cislo % 3) ){
		printf("cislo %d je delitelne 3\n", cislo);
		
	}else{
		printf("cislo %d neni delitelne 2 ani 3\n", cislo);
	}

	int delitelne_obema = ( !(cislo %2) && !(cislo % 3)) ? 1 : 0;

	( delitelne_obema) ? printf("Cislo je delitelne obema") : ( !(cislo % 2) ? printf("cislo je del 2") : ( (!cislo % 3) ? printf("cislo je del 3") : printf("cislo neni 2 ani 3") ) ) ;


}
