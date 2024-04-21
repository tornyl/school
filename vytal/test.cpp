#include <iostream>
#include <vector>
#include <algorithm>
#include <list>

using namespace std;

int main(){
    
    vector<int> vec = { 1, 2, 3, 4, 5};

    cout<< *(vec.begin()+ 1) <<endl;

    //for( int i : vec) cout << i << endl;

    for( int i = 0; i < vec.size(); i++){
        cout<< vec[i] << endl;
        if(vec[i] == 3) {
            vector<int>::iterator it = vec.begin() + i;
            *it = std::move(vec.back());
            vec.pop_back();
            i--;
        }
    }

    cout<<"printing"<<endl;
    for(int i : vec) cout<< i << " ";

    cout<<"end printign"<< endl;
    
    cout<< "here"<<endl;
    cout<<vec.size()<< endl;
    cout<<  max_element(vec.begin(), vec.end()) - vec.begin()<< endl;
    cout<<  *max_element(vec.begin(), vec.end())<< endl;


    vector<int>::iterator it = vec.begin();
    advance(it, 3);
    int& num = *it;
    cout<<num<<endl;

    cout<<"---------- TEST 2 ----------"<<endl;
    list<int> vec2 = {1,2, 3, 4, 5};
    list<int> vec3;
    for(list<int>::iterator it = vec2.begin(); it !=vec2.end(); it++){
        cout<<*it<<" ";
        if(*it == 3){
            auto splice_iter = it; 
            it++;
            vec3.splice(vec3.end(), vec2, splice_iter);
            it--;
            //int& i  = *it;
            //vec3.push_back(std::move(vec.front()));
            //vec3.push_back(*(std::move_iterator(it)));

        }
    }
    
    cout<<endl;
    for(int i : vec3) cout<<i<< " ";
    cout<<endl;



    cout<<endl;
    for(int i : vec2) cout<<i<< " ";
    cout<<endl;


    cout<<"---------- TEST 3 ----------"<<endl;

    vector<int> vec4 = { 1, 2, 3, 4, 5};

    for(int i = 0; i < vec4.size(); i++){
        if(vec4[i] == 3){
            vec4.erase(vec4.begin() + i); 
            i--;
        }
    }


    cout<<endl;
    for(int i : vec4) cout<<i<<" ";
    cout<<endl;
}
