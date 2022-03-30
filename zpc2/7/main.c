#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

int min(int count, ...){
	va_list prms; // prms = parameters

	va_start(prms, count);

	int min  = va_arg(prms, int);
	for(int i = 0; i < count; i++){
		int act = va_arg(prms, int);
		if (act < min) min  = act;
	}
	return min;
}

typedef struct{
	float a;
	float b;
}Complex;



Complex add (int count, ...){
	va_list params;
	va_start(params, count);
	float a = 0;
	Complex sum = {0,0};
	for(int i = 0; i < count; i++){
		Complex *num =  va_arg(params, Complex*);
		sum.a += num->a;
		sum.b += num->b;
	}
	return sum;
}


int main(){

	printf("nejmensi cislo je: %d\n", min(5, 2, 9 ,3, -4, 2));
	Complex nums[5] = {{4, 9}, {3, 5.7}, {2.9, 92.4}, {3.1, 5.2}, {1,1}};
	Complex sum  = add(5, &nums[0], &nums[1], &nums[2], &nums[3], &nums[4]);
	printf("Secteni konplexnich cisel je rovno realne casti: %.2f a kompelxniL %.2f\n", sum.a, sum.b);
	return 0;
}
