<?php

/**
 * Class Fivecms
 *
 * @property ArticlesCategories $articles_categories
 * @property Articles $articles
 * @property Config $config
 * @property Request $request
 * @property Database $db
 * @property Settings $settings
 * @property Design $design
 * @property Products $products
 * @property Variants $variants
 * @property Categories $categories
 * @property Brands $brands
 * @property Features $features
 * @property Money $money
 * @property Pages $pages
 * @property BlogCategories $blog_categories
 * @property Blog $blog
 * @property Cart $cart
 * @property Image $image
 * @property Delivery $delivery
 * @property Payment $payment
 * @property Orders $orders
 * @property Users $users
 * @property Coupons $coupons
 * @property Comments $comments
 * @property Feedbacks $feedbacks
 * @property Notify $notify
 * @property ReportStat $reportstat
 * @property Managers $managers
 * @property Slides $slides
 * @property Slidesm $slidesm
 * @property DiscountGroup $discountgroup
 * @property Compare $compare
 * @property SurveysCategories $surveys_categories
 * @property Surveys $surveys
 * @property Mobtheme $mobtheme
 * @property MetadataPages $metadatapages
 * @property Files $files
 * @property Links $links
 * @property ServicesCategories $services_categories
 * @property Cache $cache
 * @property Forms $forms
 * @property Banners $banners
 */
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
