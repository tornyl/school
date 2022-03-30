#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int** alloc_2d_array(size_t rows, size_t cols) {
	 int **array = (int **) malloc(rows * sizeof(int *));
	  
	 for (int row = 0; row < rows; row += 1) {
		array[row] = (int *) calloc(cols, sizeof(int));
		if(!array[row]){
			for(int i = 0; i < row; i++){
				free(array[i]);
			}
			free(array);
			return NULL;
		}
	 }
	  
	 return array;
}

int **create_mult_2d(size_t rows, size_t cols){
	int **array = (int **) malloc(rows * sizeof(int *));
	for (int row = 0; row < rows; row ++){
		
		array[row] = (int *) calloc(cols, sizeof(int));
		if(!array[row]){
			for(int i = 0; i < row; i++){
				free(array[i]);
			}
			free(array);
			return NULL;
		}
		for(int col = 0; col < cols; col++){
			array[row][col] = row * col;
		}
	}
	return array;
}
int *create_mult_2d_1d(size_t rows, size_t cols){
	int *array = (int *) malloc(rows * cols * sizeof(int));
	for (int i = 0; i< rows * cols; i++){	
		array[i] =(int)floor(i / cols) * ( i % cols);	
	}
	return array;
}

void print_2d(int **array, int rows, int cols){
	for(int row = 0; row < rows; row++){
		for(int col = 0; col < cols; col++){
			printf("%d, ", array[row][col]);
		}
		printf("\n");
	}
}

void print_2d_1d(int *array, int rows, int cols){
	for(int row = 0; row < rows * cols; row++){
		printf("%d, ", array[row]);
		if((row + 1) % cols == 0) printf("\n");
	}
	printf("\n");
}


int dealloc2d(int **arr2d, int rows, int cols){
	for(int i = 0; i < rows; i++){
		free(arr2d[i]);	
	}
	free(arr2d);
	return 1;
}

int main(){
	int rows, cols = 2;
    int** matrix = (int**) malloc(sizeof(int*) * rows);
    matrix[0] = (int*) malloc(sizeof(int) * cols);
    matrix[1] = (int*) malloc(sizeof(int) * cols);
	printf("%d\n", dealloc2d(matrix, rows, cols));
	int **arr = create_mult_2d(5, 10);
	print_2d(arr, 5, 10);
	printf("\n");
	int *arr2 = create_mult_2d_1d(5, 10);
	print_2d_1d(arr2, 5, 10);
	return 0;
}
