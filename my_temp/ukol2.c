#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define SIZEOF(arr) sizeof(arr) / sizeof(arr[0])

struct Porovnani{
	int seq;
	int bin;
	int inter;
};

struct Porovnani POROVNANI = {0,0,0};

int sequence_search(int array[], int element, int length){
	for(int i = 0; i < length; i++){
		POROVNANI.seq ++;
		if(array[i] == element) return i;
	}
	return -1;
}

void bubble_sort(int pole[], int len){
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

int binary_search(int array[], int element, int length){
	int l = 0;
	int p = length - 1;

	while (l <=p){
		int s = floor( (l + p) / 2);
		POROVNANI.bin ++;
		if(array[s] == element) return s;
		POROVNANI.bin ++;
		if(array[s] < element) l = s + 1;
		else p = s - 1;
	}
	return -1;
}

int interpolation_search(int array[], int element, int length){
	int l = 0;
	int p = length -1;
	while(l <= p){
		int r = (element  - array[l]) / (array[p] - array[l]);
		int s = l + ( p - l) * r;
		POROVNANI.inter ++;
		if(array[s] == element) return s;
		POROVNANI.inter ++;
		if(array[s] < element) l  = s + 1;
		else p = s - 1;
	}

	return -1;
}

void vypis_pole(int pole[], int len){
	for(int i = 0; i < len; i++){
		printf("%d ", pole[i]);
	}
	printf("\n");
}


int main(){
	int array[] = {0,2,7,23,9,2,5,10,1};
	int hledana_hodnota = 9;
	printf("%lu\n", SIZEOF(array));
	printf("HLEDANE CISLO: %d\n", hledana_hodnota);	
	printf("index: %d\n", sequence_search(array, hledana_hodnota, SIZEOF(array)));
	bubble_sort(array,SIZEOF(array));
	vypis_pole(array, SIZEOF(array));
		
	printf("binarni vyhledavani.  index: %d\n", binary_search(array, hledana_hodnota, SIZEOF(array)));
	printf("interpoalarni vyhledavani.  index: %d\n", interpolation_search(array, hledana_hodnota, SIZEOF(array)));

	printf("Pocet porovnani pro hodnotu %d\n sekvencni: %d\t  binarni: %d\t interpolacni: %d\t\n", hledana_hodnota, POROVNANI.seq, POROVNANI.bin, POROVNANI.inter);	
	return 0;
}
