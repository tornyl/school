import java.time.LocalDateTime;

public class main{

	public static void main(String[] args){	
		BlockInterface[] blocks = { new Prednaska("Algo2", "3005",LocalDateTime.of(2022, 6, 22, 9, 30),LocalDateTime.of(2022, 6, 22, 11, 30)),
			new Cviceni("PP3", "5003",LocalDateTime.of(2022, 6, 22, 12, 30),LocalDateTime.of(2022, 6, 22, 14, 18)), 
			new Volno(LocalDateTime.of(2022, 6, 22, 14, 18),LocalDateTime.of(2022, 6, 22, 16, 32)),
			new Zkouska("Algebra 1", "1020",LocalDateTime.of(2022, 6, 23, 8, 45), "5/8")};

		for (BlockInterface block : blocks){
			System.out.println(block.getName()+ " " + block.getTypeName() +" "+ block.getPlace() + " "+ block.getTime() + " "+  block.getExtras());
		}
	}
}


