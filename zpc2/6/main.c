#include <stdio.h>
#include <stdlib.h>
#include <string.h>

double add5(double val){
	return val + 5;
}

double exp(double val){
	return val * val;
}

double t100(double val){
	return 100 * val;
}

double *map(double (*fce)(double), double *input, int length){
	for(int i = 0; i < length; i++){
		input[i] = fce(input[i]);
	}
}

double **map2(double (*fce[])(double), double *vstup, int pocet_fce, int pocet_vstup){
	double **array = (double **) malloc(pocet_fce * sizeof(double *));
	for (int i = 0; i < pocet_fce; i++){
		array[i] = (double *) calloc(pocet_vstup, sizeof(double));
		if(!i){
			memcpy(array[i], vstup, sizeof(double) * pocet_vstup);
			continue;
		}
		for(int j = 0; j < pocet_vstup; j++){
			array[i][j] = fce[i](array[i - 1]); 
		}
	}
	return array;	
}

int main(){
	double input[] = {2,3,5, 9 , -5};
	double (*func_array[3])(double);
	map(add5, input, 3);
	for(int i = 0; i < 3; i++){
		printf("%f, ", input[i]);
	}
	printf("\n");
	return 0;
}
