import java.util.*;
import java.lang.*;

public class Main {

   /* This is my first java program.
    * This will print 'Hello World' as the output
    */

   public static void main(String []args) {
      System.out.println("Hello World"); // prints Hello World
		System.out.println(multiply(6, 9));
		System.out.println(multiply(-6, 9));
		System.out.println(multiply(6, -9));
		System.out.println(multiply(-6, -9));
		System.out.println(nameNumber(123));
		primes(50);

   }

	static int multiply(int  a, int  b){
		int sum = 0;
		int sign = 0;
		if(a < 0) {sign -= 1; a += -a + -a;}
		if(b < 0) {sign += 1; b += -b + -b;}

		for(int i = 0; i < a; i++){
			sum +=b;	
		}
		if(sign != 0) sum = -sum;
		return sum;
	}

	static String nameNumber(int num){
		switch(num){
			case 1:
				return "Jedna";
			case 2:
				return "Dva";
			case 3:
				return "Tri";
			case 4:
				return "Ctyri";
			case 5:
				return "Pet";
			case 6:
				return "Sest";
			case 7:
				return "Sedm";
			case 8:
				return "Osm";
			case 9:
				return "Devet";
			case 0:
				return "Nula";
			default:
				return "Neznam";
		}
	}

	static boolean isPrime(int n){
		if(n <= 1) return false;
		if(n == 2) return true;

		for(int i = 3; i < Math.sqrt(n); i+=2){
			if(n % i == 0) return false;
		}
		return true;
	}

	static void primes(int n){
		int i = 1;
		while(i < n){
			if(i <=1) System.out.print(", "+i);
			if(isPrime(i)) System.out.print(", "+i);	
			i+=2;
		}
		System.out.print("\n");
	}
}
