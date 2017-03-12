/*Adriano Soares
March 2017
Professor Marlowe
Program: Searching.java
Purpose: To read in arrays from a .txt file, and use those arrays to test the effectiveness of
- Linear Search
- Binary Search
- Interpolation Search
 */

import java.io.BufferedReader;
import java.io.FileReader;
import java.text.DecimalFormat;

public class Searching {
    private static int successCount = 0;
    private static int failCount = 0;
    private static int linearSuccessProbes = 0;
    private static int linearFailProbes = 0;
    private static int binarySuccessProbes = 0;
    private static int binaryFailProbes = 0;
    private static int interSuccessProbes = 0;
    private static int interFailProbes = 0;

    private static int TOP = 9999;
    private static int SEARCH = 20;
    private static int SIZE = 100;

    private static String INPUT_FILE_NAME = "input.txt";
    private static String TARGET_FILE_NAME = "targets.txt";

    private static boolean terminate = false;

    public static void main(String[] ags) {
        //Read in numbers from a ASCII text file
        int[] numbers = read_array(SIZE);
        //If no errors with reading
        if(!terminate){
            int div = 0; //Count amount of tests (in case of early termination)
            try{
                BufferedReader br = new BufferedReader(new FileReader(TARGET_FILE_NAME));
                //Check first - can't report tests if none were run.
                String line = br.readLine();
                if(Integer.parseInt(line) > TOP)
                    throw new IllegalArgumentException("The first element is invalid.");
                else {
                    for (int i = 0; i < SEARCH; i++) {
                        int temp = Integer.parseInt(line);
                        if (temp < TOP) {
                            //Run linear and count amount of success/Failures
                            if (linear_search(numbers, temp))
                                successCount++;
                            else
                                failCount++;
                            binary_search(numbers, temp);
                            interpolation_search(numbers, temp);
                            div ++;
                        }
                        else{
                            throw new IllegalArgumentException("Some errors were detected. " +
                                    "Recorded results will still be printed.");
                        }
                        line = br.readLine();
                    }
                }
            }
            catch(Exception e) {
                System.out.println(e.getMessage());
            }
            //Print the results
            System.out.println(collect_results(div));
        }
        else
            System.out.println("There was error with the input. Tests did not run.");
    }

    private static boolean linear_search(int[] n, int target){
    int currentProbes = 0;
    for(int current : n) {
        currentProbes++;
        if (target == current) {
            linearSuccessProbes += currentProbes;
            return true;
        }
    }
    linearFailProbes += currentProbes;
    return false;
}
    private static boolean binary_search(int[] n, int target) {
        int start = 0, end = n.length-1, middle, currentProbes = 0;
        while (start <= end){
            currentProbes++;
            middle = (start + end)/2; //Find pivot index
            if(n[middle] < target)
                start = middle + 1;
            else if(n[middle] > target)
                end = middle - 1;
            else{
                binarySuccessProbes += currentProbes;
                return true;
            }
        }
        binaryFailProbes += currentProbes;
        return false;
    }
    private static boolean interpolation_search(int[] n, int target){
        int low = 0, high = n.length - 1, pos, currentProbes = 0;
        while(n[low] != n[high] && target >= n[low] && target <= n[high]){
            currentProbes++;
            pos = low + (((high-low)/(n[high] - n[low]))* (target - n[low])); // Find pivot index
            if(target > n[pos]) //Slice element range
                low = pos + 1;
            else if(target < n[pos]){
                high = pos - 1;}
            else{
                interSuccessProbes += currentProbes;
                return true;
            }
        }
        if(target == n[low]){
            interSuccessProbes += currentProbes;
            return true;
        }
        else{
            interFailProbes += currentProbes;
            return false;
        }
    }
    private static String collect_results(int div){
        //Return the statistics found from the tests
        DecimalFormat df = new DecimalFormat();
        df.setMaximumFractionDigits(3);
        return  "Actual Number of Tests Run: " + div +
                "\n\nTotal Successes: " + successCount +
                "\nTotal Failures: " + failCount +
                "\n\nLinear Probes(Successes): " + linearSuccessProbes +
                "\nLinear Probes(Failures): " + linearFailProbes +
                "\nFinal Stats: " + df.format((double)linearSuccessProbes/div) + " average success and " +
                df.format((double)linearFailProbes/div) + " average failure." +
                "\n\nBinary Probes(Successes): " + binarySuccessProbes +
                "\nBinary Probes(Failures): " + binaryFailProbes +
                "\nFinal Stats: " + df.format((double)binarySuccessProbes/div) + " average success and " +
                df.format((double)binaryFailProbes/div) + " average failure." +
                "\n\nInterpolation Probes(Successes): " + interSuccessProbes +
                "\nInterpolation Probes(Failures): " + interFailProbes +
                "\nFinal Stats: : " + df.format((double)interSuccessProbes/div) + " average success and " +
                df.format((double)interFailProbes/div) + " average failure.";

    }

    private static int[] read_array(int length){
        int[] values = new int[length];
        try {
            BufferedReader br = new BufferedReader(new FileReader(INPUT_FILE_NAME));
            //Input precondition = file contains SIZE lines with one number each. SIZE > 0
            String line = br.readLine();
            //Check first to avoid back-check boundary errors (so i don't have to check every time in main loop)
            if (line.matches("[0-9]+"))
                values[0] = Integer.parseInt(line);
            else throw new IllegalArgumentException(line + " is not valid input! Stopped at index 0.");
            //Add the rest of the file to array. Checks for input validity + sorted?
            for (int i = 1; i < length; i++) {
                line = br.readLine();
                if (line.matches("[0-9]+")) {
                    int temp = Integer.parseInt(line);
                    if (temp > values[i - 1] && temp < TOP)
                        values[i] = temp;
                    else
                        throw new IllegalArgumentException("The input isn't properly sorted, or a number" +
                                " is too large! Stopped at index " + (i + 1) + '.');
                } else
                    throw new IllegalArgumentException(line + " is not valid input! Stopped at index " + (i + 1) + '.');
            }
        }
        catch(Exception e) {
            System.out.println(e.getMessage());
            terminate = true; //There was an error. Don't run any more code in main
        }
        return values;
    }
}