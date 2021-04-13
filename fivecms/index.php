<?PHP
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 1);
chdir('..');

// Засекаем время
$time_start = microtime(true);
session_start();
$_SESSION['id'] = session_id();

@ini_set('session.gc_maxlifetime', 86400); // 86400 = 24 часа
@ini_set('session.cookie_lifetime', 0); // 0 - пока браузер не закрыт

require_once('fivecms/IndexAdmin.php');

// Кеширование в админке нам не нужно
Header("Cache-Control: no-cache, must-revalidate");
header("Expires: -1");
Header("Pragma: no-cache");

header("Content-type: text/html; charset=UTF-8");

// Установим переменную сессии, чтоб фронтенд нас узнал как админа
$_SESSION['admin'] = 'admin';

$backend = new IndexAdmin();

// Проверка сессии для защиты от xss
if(!$backend->request->check_session())
{
	unset($_POST);
	header('Location: '.$_SERVER['REQUEST_URI']);
	trigger_error('Session expired', E_USER_WARNING);
	exit;
}

print $backend->fetch();

print "<!--\r\n";
	$time_end = microtime(true);
	$exec_time = $time_end-$time_start;
  	if(function_exists('memory_get_peak_usage'))
		print "memory peak usage: ".memory_get_peak_usage()." bytes\r\n";  
	print "page generated in: ".$exec_time." seconds\r\n";  
print "-->";
