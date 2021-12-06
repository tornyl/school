#include <stdio.h>


int main(){
	char sifra[]  = "Katedra Informatiky";
	int klic = 15;
	
	// zafirruj

	for(int i =0; i < 19;i++){
		if(sifra[i] >= 97 && sifra[i] <= 122) sifra[i] -= 32;
		if(sifra[i] >= 65 && sifra[i] <= 90) sifra[i] += klic;
		if(sifra[i] > 90){
			sifra[i] = 65 + sifra[i] -90;
		}
		printf("%c", sifra[i]);

	}
	
	printf("\n");

	for(int i =0; i < 19; i++){
		if(sifra[i] >= 65 && sifra[i] <= 90){
			sifra[i] -=klic;
			if(sifra[i] < 65) {
				sifra[i] = 90  -  (65 - sifra[i]);

			}
		}
		printf("%c", sifra[i]);
	

	}


 	return 0;
}
