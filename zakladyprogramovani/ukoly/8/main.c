#include <stdio.h>
#include <string.h>


struct Firma{
	char nazev[100];
	int pocet_zamestnancu;
	int rocni_naklady;
	float prumerny_plat;
};

void tisk(struct Firma f[], int pocet){
	for(int i = 0; i < pocet; i++){
		printf("Firma %s ma %d zamestnancu/ Jeji rocni naklady na mzdu jsou %d milionu korun. Prumerny mesicni plat je %.2f Kc.\n", f[i].nazev, f[i].pocet_zamestnancu, f[i].rocni_naklady, f[i].prumerny_plat);
	}

}

void celkem(struct Firma f[], int pocet){
	int z, n = 0;
	float p = 0;
	for(int i = 0; i < pocet; i++){
		z += f[i].pocet_zamestnancu;
		n += f[i].rocni_naklady;
		p += f[i].prumerny_plat;
	}
	printf("Celkove firmy zamestnavaji %d zamestnancu. Jejich rocni naklady na mzdu jsou %d milionu korun. Prumerny mesicni plat je %.2f Kc.\n", z, n, p / pocet);

}
int main(){
	int pocet = 5;
	struct Firma f[5] = {
	  { "A", 24, 10, 34722.22},
	  { "B", 18, 6, 27777.78},
	  { "C", 64, 20, 26041.67},
	  { "D", 13, 5, 32051.28},
	  { "E", 8, 8, 83333.34}};
 
	//strcpy(f[0].nazev, "A");
	//strcpy(f[1].nazev, "B");
	//strcpy(f[2].nazev, "C");
	//strcpy(f[3].nazev, "D");
	//strcpy(f[4].nazev, "E");

	//struct Firma ff= { .nazev = "A", .pocet_zamestnancu = 24, .rocni_naklady = 10, .prumerny_plat = 34722.22f};
	  
	tisk(f, pocet);
	celkem(f, pocet);

 return 0;
}
