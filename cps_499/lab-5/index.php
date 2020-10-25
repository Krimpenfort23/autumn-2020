<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Simple Web Application - Lab 5 - SS-LBS</title>
</head>
<body>
	<h1>SS-LBS-Lab 5 - Session Hijacking and Protection</h1>
	<h2>Simple Web Application</h2> 
   	<h2>Simple index page by <font color="blue">Phu Phung</font>, customized by "Evan Krimpenfort"</h2>
<?php 
	session_start();
	$welcome = "Welcome back "; //default message for return users
	$username = $_POST["username"]; //username input from the user via HTTP Request POST
	$password = $_POST["password"]; //password input from the user via HTTP Request POST
  	/*for debug only*/echo "DEBUG>Received: username=\"" . $username .  "\" and password=\"" . $password . "\"<br>\n";
	if (isset($username) and isset($password) ){
	//the case username and password is provided
    	if (mockchecklogin($username,$password)){ 
      		$_SESSION["logged"]=TRUE;
			$_SESSION["username"] = $username;
            $_SESSION["browser"] = $_SERVER["HTTP_USER_AGENT"];
			$welcome = "Welcome "; //not previously logged-in 
    	}else{//failed
			redirect_login('Invalid username/password');
		}
	}else{//no username/password is provided
		//check if the session has NOT been logged in, redirect to the login page
		if ($_SESSION["logged"]!=TRUE) {
    		redirect_login('You have not logged in. Please login first!');
  		}
        if ($_SESSION["browser"] = $_SERVER["HTTP_USER_AGENT"])
        {
            echo "<script>alert('Session Hijacking is detected.');</script>\n";
            session_destroy();
            header("Refresh:0; url=login.php");
            die();
        }
	}
	//the main business logic implementation of the page
	echo "Current time: " . date("Y-m-d h:i:sa") . "\n";
	echo "<h2>" .  $welcome . "<font color='blue'>" . $_SESSION["username"] . "</font>!</h2>\n";
?>
	<a href="logout.php">Logout</a>
<?php	
	//supporting functions	
	function redirect_login($message){
		echo "<script>alert('" . $message . "');</script>\n";
		session_destroy();//clear all session variables 
		header("Refresh:0; url=login.php");
    	die();
	}
	function mockchecklogin($username, $password) {
		//we only do mock-up check for this lab
		if (($username== "krimpenforte1@udayton.edu") and ($password == "bobgeorge")) 
		  return TRUE;
		return FALSE;
  	}
?>
</body>
</html>

