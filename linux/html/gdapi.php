<?php
include("db.php");

$json = file_get_contents('php://input');
$data = json_decode($json, true);
$act = $data["act"];
$name = $data["name"];
$passwd = $data["passwd"];

switch ($act) {
  case 'listUser':
    echo listUser($pdo,$name);
    break;
  case 'all':
    echo allUsers($pdo);
    break;
  case 'insert':
    echo insertUser($pdo,$name,$passwd);
    break;
  case 'update':
    echo updateUser($pdo,$name,$passwd);
    break;
  case 'delete':
    echo deleteUser($pdo,$name,$passwd);
    break;
}

function listUser($pdo,$name){
  try{
	$sql = "SELECT id,name,passwd FROM public.user WHERE name = :name" ;
	$stmt = $pdo->prepare($sql);
    $stmt->bindValue(':name', $name);
    $stmt->execute();
	$result = $stmt->fetchAll();   
	if ($result==null){return json_encode($ret_arr);}
	return json_encode($result);
  }
  catch(PDOException $e){
	echo 'error'.$e->getMessage();
  }	
}
	
function insertUser($pdo ,$name, $passwd){
	$ret_arr= array();
    try{
	$sql = 'INSERT INTO public.user(name,passwd) VALUES(:name,:passwd)';
    $stmt = $pdo->prepare($sql);
    // pass values to the statement
    $stmt->bindValue(':name', $name);
    $stmt->bindValue(':passwd', $passwd);
    // execute the insert statement
    $stmt->execute();
    
	}catch(PDOException $e){
		echo $e->getMessage();
	}
	// return generated id
	$id = $pdo->lastInsertId('user_id_seq');
	try{
	$sql = 'SELECT id,name,passwd from public.user WHERE id = :id';
	$stmt = $pdo->prepare($sql);
    // pass values to the statement
    $stmt->bindValue(':id', $id );
	$stmt->execute();
	$result = $stmt->fetchAll(); 
	return json_encode($result);
	}
	catch(PDOException $e){
	echo 'error'.$e->getMessage();
  }	
}
function allUsers($pdo){
	$list = '';
	$ret_arr = array();
	try{
	$sql = "SELECT * from public.user";
	foreach($pdo->query($sql) as $row)
		{
			array_push($ret_arr, $row['id'].$row['name']);

		}
	
	}
	catch(PDOException $e){
		echo 'error'.$e->getMessage();
	}
	return json_encode($ret_arr);
}


	
?>

