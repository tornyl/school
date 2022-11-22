//package cz.upol.collections;

public interface Sequence<T> {

    /**
     * Count num,ber of elements i the sequence
     * @return Number of elements
     */
     int size();

    /**
     * Inserts new value to the sequence
     * @param value Value to be added
     */
    void insert(T value);

    /**
     * Check if a value is in a sequence
     * @param value Checked value
     * @return True if the value is in a sequence otherwise false
     */
    boolean contains(T  value);

    /**
     * Delete value from a sequence
     * @param value Value to ve deleted
     * @return True id value was delete, otherwise false
     */
    boolean delete(T value);
}
