<?php
$file = 'http://'.$_SERVER['HTTP_HOST'].'/yandex.php';
$newfile = 'files/yandex.xml';

if (!copy($file, $newfile)) {
    echo "не удалось скопировать $file...\n";
} else {
	echo "файл создан\n";
}
?>