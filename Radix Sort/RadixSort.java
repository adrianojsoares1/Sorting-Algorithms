import java.util.ArrayList;
import java.util.Random;

/**
 * Created by Adriano, Mike G, Erik on 11/22/2016.
 */
public class RadixSort {
    //maxInt: Finds max integer of an ArrayList of Integers
    private static int maxInt(ArrayList<Integer> x) {
        int max = Integer.MIN_VALUE;
        //If an element is greater than max, make it max
        for (Integer X : x) {
            if (X > max)
                max = X;
        }
        return max;
    }
    //digits: Returns amount of digits in a number
    private static int digits(int x) {
        int nums = 0;
        //Whittle away int x by dividing by 10. When it hits 0, return the counter.
        //Because a number less than 10 divided by 10 is 0, we know that x will always reach 0 at some point and thus quit the loop.
        while (x > 0) {
            x = x / 10;
            nums++;
        }
        return nums;
    }
    //fill: Fill an arrayList of length "length" with integers
    private static void fill(ArrayList<Integer> i, int length) {
        //create new random
        Random rand = new Random();
        int n;

        for (int j = 0; j < length; j++) {
            //Generate number between 0-999
            n = rand.nextInt(1000);
            i.add(n);
        }
    }
    //addAll: Add every int to the buckets using algorithm (Integer % 10^maxDig+1)/10^maxDig
    private static void addAll(ArrayList<IBucket<Integer>> a, ArrayList<Integer> x, int maxDig) {
        int mod = (int) Math.pow(10, maxDig+1);
        int div = (int) Math.pow(10, maxDig);
        for (Integer c : x) { a.get((c%mod)/div).add(c); }
    }
    //dumpAll: Dump every int from the buckets back to the list using dump fct from Bucket Interface
    //Clears arrayList first to remove old elements from last cycle
    private static void dumpAll(ArrayList<IBucket<Integer>> a, ArrayList<Integer> x) {
        x.clear();
        for (IBucket<Integer> anA : a) {anA.dump(x);}
    }
    //radixSort: Sort by radix using addAll, dumpAll, maxInt, and digits
    private static ArrayList<Integer> radixSort(ArrayList<Integer> x) {
        //time to make the buckets, create 10 of them (empty of course)
        ArrayList<IBucket<Integer>> buckets = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            buckets.add(new Bucket<>());
        }
        //radix sort: start with max digit of 0 and continue till digits-1 ("digits" amount, ex 123 will run 3 times)
        for (int i = 0; i < digits(maxInt(x)); i++) {
            //add
            addAll(buckets, x, i);
            System.out.println("Cycle " + (i+1) + " complete!");
            //dump
            dumpAll(buckets, x);
        }
        //time to return the sorted list
        return x;
    }
    public static void main(String[] args) {
        //create list of numbers and fill them (20 ints)
        ArrayList<Integer> numbers = new ArrayList<>();
        fill(numbers, 20);

        //Print original array
        System.out.println("Original Array: ");
        System.out.print(numbers + "\n");

        /*RADIX SORT*/
        radixSort(numbers);

        //Print sorted array =] All done!
        System.out.println("Sorted Array: ");
        System.out.println(numbers);
    }
}
