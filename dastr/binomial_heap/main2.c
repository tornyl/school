#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <time.h>

#define SIZEOF(arr) sizeof(arr) / sizeof(arr[0])


int random_int(int from , int to){
   return from + (rand() % (to - from + 1));
}

typedef struct node{
	int key;
	struct node *child;
	struct node *sibling;
	int degree;
	struct node *parent;
}Bh_node;

typedef struct{
	Bh_node *first;
}Binomial_heap;

Bh_node* binomial_heap_minimum(Bh_node *bt){
	Bh_node* y = bt;
	Bh_node *x = bt;
	int min = bt->key;
	while(x){
		if(x->key < min){
			min = x->key;
			y = x;
		}
		x = x->sibling;
	}

	return y;
}

void binomial_link(Bh_node *h1, Bh_node *h2){
	h1->parent = h2;
	h1->sibling = h2->child;
	h2->child = h1;
	h2->degree = h2->degree + 1;
}

Bh_node *binomial_heap_merge(Bh_node *h1, Bh_node *h2){
	Bh_node *x = NULL;
	Bh_node *first = NULL;
	while(h1 && h2){
		Bh_node *new = NULL;
		if( h1->degree < h2->degree){
			new = h1;
			h1 = h1->sibling;
		}else{
			new = h2;
			h2 = h2->sibling;
		}
		if(!x){
			x = new;	
			first = x;
		}else{
			x->sibling = new;
			x = x->sibling;
		}
	}
	x->sibling = h1 ? h1 : h2;
	return first;
}

Bh_node *binomial_heap_union(Bh_node *h1, Bh_node *h2){
	if(!h1 || !h2) return h1 ? h1: h2;
	Bh_node *h = binomial_heap_merge(h1, h2);	
	if(h == NULL) return NULL;

	Bh_node *prev_x = NULL;
	Bh_node *x = h;
	Bh_node *next_x = x->sibling;

	while(next_x){
		if((x->degree != next_x->degree) || (next_x->sibling != NULL && next_x->sibling->degree == x->degree)){
			prev_x = x;
			x = next_x;
		}else{
			if(x->key <= next_x->key){
				x->sibling = next_x->sibling;
				binomial_link(next_x, x);
			}else{
				if(prev_x == NULL){
					h = next_x;
				}else{
					prev_x->sibling = next_x;
				}
				binomial_link(x, next_x);
				x = next_x;
			}
		}

		next_x = x->sibling;
	}

	return h;
}

void binomial_heap_insert(Binomial_heap* h, int x){
	Bh_node *h_ = (Bh_node *) malloc(sizeof(Bh_node));
	h_->key = x;
	h_->parent = NULL;
	h_->child = NULL;
	h_->sibling = NULL;
	h_->degree = 0;
	h->first = binomial_heap_union(h->first, h_);
}

Bh_node *remove_min_list(Bh_node *h){
	Bh_node *min = binomial_heap_minimum(h); 
	Bh_node *prev = NULL;
	Bh_node *x = h;
	while(x != min){
		prev = x;
		x = x->sibling;
	}

	if(prev) prev->sibling = x->sibling;
	return min;
}

Bh_node *reverse_list(Bh_node *h){
	Bh_node *prev = NULL;
	Bh_node *x = h;

	while(x){
		Bh_node *next = x->sibling;
		x->sibling = prev;
		prev = x;
		x = next;
	}
	return prev; 
}

void delete_parent(Bh_node *h){
	while(h) {
		h->parent = NULL;
		h = h->sibling;
	}
}

Bh_node *binomial_heap_extract_min(Binomial_heap* h){
	if(h->first == NULL) return NULL;
	Bh_node *x = remove_min_list(h->first);
	if( h->first == x) h->first = x->sibling;

	delete_parent(x->child);
	Bh_node *y = reverse_list(x->child);

	h->first = binomial_heap_union(h->first, y);
	return x;
}

void binomial_heap_decrease_key(Bh_node *h, Bh_node *x, int k){
	assert(x->key > k);

	x->key = k;
	Bh_node *y = x;
	Bh_node *z = y->parent;

	while(z != NULL && y->key < z->key){
		int tmp = y->key;
		y->key = z->key;
		z->key = tmp;

		y = z;
		z = y->parent;
	}
}



void print_heap_rec(Bh_node *h){
	Bh_node *x = h;
	while(x){
		if(!x->parent) {printf("\n");}
		printf("  %i", x->key);
		print_heap_rec(x->child);
		x = x->sibling;
	}
}

void print_heap(Bh_node *h){
	print_heap_rec(h);
	//printf("end\n");
	printf("\nend\n");
}

#define num_insert_operation 1000000
#define num_extract_operation 1000000

int main(){
	Binomial_heap bh;
	bh.first = NULL;

    time_t t;
    srand((unsigned) time(&t));

	clock_t start = clock();
	for(int i = 0; i < num_insert_operation; i++){
	    binomial_heap_insert(&bh, random_int(0, 100));
	}
	for(int i = 0; i < num_extract_operation; i++){
	    //binomial_heap_extract_min(&bh);
	}

    clock_t end = clock();
    float seconds = (float)(end - start) / CLOCKS_PER_SEC;
    printf("Insert operations: %d\nExtract operations: %d\nTime needed: %f\n", num_insert_operation, num_extract_operation, seconds);

	print_heap(bh.first);
		return 0;
}

