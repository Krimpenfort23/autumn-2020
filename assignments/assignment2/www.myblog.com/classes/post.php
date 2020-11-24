<?php

class Post{
  public $id, $title, $text, $published;
  function __construct($id, $title, $text, $published){
    $this->title= $title;
    $this->text = $text;
    $this->published= $published;
    $this->id = $id;
  }   

 
  function all($cat=NULL,$order =NULL) {
    global $dblink;
    $sql = "SELECT * FROM posts";
    if (isset($order)) 
      $sql .= "order by ".mysqli_real_escape_string($dblink, $order);  
    $results= mysqli_query($dblink, $sql);
    $posts = Array();
    if ($results) {
      while ($row = mysqli_fetch_assoc($results)) {
        $posts[] = new Post($row['id'],$row['title'],$row['text'],$row['published']);
      }
    }
    else {
      echo mysqli_error($dblink);
    }
    return $posts;
  }
 

  function render_all($pics) {
    echo "<ul>\n";
    foreach ($pics as $pic) {
      echo "\t<li>".$pic->render()."</a></li>\n";
    }
    echo "</ul>\n";
  }
 function render_edit() {
    $str = "<img src=\"uploads/".h($this->img)."\" alt=\"".h($this->title)."\" />";
    return $str;
  } 
  

  function render() {
    $str = "<h2 class=\"title\"><a href=\"/post.php?id=".h($this->id)."\">".h($this->title)."</a></h2>";
    $str.= '<div class="inner" align="center">';
    $str.= "<p>".htmlentities($this->text)."</p></div>";   
    $str.= "<p><a href=\"/post.php?id=".h($this->id)."\">";
    $count = $this->get_comments_count();
    switch ($count) {
    case 0:
        $str.= "Be the first to comment";
        break;
    case 1:
        $str.= "1 comment";
        break;
    case 2:
        $str.= $count." comments";
        break;
    }    
    $str.= "</a></p>";
    return $str;
  }
  function add_comment() {
    global $dblink;
    $sql  = "INSERT INTO comments (title,author, text, post_id) values ('";
    $sql .= mysqli_real_escape_string($dblink, $_POST["title"])."','";
    $sql .= mysqli_real_escape_string($dblink, $_POST["author"])."','";
    $sql .= mysqli_real_escape_string($dblink, $_POST["text"])."',";
    $sql .= intval($this->id).")";
    $result = mysqli_query($dblink, $sql);
    echo mysqli_error(); 
  } 
  function render_with_comments() {
    $str = "<h2 class=\"title\"><a href=\"/post.php?id=".h($this->id)."\">".h($this->title)."</a></h2>";
    $str.= '<div class="inner" style="padding-left: 40px;">';
    $str.= "<p>".htmlentities($this->text)."</p></div>";   
    $str.= "\n\n<div class='comments'><h3>Comments: </h3>\n<ul>";
    foreach ($this->get_comments() as $comment) {
      $str.= "\n\t<li>".$comment->text."</li>";
    }
    $str.= "\n</ul></div>";
    return $str;
  }

  function get_comments_count() {
    global $dblink;
    if (!preg_match('/^[0-9]+$/', $this->id)) {
      die("ERROR: INTEGER REQUIRED");
    }
    $comments = Array();
    $result = mysqli_query($dblink, "SELECT count(*) as count FROM comments where post_id=".$this->id);
    $row = mysqli_fetch_assoc($result);
    return $row['count'];
  } 
 
  function get_comments() {
    global $dblink;
    if (!preg_match('/^[0-9]+$/', $this->id)) {
      die("ERROR: INTEGER REQUIRED");
    }
    $comments = Array();
    $results = mysqli_query($dblink, "SELECT * FROM comments where post_id=".$this->id);
    if (isset($results)){
      while ($row = mysqli_fetch_assoc($results)) {
        $comments[] = Comment::from_row($row);
      }
    }
    return $comments;
  } 
 
  function find($id) {
    global $dblink;
    $result = mysqli_query($dblink, "SELECT * FROM posts where id=".$id);
    $row = mysqli_fetch_assoc($result); 
    if (isset($row)){
      $post = new Post($row['id'],$row['title'],$row['text'],$row['published']);
    }
    return $post;
  
  }
  function delete($id) {
    global $dblink;
    if (!preg_match('/^[0-9]+$/', $id)) {
      die("ERROR: INTEGER REQUIRED");
    }
    $result = mysqli_query($dblink, "DELETE FROM posts where id=".(int)$id);
  }
  
  function update($title, $text) {
      global $dblink;
      $sql = "UPDATE posts SET title='";
      $sql .= mysqli_real_escape_string($dblink, $_POST["title"])."',text='";
      $sql .= mysqli_real_escape_string($dblink, $_POST["text"])."' WHERE id=";
      $sql .= intval($this->id);
      $result = mysqli_query($dblink,$sql);
      $this->title = $title; 
      $this->text = $text; 
  } 
 
  function create(){
      global $dblink;
      $sql = "INSERT INTO posts (title, text) VALUES ('";
      $title = mysqli_real_escape_string($dblink, $_POST["title"]);
      $text = mysqli_real_escape_string($dblink, $_POST["text"]);
      $sql .= $title."','".$text;
      $sql.= "')";
      $result = mysqli_query($dblink,$sql);

  }
}
?>
