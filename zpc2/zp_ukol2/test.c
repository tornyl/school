#include <stdio.h>
#include <stdlib.h>

void *my_memset(void *s, int c,  unsigned int len)
{
    unsigned char* p=s;
    while(len--)
    {
        *p++ = (unsigned char)c;
    }
    return s;
}

int main(){
	
	char arr[] = {0,0,0,0};
	
	my_memset(arr,(1 << 7) | 1 , 4);

	for(int i = 0; i < 4; i++) printf("%i ", arr[i]);
	printf("\n");

	int *arr2 = {34, 1, 2 ,3};
	printf("%i\n", sizeof(arr2));


	return 0;
}
