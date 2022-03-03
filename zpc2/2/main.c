#include <stdio.h>
#include <stdlib.h>
#include	<string.h>

#define LEN(arr) sizeof(arr) / sizeof(arr[0])

char* connect(char arr1[], char arr2[], char len1, char len2){
	char *destination = (char*)malloc((len1 + len2)* sizeof(char));
	memcpy(destination, arr1, len1 * sizeof(char));
	memcpy(destination + len1 - 1, arr2, len2 * sizeof(char));
	return destination;
}

void vypisPole(char arr[], int size){	
	printf("%s", arr);
	printf("\n");

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

void AddToEnd(Node *list, int data){
	Node **elem = &list;
	Node* new_node;
	new_node = (Node*) malloc(sizeof(Node));
	new_node->data = data;
	new_node->next = NULL;
	while((*elem)->next != NULL){
		elem  = &(*elem)->next;
	}
	(*elem)->next = new_node;
}	

void delete_first(Node *list){
	//Node **node_p = &list;
	//(*node_p) = (*node_p)->next;
	*list = *list->next;
}

int main(){
	char arr1[] = "ahoj";
	char arr2[] = " pavle";
	int len1 = LEN(arr1);
	int len2 = LEN(arr2);
	char *arr =  connect(arr1, arr2, len1, len2);
	vypisPole(arr,len1+ len2);

	Node* list = (Node*) malloc(sizeof(Node));
   list->data = 1;
   list->next = NULL;
        
   // Funkci add předáváme ukazatel na ukazatel na list.
   push(&list, 2);
   push(&list, 3);
	AddToEnd(list, 4);

	PrintArray(list);
	delete_first(list);
	PrintArray(list);
	printf("%d\n", GetLength(list));


}
