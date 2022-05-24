<!DOCTYPE html>
<html>
<body>
<?php
include("db.php");

try{
	$sqlList = "SELECT * from public.user";
	foreach($pdo->query($sqlList) as $row)
	{
		print"<br/>";
		print $row['id'].'-'.$row['name'].'-'.$row['passwd'].'<br/>';
	}
}catch(PDOException $e){
	echo $e->getMessage();
}

?>
</body>
</html>