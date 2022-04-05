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

double soucin(double a, double b){
	return a * b;
}

double soucet(double a, double b){
	return a + b;
}

double *map(double (*fce)(double), double *input, int length){
	for(int i = 0; i < length; i++){
		input[i] = fce(input[i]);
	}
}

double **map2(double (*fce[])(double), double *vstup, int pocet_fce, int pocet_vstup){
	double **array = (double **) malloc((pocet_fce + 1) * sizeof(double *));
	for (int i = 0; i < pocet_fce +1; i++){
		array[i] = (double *) calloc(pocet_vstup, sizeof(double));
		if(!i){
			memcpy(array[i], vstup, sizeof(double) * pocet_vstup);
			continue;
		}
		for(int j = 0; j < pocet_vstup; j++){
			array[i][j] = fce[i - 1](array[i - 1][j]); 
		}
	}
	return array;	
}

double akumulator (double (*fce)(double, double), double cisla[], int pocet){
	int i = 1;
	double sum = cisla[0];
	while(i != pocet){
		sum = fce(sum, cisla[i]);
		i++;
	}
	return sum; 
}

int main(){
	double input[] = {2,3,5, 9 , -5};
	double (*func_array[3])(double);
	func_array[0] = add5;
	func_array[1] = exp;
	func_array[2] = t100;
	//map(add5, input, 3);
	for(int i = 0; i < 5; i++){
		printf("%f, ", input[i]);
	}
	printf("\n");
	double **arr = map2(func_array,input, 3, 5); 
	for(int i = 0; i < 4; i++){
		for(int j = 0; j < 5; j++){
			printf("%f  ", arr[i][j]);
		}
		printf("\n");
	}
	printf("\n");
	
	printf("sum: %f\n", akumulator(soucin, input, 5));
	return 0;
}
