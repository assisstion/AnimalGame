<?php
if (get_magic_quotes_gpc()){
	$process = array(&$_GET, &$_POST, &$_COOKIE, &$_REQUEST);
	while (list($key, $val) = each($process)){
		foreach ($val as $k => $v){
			unset($process[$key][$k]);
			if (is_array($v)){
				$process[$key][stripslashes($k)] = $v;
				$process[] = &$process[$key][stripslashes($k)];
			}
			else{
				$process[$key][stripslashes($k)] = stripslashes($v);
			}
		}
	}
	unset($process);
}
if(!((isset($_POST['value'])) && (isset($_POST['hash'])) && (isset($_POST['old_hash'])))){
	echo 'Invalid request!';
	exit();
}

try
{
	$pdo = new PDO('mysql:host=localhost;dbname=ofeng_markusfeng_animal', 'ofeng_animaluser', 'PASS');
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	$result = $pdo->query('SELECT hash FROM meta');

	$hash = 0;
	while ($row = $result->fetch()){
		$hash = $row['hash'];
	}
	
	if($result->rowCount() != 0 && !($hash === $_POST['old_hash'])){
		echo 'Invalid hash';
    	exit();
	}

	$n = $pdo->query('SELECT count(*) ' .
				'FROM information_schema.tables ' .
				'WHERE table_schema = \'ofeng_markusfeng_animal\' ' .
				'AND table_name = \'meta\' ');
	//if($n == 0){
	$pdo->exec('CREATE TABLE IF NOT EXISTS meta ' .
				'( ' .
				'value TEXT, ' .
				'hash TEXT' .
				') ');
	//}
	$pdo->exec('DELETE FROM meta ');
	$sql = 'INSERT INTO meta ' .
			'VALUES (:value, :hash) ';
	$s = $pdo->prepare($sql);
	$s->bindValue(':value', $_POST['value']);
	$s->bindValue(':hash', $_POST['hash']);
	$s->execute();
	echo 'Success!';
}
catch (PDOException $e)
{
	echo $e.getMessage;
	exit();
}
?>
