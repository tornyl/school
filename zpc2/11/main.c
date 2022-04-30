#include <stdio.h>
#include <stdlib.h>

#define p1 "soubor.txt"
#define p2 "sou.bor"

void u1(){
	FILE * f1 = fopen(p1, "w");
	FILE* f2 = fopen(p2, "wb");

	for(int i =0; i < 10; i++){
		fwrite(&i, sizeof(int), 1, f2);
		fprintf(f1, "%d", i);
	}
	fclose(f1);
	fclose(f2);
}

void u2(){
	FILE * f1 = fopen("s2.txt", "w");
	FILE* f2 = fopen("s2.x", "wb");
	int n  = 123456789;
	fwrite(&n, sizeof(int), 1, f2);
	fprintf(f1, "%i", n);
	fclose(f1);
	fclose(f2);
	}

void u3(){
	FILE* f = fopen("s3", "wb");
	double n[5]  = {45.235, 3423.234525245, 232.3423423, 5645645.4534534,  45364574.477567568};
	fwrite(n, sizeof(double), 5, f);
	fclose(f);
}

void u4(){
	FILE* f = fopen("s3", "rb");
	double sum = 0;
	double num = 0;
	int count = 0;
	while(fread(&num, sizeof(double), 1, f)){	
		sum += num;
		count++;
		//fseek(f,sizeof(double) * count,SEEK_SET); 
	}
	printf("average %f\n", sum / count);
	fclose(f);
}

int main(){
	u1();
	u2();
	u3();
	u4();
	return 0;
}
