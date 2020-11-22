<?php

    $dblink = mysqli_connect("localhost", "<database-username>", "<database-password>","blog");
    if (mysqli_connect_errno()) {
    	printf("Connect failed: %s\n", mysqli_connect_error());
    	exit();
    }

?>
