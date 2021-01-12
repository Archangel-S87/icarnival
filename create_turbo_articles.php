<?php
$file = 'http://'.$_SERVER['HTTP_HOST'].'/turbo_articles.php';
$newfile = 'files/turbo_articles.xml';

if (!copy($file, $newfile)) {
    echo "не удалось скопировать $file...\n";
} else {
	echo "файл создан\n";
}
?>