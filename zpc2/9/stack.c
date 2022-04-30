#include <stdlib.h>
typedef struct Node_{
	char bracket;
	struct Node_* prev;
}Node;
typedef struct{
	Node* node;
}Stack;
void Push(Stack stack, char bracket){
	Node *node = (Node*) malloc(sizeof(Node));
	if(stack.node) node->prev = stack.node;
	stack.node = node;
}
char Pop(Stack stack){
	if(stack.node){
		char  mychar = stack.node->bracket;
		Node *node  = stack.node->prev;
		free(stack.node);
		stack.node =  node;
		return mychar;
	}else return 0;
}
