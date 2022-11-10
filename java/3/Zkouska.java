
import java.time.LocalDateTime;
public class Zkouska implements BlockInterface{
	/** trida Zkouska */

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

	/** @return nazev zkousky */	
	public String getName(){
		return this.name;}

	/** @return misto konani zkousky */
	public String getPlace(){ 
	return "mistnost:"+this.place;}


	/** @return String "zkouska" */
	public String getTypeName() {
	return "zkouska";}

		/** @return doba trvani */
	public String getTime(){
		return from.getHour() +":"+ from.getMinute();	
	}

		/** @return extra informace pokud jsou k dispozici */
	public String getExtras() {
		return obsazeni;
	}

}
