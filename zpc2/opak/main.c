#include <stdio.h>

void ukol1(char retezec[]);
void ukol2(int rok);
int ukol4(int n);
void ukol5(int m, int n);

int main(){
	char a [] = "ahoj sfgsgsgs sgsgsg";	
	ukol1(a);
	ukol2(1612);
	printf("\n");
	ukol4(10);
	printf("\n");
	ukol5(10, 4);
	printf("\n");

	return 0;
}

void ukol5(int m, int n){
	for(int i = 0; i < n - 1; i++){
		printf(" ");
	}
	printf("(\o/)");
	for(int i = 0; i < m; i++){
		printf("\n");
		for(int j = 0; j < n; j++) printf(".");
		printf("X");
		for(int j = 0; j < n; j++) printf(".");

	}
	printf("\n");
	for(int i =0; i < 2*n + 1; i++){
		printf("X");
	}
}

int ukol4(int n){
	int a_n  = 14688;

	for(int i  = 0; i < n - 1; i++){
		a_n = 0.5 * a_n + 1200;	
	}
	printf("%d", a_n);
 	return a_n;
}

void ukol1(char retezec[]){
	int index = 0;
	int pole[256];
	for(int i  = 0; i < 256; i++){
		pole[i] = 0;
	}
	while(retezec[index]){
		//printf("%d", pole[index]);
		//printf("%c", retezec[index]);
		pole[retezec[index]] +=1;
		index++;
	}
	for(int i = 0; i < 256;i++){
		if(pole[i] >= 1){
			printf("%c %d\n", i, pole[i]);
		}
	}
}


void ukol2(int rok){
	int ok = 0;
	if( rok % 4 == 0){
		if(rok % 100 == 0){
			if( rok % 400 == 0) ok = 1;
			else ok = 0;
		}else{
			ok = 1;
		}
	}else{
	ok = 0;
	}

	if(ok) printf("Rok %d je prestupny", rok);
	else printf("Rok %d neni prestupny", rok);
}
