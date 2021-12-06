#include <stdio.h>

#define len 10

void vypis_pole(int pole[]);
void merge_sort(int pole[]);
void sort(int pole[], int p, int r);
void merge(int pole[], int p, int q,int r);

int main(){
	
	int pole[] = { 5, 3, 9 ,2 ,1, 12, 8, 0, 6, 9};
	vypis_pole(pole);
	merge_sort(pole);
	vypis_pole(pole);
	return 0;
}

void merge_sort(int pole[]){
	sort(pole, 0, len - 1);

}

void sort(int pole[], int p, int r){
	if(p < r){
		int q = (p + r) / 2;
		sort(pole, p, q);
		sort(pole, q + 1, r);
		merge(pole, p , q, r);
	}
}

void merge(int pole[], int p, int q, int r){
	int s1 = q - p + 1;
	int s2 = r - q;
	int L[s1 + 1];
	int R[s2 + 1];

	for(int i = 0; i < s1; i++){
		L[i] = pole[p + i];
	}
	for(int i = 0; i < s2; i++){
		R[i] = pole[q + 1 + i];
	}	
	
	L[s1] = 1000000000;	
	R[s2] = 1000000000;
	int i = 0;
	int j = 0;
	for(int k = p; k < r + 1; k++){
		if(L[i] <= R[j]){
			pole[k] = L[i];
			i++;
		}else{
			pole[k] = R[j];
			j++;
		}
	}
}

void vypis_pole(int pole[]){
	for(int i = 0; i < len; i++){
		printf("%d ", pole[i]);
	}
	printf("\n");
}
