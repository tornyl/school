public class main{

	public static void main(String[] args){
		System.out.println("Hello world");	
		System.out.println(formatStr("A: %0; B: %1", 1, 1.6));

		Animalfarm farm = new Animalfarm();
		farm.add("Micka", Type.Kocka, Gender.Female);
		farm.add("Alik", Type.Pes, Gender.Male);
		farm.add("Bobik", Type.Kacena, Gender.Female);
		farm.add("Donald", Type.Kacena, Gender.Male);
		farm.add("Chubaka", Type.Pes, Gender.Female);
		farm.add("Hfan", Type.Pes, Gender.Male);

		farm.list();
	}


	public static String formatStr(String format, double ... args){
		for( double arg : args){ format.replaceFirst("%", String.valueOf(arg));}	
		return format;

	}
}
