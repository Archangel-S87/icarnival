<?php
$file = 'http://'.$_SERVER['HTTP_HOST'].'/sitemap.php';
$newfile = 'files/sitemap.xml';

if (!copy($file, $newfile)) {
    echo "не удалось скопировать $file...\n";
} else {
	echo "файл создан\n";
}
?>