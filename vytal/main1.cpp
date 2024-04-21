#include <iostream>
#include <vector>
#include <map>
#include <fstream>
#include <string>
#include <sstream>

using namespace std;

int random(int min, int max){
    return min + rand() % ( max - min + 1);
}

enum class Lit{
    True ,
    False,
    Unrated,

};


map<Lit, string> litToString =  { { Lit::True, "true"},
                                    { Lit::False, "false"},
                                    { Lit::Unrated, "unrated"}};

constexpr bool operator==(Lit l, bool b){
    if(b){
        return l == Lit::True;
    }else{
        return l == Lit::False;
    }
}


constexpr bool operator!(Lit l){
    return  l == Lit::False;
}

void printVars(vector<Lit> lits){
    for(Lit l : lits) cout<< litToString[l] << endl;
}
Lit swap(Lit l){
    if(l == false) return Lit::True;
    else if(l == true) return Lit::False;
    else return l;
}

//vector<vector<int>> F = { {1, 3, -2 }, 
 //                     { 2, 3, -1,  4},
  //                    { 4, 3 },
   //                   { 1, 2, -4,  3},
    //                  { 1, -2, -3 }};

//vector<vector<int>> F = { {1, 2, 3 }, 
 //                     { -1, -2, 3 },
  //                    { -1, -2, -3 }};

vector<vector<int>> F;
int nb_var;
int nb_clauses;

bool sat(vector<Lit> fi){
    for(vector<int> clause : F){
        bool clause_val = false; 
        for(int var : clause){
            Lit l = fi[abs(var)- 1];
            if( var < 0 ) l = swap(l);
            if( l == true ){
                clause_val = true; 
                break;
            }
        }
        if (clause_val == false) return false;
    }

    return true;
}


int unitClause(vector<Lit> fi){
    for(vector<int> clause : F){
        int unrated_count = 0;
        int unrated_var = 0;
        bool true_lit = false;
        for(int var : clause){
            Lit l = fi[abs(var) - 1];
            if( var < 0 ) l = swap(l);
            if(l == true) true_lit = true;
            if(l == Lit::Unrated){
                unrated_count++;        
                unrated_var = var;
            }
        }

        if(unrated_count == 1 && !true_lit) return unrated_var;
    }
    return 0;

}

bool unsat(vector<Lit> fi){
    for(vector<int> clause : F){
        bool clause_val = false; 
        for(int var : clause){
            Lit l = fi[abs(var) - 1];
            if( var < 0 ) l = swap(l);
            if( l == true || l == Lit::Unrated ){
                clause_val = true;
                break;
            }
        }
        if(!clause_val) return true;
    }
    return false;
}

bool allDefined(vector<Lit> fi){
    for(Lit l : fi){
        if(l == Lit::Unrated) return false; 
    }
    return true;
}

bool dpllHelp(vector<Lit> fi, vector<Lit>& out){
    if(unsat(fi)) return false;
    int var = unitClause(fi);
    while(var != 0){
        if(var > 0) fi[var - 1] = Lit::True;
        else fi[abs(var) - 1] = Lit::False;
        var =  unitClause(fi);
    }
    if(unsat(fi)) return false;
    if(sat(fi)){
        out = fi;
        return true;
    }
    if(allDefined(fi)) {
        out = fi;
        return sat(fi);
    }

    int i = 0;
    while(fi[i] != Lit::Unrated) i++;
    fi[i] = Lit::True;
    if(dpllHelp(fi, out)) {
        return true;
    }
    fi[i] = Lit::False;
    if(dpllHelp(fi, out)){
        return true;
    }
    return false;
}


vector<int> dpll(){
     
    //vector<Lit> fi = { Lit::Unrated, Lit::Unrated, Lit::Unrated, Lit::Unrated};
    //vector<Lit> fi = { Lit::Unrated, Lit::Unrated, Lit::Unrated};
    vector<Lit> fi(nb_var, Lit::Unrated);

    vector<Lit> out = fi;

    bool res = dpllHelp(fi, out);
    cout<<"number of clauses: " << F.size() <<endl;
    cout<<"number of clauses: " << F[0].size() <<endl;

    cout<<"example"<< F[5][0] << F[5][1] << F[5][2] <<endl;
    cout<< res<< endl;
    printVars(out);
    
    return {0,1,1};

}

void splitLine(const string& line, vector<string>& tokens){
   
    stringstream ss(line);
    string token;
    while( ss >> token) {
        tokens.push_back(token);
    }
}


void loadData(string& line){

    vector<string> tokens;
    vector<int> clause;
    splitLine(line, tokens);

    if(tokens[0] == "p") {
        nb_var = stoi(tokens[2]);
        nb_clauses= stoi(tokens[3]);
        
    }else if(tokens[0] != "c"){
        for(int i = 0; i < tokens.size() - 1; i++ ){
            clause.push_back(stoi(tokens[i])); 
        }
        F.push_back(clause);
    }

}


void readFile( ifstream& file){
    string line;

    while(getline(file,line)){
        loadData(line);
    }

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

    readFile(file);

    
    

   dpll(); 

    return 0;

}


//
//  dpll(F){
//      
//
//  }
