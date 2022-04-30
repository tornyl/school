#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 37

typedef struct list_{
	char* value;
	struct list_* next;
	struct list_* previous;
}list;

typedef struct{
	int (*hash)(char*);
	list* data[];
}chaining_table;

chaining_table* create_chaining_table(int size, int (*hash)(char*)){
	chaining_table* table = (chaining_table*) malloc(sizeof(chaining_table) + sizeof(list*) * size);
	//table->data = (list**) malloc(sizeof(list*) * size);
	for(int i = 0; i < size; i++) table->data[i] = NULL;
	table->hash = hash;
	return table;
}
list* create_list(){
	list* new  = (list*)malloc(sizeof(list));
	new->previous = NULL;
	new->next = NULL;
	new->value = NULL;
	return new;
}
int list_insert(list* item, char* k){
	if(!item->previous) item->value = k;
	else{	
		list* new  = create_list(); 
		new->value = k;
		item->next  = new; 
		new->previous = item;
	}
	return 1;
}

list* list_search(list* item, char* k){
	list* item_curr = item;
	while(item_curr && strcmp(item_curr->value, k) != 0) {
		
		printf("val 1: %c val 2: %c\n", *k, *item_curr->value);
		item_curr = item_curr->next;
	}
	if(!item_curr) return NULL;
	else return item_curr;
}

int list_delete(list** data , int i, list* x){
	list* curr_item  = data[i];
	while(curr_item && curr_item->value != x->value) curr_item = curr_item->next;
	if(!curr_item->previous){
		data[i] = curr_item->next;
		free(curr_item);
	}else{
		curr_item->previous->next = curr_item->next;
		if(curr_item->next) curr_item->next->previous = curr_item->previous;
		free(curr_item);
	}
	return 1;
}

int add_ct(char* data, chaining_table* table){
	int i = table->hash(data);
	if(!table->data[i]) table->data[i] = create_list();
	return list_insert(table->data[i], data);
}

int contains_ct(char* k, chaining_table* table){
	//printf("%c\n", *k);
	int i  = table->hash(k);
	//printf("%i\n", i);
	return list_search(table->data[i], k) ? 1 : 0;
}

int remove_ct(char* data, chaining_table* table){
	int j = table->hash(data);
	list* x = list_search(table->data[j], data);
	if(x){
		int i  = table->hash(x->value);
		return list_delete(table->data, i, x);
	} else return 0;

}

int simpleHash(char *k){ return (int)*k;}

#define BASE 128
int divide_method_hash(char *seq){
	int i = 0;
	int sum = 0;
	int exp_result = 1;
	while(seq[i]){
		sum += (int)seq[i] * exp_result;
		exp_result *= BASE; 
		i++;
	}
	//printf("sum: %i\n", i);
	//printf("key: %i\n", sum % SIZE);
	return sum % SIZE;
}

#define OA_SIZE 50

typedef struct{
	int deleted;
	char* value;
} oa_item;

typedef struct{
	int (*probe)(int, int);
	int (*hash)(char*);
	int size; 
	oa_item* data[];
} oa_table;

oa_table* create_oa_table(int size, int (*hash)(char*), int (*probe)(int, int)){
	oa_table* table = (oa_table*) malloc(sizeof(oa_table) + sizeof(oa_item*) * size);
	table->hash =  hash;
	table->probe = probe;
	table->size = size;
	for(int i = 0; i < size; i++) table->data[i] = NULL;
	return table; 
}

int get_index(char* data, oa_table* table, int i){
	int j = table->hash(data);
	return table->probe(j, i);
}

int add_oat(char* data, oa_table* table){
	for( int i = 0; i < table->size; i++){
		int j = get_index(data, table, i);
		printf("index: %i\n", j);
		if(!table->data[j]){
			table->data[j] = (oa_item*) malloc(sizeof(oa_item));
			table->data[j]->deleted = 0;
			table->data[j]->value = data;
			return 1;
		}else if(table->data[j]->deleted){
			table->data[j]->value = data;
			table->data[j]->deleted = 0;
			return 1;
		}
	}
	return 0;
}


int remove_oat(char* data, oa_table* table){
	for( int i = 0; i < table->size; i++){
		int j  = get_index(data, table, i);
		if(!table->data[j]) return 0;
		if(!table->data[j]->deleted && strcmp(table->data[j]->value, data) == 0){
			table->data[j]->deleted = 1;
			return 1;
		}
	}
	return 0;
}

int contains_oat(char* data, oa_table* table){
	for(int i  = 0; i < table->size; i++){
		int j = get_index(data, table, i); 
		if(!table->data[j]) return 0;
		if(!table->data[j]->deleted && strcmp(table->data[j]->value, data) == 0) return 1;
	}
	return 0;
}

int linear_probe(int i , int j){ return (i + j) % OA_SIZE; }
#define C1 5
#define C2 13
int quadratic_probe(int j , int i){
	return (j + C1 * i + C2 * i * i) % OA_SIZE;
	}

int main(){
	
	chaining_table* table = create_chaining_table(SIZE, divide_method_hash);
	char* h  = "hfdsf";
	printf("%i\n", add_ct(h, table));
	char* t  = "tdfsdfg";
	printf("%i\n", add_ct(t, table));
	char* u = "udfsf";
	printf("%i\n", contains_ct(h, table)); 
	char* p = "hfdsf";
	printf("%i\n", remove_ct(t, table)); 
	printf("%i\n", contains_ct(p, table)); 
	
	printf("TEST 2\n");

	oa_table* table_oa = create_oa_table(OA_SIZE, divide_method_hash, quadratic_probe);

		
	char* key1 = "abcde";
	printf("%i\n", add_oat(key1, table_oa));
	char* key2  = "ggggg";
	printf("%i\n", add_oat(key2, table_oa));
	char* key3 = "abcde";
	printf("%i\n", contains_oat(key3, table_oa)); 
	char* key4 = "aafad";
	printf("%i\n", remove_oat(key3, table_oa)); 
	printf("%i\n", contains_oat(key4, table_oa)); 

	return 0;
}
