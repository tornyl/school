public class IntSet extends UPLikedList{

	public IntSet(int ... numbers){
		for(int number : numbers){
			if (!super.contains(number)){
				super.insert(number);
			}
		}
	}

}
