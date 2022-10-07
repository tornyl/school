import java.time.Duration;
import java.time.LocalDateTime;
public class Volno implements BlockInterface{

	LocalDateTime from;
	LocalDateTime to;

	Volno(LocalDateTime from, LocalDateTime to){
		this.from = from;
		this.to = to;
	}

	public String getName(){
		Duration  duration = Duration.between(from, to);
		return "Volno ( "+duration.toHours()+" hodiny "+duration.toMinutes() % 60 +" minut)";
	}

	public String getPlace(){ return "";}
	
	public String getTypeName() {return "volno";}

	public String getTime(){
		return " od "+ from.getHour() +":"+ from.getMinute() + " do "+ to.getHour() +":"+ to.getMinute();
	}

	public String getExtras() {return " ";}

}
