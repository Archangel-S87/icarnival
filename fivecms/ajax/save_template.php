<?php

session_start();

require_once('../../api/Fivecms.php');

$fivecms = new Fivecms();

if(!$fivecms->managers->access('design'))
	return false;

// Проверка сессии для защиты от xss
if(!$fivecms->request->check_session())
{
	trigger_error('Session expired', E_USER_WARNING);
	exit();
}
$content = $fivecms->request->post('content');
$template = $fivecms->request->post('template');
$theme = $fivecms->request->post('theme', 'string');

if(pathinfo($template, PATHINFO_EXTENSION) != 'tpl')
	exit();

$file = $fivecms->config->root_dir.'design/'.$theme.'/html/'.$template;
if(is_file($file) && is_writable($file) && !is_file($fivecms->config->root_dir.'design/'.$theme.'/locked'))
	file_put_contents($file, $content);

$result= true;
header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Pragma: no-cache");
header("Expires: -1");		
$json = json_encode($result);
print $json;