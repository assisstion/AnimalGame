<?php
$var = 'none';

try
{
	$pdo = new PDO('mysql:host=localhost;dbname=ofeng_markusfeng_animal', 'ofeng_animaluser', 'PASS');
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	
	$n = $pdo->query('SELECT count(*) ' .
				'FROM information_schema.tables ' .
				'WHERE table_schema = \'ofeng_markusfeng_animal\' ' .
				'AND table_name = \'meta\' ');
				if($n == 0){
					$var = 'a';
				}
				else{
					$var = 'b';
				}
	//if($n == 0){
	$pdo->exec('CREATE TABLE IF NOT EXISTS meta ' .
				'( ' .
				'value TEXT, ' .
				'hash TEXT' .
				') ');
	//}
	$result = $pdo->query('SELECT value, hash FROM meta');
}
catch (PDOException $e)
{
	echo $var . $e.getMessage;
	exit();
}
$done = 0;
while ($row = $result->fetch()){
	$done = 1;
	echo $row['hash'] . '$' . $row['value'];
}
if($done == 0){
	echo '0$';
}
?>
