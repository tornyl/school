#include <stdlib.h>
#include <stdio.h>

void ukazka(int *variable){
	printf("hodnota promenne variable je: %d", *variable);
	printf("adresa promenne variable je %p", variable);

}

int porovnej(char *t1, char *t2){
	int index = 0;
	while(1){
		if(!*(t1 + index) && !*(t2 + index)) return 0;
		if(!*(t1 + index)) return -1;
		if(!*(t2 + index)) return 1;
		index ++;
	}

}

char *strrstr(const char *text, const char *hledany){
	int len_text = 0;
	int len_hledany = 0;
	char *start = NULL;
	while(text[len_text]) len_text ++;
	while(hledany[len_hledany]) len_hledany ++;

	for(int i = len_text - 1; i >=0; i--){
		if(text[i] == hledany[len_hledany - 1]){
			int match = 1;
			for(int j = 0; j < len_hledany; j++){
				if( i - j < 0){
					match = 0;
					break;
				}
				if(text[i - j] != hledany[len_hledany - 1 -j]) match = 0;	
			}
			if(match){
				start = &text[i];
			}
		}
	}

	return start;



}

int main(){
	int number  = 50;
	ukazka(&number);
	char t1[] = "ahojdfdg";
	char t2[] = "holaa";
	printf("\n %d \n", porovnej(t1, t2));
	printf("%c\n", *strrstr("ahoj jak se mas", "bum"));
	return 0;
}
