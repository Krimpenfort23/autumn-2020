import java.util.Scanner;
import java.util.Date;
import java.io.*;  
import java.net.*; 

public class ShoppingCart  
{
  	public static void main(String[] args) throws Exception 
    {
		try
        {
	 		int port = 8888;
	 		ServerSocket serversocket=new ServerSocket(port);  
	   		System.out.println("ShoppingCart program is running on port " + port);
	   		System.out.println("Waiting for connections from clients");
	  		while (true)
            {
		 		Socket socket=serversocket.accept();//establishes connection 
		   		System.out.println("A new customer is connected!");  
				OutputStreamWriter outputstreamwriter= new  OutputStreamWriter(socket.getOutputStream());
				BufferedReader bufferreader= new BufferedReader(new InputStreamReader(socket.getInputStream()));
				Thread thread=new Thread(new ServerThread(socket,outputstreamwriter,bufferreader));
		   		thread.start();
			}
		}
        catch(IOException ex)
        {
			System.out.println(ex.getMessage());
		}
	}

	public static class ServerThread extends Exception implements Runnable  
    {
		final Socket socket;
		final BufferedReader bufferreader; 
		final OutputStreamWriter outputstreamwriter; 

	   	public ServerThread(Socket socket, OutputStreamWriter outputstreamwriter, BufferedReader bufferreader)
        {
		    this.socket = socket;
		    this.outputstreamwriter=outputstreamwriter;
		    this.bufferreader=bufferreader;
		}

	   	public void run() 
        {
		   	try
            {
				Scanner input = new Scanner(System.in);
				PrintWriter out=new PrintWriter(outputstreamwriter);
			   	Wallet wallet = new Wallet();
				out.println("Welcome to Evan Krimpenfort's ShoppingCart. The time now is " + (new Date()).toString());
				out.println("Please select your product: ");
			    
				for (Object element :Store.asString()) 
                {
					out.println(element);
			   	}
			    
                String product = "";
                int price = 0;
                while(true)
                {
				    out.println("What do you want to buy, type e.g., pen?");
			        out.flush();
			        product = bufferreader.readLine();
			        price = Store.getPrice(product);
                    if (price > 0) { break; }
                    out.println("That Item is not available. Pick another item.");
                }
				
                out.println("Your balance: " + wallet.getBalance() + " credits");
			    wallet.safeWithdraw(price);	// REPLACED
				Pocket pocket = new Pocket();
				pocket.addProduct(product);
				out.println("You have sucessfully purchased a '" + product + "'");
				out.println("Your new balance: " + wallet.getBalance() + " credits");
		       	out.flush();
			 	socket.close();
			}
            catch(Exception ex)
            {
		   		System.out.println(ex.getMessage());
		    }
		}
	}
}
