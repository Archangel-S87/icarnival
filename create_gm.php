<?php

$host = mb_strtolower(getenv("HTTP_HOST"));
$host = strtok($host, ':');
$file = 'http://'.$host.'/google.php';
$newfile = 'files/google.xml';

if (!copy($file, $newfile)) {
    echo "не удалось скопировать $file...\n";
} else {
	echo "файл создан\n";
}
?>