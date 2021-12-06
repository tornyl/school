#include <stdio.h>


int main()
{
	int i, soucet = 0, cisla[10];
	printf("Zadejte 10 cisel:");
	for ( i = 0; i<10; i++)
	{
		scanf("%d", &cisla[i]);
	}
	printf("\nV poli jsou cisla:");
	for ( i = 0; i < 10; i++)
	{
		printf("%d, ", cisla[i]);
	}
	for (i = 0; i < 10;i++)
	{
		soucet += cisla[i];
	}
	printf("\nSoucet cisel v poli je: %d\n", soucet);
	printf("\nPrumer cisel v poli je: %.2f\n", soucet / 10.0);

	return 0;
}
