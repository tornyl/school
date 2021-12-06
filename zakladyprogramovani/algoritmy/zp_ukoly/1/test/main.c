#include <stdio.h>
#define len 5

typedef struct Car{
	char name[20];
	int wheels;
}Car;
int main(){
	int a[10];
	int c[50];
	int *b[] = {a, c};
	
	printf("%d", sizeof(b[0]) / sizeof(b[0][0]));
	struct Car cc =  {"cigo", 5};
	printf("%s %d\n", cc.name, cc.wheels);
	for(int i = 0; i < 10; i++){
		int p[len];
	}
	printf("%d\t %d\t%d\n", 5 ,3 ,3);
	printf("%d\t %d\t%d\n", 545643 ,2454, 12);
	return 0;
}



