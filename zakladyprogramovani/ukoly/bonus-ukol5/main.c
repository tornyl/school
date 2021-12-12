/* 
   PATY BONUSOVY UKOL ZE ZP1

   Reseni odevzdejte do 3.1. 2021 23:59 na email: petr.osicka@upol.cz 
   s předmětem Bonusovy ukol 5, .c soubor prilozte k mailu, 
   do tela mailu napiste sve jmeno.

   ZADANI UKOLU.

   Binarni relace na mnozine a jeji vlastnosti jsou probirany v 
   predmetu diskretni struktury. Informace lze nalezt i na nasledujich
   strankach na wikipedii. 

   https://cs.wikipedia.org/wiki/Bin%C3%A1rn%C3%AD_relace
   https://cs.wikipedia.org/wiki/Tranzitivn%C3%AD_uz%C3%A1v%C4%9Br

   Uvazme mnozinu X = {0,1,2,3,4, ... M-1}. (M je tedy velikost mnoziny X).

   Binarni relaci R na X muzeme reprezentovat jako matici o 
   M radcich a M sloupcich. Pokud je na radku i ve sloupci j hodnota 1,
   znamena to, ze (i,j) patri do R. Pokud je tam 0, znamena to, ze 
   (i,j) nepatri do R. 

   V programu matice reprezentujte pomoci pole. (o tom jak reprezentovat dvourozmernou
   matici pomoci jednorozmerneho pole jsme mluvili na zacatku seminare).
   Velikost M zavedte pomoci #define.

   Naprogramujte nasledujici funkce.
   
   int reflexive_p(int r[]);
   int symetric_p(int r[]);
   int antisymetric_p(int r[]);
   int transitive_p(int r[]);

   ktere pro r otestuji, jestli je r reflexivni, symetricka, antisymetricka 
   ci tranzitivni (viz nazev funkce) a vysledek vrati jako navratovou hodnotu.

   Dale naprogramujte funkci

   void transitive_closure(int r[])

   která doplní r tak, aby byla nejmensi nadrelaci puvodniho r, ktera je 
   tranzitivni.

 */


#include <stdio.h>
#include <stdlib.h>
#include <time.h>


#define M 3

void fill_X(int X[]);
void vytvor_relaci(int R[]);
int nahoda(int to);
void vypis_bin_relaci(int R[]);
int reflexive_p(int r[]);
int symetric_p(int r[]);
int antisymetric_p(int r[]);
int transitive_p(int r[]);
void transitive_closure(int r[]);

 int main(){
 	time_t t;
	srand((unsigned) time(&t));	
	int R[M*M];
	vytvor_relaci(R);
	vypis_bin_relaci(R);
	printf("reflexivni: %d\n", reflexive_p(R));
	printf("symtricka: %d\n", symetric_p(R));
	printf("antisymtricka: %d\n", antisymetric_p(R));
	printf("tranzitivni: %d\n", transitive_p(R));
	if(!transitive_p(R)){
		transitive_closure(R);
		vypis_bin_relaci(R);
		printf("tranzitivni podruhe: %d\n", transitive_p(R));
	}
 	return 0;
 }

 void fill_X(int X[]){
	for(int i = 0; i < M; i++){
		X[i] = i;	
	}
 }

 void vytvor_relaci(int R[]){
	for(int i = 0; i < M * M; i++){
		R[i] = nahoda(1);
	}
 }

 int nahoda(int to){	
	return rand() % (to+1);
 }

void vypis_bin_relaci(int R[]){
	for(int i = 0; i < M; i++){
		for(int j = 0; j < M; j++){
			printf("%d ", R[i*M + j]);
		}
		printf("\n");
	}
}

int reflexive_p(int r[]){
	for(int i = 0; i < M; i++){
		if(r[i*M+i]) continue;
		return 0;
	}
	return 1;
}

int symetric_p(int r[]){
	for(int i = 0; i < M; i++){
		for(int j = 0; j < M; j++){
			if(!r[i*M+j] || (r[i * M + j] && r[j * M + i])) continue;
			return 0;
		}
	}
	return 1;
}

int antisymetric_p(int r[]){
	for(int i = 0; i < M; i++){
		for(int j = 0; j < M; j++){
			//if((i*M+j == j*M+i) || (r[i * M + j] && !r[j * M + i]) || (!r[i * M + j] && !r[j * M + i])) continue;
			if((i*M+j == j*M+i) || !(r[i * M + j] && r[j * M + i])) continue;
			return 0;
		}
	}
	return 1;

}

int transitive_p(int r[]){
	for(int i = 0; i < M; i++){
		for(int j = 0; j < M; j++){
			for(int k = 0; k < M; k++){
					if(r[i * M + j] && r[j * M + k]){
						if(r[i * M+ k]) continue;
						return 0;
					}else{
						continue;
					}
			}
		}
	}
	return 1;
}

void transitive_closure(int r[]){
	if(!transitive_p(r)){
		for(int i = 0; i < M; i++){
			for(int j = 0; j < M; j++){
				for(int k = 0; k < M; k++){
					if(r[i * M + j] && r[j * M + k]){
						if(!r[i*M + k]){
							r[i * M + k] = 1;
							transitive_closure(r);
						}
					}
				}
			}
		}
	}
}
