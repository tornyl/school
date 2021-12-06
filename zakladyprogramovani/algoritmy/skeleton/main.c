#include <stdio.h>

#define len 10

void vypis_pole(int pole[]);
void sort(int pole[]);

int main(){
	
	int pole[] = { 5, 3, 9 ,2 ,1, 12, 8, 0, 6, 9};
	vypis_pole(pole);
	sort(pole);
	vypis_pole(pole);
	return 0;
}

void sort(int pole[]){
	
}

void vypis_pole(int pole[]){
	for(int i = 0; i < len; i++){
		printf("%d ", pole[i]);
	}
	printf("\n");
}
