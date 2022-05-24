<?php
$dbuser = 'njmpjiryyfpqis';
$dbpass = '2574ff022a08e693a9b1b35b8d046a7a576ecb85558437324044db954631d785';
$host = 'ec2-52-54-212-232.compute-1.amazonaws.com';
$dbname='derfs246lv7flk';
$port="5432";
$dsn = "pgsql:host=$host;port=$port;dbname=$dbname;user=$dbuser;password=$dbpass;sslmode=require";
try{
	$pdo = new PDO($dsn);
	if($pdo){
		//echo "Connected to the $dbname database successfully!";
		;
	}
}catch (PDOException $e){
	// Show error message
	echo $e->getMessage();
}


?>
