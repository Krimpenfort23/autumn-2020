<?php

    $dblink = mysqli_connect("localhost", "krimpenforte1", "bobgeorge","blog");
    if (mysqli_connect_errno()) {
    	printf("Connect failed: %s\n", mysqli_connect_error());
    	exit();
    }

?>
