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

void binomial_heap_insert(Bh_node** h, int x){
	Bh_node *h_ = (Bh_node *) malloc(sizeof(Bh_node));
	h_->key = x;
	h_->parent = NULL;
	h_->child = NULL;
	h_->sibling = NULL;
	h_->degree = 0;
	*h = binomial_heap_union(*h, h_);
}


Bh_node* binomial_heap_insert2(Bh_node** h, int x){
	Bh_node *h_ = (Bh_node *) malloc(sizeof(Bh_node));
	h_->key = x;
	h_->parent = NULL;
	h_->child = NULL;
	h_->sibling = NULL;
	h_->degree = 0;
	*h = binomial_heap_union(*h, h_);
    return h_; 
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

Bh_node *binomial_heap_extract_min(Bh_node **h){
	Bh_node *x = remove_min_list(*h);
	if( *h == x) *h = x->sibling;
	printf("min: %i\n", x->key);

	delete_parent(x->child);
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



void print_heap_rec(Bh_node *h){
	Bh_node *x = h;
	while(x){
		if(!x->parent) {printf("\n");}
		printf("  %i", x->key);
		print_heap_rec(x->child);
		x = x->sibling;
	}
}


void find(Bh_node *h,int val, Bh_node **h_p){
	Bh_node *x = h;
	while(x){
        if(x->key == val){
            
            *h_p = x;
            return;
        }
		find(x->child, val, h_p);
		x = x->sibling;
	}
}

void print_heap(Bh_node *h){
	print_heap_rec(h);
	//printf("end\n");
	printf("\nend\n");
}

int main(){
	Binomial_heap bh;
	bh.first = (Bh_node*) malloc(sizeof(Bh_node));
	bh.first->key = 12;
	bh.first->degree = 0;
	bh.first->child = NULL;
	bh.first->sibling = NULL;
	bh.first->parent = NULL;

	Bh_node* to_del = binomial_heap_insert2(&bh.first, 5);
	print_heap(bh.first);
	binomial_heap_insert(&bh.first, 3);
	print_heap(bh.first);
	binomial_heap_insert(&bh.first, 4);
	print_heap(bh.first);
	binomial_heap_insert(&bh.first, 8);
	print_heap(bh.first);
	binomial_heap_insert(&bh.first, 1);
	print_heap(bh.first);

	Bh_node *min = binomial_heap_extract_min(&bh.first);
	printf("min: %i\n",min->key);
	print_heap(bh.first);
	min = binomial_heap_extract_min(&bh.first);
	printf("min: %i\n",min->key);
	print_heap(bh.first);
	binomial_heap_insert(&bh.first, 1);
	binomial_heap_insert(&bh.first, 2);
	binomial_heap_insert(&bh.first, 1);
	binomial_heap_insert(&bh.first, 4);
	binomial_heap_insert(&bh.first, 39);
	binomial_heap_insert(&bh.first, 22);
	binomial_heap_insert(&bh.first, 3);
	print_heap(bh.first);
	min = binomial_heap_extract_min(&bh.first);
	print_heap(bh.first);
	min = binomial_heap_extract_min(&bh.first);
	print_heap(bh.first);
	min = binomial_heap_extract_min(&bh.first);
	print_heap(bh.first);
	min = binomial_heap_extract_min(&bh.first);
	min = binomial_heap_extract_min(&bh.first);

	print_heap(bh.first);

    //binomial_heap_decrease_key(bh.first, to_del, 1 );

	print_heap(bh.first);
    Bh_node ** h_p;;
    find(bh.first, 5, h_p);
    if(h_p) printf("here");
    printf("x %d\n", (*h_p)->key);

	return 0;
}

