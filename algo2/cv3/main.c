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

void add_start(list* seznam, Node* uzel){
	uzel->next = seznam->item;
	seznam->item = uzel;

}

void add_end(list* seznam, Node* uzel){
	Node *head = seznam->item;
	while(head->next) {head = head->next;};
	head->next = uzel;

}

void add_position(list* seznam, Node* uzel, int position){
	if(position > length(*seznam)){
		add_end(seznam, uzel);
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
		seznam->item = seznam->item->next;
		return 0;
	}else{	
		return -1;
		}
}

int remove_end(list* seznam){
	if(seznam){
		Node* head = seznam->item;
		while(head->next->next) head = head->next;
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
				seznam->item = head->next;
				return 0;
			}
			if(head->next == uzel){
				head->next = head->next->next;
				return 0;
			}
			head = head->next;
		}

	}

	return -1;
}

int main(){
	
	Node nodes[] = {{5,NULL}, {3,NULL}, {8,NULL}, {1, NULL},{7, NULL}, {12,NULL}};
	list seznam  = {&nodes[0]};
	seznam.item->next = &nodes[1];
	
	printf("%d\n", length(seznam));
	print_list(seznam);
	
	add_start(&seznam, &nodes[2]);
	print_list(seznam);

	add_end(&seznam, &nodes[4]);
	print_list(seznam);

	add_position(&seznam, &nodes[5], 2);
	print_list(seznam);

	remove_start(&seznam);
	print_list(seznam);

	remove_end(&seznam);
	print_list(seznam);

	printf("pos: %d\n", search(&seznam, &nodes[1]));

	remove_node(&seznam, &nodes[5]);
	print_list(seznam);

	return 0;

}
