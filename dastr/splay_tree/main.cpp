#include <iostream>
#include <math.h>
#include <vector>
#include <iomanip>

using namespace std;

struct Node{
    int key;
    int value;
    Node* left;
    Node* right;
    Node* parent;


};


struct Tree{
    Node *root;
    int num_nodes;
};


void rotateL(Node* x){
    
    if(x->right == nullptr){
        return;
        //cerr<< "cannot make this rotation" <<endl;
    }
    
    Node *p = x->parent;
    Node *x_right = x->right;
    Node *x_right_left = nullptr;
    if(x->right->left) x_right_left = x->right->left;

    //connect parent to new x_right;
   

    x_right->parent = p;
    if(p){
        if( x == p->left) p->left = x_right;
        else p->right = x_right;
    }


    // set new parent for x
    
    x->parent = x_right;

    x_right->left = x; 
    x->right = x_right_left;
    if(x_right_left) x_right_left->parent = x;

}


void rotateR(Node* x){
    

    if(x->left == nullptr){
        return;
        //cerr<< "cannot make this rotation" <<endl;
    }

    Node *p = x->parent;
    Node *x_left = x->left;
    Node *x_left_right = nullptr;
    if(x->left->right) x_left_right = x->left->right;

    //connect parent to new x_right;
   

    x_left->parent = p;
    if(p){
        if( x == p->left) p->left = x_left;
        else p->right = x_left;
    }


    // set new parent for x
    
    x->parent = x_left;

    x_left->right = x; 
    x->left = x_left_right;
    if(x_left_right) x_left_right->parent = x;

}

void zigR(Node* x){
    rotateR(x->parent);
}

void zigL(Node* x){
    rotateL(x->parent);
}

void zigZagLR(Node* x){
    rotateL(x->parent);
    rotateR(x->parent);
}

void zigZagRL(Node* x){
    rotateR(x->parent);
    rotateL(x->parent);
}

void zigZigR(Node* x){
    rotateR(x->parent->parent);
    rotateR(x->parent);
}

void zigZigL(Node* x){
    rotateL(x->parent->parent);
    rotateL(x->parent);
}

void splay(Node *x){
    while(x->parent){
        if(x->parent->parent){
            Node *p = x->parent;
            Node *pp = x->parent->parent;
            
            if(p == pp->left){
                if( x == p->left){
                    zigZigR(x);
                }else{
                    //cout<<x->key<<endl;
                    //cout<<x->parent->key<<endl;
                    //cout<<x->parent->parent->key<<endl;
                    //cout<<"hehe 1"<<endl;
                    zigZagLR(x);
                }

            }else{ // p == pp->right
                if( x == p->right){
                   zigZigL(x); 
                }else{
                    zigZagRL(x);
                }
            }
        }else{
            if(x == x->parent->left) zigR(x);
            else zigL(x);
        }
    }
}

Node* searchNodes(Node* x, int key){
    if(x->key == key) {
        splay(x);

        return x;
    }else if(key > x->key){
        if(x->right) return searchNodes(x->right, key);
        else{
           splay(x); 
            return x;
        }
    }else{
        if(x->left) return searchNodes(x->left, key);
        else{
            splay(x); 
            return x;
        } 
    }
}


Node* search(Tree* t,int key){
    if(!t->root) return nullptr;
    Node *x = searchNodes(t->root, key);
    if(x) t->root = x;
    if(x->key == key) return x;
    else return nullptr;
}

void insert(Tree* t, int key){
    Node *prev = nullptr; 
    Node *x = t->root;
    while(x){
        prev = x;
        if(x->key == key) return;
        else if(key > x->key) x = x->right;
        else x =  x->left;
    }
    t->num_nodes++;
    

    Node* new_node = new Node();
    new_node->key = key;
    new_node->parent = prev;
    new_node->left = nullptr;
    new_node->right = nullptr;
    if(!prev) t->root = new_node;
    else{
        if(key > prev->key)prev->right = new_node;
        else prev->left = new_node;
        
        cout<<"prev key "<< prev->key<<endl;
    }
    t->root = new_node;
    cout<<"hehe"<<endl;
    splay(new_node);
}

Node *findMax(Node *x){
    if(x->right) return findMax(x->right);
    else return x;
}

void deleteNode(Tree* t, int key){
    if(!t->root){
        cout<<"cannot delete this item"<<endl;
        return;
    }
    Node *x = t->root; 
    while(x){
        if(x->key == key) break;
        else if(key > x->key) x = x->right;
        else x =  x->left;
    }
    if(x){ 
        if(x->key == 4){
            cout<<"yeey"<<endl;
            //cout<<x->parent->parent->parent->parent->right->key<<endl;
        }
        splay(x);
        //cout<<"hou "<<x->parent->key<<endl;
        cout<<"hou "<<x->left->parent->key<<endl;
        if(x->left){
            x->left->parent = nullptr;
            if(x->right) x->right->parent = nullptr;
            Node *max = findMax(x->left);
            //cout<<"here "<<max->key<<endl;
            //cout<<"here "<<max->parent->key<<endl;
            
            splay(max);
            max->right = x->right;
            if(x->right) x->right->parent = max;
            //if(x->left) x->left->parent = max;
            t->root = max;
        }else if(x->right){
            x->right->parent = nullptr;
            t->root = x->right;
        }else{
            t->root = nullptr;
        }
        delete x;
    }else{
        cout<<"key not found hehes"<<endl;
    }

}

Node* makeNode(int key){
    Node* node = new Node();
    node->key = key;
    node->parent = nullptr;
    node->left = nullptr;
    node->right = nullptr;
    
    return node;

}

void printTree(Tree *tree){
   int space = pow(2, tree->num_nodes);  
    
    vector<Node*> stack;
    stack.push_back(tree->root);
    while(!stack.empty()){
        vector<Node*> layer = stack;
        stack.clear();
        for(Node* node : layer){
            for(int i = 0; i < space; i++) cout<<" ";
            cout<<node->key;
            if(node->left) stack.push_back(node->left);
            if(node->right) stack.push_back(node->right);
        }
        space = round(space / 2);
        cout<<endl;
    }


}

int main(){
    
    Tree t= {nullptr, 0};

    //t.root = makeNode(5);
    //t.root->left = makeNode(3);
    //t.root->right = makeNode(4);

    //Node* left = t.root->left;
    //Node* right = t.root->right;
    //left->left = makeNode(1);
    //left->right = makeNode(2);
    //left->left->parent = left;
    //left->right->parent = left;
    //right->left = makeNode(6);
    //right->right = makeNode(7);
    //right->left->parent = right;
    //right->right->parent = right;

    //t.root->left->parent = t.root;
    //t.root->right->parent = t.root;
    //t.num_nodes = 3;

    insert(&t, 1);
    printTree(&t);
    insert(&t, 5);
    printTree(&t);
    insert(&t, 12);
    printTree(&t);
    insert(&t, 3);
    printTree(&t);
    insert(&t, 18);
    printTree(&t);
    insert(&t, 4);
    printTree(&t);

    Node *n = search(&t, 5); 
    if(n) cout<<"found key "<<n->key<<endl;
    printTree(&t);
    n = search(&t, 12);
    if(n) cout<<"found key "<<n->key<<endl;
    printTree(&t);
    n = search(&t, 18);
    if(n) cout<<"found key "<<n->key<<endl;
    printTree(&t);
    //insert(&t, 4);

    deleteNode(&t, 3);
     printTree(&t);

    //if(!t.root->parent) cout<<"bugas"<<endl;
    //cout<<t.root->parent->parent->parent->key<<endl;
    deleteNode(&t, 20);
    printTree(&t);
    deleteNode(&t, 4);
    printTree(&t);
    //rotateR(t.root->left);
    //t.root = left;
    
    cout<<endl;

    //printTree(&t);
    return 0;
}