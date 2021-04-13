<?PHP

// Склеиваем зеркала главной
if($_SERVER['REQUEST_URI'] == "/index.php" || $_SERVER['REQUEST_URI'] == "/index.html") {
	header("Location: /",TRUE,301);
    exit();
}

// Засекаем время
$time_start = microtime(true);

session_start();

setcookie(session_name(),session_id(),time()+30*24*60*60,"/");

require_once('view/IndexView.php');

$view = new IndexView();

header("X-Powered-CMS: 5CMS v".$view->config->version);
if(!empty($view->settings->base_domain))
	header("X-Base-Domain:".$view->settings->base_domain);

if(isset($_GET['logout']))
{
    header('WWW-Authenticate: Basic realm="5CMS"');
    header('HTTP/1.0 401 Unauthorized');
	unset($_SESSION['admin']);
}

// 301 пользовательский редирект
if($view->settings->redirect == 1) {
	$currentURL = $_SERVER['REQUEST_URI'];
	$redirect_page = $view->metadatapages->get_redirect_page($currentURL);
	if(!empty($redirect_page)) {
		header("HTTP/1.1 301 Moved Permanently");
		header("Location: ".$redirect_page->url);
		exit;
	}
}

// Если все хорошо
if(($res = $view->fetch()) !== false)
{
	// Выводим результат
	header("Content-type: text/html; charset=UTF-8");
	//header('ETag: "'.md5($res).'"');
	print $res;

	// Сохраняем последнюю просмотренную страницу в переменной $_SESSION['last_visited_page']
	if(empty($_SESSION['last_visited_page']) || empty($_SESSION['current_page']) || $_SERVER['REQUEST_URI'] !== $_SESSION['current_page'])
	{
		if(!empty($_SESSION['current_page']) && !empty($_SESSION['last_visited_page']) && $_SESSION['last_visited_page'] !== $_SESSION['current_page'])
		{
			$_SESSION['last_visited_page'] = $_SESSION['current_page'];
		}
		$_SESSION['current_page'] = $_SERVER['REQUEST_URI'];
		if ($_GET['module'] != 'LoginView' && $_GET['module'] != 'RegisterView' && $_SERVER['REQUEST_URI'] != '/') $_SESSION['current_for_login'] = $_SERVER['REQUEST_URI'];
	}	
} else { 
	// Иначе страница об ошибке
	header("http/1.0 404 not found");
	
	// Подменим переменную GET, чтобы вывести страницу 404t
	$_GET['page_url'] = '404';
	$_GET['module'] = 'PageView';
	print $view->fetch();   
}

// Отладочная информация
if ($view->config->debug) {
    print "<!--\r\n";
    $exec_time = round(microtime(true)-$time_start, 5);
    $files = get_included_files();
    print "+-------------- included files (" . count($files) . ") --------------+\r\n\n";
    foreach ($files as $file) {
        print $file . " \r\n";
    }
    print "\n\n"."+------------- SQL (last 200 query) -------------+\r\n\n";
    $view->db->query("SHOW profiles;");
    $total_time_sql = 0;
    $profiles_sql = $view->db->results();
    foreach ($profiles_sql as $sql) {
        echo $sql->Query_ID . ': ' . $sql->Duration . 's: ' . $sql->Query . "\r\n";
        $total_time_sql += $sql->Duration;
    }
    print "\n" . count($profiles_sql) . " queries, " . $total_time_sql . "s" ;
    print "\n\n" . "+-------------- page generation time -------------+\r\n\n";
    print "page generated in " . $exec_time . "s\r\n";
    if (function_exists('memory_get_peak_usage')) {
        print "\n\n" . "+--------------- memory peak usage ---------------+\r\n\n";
        print "memory peak usage: " . (round(memory_get_peak_usage() / 1048576 * 100) / 100) . " mb\r\n";
    }
    print "-->";
} else {
	print "<!--\r\n";
	$time_end = microtime(true);
	$exec_time = round($time_end-$time_start,3);
  
  	if(function_exists('memory_get_peak_usage'))
		print "Использование памяти: ".memory_get_peak_usage()." байт\r\n";  
	print "Страница сгенерирована за: ".$exec_time." сек\r\n";  
	print "-->";
}
