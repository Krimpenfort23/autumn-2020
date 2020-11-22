<?php

class User {
  const SITE= "BLOG";
  function login($user, $password) {
    global $dblink;
    $sql = "SELECT * FROM users where login=\"";
    $sql.= mysqli_real_escape_string($dblink, $user);
    $sql.= "\" and password=md5(\"";
    $sql.= mysqli_real_escape_string($dblink, $password);
    $sql.= "\")";
    $result = mysqli_query($dblink, $sql);
    if ($result) {
      $row = mysqli_fetch_assoc($result);
      if ($user === $row['login']) {
        return TRUE;
      }
    }
    else 
      echo mysqli_error($dblink);
    return FALSE;
    //die("invalid username/password");
  }


}
?>
