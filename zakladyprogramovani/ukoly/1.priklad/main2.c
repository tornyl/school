#include <stdio.h>

int main(){
	
	int n;
	printf("Zadej cislo od 1 do 11 ");
	scanf("%d", &n);

	if( n > 11){
		printf("cislo vetsi nez 11\n");
		return 0;
	}
	
	for(int i = 1; i < n;i++){
		for(int k = 0; k < i; k++){
			for(int j = 0; j < i  - k;j++){
				printf(" ");
			}
			for( int j = 0; j < 2*k + 1;j++){
				int end = 2*k;
				if (j == 0) printf("X");
				else if( j == 2*k) printf("X");
				else printf(" ");
			}
			printf("\n");
		}

		for(int k = 0; k < 2*i + 1; k++){
			printf("X");
		}
		
		printf("\n\n");


	}

	return 0;
}
