<?php
require_once('../api/Fivecms.php');
$filename = $_GET['file'];
$type = $_GET['type'];
$fivecms = new Fivecms();	
if(empty($type)) {
    header("http/1.1 404 not found");
    exit;
}
$resized_filename = $fivecms->image->resize($filename, $type == 'products' ? '' : $type);
if(is_readable($resized_filename)) {
	/*if (function_exists('exif_imagetype')) {
        $image_type = exif_imagetype($resized_filename);
    } else {
        $image_type = getimagesize($resized_filename);
        $image_type = (isset($image_type[2])) ? $image_type[2] : null;
    }
    if (is_null($image_type)) {
        $image_mime = 'image';
    } else {
        $image_mime = image_type_to_mime_type($image_type);
    }*/
	header('Content-type: image');
	print file_get_contents($resized_filename);
	exit;
}