<?php

$host = mb_strtolower(getenv("HTTP_HOST"));
$host = strtok($host, ':');
$file = 'http://'.$host.'/turbo_blog.php';
$newfile = 'files/turbo_blog.xml';

if (!copy($file, $newfile)) {
    echo "не удалось скопировать $file...\n";
} else {
	echo "файл создан\n";
}
?>