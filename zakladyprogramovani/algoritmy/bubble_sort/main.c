#include <stdio.h>

#define len 10

void vypis_pole(int pole[]);
void bubble_sort(int pole[]);

int main(){
	
	int pole[] = { 5, 3, 9 ,2 ,1, 12, 8, 0, 6, 9};
	vypis_pole(pole);
	bubble_sort(pole);
	vypis_pole(pole);
	return 0;
}

void bubble_sort(int pole[]){
	for(int i = 0; i < len - 1; i++){
		for(int j = len - 1; j >= i + 1; j--){
			if(pole[j] < pole[j - 1]){
				int t = pole[j - 1];
				pole[j - 1] = pole[j];
				pole[j] = t;
			}
		}
	}
}

void vypis_pole(int pole[]){
	for(int i = 0; i < len; i++){
		printf("%d", pole[i]);
	}
	printf("\n");
}
