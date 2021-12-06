#include <stdio.h>

int main(){

	printf("zadej znak");
	char znak;
	scanf("%c", &znak);
	if ( znak >= 'A' && znak <= 'Z') printf(" Zadany znak je velke pismeno %c\n", znak);
	else if ( znak >= 'a' && znak <= 'z') printf(" Zadany znak je male pismeno %c\n", znak);
	else {
	switch(znak){
		case '!':
			printf("Zadany znak je vykricnik");
			break;
		case '?':
			printf("Zadany znak je otaznik");
			break;
		case '*':
			printf("Zadany znak je hvezdicka");
			break;
		case '@':
			printf("Zadany znak je  zavinac");
			break;
		case '#':
			printf("Zadany znak je hesteg");
			break;
		case '^':
			printf("Zadany znak je strizka");
			break;
		default:
			printf("Jiny znak");

	}

	}
	printf("\n");



	return 0;
}
