#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <stdbool.h>
#include <time.h>

#define SIZEOF(arr) sizeof(arr) / sizeof(arr[0])


int random_int(int from , int to){
   return from + (rand() % (to - from + 1));
}

typedef struct node{
	int key;
	struct node *left;
	struct node *right;
	struct node *child;
	int degree;
	bool mark;
	struct node *p;
}Tree;

typedef struct{
	Tree *min;
	int n;
}Heap;

void connect_after(Tree* x, Tree* y){
	y->left = x;
	y->right = x->right;
	if(x->right) x->right->left = y;
	x->right = y;
	if(x->left == x) x->left = y;
}

void set_min_tree(Heap *h, Tree* t) { if(h->min->key > t->key) h->min = t;};

void insert(Heap* heap, int key){
	Tree *tree = (Tree*) malloc(sizeof(Tree));
	tree->key = key;
	tree->left = tree;
	tree->right = tree;
	tree->child = NULL;
	tree->degree = 0;
	tree->mark = false;
	tree->p = NULL;
	if(heap->min == NULL){
		tree->left = tree;
		tree->right = tree;
		heap->min  = tree;
	}else connect_after(heap->min, tree);
	set_min_tree(heap, tree);
	heap->n++;
	
}

void connect(Tree* t1, Tree *t2){
	if(!t1 || !t2) return;
	Tree* r_t1 = t1->right;
	Tree* last_t2=  t2->left;
	r_t1->left = last_t2;
	last_t2->right = r_t1;
	t1->right = t2;
	t2->left = t1;
}

Heap* heap_union(Heap* h1, Heap* h2){
	connect(h1->min, h2->min);
	Heap* new_heap = (Heap*) malloc(sizeof(Heap));
	new_heap->min = h1->min > h2->min ? h2->min : h1->min;
	new_heap->n = h1->n + h2->n;
	return new_heap;
}

void delete_tree(Tree* t){
	t->left->right = t->right;
	t->right->left = t->left;
}


void heap_link(Heap *h, Tree* y, Tree* x){
	delete_tree(y);
	if(x->child) connect_after(x->child, y);
	else{
		x->child = y;
		y->left = y;
		y->right = y;
	}
	x->degree++;
	y->mark = false;

}

void consolidate(Heap *h){
	Tree** A = (Tree**) malloc(sizeof(Tree*) *  (h->n + 1));
	for(int i = 0; i < h->n+1;i++) A[i] = NULL;
	Tree *tt = h->min->right;	
	int n_roots = 1;
	while(tt != h->min){
		n_roots++;
		tt = tt->right;
	}
	bool first_iter = true;
	Tree* w = h->min;
	for(int i = 0; i < n_roots; i++){
		first_iter = false;
		Tree* x = w;
		int d = w->degree;	
		Tree* nxt =  w->right;
		while(A[d]){
			Tree* y = A[d];
			if(x->key > y->key){
				Tree *tmp = x;
				x = y;
				y = tmp;
			}
			heap_link(h, y, x);
			A[d] = NULL;
			d++;
		}
		A[d] = x;
		w = nxt;
	}
	h->min = NULL;
	Tree* first = NULL;
	Tree* prev = NULL;
	first_iter = true;
	for(int i = 0; i < h->n + 1;i++){
		if(A[i]){
			if(first_iter){
				first = A[i];
				first_iter = false;
				h->min =  A[i];
				A[i]->left = A[i];
				A[i]->right = A[i];
			}else{
				if(h->min->key > A[i]->key) h->min = A[i];
				prev->right = A[i];
				A[i]->left = prev;
			}
			prev = A[i];
		}
	}
	first->left = prev;
	prev->right = first;
}

void print_tree(Tree *tree){
	Tree *act = tree;	
	bool ft = true;
	while(act != tree || ft){
		printf(" %d", act->key);
		ft = false;
		if(act->child) print_tree(act->child);
		act = act->right;
	}

}

void print_roots(Heap *h){
	Tree* t = h->min;
	bool ft = true;
	printf("\n-----------\n");
	while((t != h->min || ft) && h->n > 0){
		printf("root key: %d ", t->key);
		if(t->child) print_tree(t->child);
		printf("\n");
		t = t->right;
		ft = false;
	}
	printf("-----------\n");
}

int extract_min(Heap* h){
	Tree* z = h->min;
	connect(z->child, h->min);
	delete_tree(h->min);
	int k = h->min->key;
	Tree* z_r  = z->right;
	free(h->min);
	h->min = z_r != z ? z_r : NULL;
	h->n--;
	if(h->n > 0) consolidate(h);
	return k;
}

#define num_insert_operation 10000
#define num_extract_operation 10000

#define key_min 0
#define key_max 10000

int main(){
	
	time_t t;
   srand((unsigned) time(&t));

	Heap heap;
	heap.min = NULL;
	heap.n = 0;

	clock_t start = clock();
	for(int i = 0; i < num_insert_operation; i++){
		insert(&heap, random_int(key_min,key_max));
	}

	for(int i = 0; i < num_extract_operation; i++){
	    extract_min(&heap);
	}
	print_roots(&heap);

   clock_t end = clock();
   float seconds = (float)(end - start) / CLOCKS_PER_SEC;
   printf("Insert operations: %d\nExtract operations: %d\nTime needed: %f\n", num_insert_operation, num_extract_operation, seconds);

	return 0;
}


