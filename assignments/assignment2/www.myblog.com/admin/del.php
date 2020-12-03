<?php 
  require("../classes/auth.php");
  require("header.php");
  require("../classes/db.php");
  require("../classes/phpfix.php");
  require("../classes/post.php");

  $rand = bin2hex(openssl_random_pseudo_bytes(16));
  $_SESSION["nocsrftoken"] = $rand; 
?>

<?php  
  $post = Post::delete((int)($_GET["id"]));
  header("Location: /admin/index.php");
?>

