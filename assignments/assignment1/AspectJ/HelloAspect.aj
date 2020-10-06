public aspect HelloAspect{
	pointcut greeting(): call(* Hello.greeting(..));
	before(): greeting(){
          System.out.print("AOP test: ");    
    	}
}
