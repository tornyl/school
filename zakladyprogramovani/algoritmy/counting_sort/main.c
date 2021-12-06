#include <stdio.h>

#define len 10

void vypis_pole(int pole[]);
void counting_sort(int pole[]);
int getMax(int pole[]);
void copyArray(int arr1[], int arr2[]);
int main(){
	
	int pole[] = { 5, 3, 9 ,2 ,1, 12, 8, 0, 6, 9};
	vypis_pole(pole);
	counting_sort(pole);
	vypis_pole(pole);
	return 0;
}

void counting_sort(int pole[]){
	int max = getMax(pole);
	int c_len = max + 1;
	int C[c_len];
	for(int i = 0; i < c_len; i++){
		C[i] = 0;
	}

	for(int i = 0; i < len; i++){
		C[pole[i]] += 1;
	}

	for(int i = 1; i < c_len; i++){
		C[i] += C[i - 1]; 
	}
	int B[len];
	for(int i = 0; i < len; i++){
		B[ C[pole[i]] - 1] = pole[i];
		C[pole[i]] --;
	}

	copyArray(B, pole);

	//vypis_pole(B);
	//pole = B;
}

int getMax(int pole[]){
	int max = 0;
	for(int i = 0; i < len; i++){
		if(pole[i] > pole[max]) max = i;
	}
	return pole[max];
}

void copyArray(int arr1[], int arr2[]){
	for(int i = 0; i < len; i++){
		arr2[i] = arr1[i];
	}
}

void vypis_pole(int pole[]){
	for(int i = 0; i < len; i++){
		printf("%d ", pole[i]);
	}
	printf("\n");
}
