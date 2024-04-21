
#include <iostream>
#include <cmath>

using namespace std;


typedef struct node{
    int u;
    int value;
    int min =  -1;
    int max =  -1;
    struct node *summary;
    struct node **cluster;

    node(int u): u ( u){
        if( u > 2){
            summary = new node(pow(2, ceil( log2(u) / 2))); // up 
            cluster = new node* [(int) pow (2, ceil( log2(u)/ 2))];  // up
        }else{
            summary = nullptr;
            cluster = nullptr;
        }
        cout << "u " << u << endl;
    };

    int high(int x){
        return floor( x / pow(2 , floor( log2(u) / 2 ))); 
    }

    int low(int x){
        return x % (int) pow(2, floor( log2(u) / 2));
    }

    int index(int y, int z){
        return y * pow(2, floor( log2(u) / 2 )) + z;
    }

}Veb;


bool member(Veb *v, int x){
    if (!v) return false;
    if (x == v->min || x == v->max) return true; 
    else if ( v->u == 2 ) return false;
    else return member( v->cluster[ v->high(x)], v->low(x));
}

int successor(Veb *v, int x){
    if (!v) return -1;
    if ( v->u == 2){
        if ( x == 0 && v->max == 1) return 1;
        else return -1;

    }else if ( v->min != -1  && x < v->min ) return v->min;
    else{
        Veb *m_low_veb = v->cluster[v->high(x)];

        if ( m_low_veb && v->low(x) < m_low_veb->max ){
            int offset = successor( v->cluster[v->high(x)], v->low(x) );    
            return v->index( v->high(x), offset);
        }else{
            int succ_cluster = successor( v->summary, v->high(x) );
            if ( succ_cluster == -1 ) return -1;
            else{
                int offset = v->cluster[succ_cluster]->min;
                return v->index( succ_cluster, offset );
            }
        }

    }

}


int min(Veb *v) {return v->min;}
int max(Veb *v) { return v->max; }


void insert(Veb *v, int x){
    if ( v->min == -1){
        v->min = x;
        v->max = x;
    }
    if ( x < v->min){ 
        int tmp = v->min;
        v->min = x;
        x = tmp;
    }
    if ( v->u > 2){
        
        if ( !v->cluster[v->high(x)] || v->cluster[v->high(x)]->min == -1){
            insert(v->summary, v->high(x)); 
            // empty insert
            
            Veb* new_sub_v = new Veb( pow( 2, floor( log2(v->u)/ 2)));
            v->cluster[v->high(x)] = new_sub_v;
            insert(new_sub_v, v->low(x));

        }else{
            insert(v->cluster[v->high(x)], v->low(x));
        }


    }

    if( x > v->max) v->max = x;


}


typedef struct Veb_tree_{
    Veb *veb;

    Veb_tree_(int u){
        veb = new Veb(u);
    }

    int min(){ return veb->min; }
    int max(){ return veb->max; }
    int successor(int x) { return ::successor(veb, x);}
    bool member(int x) { return ::member(veb, x); }
    void insert(int x) { ::insert(veb, x); }
}Veb_tree;


void print2(Veb *v){
    if(v){
        cout<< "u: "<<v->u<<" min:"<<v->min<<" max:"<<v->max<<" summary/cluster length "<<pow(2, ceil( log2(v->u) / 2))<<endl;
        print2(v->summary);
        for(int i = 0; i < (int)  pow(2, ceil( log2(v->u) / 2)); i++){
            if(v->cluster) print2(v->cluster[i]);
        }
    }
}



int main(){

    Veb_tree t(16); 
    print2(t.veb);
    return 0;
}
