import java.util.*; 
public class Store {
        /**
        * Returns the product list as a List. 
        *
        * @return    product list
        */
        public static List asString(){
 		List<String> list = Arrays.asList("candies - 1", "car - 30000", "pen - 40", "book - 100");
 		return list;
        }
	/**
	* return price of the product
	*/
	public static int getPrice(String product){
		int price = 0;		
		if (product.equals("candies"))
             		price = 1;
		if (product.equals("car"))
             		price = 30000;
		if (product.equals("pen"))
             		price = 40;
		if (product.equals("book"))
             		price = 100;
     		return price;
        }
}
		
