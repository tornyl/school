#include <stdio.h>

#define len 10

void vypis_pole(int pole[]);
void Insertion_sort(int pole[]);

int main(){
	
	int pole[] = { 5, 3, 9 ,2 ,1, 12, 8, 0, 6, 9};
	vypis_pole(pole);
	Insertion_sort(pole);
	vypis_pole(pole);
	return 0;
}

void vypis_pole(int pole[]){
	for(int i = 0; i < len; i++){
		printf("%d", pole[i]);
	}
	printf("\n");
}

void Insertion_sort(int pole[]){
	for(int i = 1; i < len; i++){	
		int t = pole[i];
		int j = i - 1;

		while(j >=0 && pole[j] > t){
			pole[j +1] = pole[j];
			j --;
		}

		pole[j + 1] = t;
	}
}
