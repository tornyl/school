#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define len1 10
#define len2 100
#define len3 1000
#define len4 10000
#define algos 3
#define lens 4
#define DEFAULT_HODNOTY {0, 0}

typedef struct{
	int porovnani;
	int presun; 
} Hodnoty;

typedef struct Insertion_counter{
	Hodnoty hodnoty;
} Insertion_counter;

typedef struct Quick_counter{
	Hodnoty hodnoty;
} Quick_counter;

typedef struct Heap_counter{
	Hodnoty hodnoty;
}Heap_counter;

typedef struct{
	Insertion_counter insertion;
	Quick_counter quick;
	Heap_counter heap;
} Record;

void vypis_pole(int pole[]);
void Insertion_sort(int pole[], Hodnoty *hodnoty);

void quick_sort(int pole[], Hodnoty *hodnoty);
void sort(int pole[], int p, int r, Hodnoty *hodnoty);
int partition(int pole[], int p, int r, Hodnoty *hodnoty);
void swap(int pole[], int i, int j);

void heap_sort(int pole[], Hodnoty *hodnoty);
void build_max_heap(int pole[], Hodnoty *hodnoty);
void max_heapify(int pole[], int i, int heap_size, Hodnoty *hodnoty);

int left(int i) {return 2 * i + 1;};
int right(int i) {return 2 * i + 2;};
int parent(int i) {return (i - 1) / 2;};

void fill_array(int pole[], int size);
void copy_array(int arr1[], int arr2[], int size);
void vypis_porovnani_presuny( Record records[]);
int len = 0;


int main(){
	
	//int pole[] = { 5, 3, 9 ,2 ,1, 12, 8, 0, 6, 9};
	Record records[lens];
	int pa1[len1], pa2[len2], pa3[len3], pa4[len4];
	int pb1[len1], pb2[len2], pb3[len3], pb4[len4];
	int *pole1[] = {pa1, pa2, pa3, pa4};
	int *pole2[] = {pb1, pb2, pb3, pb4};
	int size[] = {len1, len2, len3,len4};
	for(int i = 0; i < lens; i++){	
		Record record = { {DEFAULT_HODNOTY}, {DEFAULT_HODNOTY}, {DEFAULT_HODNOTY}};
		//int size = sizeof(pole1[0])/sizeof(pole1[0][0]);
		len  = size[i];
		fill_array(pole1[i], size[i]);
		//vypis_pole(pole);
		copy_array(pole1[i], pole2[i], size[i]);
		Insertion_sort(pole2[i], &record.insertion.hodnoty);	
		copy_array(pole1[i], pole2[i], size[i]);
		quick_sort(pole2[i], &record.quick.hodnoty);
		copy_array(pole1[i], pole2[i], size[i]);
		heap_sort(pole2[i], &record.heap.hodnoty);
		records[i] = record;
	}
	//vypis_pole(pole);
	vypis_porovnani_presuny(records);
	return 0;
}

void Insertion_sort(int pole[], Hodnoty *hodnoty){
	for(int i = 1; i < len; i++){	
		int t = pole[i];
		int j = i - 1;
		while(j >=0 && pole[j] > t){
			pole[j +1] = pole[j];
			hodnoty->porovnani ++;
			hodnoty->presun ++;
			j --;
		}
		hodnoty->porovnani ++;

		pole[j + 1] = t;
		hodnoty->presun ++;
	}
}

void quick_sort(int pole[], Hodnoty *hodnoty){
	sort(pole, 0, len - 1, hodnoty);	
}

void sort(int pole[], int p, int r, Hodnoty *hodnoty){
	if( p < r){
		int q = partition(pole, p, r, hodnoty);
		sort(pole, p, q -1, hodnoty);
		sort(pole, q + 1, r, hodnoty);
	}
}

int partition(int pole[], int p, int r, Hodnoty *hodnoty){
	int pivot = pole[r];
	hodnoty->presun ++;
	int i = p - 1;
	for(int j = p; j < r; j++){
		hodnoty->porovnani ++;
		if(pole[j] <= pivot){
			i++;
			hodnoty->presun +=2;
			swap(pole, i, j); 
		}
	}
	hodnoty->presun +=2;
	swap(pole, i + 1, r);
	return i + 1;
}

void heap_sort(int pole[], Hodnoty *hodnoty){
	build_max_heap(pole, hodnoty);
	for(int i = len - 1; i >= 1; i--){
		hodnoty->presun +=2;
		swap(pole, 0, i);
		max_heapify(pole, 0, i - 1, hodnoty);
	}
}

void build_max_heap(int pole[], Hodnoty *hodnoty){
	int heap_size = len - 1;
	for(int i = heap_size / 2 - 1; i >= 0; i--){
		max_heapify(pole, i, heap_size, hodnoty);
	}
}

void max_heapify(int pole[], int i, int heap_size, Hodnoty *hodnoty){
	int l = left(i);
	int r = right(i);
	int largest = i;
	hodnoty->porovnani +=2;
	if(l <= heap_size && pole[i] < pole[l]){
		largest = l;
	}else{
		largest = i;
	}
	
	if(r <= heap_size && pole[largest] < pole[r]){
		largest = r;
	}

	if(largest !=i){
		hodnoty->presun +=2;
		swap(pole, largest, i);
		max_heapify(pole, largest, heap_size, hodnoty);
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


void fill_array(int pole[], int size){
	time_t t;
	srand((unsigned) time(&t));
	for(int i = 0; i < size; i++){
		pole[i] = rand() % 100;
	}

}

void copy_array(int arr1[], int arr2[], int size){
	for(int i = 0; i < size; i++){
		arr2[i] = arr1[i];
	}
}

void vypis_porovnani_presuny( Record records[]){
	printf("pocet porovani\t10\t100\t1000\t10000\n");
	printf("Inserion-sort");
	for(int i = 0; i < lens; i++){
		printf("\t%d ", records[i].insertion.hodnoty.porovnani);	
	}
	printf("\nQuick-sort");
	for(int i = 0; i < lens; i++){
		printf("\t%d ", records[i].quick.hodnoty.porovnani);	
	}
	printf("\nHeap-sort");
	for(int i = 0; i < lens; i++){
		printf("\t%d ", records[i].heap.hodnoty.porovnani);	
	}
	printf("\n\n");
	
	printf("pocet presunu\t10\t100\t1000\t10000\n");
	printf("Inserion-sort");
	for(int i = 0; i < lens; i++){
		printf("\t%d ", records[i].insertion.hodnoty.presun);	
	}
	printf("\nQuick-sort");
	for(int i = 0; i < lens; i++){
		printf("\t%d ", records[i].quick.hodnoty.presun);	
	}
	printf("\nHeap-sort");
	for(int i = 0; i < lens; i++){
		printf("\t%d ", records[i].heap.hodnoty.presun);	
	}
	printf("\n");
}
