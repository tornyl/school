#include <stdio.h>
#include <stdlib.h>

void *my_memset(void *s, int c,  unsigned int len)
{
    unsigned char* p=s;
    while(len--)
    {
        *p++ = (unsigned char)c;
    }
    return s;
}

void *is_allocated(void *pt){
	if(pt){
		return pt;
	}else{
		printf("Pri alokaci anstala chyba");
		return NULL;
	}
}


typedef struct {
	int size;
	int data_len;
	char data[];
}Bitset;

void set_all(Bitset* bitset, char value){
	my_memset(bitset->data, value, bitset->data_len * sizeof(char));
}

int create_num(int ones){
	int num  = 0;
	for(int i  = 0; i < ones; i++){
		num |= 1 << i;
	}
	return num;
}

Bitset* create_bitset(size_t size){
	int data_len = (int) (size + (sizeof(char) * 8) - 1) / (sizeof(char) * 8);
	Bitset* bitset =   (Bitset*) is_allocated(malloc(sizeof(Bitset) + sizeof(char) * data_len));
	bitset->size = size;
	bitset->data_len = data_len;
	set_all(bitset, 0);
	return bitset;
}

Bitset* create_bitset_with_values(size_t size, const int *values, size_t array_size){
	Bitset* bitset = create_bitset(size);
	for(int i = 0; i < array_size; i++){
		bitset->data[ values[i] / (sizeof(char) * 8)] |=  ( 1 << (values[i] % (sizeof(char) * 8)));
	}
	return bitset;
}

Bitset* create_bitset_with_range(size_t size, int upto){
	Bitset* bitset = create_bitset(size);
	my_memset(bitset->data, ~0, upto / 8);
	bitset->data[upto / 8] = create_num(upto + 1 % 8);
	return bitset;
}

void print(Bitset *bitset){
	for(int i = 0; i < bitset->size; i++){
		if(i < 10){
			printf("| %i ", i);
		}else{
			printf("| %i", i);
		}
	}
	printf("\n");
	for(int i = 0; i < bitset->data_len; i++){
		for(int j  = 0; j < 8; j++){
			if(i * 8 *sizeof(char) + j + 1 <= bitset->size){
				printf("| %i ", (bitset->data[i] & ( 1 << j)) >> j);
			}
		}
	}
	printf("\n\n");
}

int getPos(int element){
	return (element) / (sizeof(char) * 8);
}

void set_insert(Bitset* bitset, int element){
	bitset->data[getPos(element)] |= 1 << (element % (sizeof(char) *8 ));
}

void set_remove(Bitset* bitset, int element){
	bitset->data[getPos(element)] &= ~(1 << (element % (sizeof(char) *8 )));
}

int contains(Bitset* bitset, int element){
	return bitset->data[getPos(element)] >= (1 << (element % (sizeof(char) *8 ))) ;  
}

char and(char a, char b) {
	return a & b;
}
char or(char a, char b) {
	return a | b;
}
char neg(char a) {
	return ~a;
}
char id(char a) {
	return a;
}

void form_operation(Bitset *left, Bitset *right, char (*bin_op)(char, char), char (*un_op)(char)){
	for(int i = 0; i < left->data_len; i++){
		if(i + 1 <= right->data_len){
			left->data[i] = bin_op(left->data[i], un_op(right->data[i]));
		}else if(bin_op == and && un_op != neg){
			left->data[i] = 0;
		}
	}
}

void form_intersection(Bitset *left, Bitset* right){
	form_operation(left, right, and, id);
}
void form_union(Bitset *left, Bitset* right) {
	form_operation(left, right, or, id);
}
void form_difference(Bitset *left, Bitset* right) {
	form_operation(left, right, and, neg);
}

Bitset* greater(Bitset* a, Bitset* b) {
	return a->data_len > b->data_len ? a : b;
}
Bitset* lesser(Bitset* a, Bitset* b) {
	return a->data_len > b->data_len ? b : a;
}
Bitset *set_operation(Bitset *left, Bitset *right, char (*bin_op)(char, char), char (*un_op)(char), Bitset* (*size_op) (Bitset*, Bitset* )){
	Bitset* chosen = size_op(left, right);
	unsigned char *array =  (unsigned char*) is_allocated(malloc(sizeof(char) * chosen->data_len));
	for(int i = 0; i < chosen->data_len; i++){
		if(left->data_len >= i + 1 && right->data_len >= i + 1){
			array[i] = bin_op((unsigned char)left->data[i],  (unsigned char) un_op(right->data[i]));
		}else{
			array[i] = greater(left,right)->data[i];
		}
	}	
	int size = 0;
	for(int i = 0; i < chosen->size;i++){
		if( ((1 << (i % 8))  & array[i / 8]) != 0) size++;
	}
	int *int_arr =  (int*) is_allocated(malloc(sizeof(int) * size));
	int j = 0;
	for(int i = 0; i < chosen->size;i++){
		if( ((1 << (i % 8))  & array[i / 8]) != 0){
			int_arr[j] = i;
			j++;
		}
	}
	return create_bitset_with_values(chosen->size, int_arr, size);
}

Bitset *set_intersection(Bitset *left, Bitset *right){
	set_operation(left,right, and, id, lesser);
}
Bitset *set_union(Bitset *left, Bitset *right) {
	set_operation(left,right, or, id, greater);
}
Bitset *set_difference(Bitset *left, Bitset *right) {
	set_operation(left,right, and, neg, greater);
}

int is_subset(Bitset* left, Bitset* right){
	if(left->size > right->size){
		return 0;
	}

	Bitset *inter = set_intersection(left, right);
	for(int i  = 0; i < left->data_len; i++){
		if(left->data[i] != inter->data[i]){
			return 0;
		}
	}
	
	return 1;
}

int save_bitsets_to_file(FILE *stream, Bitset **bitsets, size_t bitsets_count){
	if(!stream){
		return 1;	
	}
	for(int i  = 0; i < bitsets_count; i++){	
		for(int j = 0; j < bitsets[i]->size;j++){
			if( ((1 << (j % 8))  & bitsets[i]->data[j / 8]) != 0){
				if(fprintf(stream, "%i ", j) <  0){
					return 2;
				}
			}
		}
		if(fprintf(stream, "\n") < 0){
			return 2;
		}
		
	}

	if(fclose(stream) == EOF){
		return 3;
	}
	
	return 0;
}
int max(int *array, int length){
	if(!array){
		return 0;
	}else{
		int max = array[0];
		int i = 0;
		while(i < length){
			if(array[i] > max){
				max = array[i];
			}
			i++;
		}
		return max;
	}
}

Bitset** load_bitsets(FILE *stream){
	Bitset** bitsets = NULL;
	char c;
	int *array = NULL;
	int size = 0;
	int max_size= 0;
	int sum = 0;
	int bitsets_len = 0;
	while( (c = fgetc(stream)) != EOF){
		if(c == '\n'){
			if(max_size){
				bitsets_len +=1;
				bitsets = (Bitset**) realloc(bitsets, sizeof(Bitset*) * bitsets_len);
				bitsets[bitsets_len - 1] = create_bitset_with_values(max(array, size) + 1, array, size);
				my_memset(array, 0, max_size);
			}
			size = 0;
			sum = 0;
		}else if(c == ' '){
			if(size == max_size){
				int* temp = (int*) (realloc(array, sizeof(int) * (size + 1)));
				if(temp) array = temp;
				max_size++;
				size++;
			}else{
				size++;
			}
			array[size - 1] = sum;
			sum = 0;	
		}else{
			int r = c - '0';
			sum  = sum * 10 + r;	
		}
	}	
	bitsets = (Bitset**) realloc(bitsets, sizeof(Bitset*) * (bitsets_len + 1));
	bitsets[bitsets_len] = NULL;
	return bitsets;
}

int is_bigger(Bitset* bitset){
	if(bitset->size > 10){
		return 1;
	}else{
		return 0;
	}
}

Bitset** load_bitsets_if(int (*condition)(Bitset*), FILE* stream){
	Bitset** bitsets = load_bitsets(stream);
	if(!bitsets){
		return NULL;
	}
	Bitset** filtered = NULL;
	int i  = 0;
	int j =  0;
	while(bitsets[i]){
		if(condition(bitsets[i])){
			filtered = (Bitset**) realloc(filtered, sizeof(Bitset*) * (j + 1));
			filtered[j] = bitsets[i];
			j++;
		}else{
			free(bitsets[i]);
		}
		i++;
	}
	filtered = (Bitset**) realloc(filtered, sizeof(Bitset*) * (j + 1));
	filtered[j] = NULL;
	return filtered;
}

int main(){
	printf("%li\n", sizeof(char));
	Bitset* bitset = create_bitset_with_range(20, 19);
	printf("%i %i\n", bitset->data_len, bitset->size);
	print(bitset);
	printf("\n");
	int vals[] = { 5, 3 ,1 ,6, 9, 3, 5, 2, 5, 8, 585, 6, 9};
	Bitset* b2 = create_bitset_with_values(800, vals, 12);
	print(b2);
	printf("\n");
	set_insert(b2, 4);
	set_remove(b2, 8);
	print(b2);
	printf("%i\n", contains(b2, 670)); 
	printf("%i\n", contains(b2, 585)); 
	form_intersection(bitset, b2);
	printf("\n");
	print(bitset);


	int vals3[] = { 5, 3 ,1 ,6, 9, 3, 19, 2, 5, 8, 6};
	Bitset* b3 = create_bitset_with_values(20, vals3, 11);
	int vals4[] = { 1, 1, 1, 6, 6, 1, 5, 6};
	Bitset* b4 = create_bitset_with_values(9, vals4, 8);
	print(b3);
	print(b4);

	//form_intersection(b4, b3);
	//form_union(b4,b3);
	//form_difference(b4, b3);
	//print(b4);
	
	Bitset *result;
	//result = set_intersection(b3, b4);
	//result = set_union(b3, b4);
	result = set_difference(b3, b4);
	print(result);
	printf("%i \n", is_subset(b4, b3));
	Bitset *bitsets[] = {bitset, b3, b4};
	//FILE* stream = fopen("bitsets.txt", "a");
	//printf("%i\n", save_bitsets_to_file(stream, bitsets, 3));
	FILE* stream = fopen("bitsets.txt", "r");
	Bitset** bitsets2 = load_bitsets_if(is_bigger, stream);
	int i = 0;
	while(bitsets2[i]){
		print(bitsets2[i]);
		i++;
	}
	return 0;
}
