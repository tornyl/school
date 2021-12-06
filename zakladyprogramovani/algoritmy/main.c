#include <stdio.h>

#define M 6

int main(){
	
	int pole[M] = {12,6,8,2,4,1};
	
	for(int i = 0; i < M; i++){
		printf("%d ", pole[i]);
	}

	printf("\n");
	// bubble sort
	for(int i = 0; i < M -1; i++){
		for( int j = M - 1; j > i; j--){
			if(pole[j] < pole[j - 1]){
				int tmp = pole[j];
				//pole[j] = pole[ j - 1];
				//pole[j - 1] = tmp;
			}
		}

	}


	//shaker sort
	for(int i = 0; i < M -1; i++){
		for( int j = M - 1; j > i; j--){
			if(pole[j] < pole[j - 1]){
				int tmp = pole[j];
				pole[j] = pole[ j - 1];
				pole[j - 1] = tmp;
			}
		}

		for(int j = i+1; j < M - 2; j++){
			if(pole[j] > pole[j + 1]){
				int tmp = pole[j];
				pole[j] = pole[j+1];
				pole[j + 1] = tmp;
			}

		}

		for(int i = 0; i < M; i++){
			printf("%d", pole[i]);
		}

		printf("\n");

	}	
	

	for(int i = 0; i < M; i++){
		printf("%d", pole[i]);
	}

	printf("\n");
	



}
