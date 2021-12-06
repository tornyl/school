#include<stdio.h>

int main(){
	
	int a = 6;
	int cislo;
	float des_cislo;
	char muj_znak;
	double male_cislo;

	printf("Zadej cislo:");
	scanf("%d",&cislo);
	printf("Hodnota promenne cislo je: %d\n", cislo);

	printf("Zadej desetinne cislo:");
	scanf("%f",&des_cislo);
	printf("Hodnota promenne des_cislo je: %f\n", des_cislo);

	printf("Zadej muj znak:");
	scanf(" %c",&muj_znak);
	printf("Hodnota promenne muj_znak je: %c\n", muj_znak);

	printf("Zadej male cislo:");
	scanf("%lf",&male_cislo);
	printf("Hodnota promenne male_cislo je: %e\n", male_cislo);

	
	//printf("%i \n", a);
	//printf("%lu \n", sizeof(int));
	
	return 0;
}
