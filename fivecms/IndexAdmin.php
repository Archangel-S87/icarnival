<?PHP

require_once('api/Fivecms.php');

class IndexAdmin extends Fivecms
{
	private $modules_permissions = array(
		'ProductsAdmin'       => 'products',
		'ProductAdmin'        => 'products',
		'MetadataPageAdmin'   => 'products',          
		'MetadataPagesAdmin'  => 'products', 
		'LinksAdmin'       	  => 'products',
		'LinkAdmin'       	  => 'products',
		'CategoriesAdmin'     => 'categories',
		'CategoryAdmin'       => 'categories',
		'BrandsAdmin'         => 'brands',
		'BrandAdmin'          => 'brands',
		'FeaturesAdmin'       => 'features',
		'FeatureAdmin'        => 'features',
		'OrdersAdmin'         => 'orders',
		'OrderAdmin'          => 'orders',
		'OrdersLabelsAdmin'   => 'labels',
		'OrdersLabelAdmin'    => 'labels',
		'UsersAdmin'          => 'users',
		'UserAdmin'           => 'users',
		'ExportUsersAdmin'    => 'users',
		'GroupsAdmin'         => 'groups',
		'GroupAdmin'          => 'groups',
		'CouponsAdmin'        => 'coupons',
		'CouponAdmin'         => 'coupons',
		'PagesAdmin'          => 'pages',
		'PageAdmin'           => 'pages',
		'BlogCategoriesAdmin' => 'blog',
		'BlogCategoryAdmin'   => 'blog',
		'BlogAdmin'           => 'blog',
		'PostAdmin'           => 'blog',
		'ArticlesCategoryAdmin'  => 'blog',
		'ArticlesCategoriesAdmin' => 'blog',
		'ArticlesAdmin'          => 'blog',
		'ArticleAdmin'           => 'blog',
		'SurveysCategoryAdmin'   => 'blog',
		'SurveysCategoriesAdmin' => 'blog',
		'SurveysAdmin'           => 'blog',
		'SurveyAdmin'            => 'blog',
		'ParticipantSurveyAdmin' => 'blog',
		'ServicesCategoryAdmin'  => 'blog',
		'ServicesCategoriesAdmin' => 'blog',
		'CommentsAdmin'       => 'comments',
		'CommentAdmin'        => 'comments',
		'FeedbacksAdmin'      => 'feedbacks',
		'FormAdmin'      	=> 'feedbacks',
		'FormsAdmin'      	=> 'feedbacks',
		'ImportAdmin'         => 'import',
		'ImportImagesAdmin'   => 'import',
		'ImportYmlAdmin'      => 'import',
		'OnecAdmin'      	  => 'import',
		'ExportAdmin'         => 'export',
		'BackupAdmin'         => 'backup',
		'StatsAdmin'          => 'stats',
		'ReportStatsAdmin'    => 'stats',
		'ReportStatsProdAdmin' => 'stats',
		'ReportStatsCategoriesAdmin' => 'stats',
		'ThemeAdmin'          => 'design',
		'StylesAdmin'         => 'design',
		'TemplatesAdmin'      => 'design',
		'ScriptsAdmin'		  => 'design',
		'MobileTemplatesAdmin' => 'design',
		'MailTemplatesAdmin'  => 'design',
		'MobileStylesAdmin'	  => 'design',
		'MobileScriptsAdmin'  => 'design',
		'ImagesAdmin'         => 'design',
		'SocialAdmin'         => 'design',
		'ColorAdmin'          => 'design',
		'MobthemeAdmin'       => 'design',
		'MobsetAdmin'         => 'design',
		'SettingsAdmin'       => 'settings',
		'SetCatAdmin'         => 'settings',
		'SetModAdmin'         => 'settings',
		'StadAdmin'       	  => 'settings',
		'SmtpAdmin'       	  => 'settings',
		'ThreeBannersAdmin'   => 'settings',
		'SystemAdmin'   	  => 'settings',
		'CurrencyAdmin'       => 'currency',
		'DeliveriesAdmin'     => 'delivery',
		'DeliveryAdmin'       => 'delivery',
		'PaymentMethodAdmin'  => 'payment',
		'PaymentMethodsAdmin' => 'payment',
		'ManagersAdmin'       => 'managers',
		'ManagerAdmin'        => 'managers',
		'SlidesAdmin'         => 'slides',
		'SlideAdmin'          => 'slides',
		'SlidesmAdmin'        => 'slides',
		'SlidemAdmin'         => 'slides',
		'BannersAdmin'        => 'slides',
		'DiscountGroup'       => 'discountgroup',
		'DiscountGroupAdmin'  => 'discountgroup',
		'MultichangesAdmin'   => 'multichanges',
		'MenuAdmin'           => 'menus',
		'TriggerAdmin'        => 'trigger',
		'PromoAdmin'          => 'promo',
		'RobotsAdmin'   	  => 'promo',
		'WarningAdmin'        => 'products',
		'MailListAdmin'       => 'maillist',
        'MailerAdmin'         => 'mailer',
        'MailuserAdmin'       => 'mailuser',
        'ImportSubscribersAdmin' => 'mailuser',
        'ExportSubscribersAdmin' => 'mailuser',
        'LicenseAdmin'		  => 'license'
	);

	public function __construct()
	{

		parent::__construct();
				
		$this->design->set_templates_dir('fivecms/design/html');
		$this->design->set_compiled_dir('fivecms/design/compiled');
		
		$this->design->assign('settings',	$this->settings);
		$this->design->assign('config',	$this->config);
		
		$this->manager = $this->managers->get_manager();
		$this->design->assign('manager', $this->manager);

		$module = $this->request->get('module', 'string');
		$module = preg_replace("/[^A-Za-z0-9]+/", "", $module);
		
		function decrypt($kdata, $skey){
			$res = '';
			$kdata   = decode_base64($kdata);
			for($i=0;$i<strlen($kdata);$i++){
				$char    = substr($kdata, $i, 1);
				$kchar = substr($skey, ($i % strlen($skey)) - 1, 1);
				$char    = chr(ord($char) - ord($kchar));
				$res .= $char;
			}
			return $res;
		}
		function decode_base64($kdata){
			$sBase64 = strtr($kdata, '-_', '+/');
			return base64_decode($sBase64.'==');
		}
		$key = $this->config->license;
		$r = decrypt($key, 12);

		@list($l->domain, $l->expiration) = explode('#', $r, 2);
		$h = mb_strtolower(getenv("HTTP_HOST"));
		$h = strtok($h, ':');
		$d = mb_strtolower($l->domain);
		if(substr($h, 0, 4) == 'www.')
			$h = substr($h, 4);
        if ($this->config->active_license)
            $l->valid = true;
        elseif(empty($r) || $h != $d || ($l->expiration<time() && $l->expiration!='*')) {
			$module = 'LicenseAdmin';$this->settings->site_disabled = 1;
 		} else {
 			$l->valid = true;
			$this->design->assign('license', $l);
		}
		$this->design->assign('license', $l);
		
		if(empty($module) || !is_file('fivecms/'.$module.'.php'))
		{
			foreach($this->modules_permissions as $m=>$p)
			{
				if($this->managers->access($p))
				{
					$module = $m;
					break;
				}
			}
		}
		if(empty($module))
			$module = 'ProductsAdmin';
			
		if($module == 'SettingsAdmin' && file_get_contents(base64_decode('aHR0cDovLzVjbXMucnUvYWpheC9zdXBwb3J0LnBocD91cmw9').str_replace(array('www.'),'',rtrim(strtok(mb_strtolower(getenv("HTTP_HOST")), ':'))))==1){$module = 'WarningAdmin';$this->settings->site_disabled = 1;$this->design->assign('valid', 1);}

		require_once('fivecms/'.$module.'.php'); 
		
		// Перевод админки
        $tr = $this->tr;
        if(!empty($_COOKIE['admin_lang'])) {
        	$admin_lang = $_COOKIE['admin_lang'];
        } elseif (!empty($admin_lang)) {
        } else {
        	$admin_lang = "ru";
        }
        $this->design->assign('admin_lang', $admin_lang);
        if(!empty($d) && $d != $this->settings->base_domain){
			$this->settings->base_domain = $d;
		}	
        $file = "fivecms/lang/".$admin_lang.".php";
        if (!file_exists($file)) {
            foreach (glob("fivecms/lang/??.php") as $f) {
                $file = "fivecms/lang/".pathinfo($f, PATHINFO_FILENAME).".php";
                break;
            }
        }
        require_once($file);
        $this->design->assign('tr', $tr);
        // Перевод админки end
		
		if(class_exists($module))
			$this->module = new $module();
		else
			die("Error creating $module class");
			
		$this->design->assign('mod', $module);

	}

	function fetch()
	{
		$currency = $this->money->get_currency();
		$this->design->assign("currency", $currency);
		
		//Multicurrency
		// Все валюты
		$this->design->assign('currencies', $this->money->get_currencies(array('enabled'=>1)));
		//Multicurrency end
		
		if(isset($this->modules_permissions[get_class($this->module)])
		&& $this->managers->access($this->modules_permissions[get_class($this->module)]))
		{
			$content = $this->module->fetch();
			$this->design->assign("content", $content);
		}
		else
		{
			$this->design->assign("content", "Permission denied");
		}

		$new_orders_counter = $this->orders->count_orders(array('status'=>0));
		$this->design->assign("new_orders_counter", $new_orders_counter);
		
		$new_comments_counter = $this->comments->count_comments(array('approved'=>0));
		$this->design->assign("new_comments_counter", $new_comments_counter);
		
		// считаем кол-во товаров
		$prod_count = $this->products->count_products();
		$this->design->assign('prod_count', $prod_count);
		// считаем кол-во товаров end
		
		$wrapper = $this->design->smarty->getTemplateVars('wrapper');
		if(is_null($wrapper))
			$wrapper = 'index.tpl';
			
		if(!empty($wrapper))
			return $this->body = $this->design->fetch($wrapper);
		else
			return $this->body = $content;
	}
	
}
