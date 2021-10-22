<?php

$dbhost = '127.0.0.1';
$dbuname = 'root';
$dbpass = '';
$dbname = 'vietnamOperations';

//$dbo = new PDO('mysql:host=abc.com;port=8889;dbname=$dbname, $dbuname, $dbpass);

$dbo = new PDO('mysql:host=' . $dbhost . ';port=3308;dbname=' . $dbname, $dbuname, $dbpass);

?>
