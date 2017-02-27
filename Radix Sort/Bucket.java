/**
 * Created by soaresad on 11/22/2016.
 */
import java.util.ArrayList;

public class Bucket<T> implements IBucket<T> {

    private ArrayList<T> elements;

    //constructs a new bucket
    public Bucket()
    {
        elements = new ArrayList<T>();
    }

    //add an element to a bucket
    public void add(T t)
    {
        elements.add(t);
    }

    //add all of the elements of the bucket to the arraylist and clear the bucket
    public ArrayList<T> dump(ArrayList<T> x)
    {
        x.addAll((ArrayList<T>) this.elements.clone());

        elements.clear();

        return x;
    }
    //reutrn the number of elements in a bucket
    public int size(){return elements.size();}

    //return the elements in the bucket
    public ArrayList<T> elems()
    {
        return this.elements;
    }

}
