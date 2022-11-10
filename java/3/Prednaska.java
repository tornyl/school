
import java.time.LocalDateTime;
public class Prednaska implements BlockInterface{

	String name;
	String place;
	LocalDateTime from;
	LocalDateTime to;

	Prednaska(String name, String place, LocalDateTime from, LocalDateTime to){
		this.name = name;
		this.place = place;
		this.from = from;
		this.to = to;
	}

		/** @return nazev prednasky */	
	public String getName(){	
		return this.name;}

		/** @return misto konani zkousky */
	public String getPlace(){
	return "mistnost"+this.place;}
	
		/** @return String "prednaska" */
	public String getTypeName() {

	return "prednaska";}

		/** @return doba trvani */
	public String getTime(){

		return " od "+ from.getHour() +":"+ from.getMinute() + " do "+ to.getHour() +":"+ to.getMinute();
	}

		/** @return extra informace pokud jsou k dispozici */
	public String getExtras() {
	return " ";}

}
