
import java.time.LocalDateTime;
public class Zkouska implements BlockInterface{

	String name;
	String place;
	String obsazeni;
	LocalDateTime from;

	Zkouska(String name, String place, LocalDateTime from, String obsazeni){
		this.name = name;
		this.place = place;
		this.from = from;
		this.obsazeni = obsazeni;
	}

	public String getName(){return this.name;}

	public String getPlace(){ return "mistnost:"+this.place;}
	
	public String getTypeName() {return "zkouska";}

	public String getTime(){
		return from.getHour() +":"+ from.getMinute();	
	}

	public String getExtras() {
		return obsazeni;
	}

}
