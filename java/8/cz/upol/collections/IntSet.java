public class IntSet<T> extends UPLikedList<T>{

	public IntSet(T ... numbers){
		for(T number : numbers){
			super.insert(number);
		}
	}

}
