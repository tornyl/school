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
	for(int i = 0; i < size; i++) bitset->data[ values[i] / (sizeof(char) * 8)] = bitset->data[values[i] / (sizeof(char) * 8)] | ( 1 << (values[i] % (sizeof(char) * 8)));
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

int main(){
	printf("%li\n", sizeof(char));
	Bitset* bitset = create_bitset_with_range(100, 20);
	print(bitset);
	int vals[] = { 5, 3 ,2 ,6, 9, 3, 5, 2, 5, 6, 2, 6, 9};
	Bitset* b2 = create_bitset_with_values(12, vals, 12);
	print(b2);
	return 0;
}
