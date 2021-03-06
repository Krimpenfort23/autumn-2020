import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;

public class Wallet 
{
   /**
    * The RandomAccessFile of the wallet file
    */  
   private RandomAccessFile file;
   private boolean isLocked;

   /**
    * Creates a Wallet object
    *
    * A Wallet object interfaces with the wallet RandomAccessFile
    */
    public Wallet () throws Exception 
    {
	    this.file = new RandomAccessFile(new File("wallet.txt"), "rw");
        isLocked = false;
    }

   /**
    * Gets the wallet balance. 
    *
    * @return                   The content of the wallet file as an integer
    */
    public int getBalance() throws IOException 
    {
	    this.file.seek(0);
	    return Integer.parseInt(this.file.readLine());
    }

   /**
    * Sets a new balance in the wallet
    *
    * @param  newBalance          new balance to write in the wallet
    */
    public void setBalance(int newBalance) throws Exception 
    {
	    this.file.setLength(0);
	    String str = new Integer(newBalance).toString()+'\n'; 
	    this.file.writeBytes(str); 
    }

   /**
    * Closes the RandomAccessFile in this.file
    */
    public void close() throws Exception 
    {
	    this.file.close();
    }

   /**
    * New function that allows the user to safely withdraw money from the Wallet.txt file
    */
    public int safeWithdraw(int valueToWithdraw) throws Exception 
    {
        int previousBalance = 0;
        int newBalance = 0;

        while(isLocked) {}  // locking loop

        isLocked = true;
        previousBalance = this.getBalance();
        newBalance = previousBalance - valueToWithdraw;
        this.setBalance(newBalance);
        isLocked = false;

        return previousBalance;
    }


   /**
    * New function that allows the user to safely deposit money from the Wallet.txt file
    */
    public void safeDeposit(int valueToDeposit) throws Exception 
    {
        int previousBalance = 0;
        int newBalance = 0;

        while(isLocked) {}  // locking loop

        isLocked = true;
        previousBalance = this.getBalance();
        newBalance = previousBalance + valueToDeposit; 
        this.setBalance(newBalance);
        isLocked = false;
    }
}
