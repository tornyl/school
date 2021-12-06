#include <stdio.h>

int main(){

	int n = 5;
	int index = 1;
	while( index <= n){
		for(int i = 0; i < index; i++){
			printf("%d", i + 1);
		}

		printf("\n");

		index += 1;

	}
	
	return 0;
}
