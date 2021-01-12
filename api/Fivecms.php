<?php  
class Fivecms
{
	// Свойства - Классы API
	private $classes = array(
		'articles_categories'     => 'ArticlesCategories',
		'articles'   => 'Articles',		
		'config'     => 'Config',
		'request'    => 'Request',
		'db'         => 'Database',
		'db2'        => 'Database',
		'settings'   => 'Settings',
		'design'     => 'Design',
		'products'   => 'Products',
		'variants'   => 'Variants',
		'categories' => 'Categories',
		'brands'     => 'Brands',
		'features'   => 'Features',
		'money'      => 'Money',
		'pages'      => 'Pages',
		'blog_categories' => 'BlogCategories',
		'blog'       => 'Blog',
		'cart'       => 'Cart',
		'image'      => 'Image',
		'delivery'   => 'Delivery',
		'payment'    => 'Payment',
		'orders'     => 'Orders',
		'users'      => 'Users',
		'coupons'    => 'Coupons',
		'comments'   => 'Comments',
		'feedbacks'  => 'Feedbacks',
		'notify'     => 'Notify',
		'reportstat' => 'ReportStat',
		'menus'      => 'Menus',
		'managers'   => 'Managers',
		'slides'     => 'Slides',
		'slidesm'    => 'Slidesm',
		'discountgroup' => 'DiscountGroup',
		'multichanges'   => 'Multichanges',
		'compare'    => 'Compare',
		'surveys_categories'     => 'SurveysCategories',
		'surveys'    => 'Surveys',
		'mobtheme'   => 'Mobtheme',
		'mailer'     => 'Mailer',
		'metadatapages'  => 'MetadataPages',
		'files'      => 'Files',
		'links'      => 'Links',
		'services_categories'     => 'ServicesCategories',
		'cache'		 => 'Cache',
		'forms'		 => 'Forms',
		'banners'    => 'Banners'
	);
	
	// Созданные объекты
	private static $objects = array();
	
	/**
	 * Конструктор оставим пустым, но определим его на случай обращения parent::__construct() в классах API
	 */
	public function __construct()
	{
		if($this->config->locale) {
			//локаль
			setlocale(LC_ALL, $this->config->locale);
		}
	}

	/**
	 * Магический метод, создает нужный объект API
	 */
	public function __get($name)
	{
		// Если такой объект уже существует, возвращаем его
		if(isset(self::$objects[$name]))
		{
			return(self::$objects[$name]);
		}
		
		// Если запрошенного API не существует - ошибка
		if(!array_key_exists($name, $this->classes))
		{
			return null;
		}
		
		// Определяем имя нужного класса
		$class = $this->classes[$name];
		
		// Подключаем его
		include_once(dirname(__FILE__).'/'.$class.'.php');
		
		// Сохраняем для будущих обращений к нему
		self::$objects[$name] = new $class();
		
		// Возвращаем созданный объект
		return self::$objects[$name];
	}
}
