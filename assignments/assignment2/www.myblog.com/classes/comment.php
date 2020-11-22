<?php

class Comment {

  public $title, $id;
  function __construct($id, $title, $author, $text) {
    $this->id = $id;
    $this->title = $title;
    $this->text = $text;
    $this->author = $author;
  }
  
  function from_row($row){
    return new Comment($row['id'],$row['title'], $row['author'], $row['text']);
  }
  function all($post_id=NULL) {
    global $dblink;
    $sql = "SELECT * FROM comments";
    if (isset($post_id)) {
      $sql.= "WHERE post_id=".intval($post_id);
    }
    $results = mysqli_query($dblink, $sql);
    $comments = Array();
    while ($row = mysqli_fetch_assoc($results)) {
      $comments[] = from_row($row);
    }
    return $comments;

  }


}
?>
