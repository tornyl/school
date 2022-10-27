public enum Type{
	Kocka(1, "Mnau", "kocicak", "kocka"),
	Pes(1, "Haf", "pes", "fena"),
	Kacena(1, "kva kva", "kacer", "kacena");
	
	private int index;
	private String sound;
	private String maleDescription;
	private String femaleDescription;


	Type(int index, String sound,String maleDescription, String femaleDescription){
		this.index = index;
		this.sound = sound;
		this.maleDescription = maleDescription;
		this.femaleDescription = femaleDescription;
	}

	public int getIndex(){
		return this.index;
	}

	public String getSound(){
		return this.sound;
	}

	public String getDescription(Gender gender){
		switch(gender){
			case Male:
				return this.maleDescription;
			
			case Female:
				return this.femaleDescription;
		}
		return "";
	}
}
