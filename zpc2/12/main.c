#include <stdio.h>
#include <stdlib.h>

int bits_count(int number){
	int count = 0;
	while(number){
		number = number >> 1;
		count ++;
	}
	return count;
}

char convert(char letter){
	char a = 1 << 5;
	return a ^ letter ; 
}

int rotate_right(int number, int count){
	int mask = 0;	
	for(int i = 0; i < count; i++){	
		int new  = 1 & number;
		new = new << 31 - i;
		mask = mask | new;
		number = number >> 1;
	}

	return mask | number;
	
}

void print_bits(int number){
	for(int i = 0; i < 32; i++){
		printf("%i ", ((1 << 31) & number) >> 31);
		number = number << 1;
	}
	printf("\n");
}

int main(){
	
	int number = 120;
	printf("number : %i bits needed: %i\n", number, bits_count(number));
	char a = 'H';
	printf("%c %c\n", a, convert(a)); 
	print_bits(255);
	print_bits(rotate_right(255, 2));
	printf("%i\n", 1 << 4);
	print_bits(65);
	print_bits(97);
	return 0;
}
