### This folder contains the source code of the ShoppingCart Java application with the following source files:

* wallet.txt: the database file storing the balance. The value in this file is 30000 (i.e. you have $30000 in your Wallet). 

* pocket.txt: the database file storing purchased products. This file is empty.

* Wallet.java: Interacts with the wallet.txt file to read and update (withdraw) from the the balance.

* Pocket.java: Interacts with the pocket.txt file which store the products have been purchased.

* Store.java: Interacts with the product options and prices.

* ShoppingCart.java: This is the main program,  a simple server application in Java, performing the following tasks:
	
	* Create a server socket and listen on port 8888.
	
	* Loop forever to check if there is a connection from a client, accept that connection and create a new thread to handle this connection and back to the loop. Within a thread, do the following steps:


        1. load and print the current balance (from the wallet.txt file).

        2. print the product list and their prices and ask the user to type a product to buy.

        3. get the product input from the user and load the product price.

        4. check to ensure the balance is sufficient; if so

			* withdraw the amount of the product’s price from the wallet i.e., by updating the content of the wallet.txt file,

			* add the name of the product to the pocket.txt file and print the confirmation, 

			* load and print the new balance (from the wallet.txt file);

        5. otherwise, alert the user that the balance is not sufficient to buy the product.

        6. terminate the thread and disconnect the client.