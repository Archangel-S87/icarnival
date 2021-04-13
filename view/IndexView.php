<?PHP

require_once('View.php');

class IndexView extends View
{	
	public $modules_dir = 'view/';

	public function __construct()
	{
		parent::__construct();
	}

	function fetch()
	{
		// Содержимое корзины
		$this->design->assign('cart', $this->cart->get_cart());

		// Содержимое информера Избранное
		if(isset($_COOKIE['wished_products'])){
        	$wished = (array)explode(',', $_COOKIE['wished_products']);
		}
		if(!empty($wished))
        	$this->design->assign('wished_products', ($wished[0] > 0) ? $wished : array());
        	
		// Содержимое информера Сравнение
		$this->design->assign('compare_informer', $this->compare->get_compare_informer());

		// Категории товаров
		$this->design->assign('categories', $this->categories->get_categories_tree());
		
		// Услуги
		$this->design->assign('services_categories', $this->services_categories->get_services_categories_tree());	
		
		// Меню страниц | Pages Menus
		$this->design->assign('menus', $this->pages->get_menus());
		
		// Страницы | Pages
		$pages = $this->pages->get_pages(array('visible'=>1));		
		$this->design->assign('pages', $pages);
		
		// Пишем реферера в сессию
		if(empty($_SESSION['referer']) && !empty($_SERVER['HTTP_REFERER'])){
			$ref = $_SERVER['HTTP_REFERER'];
			$ref_host = parse_url($ref, PHP_URL_HOST);
			$ref_host = strtok($ref_host, ':');
			$ref_host = str_ireplace('www.', '', $ref_host);
			$h = mb_strtolower(getenv("HTTP_HOST"));
			$h = strtok($h, ':');
			$host = str_ireplace('www.', '', $h);
			$ref_uri = explode('?', $ref, 2);
			if(!empty($ref_host) && !empty($host) && $ref_host != $host){
				if(substr($ref_uri[0], 0, 7) == 'http://' || substr($ref_uri[0], 0, 8) == 'https://')
					$_SESSION['referer'] = $ref_uri[0];					
				else
					$_SESSION['referer'] = $ref_host.$ref_uri[0];
			}	
		} 
		// пишем UTM-метки
		if(empty($_SESSION['utm'])){
			$url_query = parse_url($_SERVER['REQUEST_URI'], PHP_URL_QUERY);
			$url_query = urldecode($url_query);
			if(!empty($url_query) && stripos($url_query,'utm')!==false ){
				if(!empty(htmlspecialchars($url_query)))
					$url_query = htmlspecialchars($url_query);	
				$_SESSION['utm'] = $url_query;
			}
		}
		// yclid пишем в куки т.к. короткий
		if(empty($_COOKIE['yclid']) && !empty($_GET['yclid'])){
			$yclid = $_GET['yclid'];
			setcookie("yclid", $yclid, time()+(90*24*60*60), "/");
		}
		
		// Текущий модуль (для отображения центрального блока)
		$module = $this->request->get('module', 'string');
		$module = preg_replace("/[^A-Za-z0-9]+/", "", $module);

		// Если не задан - берем из настроек
		if(empty($module))
			return false;

		// Создаем соответствующий класс
		if(is_file($this->modules_dir."$module.php"))
		{
			include_once($this->modules_dir."$module.php");
			if (class_exists($module))
			{
				$this->main = new $module($this);
			} else return false;
		} else return false;

		// Создаем основной блок страницы
		if(!$content = $this->main->fetch())
		{
			return false;
		}		

		// Передаем основной блок в шаблон
		$this->design->assign('content', $content);		
		
		// Передаем название модуля в шаблон, это может пригодиться
		$this->design->assign('module', $module);
				
		// Создаем текущую обертку сайта (обычно index.tpl)
		$wrapper = $this->design->get_var('wrapper');
        if(is_null($wrapper)) {
            $wrapper = 'index.tpl';
        }

        if(!empty($wrapper)) {
            return $this->design->fetch($wrapper);
        } else {
            return trim($content);
        }	
			
	}
}
