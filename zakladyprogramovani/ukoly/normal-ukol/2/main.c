/* 

   DRUHY DOMACI UKOL 


   Reseni odevzdejte do 17.12.2021 23:59 na email: petr.osicka@upol.cz 
   s předmětem Domaci ukol 2, .c soubor prilozte k mailu, 
   do tela mailu napiste sve jmeno.

void print_index_arr(int arr[]){
   ZADANI UKOLU.
   
   Naprogramujte funkci 

   void report (int p[], int n, int lb, int ub);

   p je pole celych cisel (kladnych i zapornych)
   n je velikost pole p, muzeme predpokladat, ze n je male cislo (napr. max 16)
   lb je dolni hranice souctu (soucet viz dale)
   rb je horni hranice souctu

   Funkce vypise vsechny neprazdne mnoziny indexu takove,
   ze pokud secteme hodnoty prvku v poli p na techto indexech, tak lb <= soucet <= rb 
   Kazdou mnozinu vypise program na zvlastni radek.

   
   Napriklad pokud
   p je pole {1,5,6,-1,1}, (n je pak 5), lb = 2, rb = 5, pak funkce vypise 
   
   {0, 4}   (protoze p[0] + p[4] = 2, a plati lb <= 2 <= rb)
   {1}      (protoze p[1] = 5, a plati lb <= 5 <= rb)
   {2, 3}   (protoze p[2] + p[3] = 5 a plati lb <= 5 <= rb) 
   
   a dalsi mnoziny.
   
   Ke generovani mnozin indexu pouzijte reprezentaci mnoziny pomoci 
   celeho cisla a bitove operatory (viz zacatek seminare a napoveda nize).
   Muzeme predpokladat, ze maximalni velikost pole se pocet bitu v typu int 
   zmenseny o 1.
   
   NAPOVEDY:

   Bitove operatory (priklady na 4 bitovych cislech)

   & ... bitova konjunkce,  1001 & 0101 = 0001
 ... bitova disjunkce,  1001 | 0101 = 1101
   << ... bitovy posuv,     1001 << 1 = 0010, 1001 << 2 = 0100, 1001 << 3 = 1000

   test toho, jestli je i-ty bit v cisle a roven 1:
   a & (1 << (i-1))
   pokud je vysledek nenulovy, je i-ty bit roven 1

   dale je pro nas zajimava nasledujici tabulka (pro 3 bitova cisla), pro 
   cisla s vice bity je situace analogicka.

   cislo | binarne  | bity nastavene na 1
   --------------------------------------
     0   |   000    |    
     1   |   001    |    1
     2   |   010    |    2
     3   |   011    |    1,2
     4   |   100    |    3
     5   |   101    |    1,3
     6   |   110    |    2,3
     7   |   111    |    1,2,3
   ---------------------------------------

   vsechna cisla z pvniho sloupce jsou mensi nez 8 (1000);

 */


#include <stdio.h>

//#define size 14
#define getSize(arr) sizeof(arr) / sizeof(arr[0])

void report (int p[], int n, int lb, int ub, int size);
void null_arr(int arr[], int size);
void getcomb(int p[], int n, int size);
int  Sum(int index[], int p[], int size);
void print_index_arr(int arr[], int size);
int my_pow(int a, int n);


int main(){
	int p[] = {1,5,6,-1,1,8, 12, 8, 9, 12,3,4, -7, -3};	
	int lb = 2;
	int ub = 9;
	int n = getSize(p);
	printf("size of pole %d", n);
	report(p, n, lb, ub, n); 
	return 0;
}


void report (int p[], int n, int lb, int ub, int size){	
	int index_set[size];
	//printf("%d", my_pow(2,n));
	for(int i = 0; i < 1 << n; i++){
		null_arr(index_set, size);
		getcomb(index_set, i, size);
		//print_index_arr(index_set);
		int sum = Sum(index_set, p, size);
		if(sum >= lb && sum <= ub){
			print_index_arr(index_set, size);
		}
	}
}

void getcomb(int p[], int n, int size){
	for(int i = size - 1; i>= 0; i--){
		if( n & ( 1 << i)){
			p[size -1 -i] = 1;
		}
	}
}

int  Sum(int index[], int p[], int size){
	int sum = 0;
	for(int i = 0; i < size; i++){
		sum += p[i] * index[i];
	}

	return sum;
}

void print_index_arr(int arr[], int size){
	printf("{ ");
	for(int i = 0; i < size; i++){
		if(arr[i]) printf("%d ", i);
	}
	printf("}\n");
}

void null_arr(int arr[], int size){
	for(int i = 0; i < size; i++){
		arr[i] = 0;
	}
}

int my_pow(int a, int n){
	if(n == 0) return 1;
	else return a* my_pow(a, n - 1);

}
