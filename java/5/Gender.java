
public enum Gender{
	Male(1),
	Female(2);
	
	private int index;

	Gender(int index){
		this.index = index;

	}

	public int getIndex(){
		return this.index;
	}

}
