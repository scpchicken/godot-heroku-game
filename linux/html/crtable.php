<?php
include("db.php");

$sql = "DROP TABLE IF EXISTS public.user";
$pdo->exec($sql);

$sql = "CREATE TABLE IF NOT EXISTS public.user(
id serial PRIMARY KEY,
name varchar(40) NOT NULL UNIQUE,
passwd varchar(40) NOT NULL
)";

$pdo->exec($sql);

	
?>