//package cz.upol;

//import cz.upol.collections.UPLikedList;

public class Main {

    public static void main(String[] args) {
		arrays();
    }



    private static void arrays() {
        /*** Arrays ***/

        // Array of integers of size 10
        int[] numbers = new int[20];

        // Set value at index 2
        numbers[2] = 22;

        // Get value at index 2
        var number = numbers[2];
        System.out.println(String.format("Value at index 2 is %d", number));

        /*** Multidimensional Arrays ***/
        int[][] matrix = new int[5][5];

        int[][] matrixWithValues = {
                {1, 1, 1, 1, 1},
                {2, 2, 2, 2, 2},
                {3, 3, 3, 3, 3},
                {4, 4, 4, 4, 4},
                {5, 5, 5, 5, 5}
        };

        // Set value at indexes 1 & 1
        matrix[1][1] = 22;

        // Get value at indexes 1 & 1
        var matrixValue = matrix[1][1];
        System.out.println(String.format("Value at [1, 1] is %d", matrixValue));

		  IntSet ints = new IntSet(4 , 21, 1 , 4 ,2 ,1, 53 ,4);
		  System.out.println(ints.toString());
    }
}
