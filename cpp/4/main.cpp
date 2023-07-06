#include <cstring>
#include <iostream>



using namespace std;

class Jmeno {
    static Jmeno **jmena;
    static unsigned rozsah, pocet,iter;
    const char *jm;
    public: Jmeno(const char*);
    const char *jmeno() const;
    static bool zacatek();
    static const Jmeno *dalsi();
    static bool jeDalsi();
};

Jmeno **Jmeno::jmena = NULL;
unsigned Jmeno::rozsah = 0;
unsigned Jmeno::pocet = 0;
unsigned Jmeno::iter = 0;

const char* Jmeno::jmeno() const {
    return jm;
}

bool Jmeno::zacatek(){
    iter = 0;
    return pocet > 0;
}

const Jmeno *Jmeno::dalsi(){
    iter++;
    return jmena[iter-1];    
}

bool Jmeno::jeDalsi(){
    return iter < pocet;
}

Jmeno::Jmeno(const char *jmeno){
    if(rozsah == 0){
        jmena = new Jmeno*[5];
        rozsah = 5;
    }
    if(pocet == rozsah){
       Jmeno **nove_jmena = new Jmeno*[rozsah * 2];
       memcpy(nove_jmena, jmena, sizeof(Jmeno*) * rozsah * 2);
       delete[] jmena;
       jmena = nove_jmena;
       rozsah *=2;
    }
    
    jm = strdup(jmeno);
    jmena[pocet] = this;
    pocet++;
};


int main()
{
	typedef Jmeno J;
    new J("Jana"),new J("Petr"),new J("Eva"),new J("Jan"),new J("Irena"),new J("Alena"),new J("Pavel"),new J("Roman"),new J("Veronika"),new J("Jitka"),
    new J("Denisa");
    char h[]="Hana";
    new J(h);
    *h='?';
	 while(Jmeno::jeDalsi()){
		cout<<Jmeno::dalsi()->jmeno()<<endl;   
    }
    return 0;
}
