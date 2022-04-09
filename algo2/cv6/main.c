#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node{
	int data;
	struct node *next;
}Node;

typedef struct{
	Node *item;
} list;



typedef struct br{
		int  data;
		struct br *left;
		struct br *right;
		struct br *parent; 
		int bf;

}Branch;

typedef struct{
	Branch *root;

}Tree;



void print_in_order_help(Branch *branch){
	if(branch){
		print_in_order_help(branch->left);
		printf("{val: %d bf: %d}, ", branch->data, branch->bf);
		print_in_order_help(branch->right);
	}
}

void print_in_order(Tree t){
	Branch *branch = t.root;
	print_in_order_help(branch);
	printf("\n");
}

int depth_help(Branch *branch, int depth){
	if(branch){
		int l = depth_help(branch->left, depth + 1);
		int r = depth_help(branch->right, depth + 1);
		if(l > r) return l;
		return r;
	}else{
		return depth;
	}
}

int depth(Tree t){
	Branch *branch = t.root;
	return depth_help(branch, 0) - 1;
}

int tree_min(Branch *root){
	if(root->left){
		return tree_min(root->left);
	}
	return root->data;
}

int tree_max(Branch *root){
	if(root->right){
		return tree_max(root->right);
	}
	return root->data;
}

void branch_swap(Tree *t, Branch *u, Branch *v){
	if(v->left && v->parent){
		if(v->parent == u){	
			v->parent->left = v->left;
		}else{
			v->parent->right = v->left;
		}	
		v->left->parent  = v->parent;
	}else if(v->right && v->parent){
		if(v->parent == u){
			v->parent->right = v->right;
		}else{
			v->parent->left = v->right;
		}
		v->right->parent = v->parent;
	}
	if(u->left && u->left != v){
		v->left = u->left;
		u->left->parent = v;
	}
	if(u->right && u->right != v){
		v->right = u->right;
		u->right->parent = v;
	}
	if(!u->parent) {
		t->root = v;
		return;
	}
	if(u->parent->left == u){
		free(u->parent->left);
		u->parent->left = v;
	}else{
		free(u->parent->right);
		u->parent->right = v;
		v->parent = u->parent;
	}
}

int tree_remove(Tree *t, int data){
	Branch *root = t->root;
	Branch *parent = NULL;
	while(root && root->data != data){
		parent = root;
		if(root->data > data){
			root = root->left;
		}else{
			root = root->right;
		}
	}

	if(!root) return 0;
	Branch *new_root = NULL;
	if(root->left != NULL){
		new_root = root->left;
		while(new_root->right){
			new_root = new_root->right;
		}
	}else if(root->right != NULL){
		new_root = root->right;
		while(new_root->left){
			new_root = new_root->left;
		}
	}else{
		if(root->parent->left == root) {
			free(root->parent->left);
			root->parent->left = NULL;
		}else{
			free(root->parent->right);
			root->parent->right = NULL;
		}
		return 1;
	}
	branch_swap(t, root, new_root);	
	return 1;
}

typedef struct {
	int head;
	int tail;
	int length;
	Branch *data[];
}queue;

int empty(queue *fronta){
	return fronta->head == fronta->tail;
}

int full(queue *fronta){
	return (fronta->tail + 1) % fronta->length == fronta->head;
}

void enqueue(queue *fronta, Branch *data){
	fronta->data[fronta->tail] = data;
	fronta->tail = (fronta->tail + 1) % fronta->length;
}

Branch *dequeue(queue *fronta){
	Branch *data = fronta->data[fronta->head];
	fronta->head = (fronta->head + 1) % fronta->length;
	return data;
}


void print_bft(Tree *t){	
	queue *fronta =  malloc(sizeof(queue) + 30 * sizeof(Branch));
	fronta->tail = 0;
	fronta->head = 0;
	fronta->length = 30;
	enqueue(fronta, t->root);
	while(!empty(fronta)){
		Branch *branch = dequeue(fronta);
		printf("%d, ", branch->data);
		if(branch->left) enqueue(fronta, branch->left);
		if(branch->right) enqueue(fronta, branch->right);
	}
	printf("\n");
	free(fronta);
}

int height(Branch *root){
	if(!root) return 0;
	return 1 + height(root->parent);
}

void print_visual_help(Branch *branch, int arr[], int n, int i, int pos, int slash_pos, int f_slash, int b_slash){
	if(branch){
		printf("i: %d", pos);
		arr[pos - 1] = branch->data;
		if(i >1){
			if(slash_pos < 0) arr[-1 * slash_pos -1] = f_slash;
			else arr[slash_pos - 1] = b_slash;
		}
		int new_dir = ((n / ( 1 << i)) + 2 - 1) / 2;
		int new_slash_dir = (new_dir  + 2 - 1) / 2;
		//int new_slash_dir = (new_dir) / 2;
		print_visual_help(branch->left, arr, n, i + 1, pos  + 2 * n - new_dir, -1 *(pos + n - new_slash_dir), f_slash, b_slash);
		print_visual_help(branch->right, arr, n, i + 1, pos  + 2 * n + new_dir , pos + n + new_slash_dir, f_slash, b_slash );
	}
}

void print_visual(Tree *t, int size){
	Branch *branch = t->root;
	int dpth = depth(*t) ;
	int n = 1 << dpth;
	n *=size;
	int len  = (n * (2 *(dpth + 1)));
	int *a = malloc(len  * sizeof(int) );
	int f_slash = tree_min(branch) - 1;
	int b_slash = tree_max(branch) + 1;
	printf("flsash:%d \n", f_slash);
	for(int k = 0; k < len; k++){ a[k] = f_slash -1;}
	print_visual_help(branch, a, n, 1, n/2, 0, f_slash, b_slash);
	printf("\nstart\n");
	for(int k = 0; k < len; k++){
		if(a[k] == f_slash - 1 ) printf(" ");
		else if(a[k] == f_slash) printf("/");
		else if(a[k] == b_slash) printf("\\");
		else printf("%d", a[k]);	
		//printf("%d", a[k]);
		if((k + 1) % n == 0 && k !=0) {
			printf("\n");
		}
	}
	printf("end\n");
	printf("\n");
	free(a);
}

void print_bft_v(Tree *t){
	int dpth = depth(*t) ;
	int n = 1 << dpth;
	int len  = (n * (dpth + 1));
	printf("%d", len);
	int *a = malloc(len  * sizeof(int) );
	for(int k = 0; k < len; k++){ a[k] = 0;}
	queue *fronta =  malloc(sizeof(queue) + 30 * sizeof(Branch));
	fronta->tail = 0;
	fronta->head = 0;
	fronta->length = 30;
	enqueue(fronta, t->root);
	int i=1;
	int j = 0;
	a[ n / 2 - 1] = t->root->data;
	while(!empty(fronta)){
		Branch *branch = dequeue(fronta);
		//printf("bzz %d\n", depth_help(branch, i - 2));
		if( i  != height(branch)){
			printf("i: %d curr: %d", i, branch->data);
			i++;
			j = 0;
		}
		//printf("%d, ", branch->data);
		int incf = 0;
		int branch_space = n / ( 1 << i); 
		j += branch_space;
		if(branch->left){
			enqueue(fronta, branch->left);
			//a[n * i + 1 + (n / (i+ 1)) * (j + 1)] = branch->left->data + '0';
			a[n* i + j - (int)(branch_space + 2 -1) / 2 - 1] =  branch->left->data;
		}
		if(branch->right){
			enqueue(fronta, branch->right);
			//a[n * i + 1 + (n / (i + 1)) * (j + 1) + 1] = branch->right->data + '0'; 
			a[n* i + j +  (int)(branch_space + 2 - 1) / 2 - 1] = branch->right->data;
		}
		j +=branch_space;
	}
	//a[len] = '\0';
	printf("\nstart\n");
	for(int k = 0; k < len; k++){	
		printf("%d", a[k]);	
		if((k + 1) % n == 0) {
			printf("\n");
		}
	}
	printf("end\n");
	printf("\n");
	free(fronta);
}

void update_bf(Branch *root){
	if(root->left) update_bf(root->left);
	if(root->right) update_bf(root->right);

	root->bf =  depth_help(root->left, -1) - depth_help(root->right, -1);	
}

Branch* rotate_right(Branch *root){
	Branch *x = root->left;
	Branch *b = x->right;
	
	//set-left-child(r, B);
	root->left = b;
	if(b) b->parent = root;
	
	//set_right-child(x, r);
	x->right = root;
	root->parent = x;
	return x;
}

Branch* rotate_left(Branch *root){
	Branch *x = root->right;
	Branch *b = x->left;
	
	//set-left-child(r, B);
	root->right = b;
	if(b) b->parent = root;
	
	//set_right-child(x, r);
	x->left = root;
	root->parent = x;
	return x;
}

void complete_rotation(Tree *t, Branch *branch, Branch *parent){
	if(!parent) t->root = branch;
	else if(parent->left && (parent->left == branch->left || parent->left == branch->right)){printf("barbell\n"); parent->left = branch;}
	else if(parent->right && (parent->right == branch->left || parent->right == branch->right)){printf("suzuko\n"); parent->right = branch;} 
	branch->parent = parent;
}

void repair_bf(Tree* t, Branch* v_, Branch *u_){
	Branch* v = v_;
	Branch* u  = u_;
	while(u){
		if(v == u->left) u->bf +=1;
		else u->bf -=1;
		
		if(u->bf == 0) break;
		Branch *p = u->parent;
		Branch *w = NULL;
		if(u->bf == 1 || u->bf == -1){
			v = u;
			u = u->parent;
			continue;
		}
		else if(u->bf == 2 && (v->bf == 1 || v->bf == 0)) {w = rotate_right(u); complete_rotation(t, w, p);}
		else if(u->bf == -2 && (v->bf == -1 || v->bf == 0)) {w = rotate_left(u); complete_rotation(t, w, p);}
		else if(u->bf == 2 && v->bf == -1){
			//printf("bb\n");
			w = rotate_left(v);
			complete_rotation(t, w, u);
			w = rotate_right(u);
			complete_rotation(t, w, p);
		}else if(u->bf == -2 && v->bf == 1){
			//printf("%d\n", v->data);
			Branch* v_w = rotate_right(v);
			//printf("sik: %p\n", u->right);
			complete_rotation(t, v_w, u);
			w = rotate_left(u);
			//printf("suka\n");
			//printf("pointers: %p %p\n", w, p);
			complete_rotation(t, w, p);
		}
		//printf("data:cur: %d\n", v_->data);
		//printf("root: %p\n", t->root->right);
		update_bf(t->root);
		//print_visual(t, 2);
		//print_in_order(*t);
		//printf("bff: %p %p\n", w, p);
		v = w;
		u = p;
	}
	print_visual(t, 2);
	print_in_order(*t);
	printf("cola\n");
}


void tree_add(Tree *t, int data){
	Branch *branch = t->root;
	Branch *parent = NULL;
	Branch *new_branch = (Branch*) malloc(sizeof(Branch));
	new_branch->bf = 0;
	new_branch->data = data;
	while(branch){
		parent = branch;
		if(new_branch->data < branch->data){
			branch = branch->left;	
		}else{
			branch = branch->right;
		}	
	}
	new_branch->parent = parent;
	if(!parent){
		t->root = new_branch;
	}else if(new_branch->data < parent->data){
		parent->left = new_branch;	
	}else{
		parent->right = new_branch;
	}
	print_visual(t, 2);
	printf("er: %d %d\n", parent ? parent->data : 0, data);
	repair_bf(t, new_branch, parent);
}

int main(){
	

	Tree tree ={NULL};
	tree_add(&tree, 5);
	tree_add(&tree, 8);
	tree_add(&tree, 7);
	tree_add(&tree, 3);
	tree_add(&tree, 12);
	tree_add(&tree, 18);
	tree_add(&tree, 1);	
	//print_bft_v(&tree);
	printf("Tree depth: %d\n", depth(tree));
	printf("Maximum stromu: %d\n", tree_max(tree.root));
	printf("Mininum  stromu: %d\n", tree_min(tree.root));
	//printf("Remove branch %d\n", tree_remove(&tree, 1));
	//update_bf(tree.root);
	//Branch *new  =rotate_left(tree.root->right);
	//complete_rotation(&tree,new,tree.root);
	//print_visual(&tree, 2);
	//printf("ggs: %d %p %d\n", tree.root->right->parent->data, tree.root->right->left, tree.root->right->left->parent->data);
	//return 0;
	//update_bf(tree.root);
	//print_in_order(tree);

	// bf add test
	tree_add(&tree, 9);
	print_visual(&tree, 2);
	print_in_order(tree);

	tree_add(&tree, 1);
	print_visual(&tree, 2);
	print_in_order(tree);
	
	tree_add(&tree, 0);
	print_visual(&tree, 3);
	print_in_order(tree);
	return 0;
	
}
