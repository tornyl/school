public class Country{
	String name;
	String phoneCode;

	Country(String name, String phoneCode){
		this.name= name;
		this.phoneCode = "+"+phoneCode;
	}	

	void print(){
		System.out.format("Stat{jmeno=%s, predvolba=%s\n",this.name, this.phoneCode);
	}
}



















