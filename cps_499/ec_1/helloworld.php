<?php
	session_start();
	$times = 'times';
	if (isset($_SESSION['views']))
		$_SESSION['views'] = $_SESSION['views'] + 1;
	else
	{
		$_SESSION['views'] = 1;
		$times = 'time';
	}
	echo "You have visted this page " . $_SESSION['views'] . " " . $times;
?>
