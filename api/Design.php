<?php

/**
 *
 * @copyright	5CMS
 * @link		http://5cms.ru
 *
 */
 
require_once(dirname(__FILE__).'/'.'Fivecms.php');
require_once(dirname(dirname(__FILE__)).'/Smarty/libs/Smarty.class.php');
//require_once(dirname(dirname(__FILE__)).'/Smarty/libs/SmartyBC.class.php');

class Design extends Fivecms
{
	public $smarty;

	public function __construct()
	{
		parent::__construct();

		// Создаем и настраиваем Смарти
		$this->smarty = new SmartyBC();
		$this->smarty->compile_check = $this->config->smarty_compile_check;
		$this->smarty->caching = $this->config->smarty_caching;
		$this->smarty->cache_lifetime = $this->config->smarty_cache_lifetime;
		$this->smarty->debugging = $this->config->smarty_debugging;
		if($this->config->error_reporting)
			$this->smarty->error_reporting = E_ALL;

		// Берем тему
		if ($this->is_mobile_browser()) {
			$theme = "mobile_mod";
		} else {
			$theme = $this->settings->theme;
		}

        $this->smarty->setCompileDir($this->config->root_dir.'/compiled/'.$theme);
        $this->smarty->setTemplateDir($this->config->root_dir.'/design/'.$theme.'/html');

		// Создаем папку для скомпилированных шаблонов текущей темы
		if(!is_dir($this->smarty->getCompileDir()))
			mkdir($this->smarty->compile_dir, 0777);

		$this->smarty->cache_dir = 'cache';
				
		$this->smarty->registerPlugin('modifier', 'resize', array($this, 'resize_modifier'));		
		$this->smarty->registerPlugin('modifier', 'token', array($this, 'token_modifier'));
		$this->smarty->registerPlugin('modifier', 'plural', array($this, 'plural_modifier'));		
		$this->smarty->registerPlugin('function', 'url', array($this, 'url_modifier'));		
		$this->smarty->registerPlugin('modifier', 'first', array($this, 'first_modifier'));		
		$this->smarty->registerPlugin('modifier', 'cut', array($this, 'cut_modifier'));		
		$this->smarty->registerPlugin('modifier', 'date', array($this, 'date_modifier'));		
		$this->smarty->registerPlugin('modifier', 'time', array($this, 'time_modifier'));
		$this->smarty->registerPlugin('modifier', 'hashtag', array($this, 'hashtag_modifier'));
		$this->smarty->registerPlugin('modifier', 'bbcode', array($this, 'bbcode_modifier'));
		$this->smarty->registerPlugin('function', 'api', array($this, 'api_plugin'));

		if($this->config->smarty_html_minify) {
			//$this->smarty->loadFilter('output', 'trimwhitespace');
			$this->smarty->registerFilter('pre', array($this, 'template_min'));
		}
		
	}

	public function is_android_browser()
	{
		if(!empty($_SERVER['HTTP_USER_AGENT'])){
			$user_agent = $_SERVER['HTTP_USER_AGENT']; 
			if(preg_match('#5cms#', $user_agent)) {
				if(preg_match('/iphone|ipad|ipod/i', $user_agent)) {
					$uagent = 'iphone';
				} else {
					$uagent = 'android';
				}
				$this->smarty->assign('uagent', $uagent);
				return $uagent;
			}
		}
		
		return false;
	}	
	
	public function assign($var, $value)
	{
		return $this->smarty->assign($var, $value);
	}

	public function fetch($template)
	{
		// Передаем в дизайн то, что может понадобиться в нем
		$this->assign('config',		$this->config);
		$this->assign('settings',	$this->settings);
		return $this->smarty->fetch($template);
	}
	
	public function set_templates_dir($dir)
	{
		$this->smarty->template_dir = $dir;			
	}

	public function set_compiled_dir($dir)
	{
		$this->smarty->compile_dir = $dir;
	}
	
	public function get_var($name)
	{
		return $this->smarty->getTemplateVars($name);
	}
	
	public function clear_cache()
 	{
		$this->smarty->clearAllCache();	
	}

	public function is_mobile_browser()
	{
        if ($this->config->is_mobile) {
            $this->smarty->assign('uagent', 'local');
            return true;
        }

		if(!empty($_SERVER['HTTP_USER_AGENT'])){
			$user_agent = $_SERVER['HTTP_USER_AGENT']; 
		
			if(preg_match('#5cms#', $user_agent))
				$this->smarty->assign('mobile_app', '5cms');

			if(stristr($user_agent, 'windows') && !stristr($user_agent, 'windows ce'))
				return false;
			
			if(preg_match('/ipod|iphone|ipad/i', $user_agent)) {
				$this->smarty->assign('uagent', 'iphone');
				return 'iphone';
			}
		
			if(preg_match('/android/i', $user_agent)) {
				$this->smarty->assign('uagent', 'android');
				return 'android';
			}
		
			if(preg_match('/windows ce|iemobile|mobile|symbian|mini|wap|pda|psp|up.browser|up.link|mmp|midp|phone|pocket/i', $user_agent)) {
				return 'windows';
			}
		
			if(!empty($_SERVER['X-OperaMini-Features']) || !empty($_SERVER['UA-pixels']))
				return 'operamini';
	
			$agents = array(
			'acs-'=>'acs-',
			'alav'=>'alav',
			'alca'=>'alca',
			'amoi'=>'amoi',
			'audi'=>'audi',
			'aste'=>'aste',
			'avan'=>'avan',
			'benq'=>'benq',
			'bird'=>'bird',
			'blac'=>'blac',
			'blaz'=>'blaz',
			'brew'=>'brew',
			'cell'=>'cell',
			'cldc'=>'cldc',
			'cmd-'=>'cmd-',
			'dang'=>'dang',
			'doco'=>'doco',
			'eric'=>'eric',
			'hipt'=>'hipt',
			'inno'=>'inno',
			'ipaq'=>'ipaq',
			'java'=>'java',
			'jigs'=>'jigs',
			'kddi'=>'kddi',
			'keji'=>'keji',
			'leno'=>'leno',
			'lg-c'=>'lg-c',
			'lg-d'=>'lg-d',
			'lg-g'=>'lg-g',
			'lge-'=>'lge-',
			'maui'=>'maui',
			'maxo'=>'maxo',
			'midp'=>'midp',
			'mits'=>'mits',
			'mmef'=>'mmef',
			'mobi'=>'mobi',
			'mot-'=>'mot-',
			'moto'=>'moto',
			'mwbp'=>'mwbp',
			'nec-'=>'nec-',
			'newt'=>'newt',
			'noki'=>'noki',
			'opwv'=>'opwv',
			'palm'=>'palm',
			'pana'=>'pana',
			'pant'=>'pant',
			'pdxg'=>'pdxg',
			'phil'=>'phil',
			'play'=>'play',
			'pluc'=>'pluc',
			'port'=>'port',
			'prox'=>'prox',
			'qtek'=>'qtek',
			'qwap'=>'qwap',
			'sage'=>'sage',
			'sams'=>'sams',
			'sany'=>'sany',
			'sch-'=>'sch-',
			'sec-'=>'sec-',
			'send'=>'send',
			'seri'=>'seri',
			'sgh-'=>'sgh-',
			'shar'=>'shar',
			'sie-'=>'sie-',
			'siem'=>'siem',
			'smal'=>'smal',
			'smar'=>'smar',
			'sony'=>'sony',
			'sph-'=>'sph-',
			'symb'=>'symb',
			't-mo'=>'t-mo',
			'teli'=>'teli',
			'tim-'=>'tim-',
			'tosh'=>'tosh',
			'treo'=>'treo',
			'tsm-'=>'tsm-',
			'upg1'=>'upg1',
			'upsi'=>'upsi',
			'vk-v'=>'vk-v',
			'voda'=>'voda',
			'webc'=>'webc',
			'winw'=>'winw',
			'winw'=>'winw',
			'xda-'=>'xda-'
			);
		
			if(!empty($agents[substr($_SERVER['HTTP_USER_AGENT'], 0, 4)]))
				return 'phone';
	    } 
	    	
	    return false;
	}	

	public function resize_modifier($filename, $width=0, $height=0, $set_watermark=false, $resized_dir = null)
	{
		$resized_filename = $this->image->add_resize_params($filename, $width, $height, $set_watermark);
		$resized_filename_encoded = $resized_filename;
		
		$size = ($width?$width:0).'x'.($height?$height:0).($set_watermark?"w":'');
        $image_sizes = array();
        if($this->settings->image_sizes)
            $image_sizes = explode('|',$this->settings->image_sizes);
        if(!in_array($size, $image_sizes)){
            $image_sizes[] = $size;
            $this->settings->image_sizes = implode('|',$image_sizes);
        }

		/*if(substr($resized_filename_encoded, 0, 7) == 'http://' || substr($resized_filename_encoded, 0, 8) == 'https://')
			$resized_filename_encoded = rawurlencode($resized_filename_encoded);*/

		$resized_filename_encoded = rawurlencode($resized_filename_encoded);
		
		if(empty($resized_dir)){
            $resized_dir = $this->config->resized_images_dir;
        }

		return $this->config->root_url.'/'.$resized_dir.$resized_filename_encoded;
	}

	public function token_modifier($text)
	{
		return $this->config->token($text);
	}

	public function url_modifier($params)
	{
		if(is_array(reset($params)))
			return $this->request->url(reset($params));
		else
			return $this->request->url($params);
	}

	public function plural_modifier($number, $singular, $plural1, $plural2=null)
	{
		$number = abs($number); 
		if(!empty($plural2))
		{
		$p1 = $number%10;
		$p2 = $number%100;
		if($number == 0)
			return $plural1;
		if($p1==1 && !($p2>=11 && $p2<=19))
			return $singular;
		elseif($p1>=2 && $p1<=4 && !($p2>=11 && $p2<=19))
			return $plural2;
		else
			return $plural1;
		}else
		{
			if($number == 1)
				return $singular;
			else
				return $plural1;
		}
	}

	public function first_modifier($params = array())
	{
		if(!is_array($params))
			return false;
		return reset($params);
	}

	public function cut_modifier($array, $num=1)
	{
		if($num>=0)
	    	return array_slice($array, $num, count($array)-$num, true);
	    else
	    	return array_slice($array, 0, count($array)+$num, true);
	}
	
	public function date_modifier($date, $format = null)
	{
		if(empty($date))
			$date = date("Y-m-d");
	    return date(empty($format)?$this->settings->date_format:$format, strtotime($date));
	}
	
	public function time_modifier($date, $format = null)
	{
	    return date(empty($format)?'H:i':$format, strtotime($date));
	}
	
	public function hashtag_modifier($str)
    {
    	/* другая реализация но без тире return preg_replace('/#([\w!%]+(?=[\s,!?.\n]|$))/u', '<a href="tags?keyword=$1">#$1</a>', $str);*/
    	return preg_replace('/#([а-яА-ЯёЁa-zA-Z0-9.*!_\-%]+)([^;\w]{1}|$)/u', '<a href="tags?keyword=$1">#$1</a>$2', $str);
    }
    
    public function bbcode_modifier($str)
    {
    	// BBcode array
		$find = array(
			'~\[b\](.*?)\[/b\]~s',
			'~\[i\](.*?)\[/i\]~s',
			'~\[u\](.*?)\[/u\]~s',
			'~\[s\](.*?)\[/s\]~s',
			'~\[color=(.*?)\](.*?)\[/color\]~s',
			//'~\[url\]((?:ftp|https?)://.*?)\[/url\]~s',
			'~\[img\](https?://.*?\.(?:jpg|jpeg|gif|png|bmp|webp|jp2|jxr))\[/img\]~s'
		);
		// HTML tags to replace BBcode
		$replace = array(
			'<b>$1</b>',
			'<i>$1</i>',
			'<span style="text-decoration:underline;">$1</span>',
			'<strike>$1</strike>',
			'<span style="color:$1;">$2</span>',
			//'<a href="$1">$1</a>',
			'<img class="izoom" src="$1" alt="" />'
		);
		// Replacing the BBcodes with corresponding HTML tags
		return preg_replace($find,$replace,$str);
    }

	public function api_plugin($params, $smarty)
	{		
		if(!isset($params['module']) || !isset($params['method']))
 			return false;

		$module = $params['module'];
		$method = $params['method'];
		$var = $params['var'];
		unset($params['module']);
		unset($params['method']);
		unset($params['var']);
		if(isset($params['_']))
			$res = $this->$module->$method($params['_']);
		else
			$res = $this->$module->$method($params);
		$smarty->assign($var, $res);
	}		
	
	public function template_min($source, $smarty){
		$store = array();
		$_store = 0;
		$_offset = 0;
		// Unify Line-Breaks to \n
		$source = preg_replace('/\015\012|\015|\012/', "\n", $source);
		// capture Internet Explorer and KnockoutJS Conditional Comments
		if (preg_match_all(
			'#<!--((\[[^\]]+\]>.*?<!\[[^\]]+\])|(\s*/?ko\s+.+))-->#is',
			$source,
			$matches,
			PREG_OFFSET_CAPTURE | PREG_SET_ORDER
		)
		) {
			foreach ($matches as $match) {
				$store[] = $match[ 0 ][ 0 ];
				$_length = strlen($match[ 0 ][ 0 ]);
				$replace = '@!@SMARTY:' . $_store . ':SMARTY@!@';
				$source = substr_replace($source, $replace, $match[ 0 ][ 1 ] - $_offset, $_length);
				$_offset += $_length - strlen($replace);
				$_store++;
			}
		}
		// Strip all HTML-Comments
		// $source = preg_replace('#<!--.*?-->#ms', '', $source);
		// capture html elements not to be messed with
		$_offset = 0;
		if (preg_match_all(
			'#(<script[^>]*>.*?</script[^>]*>)|(<textarea[^>]*>.*?</textarea[^>]*>)|(<pre[^>]*>.*?</pre[^>]*>)#is',
			$source,
			$matches,
			PREG_OFFSET_CAPTURE | PREG_SET_ORDER
		)
		) {
			foreach ($matches as $match) {
				$store[] = $match[ 0 ][ 0 ];
				$_length = strlen($match[ 0 ][ 0 ]);
				$replace = '@!@SMARTY:' . $_store . ':SMARTY@!@';
				$source = substr_replace($source, $replace, $match[ 0 ][ 1 ] - $_offset, $_length);
				$_offset += $_length - strlen($replace);
				$_store++;
			}
		}
		$expressions = array(
							 '#(:SMARTY@!@|>)\s+(?=@!@SMARTY:|<)#s'                                    => '\1 \2',
							 '#(([a-z0-9]\s*=\s*("[^"]*?")|(\'[^\']*?\'))|<[a-z0-9_]+)\s+([a-z/>])#is' => '\1 \5',
							 '#^\s+<#Ss'                                                               => '<',
							 '#>\s+$#Ss'                                                               => '>',
		);
		$source = preg_replace(array_keys($expressions), array_values($expressions), $source);
		$source = trim( $source ); // comment this line if have problems with spaces
		$_offset = 0;
		if (preg_match_all('#@!@SMARTY:([0-9]+):SMARTY@!@#is', $source, $matches, PREG_OFFSET_CAPTURE | PREG_SET_ORDER)) {
			foreach ($matches as $match) {
				$_length = strlen($match[ 0 ][ 0 ]);
				$replace = $store[ $match[ 1 ][ 0 ] ];
				$source = substr_replace($source, $replace, $match[ 0 ][ 1 ] + $_offset, $_length);
				$_offset += strlen($replace) - $_length;
				$_store++;
			}
		}
		return $source;
	}

	public function get_user_ip()
	{
		$client_ip  = @$_SERVER['HTTP_CLIENT_IP'];
		$forwarded_ip = @$_SERVER['HTTP_X_FORWARDED_FOR'];
		$real_ip = @$_SERVER['HTTP_X_REAL_IP'];
		$remote_ip  = $_SERVER['REMOTE_ADDR'];

		if(filter_var($real_ip, FILTER_VALIDATE_IP))
			$ip = $real_ip;
		elseif(filter_var($client_ip, FILTER_VALIDATE_IP))
			$ip = $client_ip;
		elseif(!empty($forwarded_ip)) 
		{
			if(is_array($forwarded_ip) && array_key_exists($forwarded_ip, '$_SERVER') && strpos($forwarded_ip, ',')>0){
				$ip = explode(',',$forwarded_ip);
				$ip = trim($ip[0]);
			} elseif(filter_var($forwarded_ip, FILTER_VALIDATE_IP)) {
				$ip = $forwarded_ip;
			} else {
				$ip = $remote_ip;
			}
		}
		else
			$ip = $remote_ip;

		return $ip;
	}

}
