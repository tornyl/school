/* 

   PRVNI DOMACI UKOL 
  
   
   Reseni odevzdejte do 21.11.2021 23:59 na email: petr.osicka@upol.cz 
   s předmětem Domaci ukol 1, .c soubor prilozte k mailu, 
   do tela mailu napiste sve jmeno.
   
   ZADANI UKOLU: 
   

    Naprogramujte funkci s hlavickou

    int delete_words(char src[], char words[]);

    Oba argumenty funkce jsou retezce, ktere obsahuji slova oddelena
    mezerami (= mezi dvěma slovy je vždy jedna mezera).  Prvnim znakem
    neni mezera, za poslednim slovem neni mezera.  Za slovo povazujeme
    posloupnost znaku neprerusenych mezerou. Zadne dalsi bile znaky
    (napr. tabulator, novy radek apod.) se v retezci nevyskytuji.

    Priklad"
    - "toto je priklad spravneho vstupu" je priklad spravneho vstupu.
    - "  toto    neni    priklad \n spravneho   vstupu  " neni priklad spravneho vstupu.

    Funkce smaze z retezce src vsechna slova, ktera se nachazeji v
    retezci words. Pozadujeme, aby retezec src pote byl ve spravnem
    tvaru. Tedy prvnim znakem nesmi byt mezera, jednotliva slova jsou
    oddelena jednou mezerou, za poslednim slovem neni mezera.
    
    Funkce vrati jako navratovou hodnotu pocet smazanych slov.
    
    Je povolen pouze hlavickovy soubor stdio.h (specialne neni povolen string.h).

    NAPOVEDA:

    -> znak v retezci smazeme tak, ze vsechny znaky nalevo od nej (a nulu na
       konci retezce) posuneme o jednu pozici vlevo.

    -> ukol pred odevzdanim poradne otestujte, musi se chovat dobre i v situacich,
       kdy je jeden (nebo oba) argument prazdny retezec.

    -> pri pristupu pomoci indexu si davejte pozor na to, abyste nepristupovali
       mimo pole. To muzete testovat pomoci assert. 
    
    -> ukazka nize, neni jediny test, ktery budu na kodu zkouset.
   
*/


#include <stdio.h>

int delete_words(char src[], char words[]);


int main() {

  char s[] = "aa bb cc nejaka slova uprostred dd";
  char w[] = "bb dd cc slov";
  //char w[] = "dd";

  int pocet = delete_words(s, w);

  printf("smazano: %i\nnovy retez:%s\n", pocet, s);

  /* 
     predchozi printf vytiskne: 

     smazano: 3
     novy retez: aa nejaka slova uprostred  
   */
    
  
  return 0;
}



int delete_words(char src[], char words[]){
	int pocet = 0;
	int src_len = 0;
	int w_len = 0;
	while(src[src_len]) src_len +=1;
	while(words[w_len]) w_len +=1;

	if(!src_len) return 0;
	if(!w_len) return 0;

	for(int i = 0; i < src_len; i++){
		for(int j = 0; j < w_len; j++){
			if( src[i] == words[j] && src[i] != ' ' && (i == 0 || src[i - 1] == ' ' ) && (j == 0 || words[j - 1] == ' ' ) ){
				int k = 0;
				while(src[i + k] && src[i + k] == words[j + k]){
					if((src[i + k+ 1] == ' ' || src[i + k + 1] == '\0') && (words[j + k + 1] == ' ' || words[j + k + 1] == '\0')){
						pocet +=1;
						//delete word
						k +=2;
						for(int l = i + k; l < src_len; l++){
							src[l - k] = src[l];
						}	
						src_len -=k;	
						src[src_len] = '\0';	
						break;
					}
					k++;
				}
			}
		}

	}

	return pocet;
}

