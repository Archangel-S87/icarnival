<?php

$host = mb_strtolower(getenv("HTTP_HOST"));
$host = strtok($host, ':');
$file = 'http://'.$host.'/yandex.php';
$newfile = 'files/yandex.xml';

if (!copy($file, $newfile)) {
    echo "не удалось скопировать $file...\n";
} else {
	echo "файл создан\n";
}
?>