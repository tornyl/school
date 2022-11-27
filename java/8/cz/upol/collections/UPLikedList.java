//package cz.upol.collections;
import java.util.Iterator;
/**
 * LinkedList implementation for integers
 */
public class UPLikedList<T> implements Iterable<T>, Sequence<T>, Comparable<UPLikedList>{

    /**
     * Class represents item in LinkedList
     */
    private class Node<T>{
        /**
         * Node value
         */
        private T value;

        /**
         * Pointer to the next node in the list.
         * If NULL this node is the last one.
         */
        private Node next_;

        public Node(T value, Node next) {
            this.value = value;
            this.next_ = next_;
        }

        public Node(T value) {
            this.value = value;
            this.next_ = null;
        }

        public Node getNext() {
            return next_;
        }

        public void setNext(Node next_) {
            this.next_ = next_;
        }

        public T getValue() {
            return value;
        }

        public void setValue(T value) {
            this.value = value;
        } 
   }

	public class CustomIterator implements Iterator<T>{
		Node node;
		public CustomIterator(Node root){
			this.node = root;
		}

		public boolean hasNext(){
			return !(node.getNext() == null);
		}

		public T next(){
			if(this.node != null){
				T val =(T) this.node.getValue();
				this.node =this.node.getNext();
				return val;
			}else{
				return null;
			}
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

	 public CustomIterator iterator(){
		return new CustomIterator(this.root);
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
        
        current.next_ = new Node<T>(value);
		  this.size_++;
    }

	 public boolean contains(T value){
	 	if(this.root == null) return false;
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
					previous.next_ = current.getNext();
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

	public int compareTo(UPLikedList o){
		return Integer.compare(this.size(), o.size());
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



