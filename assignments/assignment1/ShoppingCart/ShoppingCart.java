import java.util.Scanner;
import java.util.Date;
import java.io.*;  
import java.net.*; 

public class ShoppingCart  {

  	public static void main(String[] args) throws Exception {

		try{
	 		int port = 8888;
	 		ServerSocket serversocket=new ServerSocket(port);  
	   		System.out.println("ShoppingCart program is running on port " + port);
	   		System.out.println("Waiting for connections from clients");
	  		while (true){
		 		Socket socket=serversocket.accept();//establishes connection 
		   		System.out.println("A new customer is connected!");  
				OutputStreamWriter outputstreamwriter= new  OutputStreamWriter(socket.getOutputStream());
				BufferedReader bufferreader= new BufferedReader(new InputStreamReader(socket.getInputStream()));
				Thread thread=new Thread(new ServerThread(socket,outputstreamwriter,bufferreader));
		   		thread.start();
			}
		}catch(IOException ex){
			System.out.println(ex.getMessage());
		}
	}

	public static  class ServerThread  extends Exception implements Runnable  {
		final Socket socket;
		final BufferedReader bufferreader; 
		final OutputStreamWriter outputstreamwriter; 

	   	public ServerThread(Socket socket, OutputStreamWriter outputstreamwriter, BufferedReader bufferreader){
		    this.socket = socket;
		    this.outputstreamwriter=outputstreamwriter;
		    this.bufferreader=bufferreader;
		}

	   	public void run() {

		   	try{
				Scanner input = new Scanner(System.in);
				PrintWriter out=new PrintWriter(outputstreamwriter);
			   	Wallet wallet = new Wallet();
			   	int balance = wallet.getBalance();
				//Add your name after SS-LBS!!! 
				out.println("Welcome to SS-LBS's ShoppingCart. The time now is " + (new Date()).toString());
				out.println("Your balance: " + balance+ " credits");
				out.println("Please select your product: ");
			    
				for (Object element :Store.asString() ) {
					out.println(element);
			   	}
				
				out.println("What do you want to buy, type e.g., pen?");
			    	out.flush();
			    	String product = bufferreader.readLine(); 
			    	int price = Store.getPrice(product);
				
				if(balance>=price){
					wallet.setBalance(balance-price);
					Pocket pocket = new Pocket();
					pocket.addProduct(product);
					out.println("You have sucessfully purchased a '" + product + "'");
					out.println("Your new balance: " + wallet.getBalance()+ " credits");
			        	out.flush();
				}else{
					out.println("Your balance is less than the price");
					out.flush();
				}

			 	socket.close();
			}catch(Exception ex){
		   		System.out.println(ex.getMessage());
		    }
		}
	}
}
