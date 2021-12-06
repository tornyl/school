#include <stdio.h>

#define len 10

void vypis_pole(int pole[]);
void selection_sort(int pole[]);

int main(){
	
	int pole[] = { 5, 3, 9 ,2 ,1, 12, 8, 0, 6, 9};
	vypis_pole(pole);
	selection_sort(pole);
	vypis_pole(pole);
	return 0;
}

void selection_sort(int pole[]){
	for(int i = 0; i < len - 1; i++){
		int iMin = i;
		for(int j = i + 1; j < len; j++){
			if(pole[j] < pole[iMin]){
				iMin = j;
			}
		}
		int t =	pole[i];
		pole[i] = pole[iMin];
		pole[iMin] = t;
	}
}

void vypis_pole(int pole[]){
	for(int i = 0; i < len; i++){
		printf("%d", pole[i]);
	}
	printf("\n");
}
