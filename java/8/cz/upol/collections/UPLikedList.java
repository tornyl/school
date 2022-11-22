//package cz.upol.collections;

/**
 * LinkedList implementation for integers
 */
public class UPLikedList<T> implements Sequence<T>{

    /**
     * Class represents item in LinkedList
     */
    private class Node<T> implements Iterable<T>{
        /**
         * Node value
         */
        private T value;

        /**
         * Pointer to the next node in the list.
         * If NULL this node is the last one.
         */
        private Node next;

        public Node(T value, Node next) {
            this.value = value;
            this.next = next;
        }

        public Node(T value) {
            this.value = value;
            this.next = null;
        }

        public Node getNext() {
            return next;
        }

        public void setNext(Node next) {
            this.next = next;
        }

        public T getValue() {
            return value;
        }

        public void setValue(T value) {
            this.value = value;
        }
		  
		  public  boolean hasNext(){
			return this.next != null;
		  }

		  public T next(){
				return (T) this.next.getValue();	
		  }
    }

    /**
     * List first value.
     * If NULL, then the list is empty
     */
    private Node<T> root;
	 
	 private int size_;

    public UPLikedList() { }

    public UPLikedList(T value) {
        insert(value);
		  this.size_++;
    }

	 public int size(){ return this.size_; }

    /**
     * Insert new value to the list
     * @param value Value to be inserted
     */
    public void insert(T value) {
        if (root == null) {
            root = new Node<T>(value);
            return;
        }
        Node current = root;
        
        while (current.getNext() != null) {
            current = current.getNext();
        }
        
        current.next = new Node<T>(value);
		  this.size_++;
    }

	 public boolean contains(T value){
		Node current = this.root;
		while(current.getNext() != null){
			if(current.getValue() == value) return true;
			current = current.getNext();
		}
		return false;
	 }
		
	public boolean delete(T value){
		Node previous = null;
		Node current = this.root;
		while(current.getNext() != null){
			if(current.getValue() == value){
				if(previous != null){
					previous.next = current.getNext();
				}else{
					this.root = current.getNext();
				}
				return true;
			}
			previous = current;
			current = current.getNext();
		}
		return false;
	}



    @Override
    public String toString() {
        StringBuilder description = new StringBuilder();
        description.append("[");

        Node current = root;

        while (current.getNext() != null) {
            description.append(current.getValue());
            description.append(", ");
            current = current.getNext();
        }

        description.append(current.getValue());
        description.append("]");

        return description.toString();
    }
}
