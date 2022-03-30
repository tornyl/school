#include <stdio.h>
#include <stdlib.h>


typedef struct node{
	int data;
	struct node *next;
}Node;

typedef struct{
	Node *item;
} list;



typedef struct {
	//Node *left;
	//Node *right;
}Child;

typedef struct br{
		int  data;
		struct br *left;
		struct br *right;
		struct br *parent; 

}Branch;

typedef struct{
	Branch *root;

}Tree;


void tree_add(Tree *t, int data){
	Branch *branch = t->root;
	Branch *parent = NULL;
	Branch *new_branch = (Branch*) malloc(sizeof(Branch));
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
}

void print_in_order_help(Branch *branch){
	if(branch){
		print_in_order_help(branch->left);
		printf("%d, ", branch->data);
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

int main(){
	

	Tree tree ={NULL};
	tree_add(&tree, 5);
	tree_add(&tree, 8);
	tree_add(&tree, 3);
	tree_add(&tree, 12);
	tree_add(&tree, 18);
	tree_add(&tree, 1);	
	print_in_order(tree);
	printf("Tree depth: %d\n", depth(tree));
	printf("Maximum stromu: %d\n", tree_max(tree.root));
	printf("Mininum  stromu: %d\n", tree_min(tree.root));
	printf("Remove branch %d\n", tree_remove(&tree, 1));
	print_in_order(tree);
	print_bft(&tree);
	return 0;
	
}
