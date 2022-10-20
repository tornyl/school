public class main{

	public static void main(String[] args){
		System.out.println("Hello world");	
		System.out.println(formatStr("A: %0; B: %1", 1, 1.6));
	}


	public static String formatStr(String format, double ... args){
		for( double arg : args){ format.replaceFirst("%", String.valueOf(arg));}	
		return format;

	}
}
