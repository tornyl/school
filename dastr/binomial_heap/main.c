#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>

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
	Bh_node* y = NULL;
	Bh_node *x = bt;
	int min = -1;
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
	Bh_node *x = h1;
	while(x->sibling){ x = x->sibling;}
	x->sibling = h2;
	return h1;
}

Bh_node *binomial_heap_union(Bh_node *h1, Bh_node *h2){
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

binomial_heap_insert(Bh_node** h, int x){
	Bh_node *h_ = (Bh_node *) malloc(sizeof(Bh_node));
	h_->key = x;
	h_->parent = NULL;
	h_->child = NULL;
	h_->sibling = NULL;
	h_->degree = 0;
	*h = binomial_heap_union(*h, h_);
}

Bh_node *remove_min_list(Bh_node *h){
	Bh_node *min = binomial_heap_minimum(h); 
	Bh_node *prev = NULL;
	Bh_node *x = h;
	while(x != min){
		prev = x;
		x = x->sibling;
	}

	prev->sibling = x->sibling;
	return min;
}

Bh_node *reverse_list(Bh_node *h){
	
}

Bh_node *binomial_heap_extract_min(Bh_node **h){
	Bh_node *x = remove_min_list(h);

	Bh_node *y = reverse_list(x->child);

	*h = binomial_heap_union(*h, y);
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

int main(){
	Binomial_heap bh;
	bh.first = (Bh_node*) malloc(sizeof(Bh_node));
	bh.first->key = 5;
	bh.first->key = 0;
	bh.first->child = NULL;
	bh.first->sibling = NULL;
	bh.first->parent = NULL;

	return 0;
}

