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


typedef struct {
	int size;
	int data_len;
	unsigned char data[];
}Bitset;

void set_all(Bitset* bitset, char value){ my_memset(bitset->data, value, bitset->data_len * sizeof(char));}

int create_num(int ones){
	int num  = 0;
	for(int i  = 0; i < ones; i++) num |= 1 << i;
	return num;
}

Bitset* create_bitset(size_t size){
	int data_len = (int) (size + (sizeof(char) * 8) - 1) / (sizeof(char) * 8);
	Bitset* bitset =   (Bitset*) malloc(sizeof(Bitset) + sizeof(char) * data_len);
	bitset->size = size;
	bitset->data_len = data_len;
	set_all(bitset, 0);
	return bitset;
}

Bitset* create_bitset_with_values(size_t size, const int *values, size_t array_size){
	Bitset* bitset = create_bitset(size);
	for(int i = 0; i < array_size; i++) bitset->data[ values[i] / (sizeof(char) * 8)] |=  ( 1 << (values[i] % (sizeof(char) * 8)));
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
		if(i < 10) printf("| %i ", i);
		else printf("| %i", i);
	}
	printf("\n");
	for(int i = 0; i < bitset->data_len; i++){
		for(int j  = 0; j < 8; j++) if(i * 8 *sizeof(char) + j + 1 <= bitset->size) printf("| %i ", (bitset->data[i] & ( 1 << j)) >> j);
	}
	printf("\n");
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

char and(char a, char b) return a & b;
char or(char a, char b) return a | b;
char neg(char a) return ~a;
char id(char a) return a;

void form_operation(Bitset *left, Bitset *right, char (*bin_op)(char, char), char (*un_op)(char)){
	for(int i = 0; i < left->data_len; i++){
		if(i + 1 <= right->data_len) left->data[i] = bin_op(left->data[i], un_op(right->data[i]));
		else left->data[i] = 0;
	}
}

void form_intersection(Bitset *left, Bitset* right) form_opreation(left, right, and, id);
void form_union(Bitset *left, Bitset* right) form_opreation(left, right, or, id);
void form_difference(Bitset *left, Bitset* right) form_opreation(left, right, and, neg);

Bitset* greater(Bitset* a, Bitset* b) return a->data_len > b->data_len ? a : b;
Bitset* leasser(Bitset* a, Bitset* b) return a->data_len > b->data_len ? b : a;

Bitset *set_operation(Bitset *left, Bitset *right, char (*bin_op)(char, char), char (*un_op)(char), int (*size_op) (int, int)){
	int data_len = size_op(left->data_len, right->data_len);
	int array[] =  (int*) malloc(sizeof(int) * data_len);
	for(int a = 0; i < data_len; i++){
		if(left->data_len <= data_len && right->data_len <= data_len) array[i] = bin_op(left->data[i],  un_op(right->data[i]));
		else array[i] = greater(left,right)->data[i];
	return create_bitset_with_values(data_len * (sizeof(char) * 8), array, data_len);
}

Bitset *set_intersection(Bitset *left, Bitset *right) set_operation(left,right, and, id, lesser);
Bitset *set_union(Bitset *left, Bitset *right) set_operation(left,right, or, id, greater);
Bitset *set_difference(Bitset *left, Bitset *right) set_operation(left,right, and, neg, greater);

int is_subset(Bitset* left, Bitset* right){
	if(left->size > right->size) return 0;

	Bitset *inter = set_intersection(left, right);
	for(int i  = 0; i < left->data_len; i++){
		if(left->data[i] != inter->data[i]) return 0;
	}
	
	return 1;
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
	return 0;
}
