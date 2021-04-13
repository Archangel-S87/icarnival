<?php

$host = mb_strtolower(getenv("HTTP_HOST"));
$host = strtok($host, ':');
$file = 'http://'.$host.'/turbo_articles.php';
$newfile = 'files/turbo_articles.xml';

if (!copy($file, $newfile)) {
    echo "не удалось скопировать $file...\n";
} else {
	echo "файл создан\n";
}
?>