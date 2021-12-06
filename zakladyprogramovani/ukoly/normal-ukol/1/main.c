#include <stdio.h>

void justify_left (char src[], int line_len);
void justify_right (char src[], int line_len);


int main(){
	int line_len = 30;	
	char src[] = "Vzorovy text ukazuje priklad zarovnani vlevo ahoj aaaa bbbbbb rrrrrrrrr fggggggggg";
	printf("%s\n", src);
	for(int i = 0; i < line_len; i++){
		printf("-");
	}
	printf("\n");
	//justify_left( src, line_len);	
	justify_right( src, line_len);	

	//printf("\n");

	printf("\n");
	for(int i = 0; i < line_len; i++){
		printf("-");
	}
	printf("\n");

	return 0;
}


void justify_left (char src[], int line_len){
	int i = 0;
	while(src[i]){
		if(src[i] == ' '){
			if(i % line_len == 0){
				printf("\n");
			}else{
				printf(" ");	
			}
		}else{
			int j = i;
			while(src[j] != ' ' && src[j] != '\0'){	
				j++;
			}
			if( ((j) / line_len) > (i / line_len)){
				printf("\n");
				for(int k = i; k < j; k++){
					printf("%c", src[k]);
				}	

			}else{
				for(int k = i; k < j; k++){
					printf("%c", src[k]);
				}
			}
			i = j - 1;
		}
		i++;
		if(i % line_len == 0){
			printf("\n");
			i++;
		}
	}
}


void justify_right (char src[], int line_len){
	int i = 0;
	while(src[i]){
		int space = line_len;
		int j = i;
		while(space){
			if(src[j]){
				space -=1;
				j++;
			}else break;
		}
		if(src[j] == ' '){
			j -=1;
		}else if(src[j+1] != ' ' && src[j+1] !='\0' && src[j] != '\0'){
			while(src[j] != ' '){	
				j--;
				space++;
			}
		}
		for(int k = 0; k < space; k++){
			printf(" ");
		}
		for(int k = i; k < j + 1; k++){
			printf("%c", src[k]);
		}
		if(src[j] == '\0') break;
		printf("\n");
		i = j + 1;
	}
}
