#include <stdio.h>

#define len 10

void vypis_pole(int pole[]);
void heap_sort(int pole[]);
void build_max_heap(int pole[]);
void max_heapify(int pole[], int i, int heap_size);

int left(int i) {return 2 * i + 1;};
int right(int i) {return 2 * i + 2;};
int parent(int i) {return (i - 1) / 2;};
void swap(int pole[], int a,int b);
int main(){
	
	int pole[] = { 5, 3, 9 ,2 ,1, 12, 8, 0, 6, 9};
	vypis_pole(pole);
	heap_sort(pole);
	vypis_pole(pole);
	return 0;
}

void heap_sort(int pole[]){
	build_max_heap(pole);
	for(int i = len - 1; i >= 1; i--){
		swap(pole, 0, i);
		max_heapify(pole, 0, i - 1);
	}
}

void build_max_heap(int pole[]){
	int heap_size = len - 1;
	for(int i = heap_size / 2 - 1; i >= 0; i--){
		max_heapify(pole, i, heap_size);
	}
}

void max_heapify(int pole[], int i, int heap_size){
	int l = left(i);
	int r = right(i);
	int largest = i;
	if(l <= heap_size && pole[i] < pole[l]){
		largest = l;
	}else{
		largest = i;
	}

	if(r <= heap_size && pole[largest] < pole[r]){
		largest = r;
	}

	if(largest !=i){
		swap(pole, largest, i);
		max_heapify(pole, largest, heap_size);
	}
}

void swap(int pole[], int a, int b){
	int tmp = pole[a];
	pole[a] = pole[b];
	pole[b] = tmp;
}

void vypis_pole(int pole[]){
	for(int i = 0; i < len; i++){
		printf("%d ", pole[i]);
	}
	printf("\n");
}
