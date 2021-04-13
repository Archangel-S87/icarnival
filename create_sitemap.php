<?php

$host = mb_strtolower(getenv("HTTP_HOST"));
$host = strtok($host, ':');
$file = 'http://'.$host.'/sitemap.php';
$newfile = 'files/sitemap.xml';

if (!copy($file, $newfile)) {
    echo "не удалось скопировать $file...\n";
} else {
	echo "файл создан\n";
}
?>