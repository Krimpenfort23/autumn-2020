<?php
  $httponly = TRUE;
  $path = "/";
  $domain = "krimpenforte1.myblog.com"; // Your local domain
  $secure = TRUE;
  session_set_cookie_params (60*15,$path,$domain,$secure,$httponly);
  session_start();
  require('../classes/db.php'); 
  require('../classes/user.php'); 

  if (isset($_POST["user"]) and isset($_POST["password"]) )
    if (User::login($_POST["user"],$_POST["password"])){
      $_SESSION["admin"] = User::SITE;
      $_SESSION["user"] = $_POST["user"];
      $_SESSION["browser"] = $_SERVER["HTTP_USER_AGENT"];
    }  
      
  if (!isset($_SESSION["admin"] ) or $_SESSION["admin"] != User::SITE) {
    header( 'Location: /admin/login.php' ) ;
    die();
  }
  if ($_SESSION["browser"] != $_SERVER["HTTP_USER_AGENT"])
  {
    echo "<script>alert('Session Hijacking Detected!')</script>";
    die();
  }
?>
