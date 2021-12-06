#include <stdio.h>

int main(){
	char text[] = "aaaa"; // 1: ahojsvete 2:blablabla 3:ah 4:aaaa
	char vzor[] = "aa";  // 1:svete 2:bl 3:bkdoalskd 4:aa
	

	//int text_len = sizeof(text) - 1;
	//int vzor_len = sizeof(vzor)/ sizeof(vzor[0]) - 1;
	int text_len = 0;
	int vzor_len = 0;
	while(text[text_len]){
		text_len +=1;
	}
	while(vzor[vzor_len]){
		vzor_len +=1;
	}


	
	printf("vyzkyt\n");
	int nic = 0;
	if(vzor_len > text_len){
		printf("nic se tam nenachzi\n");
		nic = 1;
	}	
	for(int i =0; i < text_len; i++){
		if(vzor[0] == text[i] && !nic){
			int match = 1;
			for(int j = 0; j < vzor_len; j++){
				if(vzor[j] != text[i + j]){
					match = 0;
				}
			}
			if(match) printf("%d ", i + 1);

		}
	}
	printf("\n");

	return 0;
}
