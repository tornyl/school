
public  class Animal{
	
	public Type type;
	public  Gender gender;
	public String name;

	Animal(String name, Type type, Gender gender){
		this.name = name;
		this.type = type;
		this.gender = gender;
	}

	String getDescription(){
		return type.getDescription(this.gender);
	}
}
