<?PHP

require_once('api/Fivecms.php');

class View extends Fivecms
{
	/* Смысл класса в доступности следующих переменных в любом View */
	public $currency;
	public $currencies;
	public $user;
	public $group;
	public $page;
	
	/* Класс View похож на синглтон, храним статически его инстанс */
	private static $view_instance;
	
	public function __construct()
	{
		parent::__construct();

		// Если инстанс класса уже существует - просто используем уже существующие переменные
		if(self::$view_instance)
		{
			$this->currency     = &self::$view_instance->currency;
			$this->currencies   = &self::$view_instance->currencies;
			$this->user         = &self::$view_instance->user;
			$this->group        = &self::$view_instance->group;	
			$this->page         = &self::$view_instance->page;	
		}
		else
		{
			// Сохраняем свой инстанс в статической переменной,
            // чтобы в следующий раз использовать его
			self::$view_instance = $this;
			
			if($this->settings->site_disabled && !isset($_SESSION['admin'])) {
				header("X-Powered-CMS: 5CMS v".$this->config->version);
				print $this->design->fetch('offline.tpl');
				exit();
			}

			// Валюта
			$this->currencies = $this->money->get_currencies(array('enabled'=>1));
	
			if($currency_id = $this->request->get('currency_id', 'integer'))
			{
				$_SESSION['currency_id'] = $currency_id;
				header("Location: ".$this->request->url(array('currency_id'=>null)));
			}
			
			// multicurrency	
			//возвращаем  текущую валюту
			$this->currency = $this->money->get_current();
			// multicurrency end
	
			if(isset($_SESSION['user_id']))
			{
				$u = $this->users->get_user(intval($_SESSION['user_id']));
				if($u && $u->enabled)
				{
					$this->user = $u;
					$this->group = $this->users->get_group($this->user->group_id);
				}
			}

			// Пишем partner_id в cookie
			if(!empty($this->request->get('appid', 'integer')))
				$appid = intval($this->request->get('appid', 'integer'));
            if(!empty($appid)){
				$partner = $this->users->get_user($appid);
				if(!empty($partner) && $partner->enabled){
					$expires_partner = time()+60*60*24*intval($this->settings->ref_cookie);
					setcookie('partner_id',$partner->id,$expires_partner,'/');
					$this->users->update_ref_views($partner->id);
				}
				//скрываем ref-код
				header("Location: ".$this->request->url(array('appid'=>null)));
            }

			// Текущая страница (если есть)
			$subdir = substr(dirname(dirname(__FILE__)), strlen($_SERVER['DOCUMENT_ROOT']));
			$page_url = trim(substr($_SERVER['REQUEST_URI'], strlen($subdir)),"/");
			if(strpos($page_url, '?') !== false)
				$page_url = substr($page_url, 0, strpos($page_url, '?'));
			$this->page = $this->pages->get_page((string)$page_url);
			$this->design->assign('page', $this->page);
			// Передаем в дизайн то, что может понадобиться в нем
			$this->design->assign('currencies',	$this->currencies);
			$this->design->assign('currency',	$this->currency);
			$this->design->assign('user',       $this->user);
			$this->design->assign('group',      $this->group);
			
			$this->design->assign('config',		$this->config);
			$this->design->assign('settings',	$this->settings);
			
			if($this->design->is_mobile_browser())
				$this->design->assign('mobtheme',	$this->mobtheme);
				
			// Название текущего модуля в шаблон
			$mod = $this->request->get('module', 'string');
			$this->design->assign('mod', $mod);
		
			/* // Last purchases
			$this->db->query($this->db->placehold("SELECT p.* FROM __purchases p
							LEFT JOIN __orders o ON p.order_id = o.id
							WHERE o.status = 0
							GROUP BY p.product_id
							ORDER BY o.id DESC LIMIT 5"));
			$this->design->assign('last_purchases',	$this->db->results());*/
			// Настраиваем плагины для смарти
			$this->design->smarty->registerPlugin("function", "get_comments", 			array($this, 'get_comments_plugin'));
			$this->design->smarty->registerPlugin("function", "get_posts",              array($this, 'get_posts_plugin'));
			$this->design->smarty->registerPlugin("function", "get_links",              array($this, 'get_links_plugin'));
			$this->design->smarty->registerPlugin("function", "get_pages",              array($this, 'get_pages_plugin'));
			$this->design->smarty->registerPlugin("function", "get_articles",           array($this, 'get_articles_plugin'));
			$this->design->smarty->registerPlugin("function", "get_services",           array($this, 'get_services_plugin'));
			$this->design->smarty->registerPlugin("function", "get_surveys",            array($this, 'get_surveys_plugin'));
			$this->design->smarty->registerPlugin("function", "get_brands",             array($this, 'get_brands_plugin'));
			$this->design->smarty->registerPlugin("function", "get_browsed_products",   array($this, 'get_browsed_products'));
			$this->design->smarty->registerPlugin("function", "get_products",        	array($this, 'get_products_plugin'));
			$this->design->smarty->registerPlugin("function", "get_slides",             array($this, 'get_slides_plugin'));
			$this->design->smarty->registerPlugin("function", "get_slidesm",            array($this, 'get_slidesm_plugin'));
			$this->design->smarty->registerPlugin("function", "get_forms",              array($this, 'get_forms_plugin'));
			$this->design->smarty->registerPlugin("function", "get_banners", 			array($this, 'get_banners_plugin'));
			$this->design->smarty->registerPlugin("function", "get_object_articles", array($this, 'get_object_articles_plugin'));
		}
	}
		
	function fetch()
	{
		return false;
	}
	
	public function get_comments_plugin($params, $smarty)
	{
		if(!isset($params['approved']))
			$params['approved'] = 1;
		if(!empty($params['var']))
			$smarty->assign($params['var'], $this->comments->get_comments($params));
	}

	public function get_posts_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;

		if(!empty($params['var'])) {
			$temp_posts = $this->blog->get_posts($params);
			if (empty($temp_posts)) {
            	return false;
        	}
			
			foreach($temp_posts as $p) {
				$posts[$p->id] = $p;

				// Выбираем разделы
				$section = $this->blog_categories->get_category(intval($p->category));
				if(!empty($section)){
					$posts[$p->id]->section = array();
					$posts[$p->id]->section = $section;
				}	
				// Выбираем первое изображение блога
				$images = $this->blog->get_images(array('post_id'=>$p->id));
				if(!empty($images))
					$posts[$p->id]->images[] = $images[0];
				
				// Кол-во комментриев	
				$comments_count = $this->comments->count_comments(array('type'=>'blog', 'object_id'=>$p->id, 'approved'=>1));
				if(isset($comments_count))
					$posts[$p->id]->comments_count = $comments_count;
			}
	
			$smarty->assign($params['var'], $posts);
		}

	}
	
	public function get_pages_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;	
		if(!empty($params['var']))
			$smarty->assign($params['var'], $this->pages->get_pages($params));
	}
	
	public function get_articles_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		if(!isset($params['sort']))
			$params['sort'] = 'date';	

		if(!empty($params['var'])) {
			$posts = array();
			$temp_posts = $this->articles->get_articles($params);
			
			if (empty($temp_posts)) {
            	return false;
        	}
			
			foreach($temp_posts as $p) {
				$posts[$p->id] = $p;
				
				// Выбираем категории
				$category = $this->articles_categories->get_articles_category(intval($p->category_id));
				if(!empty($category)){
					$posts[$p->id]->section = array();
					$posts[$p->id]->section = $category;
				}	
					
				// Выбираем первое изображение статьи
				$images = $this->articles->get_images(array('post_id'=>$p->id));
				if(!empty($images))
					$posts[$p->id]->images[] = $images[0];
			}
	
			$smarty->assign($params['var'], $posts);
		}
	}
	
	public function get_links_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;			
		if(!empty($params['var']))
			$smarty->assign($params['var'], $this->links->get_linkss($params));
	}
	
	public function get_services_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		if(!isset($params['sort']))
			$params['sort'] = 'date';			
		if(!empty($params['var']))
			$smarty->assign($params['var'], $this->services->get_services($params));
	}

	public function get_surveys_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		if(!isset($params['sort']))
			$params['sort'] = 'date';			
		if(!empty($params['var']))
			$smarty->assign($params['var'], $this->surveys->get_surveys($params));
	}

	public function get_slides_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		if(!empty($params['var']))
			$smarty->assign($params['var'], $this->slides->get_slides($params));
	}

	public function get_slidesm_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		if(!empty($params['var']))
			$smarty->assign($params['var'], $this->slidesm->get_slidesm($params));
	}

	public function get_forms_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		if(!empty($params['var']))
			$smarty->assign($params['var'], $this->forms->get_forms($params));
	}

	public function get_brands_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		if(!isset($params['active']))
			$params['active'] = 1;	
		if(!empty($params['var']))
			$smarty->assign($params['var'], $this->brands->get_brands($params));
	}
	
	public function get_browsed_products($params, $smarty)
	{
		if(!empty($params['only_count'])) {
			if(empty($_COOKIE['browsed_products'])) $smarty->assign($params['var'], 0);
			else $smarty->assign($params['var'], sizeof(explode(',', $_COOKIE['browsed_products'])));
		}
		else {
			if(!empty($_COOKIE['browsed_products']))
			{
				$browsed_products_ids = explode(',', $_COOKIE['browsed_products']);
				$browsed_products_ids = array_reverse($browsed_products_ids);
				if(isset($params['limit']))
					$browsed_products_ids = array_slice($browsed_products_ids, 0, $params['limit']);

				$products = array();
				foreach($this->products->get_products(array('id'=>$browsed_products_ids, 'visible'=>1)) as $p)
					$products[$p->id] = $p;

				/*foreach($products as &$browsed_product)
				{
					$browsed_product->category = reset($this->categories->get_categories(array('product_id'=>$browsed_product->id)));
				};*/

				$browsed_products_images = $this->products->get_images(array('product_id'=>$browsed_products_ids));
				foreach($browsed_products_images as $browsed_product_image)
					if(isset($products[$browsed_product_image->product_id]))
						$products[$browsed_product_image->product_id]->images[] = $browsed_product_image;
			
				foreach($browsed_products_ids as $id)
				{	
					if(isset($products[$id]))
					{
						if(isset($products[$id]->images[0]))
							$products[$id]->image = $products[$id]->images[0];
						$result[] = $products[$id];
					}
				}
				if(isset($result))
					$smarty->assign($params['var'], $result);
			}
		}
	}
	
	public function get_products_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		if(!isset($params['in_stock']))
			$params['in_stock'] = 1;
		if(!empty($params['var']))
		{
			foreach($this->products->get_products($params) as $p)
				$products[$p->id] = $p;
			if(!empty($products))
			{
				$products_ids = array_keys($products);
				$variants = $this->variants->get_variants(array('product_id'=>$products_ids, 'in_stock'=>true));
				
				foreach($variants as &$variant)
				{
					$products[$variant->product_id]->variants[] = $variant;
				}
				
				$images = $this->products->get_images(array('product_id'=>$products_ids));
				foreach($images as $image)
					$products[$image->product_id]->images[] = $image;
	
				foreach($products as &$product)
				{
					//$product->category = reset($this->categories->get_categories(array('product_id'=>$product->id)));
					if(isset($product->variants[0]))
						$product->variant = $product->variants[0];
					if(isset($product->images[0]))
						$product->image = $product->images[0];

					$ids=array();	
					if(is_array($product->variants))foreach ($product->variants as $k => $v) {
						if(!empty($v->name1) or !empty($v->name2)){
							$ids[0][$v->name1][] = $v->id;
							$ids[1][$v->name2][] = $v->id;
						}
					}
					$classes=array();
					for($i=0;$i<2;$i++) 
					if(isset($ids[$i]) && is_array($ids[$i]))foreach ($ids[$i] as $name => $ids1) {
						$classes[$i][$name]='c'.join(' c', $ids1);
					}
					$product->vproperties = $classes;
				}				
			}
			if(isset($products))
				$smarty->assign($params['var'], $products);
		}
	}
	
	public function get_banners_plugin($params, $smarty)
	{
		if($params['group'])
		{
			$filter['show_all_pages'] = true;//Обязательный параметр
			$filter['group'] = (int)$params['group'];
			
			@$category = $smarty->get_template_vars('category');
			@$brand = $smarty->get_template_vars('brand');
			@$page = $smarty->get_template_vars('page');
			
			$filter['category'] = !empty($category)?$category->id:'';
			$filter['brand']    = !empty($brand)   ?$brand->id:'';
			$filter['page']     = !empty($page)    ?$page->id:'';
			
			list($banners,$count) = $this->banners->get_banners($filter);
			foreach($banners as $key=>$value)
				$banners[$key]->image = "/".$this->config->banners_images_dir.$banners[$key]->image;
			
			$smarty->assign('banners', $banners);
		}
	}
	
	public function get_object_articles_plugin($params, $smarty)
	{
		if(!empty($params['var']) && !empty($params['id'])) {
			$related_articles = $this->articles->get_related_articles($params);
			
			if(empty($related_articles)) 
            	return false;
			
            $r_articles = array();
                                
            foreach($related_articles as &$r_p)
                $r_articles[$r_p->article_id] = &$r_p;
 
 			$params['id'] = array_keys($r_articles);
			
 			$temp_posts = $this->articles->get_articles($params);

            foreach($temp_posts as $p){
				$posts[$p->id] = $p;
				
				// Выбираем категории
				$category = $this->articles_categories->get_articles_category(intval($p->category_id));
				if(!empty($category))
					$posts[$p->id]->categories[] = $category;
					
				// Выбираем первое изображение статьи
				$images = $this->articles->get_images(array('post_id'=>$p->id));
				if(!empty($images))
					$posts[$p->id]->images[] = $images[0];
			}
			$smarty->assign($params['var'], $posts);
		}
	}

	public function setHeaderLastModify($lastModify, $lastExpire) {
        $lastModify=empty($lastModify)?date("Y-m-d H:i:s"):$lastModify;
        $lastExpire=empty($lastExpire)?604800:$lastExpire;
        $LastModified_unix = strtotime($lastModify);
        //Проверка модификации страницы
        $LastModified = gmdate("D, d M Y H:i:s \G\M\T", $LastModified_unix); 
        $LastExpires = gmdate("D, d M Y H:i:s \G\M\T", $LastModified_unix + $lastExpire);               
        $IfModifiedSince = false;
        if(isset($_ENV['HTTP_IF_MODIFIED_SINCE'])) 
            $IfModifiedSince = strtotime(substr($_ENV['HTTP_IF_MODIFIED_SINCE'], 5));
        if(isset($_SERVER['HTTP_IF_MODIFIED_SINCE'])) 
            $IfModifiedSince = strtotime(substr($_SERVER['HTTP_IF_MODIFIED_SINCE'], 5));
        if($IfModifiedSince && $IfModifiedSince >= $LastModified_unix) {
            header($_SERVER['SERVER_PROTOCOL'] . ' 304 Not Modified');
            exit;
        }
        header('Last-Modified: '.$LastModified);
        header('Expires: '.$LastExpires);
        //header('Cache-Control: max-age='.$lastExpire);
    }

}
