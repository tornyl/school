
import java.time.LocalDateTime;
public class Cviceni implements BlockInterface{

	String name;
	String place;
	LocalDateTime from;
	LocalDateTime to;

	Cviceni(String name, String place, LocalDateTime from, LocalDateTime to){
		this.name = name;
		this.place = place;
		this.from = from;
		this.to = to;
	}

	public String getName(){return this.name;}

	public String getPlace(){ return "mistnost:"+this.place;}
	
	public String getTypeName() {return "cviceni";}

	public String getTime(){
		return " od "+ from.getHour() +":"+ from.getMinute() + " do "+ to.getHour() +":"+ to.getMinute();
	}

	public String getExtras() {return " ";}

}
