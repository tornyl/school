//package cz.upol.collections;

/**
 * LinkedList implementation for integers
 */
public class UPLikedList implements Sequence{

    /**
     * Class represents item in LinkedList
     */
    private class Node implements Iterable{
        /**
         * Node value
         */
        private int value;

        /**
         * Pointer to the next node in the list.
         * If NULL this node is the last one.
         */
        private Node next;

        public Node(int value, Node next) {
            this.value = value;
            this.next = next;
        }

        public Node(int value) {
            this.value = value;
            this.next = null;
        }

        public Node getNext() {
            return next;
        }

        public void setNext(Node next) {
            this.next = next;
        }

        public int getValue() {
            return value;
        }

        public void setValue(int value) {
            this.value = value;
        }
		  
		  public  boolean hasNext(){
			return this.next != null;
		  }

		  public int next(){
				return  this.next.getValue();	
		  }
    }

    /**
     * List first value.
     * If NULL, then the list is empty
     */
    private Node root;
	 
	 private int size_;

    public UPLikedList() { }

    public UPLikedList(int value) {
        insert(value);
		  this.size_++;
    }

	 public int size(){ return this.size_; }

    /**
     * Insert new value to the list
     * @param value Value to be inserted
     */
    public void insert(int value) {
        if (root == null) {
            root = new Node(value);
            return;
        }
        Node current = root;
        
        while (current.getNext() != null) {
            current = current.getNext();
        }
        
        current.next = new Node(value);
		  this.size_++;
    }

	 public boolean contains(int value){
	 	if (this.root == null) return false;
		Node current = this.root;
		while(current.getNext() != null){
			if(current.getValue() == value) return true;
			current = current.getNext();
		}
		return false;
	 }
		
	public boolean delete(int value){
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


class CustomIterator<> implements Iterator<> {
      
    // constructor
    CustomIterator<>(CustomDataStructure obj) {
        // initialize cursor
    }
      
    // Checks if the next element exists
    public boolean hasNext() {
    }
      
    // moves the cursor/iterator to next element
    public T next() {
    }
      
    // Used to remove an element. Implement only if needed
    public void remove() {
        // Default throws UnsupportedOperationException.
    }
}
