#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#define PATH "soubor.txt"

void ukol_1(){
	FILE* file = fopen("neexistujici soubor", "r");
	if(errno) printf("Pri otevirani soubor doslo k chybe. Kod chyby %i\n", errno);
	else {
		fclose(file);
	}
}

int ukol_2(){
	int count = 0;
	FILE* file = fopen("./soubor.txt", "r");
	//if(errno) printf("Pri otevirani soubor doslo k chybe. Kod chyby %i %p\n", errno, file);
	if(!file) printf("chybicka\n");
	else {
		while(1){
			char c = fgetc(file);
			if(c == EOF){
				if(feof(file)) break;
				else if(errno) {printf("Pri cteni ze soubor doslo k chybe. Kod chyby %i\n", errno); break;}
			}else count++;
		}
	}
	return count;
}

int main(){
	ukol_1();
	printf("pocet znaku %i\n", ukol_2());
	return 0;
}
