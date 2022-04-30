#include <stdio.h>
#include <stdlib.h>

#include "geom.h" 
#include "stack.h"
int main(int argc, char* argv[]){
	
	if(argc < 4) return -1;
	float a = atof(argv[1]);
	float v = atof(argv[2]);
	float r = atof(argv[3]);
	


	printf("Valec s vyskou %f a polomerem podstavy %f ma objem %f a povrch %f\n",v ,r,  objem_valce(r, v), povrch_valce(r, v));

	
	return 0;
}
