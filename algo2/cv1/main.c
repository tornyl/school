#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define pocet_dluzniku 5

typedef struct {
	char name[100];
	char surname[100];
	int age;
	float dluh;
}Dluznik;

void Print_adresar(Dluznik dluznici[], int len){
	for(int i = 0; i < len; i++){
		printf("Dluzna castka: %2.f Jmeno: %s Prijmeni: %s\n", dluznici[i].dluh, dluznici[i].name, dluznici[i].surname);
	}
}

Dluznik GetBiggest (Dluznik dluznici[], int len){
	int biggest = 0;
	for(int i = 0; i < len; i++){
		if(dluznici[i].dluh > dluznici[biggest].dluh){
			biggest  = i;
		}
	}
	return dluznici[biggest];
}

void Modify(Dluznik* dluznik, int amount, int direction){
	dluznik->dluh = dluznik->dluh + direction * amount;
	if(dluznik->dluh < 0) dluznik->dluh = 0;
}

void NavysDluh(Dluznik* dluznik, int amount){
	Modify(dluznik, amount, 1);
}
void SnizDluh(Dluznik* dluznik, int amount){
	Modify(dluznik, amount, -1);
}

int RandInt(int min,int max){
	return ((rand() % (int)((max + 1) - min)) + min);
}

void swap(Dluznik pole[],int a, int b){
	Dluznik tmp = pole[b];
	pole[b] = pole[a];
	pole[a] = tmp;
}

int Partition(Dluznik pole[], int p, int r){
	int pivot = pole[r].age;
	int i = p - 1;
	for(int j = p; j < r; j++){
		if(pole[j].age <= pivot){
			i++;
			swap(pole, i, j); 
		}
	}
	swap(pole, i + 1, r);
	return i + 1;
}


int RandomizedPartition(Dluznik dluznici[], int p,int r){
	int q = RandInt(p,r);
	swap(dluznici, q, r);
	return Partition(dluznici, p, r);  
}

Dluznik RandomizedSelect(Dluznik dluznici[], int p, int r, int i){
	if(p == r) return dluznici[p];
	int q = RandomizedPartition(dluznici, p, r);
	int k = q - p + 1;
	if(i == k) return dluznici[q];
	else if(i < k) return RandomizedSelect(dluznici, p, q - 1, i);
	else return RandomizedSelect(dluznici, q + 1, r, i - q + p - 1);
}

Dluznik GetNthYoungest(Dluznik dluznici[],int len, int i){
	return RandomizedSelect(dluznici, 0, len - 1, i);	
}

void Sort(Dluznik dluznici[], int len){
	for(int i = 0; i < len - 1; i++){
		int imin = i;
		for( int j = i + 1; j < len; j++){
			if(dluznici[j].age < dluznici[imin].age) imin = j;
		}
		swap(dluznici, i, imin);
	}

}

int main(){
	srand(time(NULL));
	Dluznik dluznici[pocet_dluzniku] = {
				{"Honza", "Luznik", 25, 100040.0},
				{"Pavel", "Babovka", 31, 345453.0},
				{"Jarda", "Smazeny", 45, 4566.0},
				{"Vladislav", "Kropnik", 15, 343.0},
				{"Marek", "Novy", 69, 34536.0}};
	
	Print_adresar(dluznici, pocet_dluzniku);
	Dluznik nejvetsi_dluznik = GetBiggest(dluznici, pocet_dluzniku);
	printf("Nejvetsi dluznik je: %s\n", nejvetsi_dluznik.surname);
	NavysDluh(&dluznici[2], 5000);
	SnizDluh(&dluznici[1], 10000);
	Print_adresar(dluznici, pocet_dluzniku);
	Dluznik nthyoungest = GetNthYoungest(dluznici, pocet_dluzniku, 4);
	printf(" %d ity Nejmladsi dluznik je: %s\n", 1, nthyoungest.surname);
	Sort(dluznici, pocet_dluzniku);
	Print_adresar(dluznici, pocet_dluzniku);



				
	return 0;
}
