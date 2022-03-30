#include <stdio.h>
#include <stdlib.h>


typedef struct node{
	int data;
	struct node *next;
}Node;

typedef struct{
	Node *item;
} list;


int length(list seznam){
	int len = 0;	
	while(seznam.item){
		seznam.item = seznam.item->next;
		len ++;
	}
	return len;
}

void print_list(list seznam){
	while(seznam.item){
		printf("%d, ", seznam.item->data);
		seznam.item =  seznam.item->next;
	}

	printf("\n");

}

void add_start(list* seznam, int value){
	Node *uzel =  (Node*) malloc(sizeof(Node));
	uzel->data = value;
	uzel->next = seznam->item;
	seznam->item = uzel;

}


void add_end(list* seznam, int value){
	Node *uzel = (Node*) malloc(sizeof(Node));
	uzel->data = value;
	Node *head = seznam->item;
	while(head->next) {head = head->next;};
	head->next = uzel;

}

void add_position(list* seznam, int value, int position){
	Node *uzel = (Node*) malloc(sizeof(Node));
	uzel->data = value;
	if(position > length(*seznam)){
		add_end(seznam, value);
		return;
	}
	Node *head = seznam->item;
	if(position == 0){
		uzel->next = head;
		seznam->item = uzel;
		return;
	}
	while((position - 1 > 0)){
		head =  head->next;
		position --;
	}
	uzel->next = head->next;
	head->next = uzel;
}

int remove_start(list* seznam){
	if(seznam){
		Node *next = seznam->item->next;
		free(seznam->item);
		seznam->item = next;
		return 0;
	}else{	
		return -1;
		}
}

int remove_end(list* seznam){
	if(seznam){
		Node* head = seznam->item;
		while(head->next->next) head = head->next;
		free(head->next);
		head->next = NULL;
		return 0;
	}
	
	return -1;
}

int search(list* seznam, Node* uzel){
	Node* head = seznam->item;
	int position = 0;
	if(seznam){
		while(head){
			if(head == uzel) return position;
			position ++;
			head = head->next;
		}
		//return position;

	}

	return -1;

}

int remove_node(list* seznam, Node* uzel){
	Node* head = seznam->item;
	if(seznam){
		while(head){
			if(head == uzel){
				free(seznam->item);
				seznam->item = head->next;
				return 0;
			}
			if(head->next == uzel){
				Node *n = head->next->next;
				free(head->next);
				head->next = n;
				return 0;
			}
			head = head->next;
		}

	}

	return -1;
}

int remove_data(list *seznam, int data){
	Node *head = seznam->item;
	if(seznam){
		while(head){
			if(head->data == data){
				free(seznam->item);
				seznam->item = head->next;
				return 0;
			}
			if(head->next->data == data){
				Node *n  =head->next->next;
				head->next = n;
				return 0;
			}
			head = head->next;
		}

	}

	return -1;
}

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


int main(){
	
	Node nodes[] = {{5,NULL}, {3,NULL}, {8,NULL}, {1, NULL},{7, NULL}, {12,NULL}};
	Node *first_node = (Node*) malloc(sizeof(Node));
	first_node->data = 5;
	list seznam  = {first_node};
	seznam.item->next = &nodes[1];
	
	printf("%d\n", length(seznam));
	print_list(seznam);
	
	add_start(&seznam, 6);
	print_list(seznam);

	add_end(&seznam, 4);
	print_list(seznam);

	add_position(&seznam, 8, 2);
	print_list(seznam);

	remove_start(&seznam);
	print_list(seznam);

	remove_end(&seznam);
	print_list(seznam);

	printf("pos: %d\n", search(&seznam, &nodes[1]));

	//remove_node(&seznam, &nodes[5]);
	remove_data(&seznam, 8);
	print_list(seznam);

	Tree tree ={NULL};
	tree_add(&tree, 5);
	tree_add(&tree, 8);
	tree_add(&tree, 3);
	tree_add(&tree, 12);
	tree_add(&tree, 18);
	tree_add(&tree, 1);	
	print_in_order(tree);
	printf("Tree depth: %d\n", depth(tree));
	return 0;
	
}
