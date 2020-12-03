<?php 
  require("../classes/auth.php");
  require("header.php");
  require("../classes/db.php");
  require("../classes/phpfix.php");
  require("../classes/post.php");
  $rand = bin2hex(openssl_random_pseudo_bytes(16));
  $_SESSION["nocsrftoken"] = $rand; 
?>

  <form action="index.php" method="POST" enctype="multipart/form-data">
    Title: <input type="text" name="title" /><br/>
    Text: <textarea name="text" cols="80" rows="5">
        </textarea><br/>

        <input type="hidden" name="nocsrftoken" value="<?php echo $rand ?>"/> 
    <input type="submit" name="Add" value="Add">

  </form>

<?php
  require("footer.php");

?>

