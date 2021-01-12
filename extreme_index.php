<?PHP

// Склеиваем зеркала главной
if($_SERVER['REQUEST_URI'] == "/index.php" || $_SERVER['REQUEST_URI'] == "/index.html") {
	header("Location: /",TRUE,301);
    exit();
}

// Засекаем время
$time_start = microtime(true);

session_start();

if(!empty($_SERVER['HTTP_USER_AGENT'])){
    session_name(md5($_SERVER['HTTP_USER_AGENT']));
}

setcookie(session_name(),session_id(),time()+30*24*60*60,"/");

require_once('view/IndexView.php');

$view = new IndexView();

if(isset($_GET['logout']))
{
    header('WWW-Authenticate: Basic realm="Fivecms CMS"');
    header('HTTP/1.0 401 Unauthorized');
	unset($_SESSION['admin']);
}

$compiledurl = md5($_SERVER['REQUEST_URI']);
$rndomis=rand(123456,654321);
$themecompiled = $view->settings->theme; // TODO тему взять из $view->design
$mods = array('module=UserView','module=CartView','module=LoginView','module=RegisterView','module=WishlistView','module=CompareView','module=OrderView','module=FeedbackView','module=SurveysView');

//setlocale(LC_TIME, 'ru_RU.UTF-8');

// TODO включение/выключение кэширования из админки и проверку на него
// TODO очистка папки compiled из админки
// TODO отключение скрипта ajax-пагинации
	
if(!$_SESSION['admin'] && !in_array($_SERVER['QUERY_STRING'], $mods) && file_exists('compiled/'.$themecompiled.'/'.$compiledurl) && !$_POST[text] && !$_POST[name]){
		header("Content-type: text/html; charset=UTF-8");
		header("Expires: ".gmdate("D, d M Y H:i:s", time()+($rndomis*3))." GMT"); 
		$compiledfile = 'compiled/'.$themecompiled.'/'.$compiledurl;
		$htmlcode = file_get_contents($compiledfile);
		echo $htmlcode;
		fclose($compiledfile);
		print "\r\n<!--   ";
		print "compiled";
		print "  -->";
} else {
		if(($res = $view->fetch()) !== false && $_SERVER['QUERY_STRING'] != 'module=ProductsView'){
			if($_SESSION['admin'] || in_array($_SERVER['QUERY_STRING'], $mods)){
				// Выводим результат
				header("Content-type: text/html; charset=UTF-8");	
				print $res;
			} else {
				ob_start();
				header("Content-type: text/html; charset=UTF-8");
				header("Expires: ".gmdate("D, d M Y H:i:s", time()+($rndomis*3))." GMT"); 
				print $res;
				$htmlcode = ob_get_contents();
				$compiledfile = fopen('compiled/'.$themecompiled.'/'.$compiledurl, 'w') or die("-");
				fwrite($compiledfile,$htmlcode);
				fclose($compiledfile);
			}
			
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
    print "page generation time: " . $exec_time . "s\r\n";
    if (function_exists('memory_get_peak_usage')) {
        print "\n\n" . "+--------------- memory peak usage ---------------+\r\n\n";
        print "memory peak usage: " . (round(memory_get_peak_usage() / 1048576 * 100) / 100) . " mb\r\n";
    }
    print "-->";
} else {
	print "<!--\r\n";
	$time_end = microtime(true);
	$exec_time = $time_end-$time_start;
  
  	if(function_exists('memory_get_peak_usage'))
		print "memory peak usage: ".memory_get_peak_usage()." bytes\r\n";  
	print "page generation time: ".$exec_time." seconds\r\n";  
	print "-->";
}
