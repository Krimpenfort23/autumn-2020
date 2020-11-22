<?php
  $site = "myblog.com -SS-LBS at UDayton";
  require "header.php";
  $posts = Post::all();
?>
  <div class="block" id="block-text">
    <div class="secondary-navigation">
      <div class="content">
      <?php 
    	foreach ($posts as $post) {
            echo $post->render(); 
      } ?> 
     </div>
 
    </div>
  </div>


<?php


  require "footer.php";
?>

