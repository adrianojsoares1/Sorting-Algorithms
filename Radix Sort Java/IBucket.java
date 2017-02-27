import java.util.ArrayList;

/**
 * Created by soaresad on 11/22/2016.
 */
public interface IBucket<T> {

	//add to a bucket
    public void add(T t);
    //dump a bucket
    public ArrayList<T> dump(ArrayList<T> x);
    //return elements of a bucket
    public ArrayList<T> elems();
    //return size of a bucket
    public int size();

}
