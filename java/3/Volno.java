import java.time.Duration;
import java.time.LocalDateTime;
public class Volno implements BlockInterface{

	LocalDateTime from;
	LocalDateTime to;

	Volno(LocalDateTime from, LocalDateTime to){
		this.from = from;
		this.to = to;
	}

		/** @return trvani volna */	
	public String getName(){
		Duration  duration = Duration.between(from, to);
		return "Volno ( "+duration.toHours()+" hodiny "+duration.toMinutes() % 60 +" minut)";
	}

		/** @return prazdny String */
	public String getPlace(){

	return "";}
	
		/** @return String "volno" */
	public String getTypeName() {
	
	return "volno";}

		/** @return doba trvani */
	public String getTime(){

		return " od "+ from.getHour() +":"+ from.getMinute() + " do "+ to.getHour() +":"+ to.getMinute();
	}

		/** @return extra informace pokud jsou k dispozici */
	public String getExtras() {
	return " ";}

}
