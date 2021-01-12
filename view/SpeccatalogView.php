<?PHP

require_once('View.php');

class SpeccatalogView extends View
{
	public function fetch()
	{
		$url = $this->request->get('link_url', 'string');
		
		// Если указан адрес записи,
		if(!empty($url))
		{
			// Выводим запись
			return $this->fetch_link($url);
		}
		else
		{
			// Иначе выводим список записей
			return $this->fetch_links();
		}
	}
	
	private function fetch_link($url)
	{
		// Выбираем запись из базы
		$link = $this->links->get_link($url);
		
		// Если не найден - ошибка
		if(!$link || (!$link->visible && empty($_SESSION['admin'])))
			return false;

		$this->design->assign('link', $link);

		$url=$this->config->root_url.'/'.$link->src_url;

		if($this->design->is_android_browser()) {
			$user_agent = $_SERVER['HTTP_USER_AGENT']; 
			if(preg_match('/iPad|iPhone/i', $user_agent)) {
				$uagent="User-Agent: 5cms iphone";
			}
			if(preg_match('/Android/i', $user_agent)) {
				$uagent="User-Agent: 5cms android";
			}
			$opts = array(
			  'http'=>array(
			    'method'=>"GET",
			    'header'=>$uagent
			  )
			  // Для SSL operation failed with code 1. OpenSSL
			  //'ssl' => array('verify_peer' => false, 'verify_peer_name' => false)
			);
			$context = stream_context_create($opts);
			$t=file_get_contents($url, false, $context);
		} elseif ($this->design->is_mobile_browser()) {
			$opts = array(
			  'http'=>array(
			    'method'=>"GET",
			    'header'=>"User-Agent: android"
			  )
			  // Для SSL operation failed with code 1. OpenSSL
			  //'ssl' => array('verify_peer' => false, 'verify_peer_name' => false)
			);
			$context = stream_context_create($opts);
			$t=file_get_contents($url, false, $context);
		} else {
			$t=file_get_contents($url);
			// Для SSL operation failed with code 1. OpenSSL
			//$t=file_get_contents($url, false, stream_context_create(array('ssl' => array('verify_peer' => false, 'verify_peer_name' => false))));
		}		
		$t=preg_replace('@[^<>]*</title>@', $link->meta_title.'</title>', $t);
		$t=preg_replace('@<meta name="keywords"\s+content="[^"]*@', '<meta name="keywords" content="'.$link->meta_keywords, $t);
		$t=preg_replace('@<meta name="description"\s+content="[^"]*@', '<meta name="description" content="'.$link->meta_description, $t);
		//$t=preg_replace('@[^<>]*</h1>@', $link->h1.'</h1>', $t);
		$t=preg_replace('#<!--h1-[^>]*>.*?<!--/h1-->#is', $link->h1, $t);
		$t=preg_replace('#<!--desc-[^>]*>.*?<!--/desc-->#is', $link->description, $t);
		$t=preg_replace('#<!--seo-[^>]*>.*?<!--/seo-->#is', $link->seo, $t);
		$t=preg_replace('#<!--canonical-[^>]*>.*?<!--/canonical-->#is', '<link rel="canonical" href="'.$this->config->root_url.'/pages/'.$link->url.'"/>', $t);
		print $t;
		exit;

	}	
	
	// Отображение списка записей
	private function fetch_links()
	{
		// Количество записей на 1 странице
		$items_per_page = 20;

		$filter = array();
		
		// Выбираем только видимые записи
		$filter['visible'] = 1;
		
		// Текущая страница в постраничном выводе
		$current_page = $this->request->get('page', 'integer');
		
		// Если не задана, то равна 1
		$current_page = max(1, $current_page);
		$this->design->assign('current_page_num', $current_page);

		// Вычисляем количество страниц
		$links_count = $this->links->count_links($filter);

		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$items_per_page = $links_count;	

		$pages_num = ceil($links_count/$items_per_page);
		$this->design->assign('total_pages_num', $pages_num);

		$filter['page'] = $current_page;
		$filter['limit'] = $items_per_page;
		
		// Выбираем записи из базы
		$links = $this->links->get_links($filter);
		if(empty($links))
			return false;
		
		// Передаем в шаблон
		$this->design->assign('links', $links);
		
		// Метатеги
		if($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
		}
		
		$body = $this->design->fetch('links.tpl');
		
		return $body;
	}	
	
}

return;

