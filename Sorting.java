public class Sorting{

public static int[] selectionSort(int[] a)
{
int leastDig;
int temp = 0;
	for(int i = 0;i<a.length;i++){
		leastDig = i;
		for(int j = i+1;j<a.length;j++)
			if(a[j] < a[leastDig]){leastDig = j;}
		temp = a[i];
		a[i] = a[leastDig];
		a[leastDig] = temp;
	}
	return a;
} //end selectionSort

public static int[] bubbleSort(int[] a)
{
boolean swapped = false;
int temp = 0;
	while(!swapped){
		for(int i = 1;i<a.length;i++){
			if(a[i] < a[i-1]){
				temp = a[i];
				a[i] = a[i-1];
				a[i-1] = temp;
				swapped = true;}
		}
		if(swapped){swapped = !swapped;}
		else {swapped = true;}
	}
	return a;
}//end bubbleSort

public static int[] insertionSort(int[] a){
int temp = 0;
	for(int i = 1,j=i;i<a.length;i++){
		j = i;
		while(j>0 && a[j-1] > a[j]){
			temp = a[j];
			a[j] = a[j-1];
			a[j-1] = temp;
			j--;
		}
	}
	return a;	
}//end insertionSort

//NEXT UP: QUICKSORT, MERGESORT, TOURNAMENT SORT
		
public static void main(String[] args)
{
}

}//end class
		
		
			
			
			
		