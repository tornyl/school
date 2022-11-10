
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

		/** @return nazev Cviceni */	
	public String getName(){

	return this.name;}

		/** @return misto konani  */
	public String getPlace(){ 

	return "mistnost:"+this.place;}
	
		/** @return String "cviceni" */
	public String getTypeName() {

	return "cviceni";}

		/** @return doba trvani */
	public String getTime(){

		return " od "+ from.getHour() +":"+ from.getMinute() + " do "+ to.getHour() +":"+ to.getMinute();
	}

		/** @return extra informace pokud jsou k dispozici */
	public String getExtras() {
	return " ";}

}
