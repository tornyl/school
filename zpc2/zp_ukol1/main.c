#include <stdio.h>
#include <stdlib.h>

typedef struct Cell_{
	double value;
	int i;
	int j;
	struct Cell_* row_next;
	struct Cell_* column_next;
	
}Cell;

typedef struct Line_{
	int index;
	struct Line_* next;
	Cell* first_cell;
}Line;

typedef struct{
	int rows;
	int columns;
	Line* first_row;
	Line* first_column;
	
}Matrix;


Matrix *create_matrix(double values[], size_t rows, size_t cols){
	Matrix *m = (Matrix*)malloc(sizeof(Matrix));
	m->rows = rows;
	m->columns = cols;
	Line *curr_row = (Line*) malloc(sizeof(Line));
	Line *curr_column = (Line*) malloc(sizeof(Line));
	m->first_row = curr_row;
	m->first_column  = curr_column;
	for(int i = 1; i < rows; i++){
		curr_row->index = i - 1;
		curr_row->next = (Line*) malloc(sizeof(Line));
		curr_row = curr_row->next;
	}
	curr_row->index = rows - 1;

	for(int i = 1; i < cols; i++){
		curr_column->index = i - 1;
		curr_column->next = (Line*) malloc(sizeof(Line));
		curr_column = curr_column->next;
	}
	curr_column->index = cols - 1;
	Cell *previous_row[cols];
	for(int i = 0; i < cols; i++) previous_row[i] = NULL;
	curr_row = m->first_row;
	curr_column = m->first_column;
	Cell* prev_row_cell = NULL;
	for(int i = 0; i < rows; i++){	
		prev_row_cell = NULL;
		curr_column = m->first_column;
		for(int j = 0; j < cols; j++){
			if(values[i* cols + j]){
				Cell *new_cell = (Cell*) malloc(sizeof(Cell));
				new_cell->value = values[cols * i + j];
				new_cell->i = i;
				new_cell->j = j;
				if(prev_row_cell !=NULL){
					prev_row_cell->row_next = new_cell;
				}
				prev_row_cell = new_cell;
				if(previous_row[j]) {
					previous_row[j]->column_next = new_cell;
				}
				previous_row[j] = new_cell;
				//printf("pr: %d\n", prev_row_cell->value);
				if(!curr_row->first_cell) curr_row->first_cell = new_cell;
				if(!curr_column->first_cell) curr_column->first_cell = new_cell;
			}

			curr_column = curr_column->next;
		}
		curr_row = curr_row->next;
	}
	return m;
}

void print(Matrix *m){
	Line* row = m->first_row;

	while(row){
		Cell* cell = row->first_cell;
		printf("{");
		for(int i = 0; i < m->columns; i++){
			if(cell  && cell->j == i){
				printf(" %2.f ", cell->value);
				cell = cell->row_next;
			}else printf(" 0 ");
		}
		printf("}\n");
		row = row->next;
	}

	printf("}\n");
}

void delete(Matrix *m){
	Line* row = m->first_row;

	while(row){
		Cell* cell = row->first_cell;
		while(cell){
			Cell* tmp = cell;
			cell = cell->row_next;
			free(tmp);
		}
		Line* tmp = row;
		row = row->next;
		free(tmp);
	}
	free(m);
	printf("}\n");
}

double element_at(Matrix *m, unsigned int row, unsigned int col){
	if(row > m->rows - 1 || col > m->columns -1){
		printf("Spatny index\n");
		return 0;
	}

	Line *line_row = m->first_row;
	int i = 0;
	while(i != row){
		line_row = line_row->next;
		i++;
	}
	Cell *cell = line_row->first_cell;
	int j = 0;
	printf("bum\n");
	while(j != col){
		if(cell->j == j) cell = cell->row_next;
		j++;
	}
	if(cell && cell->j == j) return cell->value;
	else return 0;
}

double set_element_at(Matrix *m, unsigned int row, unsigned int col, double value){
	
	if(row > m->rows - 1 || col > m->columns -1){
		printf("Spatny index\n");
		return 0;
	}

	Line *line_row = m->first_row;
	int i = 0;
	while(i != row){
		line_row = line_row->next;
		i++;
	}
	int k = 0;
	Cell *cell = line_row->first_cell;
	Cell *prev_cell_row = NULL;
	int j = 0;
	Line* line_col = m->first_column;
	while(j != col){
		if(cell->j == j){
			prev_cell_row = cell;
			cell = cell->row_next;
		}
		line_col  = line_col->next;
		j++;
	}
	Cell *prev_cell_column = line_col->first_cell;
	while(prev_cell_column && prev_cell_column->column_next && prev_cell_column->j < j - 1) prev_cell_column = prev_cell_column->column_next;
	if(cell && cell->j == j) cell->value = value;
	else{
		Cell* new_cell = (Cell*) malloc(sizeof(Cell));
		new_cell->value = value;
		new_cell->i = i;
		new_cell->j = j;
		if(prev_cell_row){
			if(prev_cell_row->row_next) new_cell->row_next = prev_cell_row->row_next;
			prev_cell_row->row_next = new_cell;
		}else {
			new_cell->row_next = line_row->first_cell;
			line_row->first_cell = new_cell;
		}

		if(prev_cell_column){
			if(prev_cell_column->column_next) new_cell->column_next = prev_cell_column->column_next;
			prev_cell_column->column_next = new_cell;
		}else{
			new_cell->column_next = line_col->first_cell;
			line_col->first_cell = new_cell;
		}
	}
	return value;
}

double simple_add(double a, double b){
	return a + b;
}

double simple_subtract(double a, double b){
	return a - b;
}

Matrix *apply_fun(Matrix *left, Matrix *right, double (*fun)(double, double)){
	double result_array[left->rows*left->columns];
	for(int i = 0; i < left->rows*left->columns; i++) result_array[i] = 0;

	Line *left_row = left->first_row;
	Line *right_row = right->first_row;
	for(int i = 0 ;i < left->rows; i++){
		Cell *left_cell = left_row->first_cell;
		Cell *right_cell = right_row->first_cell;
		for(int j  = 0; j < left->columns; j++){
			printf("ggsn\n");
			double arg1 = 0;
			double arg2 = 0;
			if(left_cell && left_cell->j == j){
				arg1 = left_cell->value;
				left_cell = left_cell->row_next;
			}
			if(right_cell && right_cell->j == j){
				arg2 =right_cell->value;
				right_cell = right_cell->row_next;
			}
			result_array[i * left->columns + j] = fun(arg1, arg2);
		}
		left_row = left_row->next;
		right_row = right_row->next;
	}

	Matrix *result_m = create_matrix(result_array, left->rows, left->columns);
	return result_m;
}

Matrix*  add(Matrix* m1, Matrix* m2){
	return apply_fun(m1, m2, simple_add);
}


Matrix*  subtract(Matrix* m1, Matrix* m2){
	return apply_fun(m1, m2, simple_subtract);
}
//Matrix *add(Matrix *left, Matrix *right){
//	Matrix *result_m = (Matrix*) malloc(sizeof(Matrix));
//	Line *row = (Line*) malloc(sizeof(Line));
//	Line *column = (Line*) malloc(sizeof(Line));
//	result_m->rows = left->rows;
//	result_m->columns = left->columns;
//	for(int i = 0; i < left->rows - 1; i++){
//		row->index = i;
//		row->next = (Line*) malloc(sizeof(Line));
//		row = row->next;
//	}
//	row->index = left->rows - 1; 
//	for(int i = 0; i < left->columns - 1; i++){
//		column->index = i;
//		column->next = (Line*) malloc(sizeof(Line));
//		column = column->next;
//	}
//	column->index = left->columns - 1; 
//	
//	Cell *previous_row[left->columns];
//	for(int i = 0; i < cols; i++) previous_row[i] = NULL;
//	curr_row = result_m->first_row;
//	curr_column = result_m->first_column;
//	Cell* prev_row_cell = NULL;
//	for(int i = 0; i < left->rows; i++){	
//		prev_row_cell = NULL;
//		curr_column = m->first_column;
//		for(int j = 0; j < left->columns; j++){
//			double result_val = 0;
//			if(leeft
//			if(){
//				Cell *new_cell = (Cell*) malloc(sizeof(Cell));
//				new_cell->value = values[cols * i + j];
//				new_cell->i = i;
//				new_cell->j = j;
//				if(prev_row_cell !=NULL){
//					prev_row_cell->row_next = new_cell;
//				}
//				prev_row_cell = new_cell;
//				if(previous_row[j]) {
//					previous_row[j]->column_next = new_cell;
//				}
//				previous_row[j] = new_cell;
//				//printf("pr: %d\n", prev_row_cell->value);
//				if(!curr_row->first_cell) curr_row->first_cell = new_cell;
//				if(!curr_column->first_cell) curr_column->first_cell = new_cell;
//			}
//
//			curr_column = curr_column->next;
//		}
//		curr_row = curr_row->next;
//	}
//	return result_m;
//}

double matrix_max(Matrix* m){
	double max;
	int first = 1, full = 1;
	Line* row = m->first_row;
	while(row){
		Cell *cell = row->first_cell;
		int j = 1;
		while(cell){
			if(first) {max = cell->value; first = 0;}
			else if(cell->value > max) max = cell->value;
			cell = cell->row_next;
			j++;
		}
		if(j != m->columns) full = 0;
		row = row->next;
	}
	if(!full && max < 0) return 0;
	else return max;
}

int main(){
	//double vals[] = {0, 1, 0, 0, 11, 3, 0 ,60 ,4};
	//double vals2[] = {0, 2, 6, 3, 6, 4, 0 ,3 ,4};
	double vals[] = {0, 1, 0, 0, 11, 3, 0 ,60 ,4,0, 1,5};
	double vals2[] = {0, 2, 6, 3, 6, 4, 0 ,3 ,4, 5, 2 ,1};
	Matrix *m = create_matrix(vals ,4, 3);
	Matrix *m2 = create_matrix(vals2 ,4, 3);
	print(m);
	//delete(m);
	printf("%p\n", m);
	printf("at index: %2.f\n", element_at(m, 2, 2));
	//set_element_at(m, 0, 2, 5);
	print(m);
	printf("max val: %2.f\n", matrix_max(m));
	Matrix *result = add(m, m2);
	Matrix *result2 = subtract(m, m2);
	print(result);
	print(result2);
	return 0;
}

