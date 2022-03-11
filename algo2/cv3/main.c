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

//zasobnik
typedef struct node_{
	int data;
	struct node_ *next;
	struct node_ *previous;
}stack_node;
typedef struct{
	stack_node *uzel;
	}stack;

void push(stack *seznam, stack_node *uzel){
	if(!seznam->uzel){
		seznam->uzel = uzel;
		return;
	}
	seznam->uzel->next = uzel;
	uzel->previous = seznam->uzel;
	seznam->uzel = uzel;	
}

stack_node* pop(stack *seznam){
	stack_node *pop_node = seznam->uzel;
	seznam->uzel = seznam->uzel->previous;
	seznam->uzel->next = NULL;
	return pop_node;
}
typedef struct {
	int head;
	int tail;
	int length;
	Node *data[];
}queue;

int empty(queue *fronta){
	return fronta->head == fronta->tail;
}

int full(queue *fronta){
	return (fronta->tail + 1) % fronta->length == fronta->head;
}

void enqueue(queue *fronta, Node *data){
	fronta->data[fronta->tail] = data;
	fronta->tail = (fronta->tail + 1) % fronta->length;
}

Node *dequeue(queue *fronta){
	Node *data = fronta->data[fronta->head];
	fronta->head = (fronta->head + 1) % fronta->length;
	return data;
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
	stack_node uzly[] = {{3, NULL, NULL}, {4, NULL, NULL}, {12, NULL, NULL}, {5, NULL, NULL}, {3, NULL, NULL}};	
	stack stack_seznam;
	stack_seznam.uzel = NULL;
	push(&stack_seznam, &uzly[1]);
	push(&stack_seznam, &uzly[0]);
	push(&stack_seznam, &uzly[3]);
	push(&stack_seznam, &uzly[2]);
	stack_node *pop_node = pop(&stack_seznam);
	printf("uzel s hodnotou: %d\n", pop_node->data);	
	pop_node = pop(&stack_seznam);
	printf("uzel s hodnotou: %d\n", pop_node->data);
	
	int queue_length = 20;
	queue *fronta = malloc(sizeof(queue) + queue_length * sizeof(Node*));
	fronta->tail = 0;
	fronta-> head = 0;
	fronta->length = queue_length;
	enqueue(fronta, &nodes[1]);
	enqueue(fronta, &nodes[0]);
	enqueue(fronta, &nodes[4]);
	enqueue(fronta, &nodes[3]);
	Node *dequeued_node = dequeue(fronta);
	printf("uzel z fronty s hodnotou: %d\n", dequeued_node->data);
	dequeued_node = dequeue(fronta);
	printf("uzel z fronty s hodnotou: %d\n", dequeued_node->data);
	return 0;

}
