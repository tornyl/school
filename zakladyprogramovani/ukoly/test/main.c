#include <stdio.h>

int main(){

	int n,m;
	n = 109;
	m = 11333;

	while( n <= m){
		
		int v;
		int i = 1;
		int okay = 1;
		do{
			i *= 10;
			v = n / i;
			//printf("bum");

		}while( v != 0 );
		i /= 10;
		v = 1;
		int i2 = 10;
		//printf("%d\n", i);
		for(int k = 0; k < (i / 10); k++){
			v = n % i2;
			int g = n / i;
			i /= 10;
			i2 *= 10;
			//printf("v: %d   g: %d\n", v, g);
			if ( v != g) okay = 0;


		}
		if(okay) printf("%d\n", n);
		n++;
	}


	return 0;
}
