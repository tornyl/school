#include <stdio.h>

int main(){
	
	printf("Zadej cislo od 1 do 12: ");
	int n = 0 ;
	do{
		if(n) printf("Zadal jsi spatne cislo, zkus to znovu:");
		scanf("%d", &n);


	}
	while(n < 1 || n > 12);

	for(int i = 1; i < n + 1; i++){
		for(int j = 0; j < i; j++){
			//printf("b\n");
			for(int k = 0; k < j;k++){
				printf(" ");
			}
			printf("x");
			for(int k = 0; k < (i - j )* 2 -1;k++){
				printf(" ");
			}
			printf("x");
			printf("\n");
		}
		//printf("\n");
		for(int j = i; j >= 0; j--){
			//printf("b\n");
			for(int k = 0; k < j;k++){
				printf(" ");
			}
			printf("x");
			for(int k = 0; k < (i - j )* 2 -1;k++){
				printf(" ");
			}
			if(j != i) printf("x");
			printf("\n");
		}

		printf("\n");

	}


	return 0;
}
