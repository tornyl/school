#include <iostream>
#include <vector>
#include <map>
#include <fstream>
#include <string>
#include <sstream>
#include <algorithm>
#include <list>
#include <tuple>
#include <chrono>
#include <iomanip>


using namespace std;

int random(int min, int max){
    return min + rand() % ( max - min + 1);
}


struct Clause{
    vector<int> literals; 
};

struct Formula{
    list<Clause> clauses;

    // 0 == Unassigned
    // 1 == True
    // -1 == False
    vector<int> assignment; 
    vector<int> lit_count;

    int nb_vars;
    int nb_clauses;
    struct GoThroughInfo{
        int unit_propagation_count = 0;;
        int searched_tree_size = 0;;
    };
    GoThroughInfo goThroughInfo;
};

void removeClause(Formula& f, list<Clause>& removed_clauses, list<Clause>::iterator& it, vector<int>& removed_literals){
    for(int i : (*it).literals){
        if(f.assignment[abs(i) - 1] == 0){
            f.lit_count[abs(i) - 1] -=1;
            removed_literals.push_back(i);
        }
    }
    list<Clause>::iterator splice_iter = it;
    it++;
    removed_clauses.splice(removed_clauses.begin(), f.clauses, splice_iter);
    it--;
    
}

bool sat(Formula& f){

    for(list<Clause>::iterator it = f.clauses.begin(); it !=f.clauses.end(); it++){
        Clause& c = *it;
        bool clause_val = false; 
        for(int lit : c.literals){
            int val  = f.assignment[abs(lit) - 1];
            if( lit < 0 ) val *=-1;
            if( val == 1 ){
                clause_val = true;
                break;
            }
        }

        if (clause_val == false) return false;
    }
    return true;
}

bool unsat(Formula& f, list<Clause>& removed_clauses, vector<int>& removed_literals){

    for(list<Clause>::iterator it = f.clauses.begin(); it !=f.clauses.end(); it++){
        Clause& c= *it;
        bool clause_val = false; 
        for(int lit : c.literals){
            int val  = f.assignment[abs(lit) - 1];
            if( lit < 0 ) val *=-1;
            if( val == 0 ){
                clause_val = true;
                break;
            }else if( val == 1){
                clause_val  =  true;
                removeClause(f, removed_clauses, it, removed_literals);
                break;
            }
        }
        if(!clause_val) return true;
    }
    return false;
}

int unitClause(Formula& f, list<Clause>& removed_clauses, vector<int>& removed_literals){
    for(list<Clause>::iterator it = f.clauses.begin(); it !=f.clauses.end(); it++){
        Clause& c= *it;
        int unrated_count = 0;
        int unrated_var = 0;
        bool true_lit = false;
        for(int lit : c.literals){
            int val = f.assignment[abs(lit) - 1];
            if( lit < 0 ) val *=-1;
            if(val == 1) {
                true_lit = true;
                //break;
            }
            if(val == 0){
                unrated_count++;        
                unrated_var = lit;
            }
        }

        if(unrated_count == 1 && !true_lit){
            if(unrated_var < 0) f.assignment[abs(unrated_var) - 1] = -1;
            else f.assignment[unrated_var - 1] = 1;
            f.goThroughInfo.unit_propagation_count++;
            removeClause(f, removed_clauses, it, removed_literals);
            return unrated_var;
        }
    }
    return 0;

}

void removePureLiterals(Formula& f, list<Clause>& removed_clauses, vector<int>& removed_literals, vector<tuple<int, int>>& assigned_variables){
    vector<int> vars_polarity(f.nb_vars, 0);
    for(int i = 0; i < f.assignment.size(); i++){
        if(f.assignment[i] != 0) vars_polarity[i] = 2;
    }
    for(list<Clause>::iterator it = f.clauses.begin(); it != f.clauses.end(); it++){
        Clause &c = *it;
        for(int lit: c.literals){
            int polarity = lit / abs(lit);
            if(vars_polarity[abs(lit) - 1] == 0) vars_polarity[abs(lit) -1 ] = polarity;
            else if(vars_polarity[abs(lit) - 1] != polarity && vars_polarity[abs(lit) -1] != 2) vars_polarity[abs(lit) -1 ] = 2;

        }
        

    }
    //cout<<"polazity vars size: "<< single_polarity_vars.size()<<endl;
    //for(int i : single_polarity_vars) cout<<i<<" "; 
    //cout<<endl;
    //return;
    //cout<<"before: "<<single_polarity_vars.size(); 
    //for(int i = 0; i < single_polarity_vars.size(); i++) if(single_polarity_vars[i] == 0) cout<<"Its zero "<< i <<endl;
    //cout<<endl;
    //for(int i = 0; i < vars_polarity.size(); i++)  cout<<vars_polarity[i]<<" ";
    //cout<<endl;
    
    vector<int> single_polarity_vars;

    for( int i = 0; i < vars_polarity.size(); i++){
        if(vars_polarity[i] == 1 || vars_polarity[i] == -1){
            //single_polarity_vars.erase(single_polarity_vars.begin() + i);
            //i--;
            f.assignment[i] = vars_polarity[i];
            single_polarity_vars.push_back((i + 1) * vars_polarity[i]);
            f.goThroughInfo.searched_tree_size++;
        }
    }
    //cout<<" after: "<<single_polarity_vars.size()<<endl;
    //cout<<"polazity vars size: "<< single_polarity_vars.size()<<endl;
    //for(int i : single_polarity_vars) cout<<i<<" "; 
    //cout<<endl;
    //return;

    for(list<Clause>::iterator it = f.clauses.begin(); it != f.clauses.end(); it++){
        Clause &c = *it;
        for(int lit: c.literals){
            
        }

        if( any_of(single_polarity_vars.begin(), single_polarity_vars.end(), [&](int var){
                return find(c.literals.begin(), c.literals.end(), var) != c.literals.end();})){

            removeClause(f, removed_clauses, it, removed_literals);
        }

    }
    
    for(int i : single_polarity_vars){
        assigned_variables.push_back(make_tuple( abs(i) - 1, f.lit_count[abs(i) - 1])); 
        f.lit_count[abs(i) - 1] = 0;
    }
    

}




void backtrack(Formula& f, list<Clause>& removed_clauses, vector<int>& removed_literals, vector<tuple<int, int>>& assigned_variables){
    
    for(tuple<int , int> tup : assigned_variables){
        f.assignment[get<0>(tup)] = 0;
        f.lit_count[get<0>(tup)] = get<1>(tup);
    }
    f.clauses.splice(f.clauses.begin(), removed_clauses);
    for(int i : removed_literals) f.lit_count[abs(i) - 1]+=1;


}



bool dpll(Formula &f){
    list<Clause> removed_clauses;
    vector<int> removed_literals;
    vector<tuple<int, int>> assigned_variables; // tuple<variable, lit_count>
    
    
    int lit = unitClause(f, removed_clauses, removed_literals);
    while(lit != 0){
        //if(lit > 0) f.assignment[lit - 1] = 1;
        //else f.assignment[abs(lit) - 1] = -1;
        //f.goThroughInfo.searched_tree_size++;
        assigned_variables.push_back(make_tuple(abs(lit) - 1, f.lit_count[abs(lit) - 1]));
        f.lit_count[abs(lit) - 1] = 0;
        f.goThroughInfo.searched_tree_size++;
        lit =  unitClause(f, removed_clauses, removed_literals);
    }

    removePureLiterals(f, removed_clauses, removed_literals, assigned_variables);

    if(unsat(f, removed_clauses, removed_literals)){
        
        backtrack(f, removed_clauses, removed_literals, assigned_variables); 
        return false; 
    }
    if(sat(f)) return true;



    
    //int i = 0;
    //while(f.assignment[i] !=0) i++;
    int i = max_element(f.lit_count.begin(), f.lit_count.end()) - f.lit_count.begin();
    assigned_variables.push_back(make_tuple(i, f.lit_count[i]));
    f.lit_count[i] = 0;

    
    f.goThroughInfo.searched_tree_size++;

    f.assignment[i] = 1;
    if(dpll(f)) return true;

    
    f.goThroughInfo.searched_tree_size++;

    f.assignment[i] = -1;
    if(dpll(f)) return true;

    //backtrack 
    backtrack(f, removed_clauses, removed_literals, assigned_variables); 
    return false;

}

void splitLine(const string& line, vector<string>& tokens){
    stringstream ss(line);
    string token;
    while( ss >> token) {
        tokens.push_back(token);
    }
}


void loadData(string& line, Formula& f){

    vector<string> tokens;
    vector<int> clause;
    Clause c;
    splitLine(line, tokens);

    if(tokens[0] == "p") {
        f.nb_vars = stoi(tokens[2]);
        f.nb_clauses = stoi(tokens[3]);
        f.assignment.resize(f.nb_vars, 0);
        f.lit_count.resize(f.nb_vars, 0);
        
    }else if(tokens[0] != "c"){
        for(int i = 0; i < tokens.size() - 1; i++ ){
            c.literals.push_back(stoi(tokens[i])); 
            f.lit_count[abs(stoi(tokens[i])) - 1]+=1;
        }
        f.clauses.push_back(c);
    }


}


Formula readFile( ifstream& file){
    string line;
    Formula f;

    while(getline(file,line)){
        loadData(line, f);
    }

    return f;

    //cout<<"size: "<<lit_count.size()<< "r1 "<<lit_count[5]<< " r2 "<<lit_count[15]<<endl;

}

map<int, string> intToTruth = { { 0 , "unrated"},
                                { 1 , "True"},
                                { -1 , "False"}};



void printResults(Formula f, bool res, double load_time, double execution_time){
    if(res){
        
        cout<<"SAT"<<endl;
        
        for( int i = 0; i < f.assignment.size(); i++) if (f.assignment[i] == 1) cout<< i+1<<" ";
        cout<<endl;


    }else cout<<"UNSAT"<<endl;
    
    string load_time_unit = "ms";
    string execution_time_unit = "ms";
    if(load_time > 1000) {
        load_time *= 1e-3;
        load_time_unit = "s";
    } 
    if(execution_time > 1000){
        execution_time *= 1e-3; 
        execution_time_unit = "s";
    }
    cout<< "load time: "<< setprecision(4) << load_time << " "<<load_time_unit<<endl;
    cout<< "execution time: "<< setprecision(4) << execution_time << " "<<execution_time_unit<<endl;
    cout<< "Unit propagation used: "<<f.goThroughInfo.unit_propagation_count<<" times"<<endl;
    cout<< "search tree nodes: "<< f.goThroughInfo.searched_tree_size <<endl;


}



int main(int argc, char  *argv[]){

    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " <filename>" << std::endl;
        return 1; // Exit with error
    }

    ifstream file(argv[1]);
    if(!file.is_open()){
        cerr << "Error opening file: " << argv[1] << endl;
        return 1;
    }

    

    chrono::high_resolution_clock::time_point t1 = chrono::high_resolution_clock::now();
    Formula f = readFile(file);
    chrono::high_resolution_clock::time_point t2 = chrono::high_resolution_clock::now();


    double load_time = chrono::duration_cast<chrono::nanoseconds> (t2 - t1).count();
    load_time *= 1e-6;
    //cout<<endl;
    //for(int i : f.lit_count) cout<<i<<" ";
    //cout<<endl;

    //for( Clause c : f.clauses){
    //    for( int i : c.literals){
    //        cout << i <<" ";
    //    }
    //    cout<< endl;
    //}
    
    t1 = chrono::high_resolution_clock::now(); 
    bool res = dpll(f);
    t2 = chrono::high_resolution_clock::now(); 
    
    double execution_time = chrono::duration_cast<chrono::nanoseconds> (t2 - t1).count();
    execution_time *= 1e-6;
   

    //print results  
    cout<<"Truth assigmnent"<<endl;
    for(int a : f.assignment) cout <<intToTruth[a]<<" ";
    cout<<endl;
    cout<<"End"<<endl;
    cout<<boolalpha;
    cout<<"Final result is "<< res <<endl;
    cout<<noboolalpha;
    


    printResults(f, res, load_time, execution_time);

    
    


    return 0;

}




