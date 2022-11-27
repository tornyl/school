public class IntSet<T> extends UPLikedList<T>{

	public IntSet(T ... numbers){
		for(T number : numbers){
			if(!super.contains(number)){
				super.insert(number);
			}
		}
	}

}
