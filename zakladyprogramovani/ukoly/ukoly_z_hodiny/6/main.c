#include <stdio.h>
#include <stdlib.h>

void vypis_pole(int a[], int n);
void ukol_3(int n, int m);
int je_prvocislo(int n, int m);
void ukol_4(int n);
int sou_j_prv(int n);

int main()
{
    printf("Hello world!\n");
    //int y = sum( 10, 15);a
    int p[] = {1,2,3,4};
    vynuluj(p, 4);
    vypis_pole(p, 4);
    //ukol_2();
    //ukol_3(20, 21); 
    //printf("%i\n",y);
    printf("hello\n");
    printf("%d\n", ukol_5(3));
    ukol_4(19);
	 //printf("\n%d\n", fac(7));
    //printf("%d", je_prvocislo(19,18));
    return 0;
}


void vynuluj(int a [], int n){
    //int result = a + b;
    for(int i =0; i < n; i++){
        a[i] = 0;
    }
    //return result;


}

void vypis_pole(int a[], int n){
    for(int i =0; i < n; i++){
        printf("%i ", a[i]);
    }
}

void ukol_2(){
    for(int i = 1000; i < 10000; i++){
        int delitel = (i / 100) + (i % 100);
        if (i % delitel == 0) printf("%d\n", i);
    }

}

void ukol_3(int n, int m){
    if(je_prvocislo(m, m - 1)){
        printf("%d", n - m);
    }else{
        ukol_3(n, m + 1);
    }

}

int je_prvocislo(int n, int m){
    if( m == 1){
        return 1;
    }else if( n % m == 0 ){
        return 0;
    }else{
        //printf("%d\n", m);
        return je_prvocislo(n, m - 1);
    }
}

void ukol_4(int n){
    if( je_prvocislo(n, n - 1) && sou_j_prv(n)) printf("%d\n", n);

    if( n != 0) ukol_4(n - 1);

}

int sou_j_prv(int n){
    if (n > 0){
        return je_prvocislo( (n % 10) + sou_j_prv(n / 10), (n % 10) + sou_j_prv(n / 10) - 1 );
    }else{
        return 0;
    }
}


int ukol_5(int n){
    if (n == 1) return 1;
    return  fac(sum(n)) + ukol_5(n - 1);
}

int fac(int n){
	if(!n) return 1;
	return (n * fac(n - 1));
}

int sum(int n){
	if(!n) return 0;
	return n + sum(n - 1);
}



