#include <stdio.h>

#define len 10

void vypis_pole(int pole[]);
void quick_sort(int pole[]);
void sort(int pole[], int p, int r);
int partition(int pole[], int p, int r);
void swap(int pole[], int i, int j);
int main(){
	
	int pole[] = { 5, 3, 9 ,2 ,1, 12, 8, 0, 6, 9};
	vypis_pole(pole);
	quick_sort(pole);
	vypis_pole(pole);
	return 0;
}

void quick_sort(int pole[]){
	sort(pole, 0, len - 1);	
}

void sort(int pole[], int p, int r){
	if( p < r){
		int q = partition(pole, p, r);
		sort(pole, p, q -1);
		sort(pole, q + 1, r);
	}
}

int partition(int pole[], int p, int r){
	int pivot = pole[r];
	int i = p - 1;
	for(int j = p; j < r; j++){	
		if(pole[j] <= pivot){
			i++;
			swap(pole, i, j); 
		}
	}
	swap(pole, i + 1, r);
	return i + 1;
}

void swap(int pole[], int i, int j){
	int tmp = pole[i];
	pole[i] = pole[j];
	pole[j] = tmp;
}

void vypis_pole(int pole[]){
	for(int i = 0; i < len; i++){
		printf("%d ", pole[i]);
	}
	printf("\n");
}
