#include <stdio.h>

int main(){
	
	int n;
	printf("Zadej cislo od 1 do 11");
	scanf("%d", &n);	
	
	for(int i = 1; i < n;i++){
		for(int k = 0; k < i; k++){
			for(int j = 0; j < i  - k;j++){
				printf(" ");	

			}
			printf("X");
			for(int j = 0; j < 2 * k - 1; j++){
				printf(" ");
			}
			if(k != 0) printf("X");
			printf("\n");
		}

		for(int k = 0; k < 2 * (i + 1) -1; k++){
			printf("X");
		}
		
		printf("\n\n");


	}

	return 0;
}
