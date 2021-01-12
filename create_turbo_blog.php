<?php
$file = 'http://'.$_SERVER['HTTP_HOST'].'/turbo_blog.php';
$newfile = 'files/turbo_blog.xml';

if (!copy($file, $newfile)) {
    echo "не удалось скопировать $file...\n";
} else {
	echo "файл создан\n";
}
?>