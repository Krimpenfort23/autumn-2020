public aspect ShoppingCartAspectJ
{
    pointcut safeWithdraw(int price): call(* Wallet.safeWithdraw(int)) && args(price);
    before(int price): safeWithdraw(price)
    {
        try
        {
            Wallet wallet = new Wallet();
            if (wallet.getBalance() - price < 0)
            {
                System.out.println("The amount withdrawn is too much: " + price + " credits");
            }
        }
        catch (Exception e)
        {
            System.out.println("Wallet threw an exception.");
        }
    }
    after(int price) returning (int withdrawnAmount): safeWithdraw(price)
    {
        try
        {
            Wallet wallet = new Wallet();
            if (withdrawnAmount - price < 0)
            {
                wallet.safeDeposit(price);
                System.out.println(withdrawnAmount + " credits was returned to the owner.");
                System.exit(1);
            }
        }
        catch (Exception e)
        {
            System.out.println("Wallet threw an exception.");
        }
    }
}
