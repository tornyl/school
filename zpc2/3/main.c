#include <stdio.h>
#include <stdlib.h>

float mocnina(float zaklad, int exponent){
	if(!exponent) return 1;
	return zaklad * mocnina(zaklad, exponent - 1);

}

int secti_interval(int zacatek, int konec){
	if(zacatek < konec){
		return zacatek + secti_interval(zacatek + 1, konec); 
	}

	return zacatek;

}

typedef struct node {
        int data;
        struct node *next ;
} Node;
    
    // Funkce vloží prvek na začátek seznamu
void push(Node **list, int data) {
	Node *new_node;
   new_node = (Node*) malloc(sizeof(Node));
	new_node->data = data;
	new_node->next = *list;
   *list = new_node;
}

void PrintArray(Node *list){
	Node *elem = list;
	while(elem){
		printf("%d ", elem->data);
		elem  = elem->next;
	}
	printf("\n");
}
int GetLength(Node *list){ 
	Node *elem = list; 
	int length = 0;
	while(elem){
		elem  = elem->next;
		length++;
	}
	return length;	

}

int recursive_length(Node *list){
	if(list) return 1 + recursive_length(list->next);
	return 0;
}


int pascal(int row, int column){
	if( row < column) return -1;
	if(!row || !column || row == column) return 1;
	return pascal(row - 1, column - 1) + pascal(row - 1, column);
}

int main(){
	float zaklad = 5;
	int  mocnina_ = 4;
	printf(" %3.f na %d je %3.f\n", zaklad, mocnina_, mocnina(zaklad, mocnina_));
	
	int zacatek = 4;
	int konec = 10;
	printf("soucet cisel v intervalu od %d do %d je %d\n", zacatek, konec, secti_interval(zacatek, konec));


	Node* list = (Node*) malloc(sizeof(Node));
   list->data = 1;
   list->next = NULL;
        
   // Funkci add předáváme ukazatel na ukazatel na list.
   push(&list, 2);
   push(&list, 3);
   push(&list, 6);
   push(&list, 7);
   push(&list, 9);
	PrintArray(list);
	printf("Delka seznamu je: %d\n", recursive_length(list));

	int radek = 1;
	int sloupec = 0 ;
	printf("Hodnota pascalova trojuhleniku na radku %d a slopuci %d je %d\n", radek, sloupec, pascal(radek, sloupec));


	return 0;
}
