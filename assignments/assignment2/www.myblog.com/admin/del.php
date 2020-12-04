<?php 
  require("../classes/auth.php");
  require("header.php");
  require("../classes/db.php");
  require("../classes/phpfix.php");
  require("../classes/post.php");
?>

<?php  
  $nocsrftoken_get = $_GET["nocsrftoken_get"];
  if (!isset($nocsrftoken_get) or ($nocsrftoken_get != $_SESSION['nocsrftoken_get']))
  {
    echo "Cross Site Forgery Detected!";
    die();
  }

  $post = Post::delete((int)($_GET["id"]));
  header("Location: /admin/index.php");
?>

