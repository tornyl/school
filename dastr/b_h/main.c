#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>

#define SIZEOF(arr) sizeof(arr) / sizeof(arr[0])

typedef struct{
	int size;
	int *arr;
}Binary_heap;


void print_heap(Binary_heap *heap){
	int i = 0;
	while( i < heap->size){
		printf(" %i |", heap->arr[i]);
		i++;
	}
	printf("\n");
}

void swap(int *x, int *y){
	int temp = *x;
	*x = *y;
	*y = temp;
}

int left(int i){ return  2 * i + 1;}
int right(int i){ return  2 * i + 2;}
int parent(int i){ return  ceil(i/2.0) -1;}

void increase_heap_size(Binary_heap *heap, int by){
	int *temp = realloc(heap->arr, ( heap->size + by) * sizeof(int));
	heap->arr = temp;
	heap->size +=by;
}

void min_heapify(Binary_heap *heap, int i){
	int l = left(i);
	int r = right(i);
	int smallest = i;

	if (l <= heap->size && heap->arr[l] < heap->arr[i]) { smallest = l;}
	if (r <= heap->size && heap->arr[r] < heap->arr[i]) { smallest = r;}

	if( smallest != i){
		swap(&heap->arr[i], &heap->arr[smallest]);
		min_heapify(heap, smallest);
	}
}

int heap_minimum(Binary_heap *heap){ return heap->arr[0];}

int heap_extract_min(Binary_heap *heap){
	if(heap->size < 1) return -1;

	int min = heap_minimum(heap);
	heap->arr[0] =heap->arr[heap->size - 1];
	//increase_heap_size(heap, 1);
	heap->size -=1;
	min_heapify(heap, 0);
	return min;
}

void heap_increase_key(Binary_heap *heap, int i, int key){
	assert(key > heap->arr[i]);

	heap->arr[i] = key;
	//print_heap(heap);

	while(i > 0 && heap->arr[parent(i)] > heap->arr[i]){
		swap(heap->arr + i, heap->arr + parent(i));
		i = parent(i);
	}
	//print_heap(heap);
}

void heap_insert(Binary_heap *heap, int key){
	increase_heap_size(heap, 1);
	heap->arr[heap->size - 1] = -1;
	heap_increase_key(heap, heap->size - 1, key);
}


#define init_ize 10
int main(){
	
	Binary_heap *heap = (Binary_heap*) malloc(sizeof(Binary_heap));
	heap->arr = NULL;
	heap->size = 0;
	//heap->arr = (int *) malloc(init_size * sizeof(int));
	heap_insert(heap, 4);
	print_heap(heap);
	heap_insert(heap, 23);
	print_heap(heap);
	heap_insert(heap, 1);
	print_heap(heap);
	heap_insert(heap, 6);
	heap_insert(heap, 11);
	print_heap(heap);

	heap_extract_min(heap);
	print_heap(heap);
	heap_extract_min(heap);
	print_heap(heap);
	heap_insert(heap, 1);
	print_heap(heap);
	
	return 0;
}
