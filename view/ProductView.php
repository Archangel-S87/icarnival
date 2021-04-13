<?PHP

require_once('View.php');

class ProductView extends View
{

	function fetch()
	{   
		$product_url = $this->request->get('product_url', 'string');
		$ip = $this->design->get_user_ip();
		
		if(empty($product_url))
			return false;
			
		$filter = array();
		if($this->settings->showinstock == '1')
			$filter['in_stock'] = 1;	

		$product = $this->products->get_product((string)$product_url);
		if(empty($product) || (!$product->visible && empty($_SESSION['admin'])))
			return false;
		
		$product->images = $this->products->get_images(array('product_id'=>$product->id));
		
		// Проверка загрузки всех изображений из интернета
		if(!empty($this->settings->check_download)){
			foreach($product->images as $url){
				if(!empty($url->filename) && (substr($url->filename,0,7) == 'http://' || substr($url->filename,0,8) == 'https://')){
					$new_name=$this->image->download_image($url->filename);
				}
			}
			$product->images = $this->products->get_images(array('product_id'=>$product->id));
		}	
		// Проверка загрузки всех изображений из интернета @
		
		$product->image = reset($product->images);

		$variants = array();

		// Выбираем варианты в наличии, если нет, то включая отсутствующие
		$get_variants = $this->variants->get_variants(array('product_id'=>$product->id, 'in_stock'=>true));
		if(empty($get_variants)){
			$get_variants = $this->variants->get_variants(array('product_id'=>$product->id));
		}
		foreach($get_variants as $v)
			$variants[$v->id] = $v;

		$ids=array();	
		if(is_array($variants))foreach ($variants as $k => $v) {
			if(!empty($v->name1) or !empty($v->name2)){
				$ids[0][$v->name1][] = $v->id;
				$ids[1][$v->name2][] = $v->id;
			}
		}
		$classes=array();
		for($i=0;$i<2;$i++) 
		if(isset($ids[$i]) && is_array($ids[$i])){
			foreach ($ids[$i] as $name => $ids1) {
				$classes[$i][$name]='c'.join(' c', $ids1);
			}
		}
		$product->vproperties = $classes;

		$product->variants = $variants;
		
		if(($v_id = $this->request->get('variant', 'integer'))>0 && isset($variants[$v_id]))
			$product->variant = $variants[$v_id];
		else
			$product->variant = reset($variants);

		$options = $this->features->get_product_options($product->id);
		if(is_array($options))
		{
			$temp_options = array();
			foreach($options as $option){
				if(isset($temp_options[$option->feature_id]))
					$temp_options[$option->feature_id]->value .= ', '.$option->value; 
				else
					$temp_options[$option->feature_id] = $option;
			}
			$product->features = $temp_options;
		}
	
		if(!empty($this->user)) {
			$this->design->assign('comment_name', $this->user->name);
			$this->design->assign('comment_email', $this->user->email); 

			$last_order = $this->orders->get_orders(array('user_id'=>$this->user->id, 'limit'=>1));
			$last_order = reset($last_order);
			if($last_order)
				$this->design->assign('phone', $last_order->phone);
		}

		if ($this->request->method('post') && $this->request->post('comment'))
		{
			$comment = new stdClass;
			$comment->name = $this->request->post('name');
			$comment->text = $this->request->post('text');
			$comment->email = $this->request->post('email');
			// antibot
			if($this->request->post('bttrue')) {
				$bttrue = $this->request->post('bttrue');
				$this->design->assign('bttrue', $bttrue);
			}	
			if($this->request->post('btfalse')) {
				$btfalse = $this->request->post('btfalse');
				$this->design->assign('btfalse', $btfalse);
			}
			// antibot end
			
			$this->design->assign('comment_text', $comment->text);
			$this->design->assign('comment_name', $comment->name);
			$this->design->assign('comment_email', $comment->email);
			
			if (empty($comment->name))
				$this->design->assign('error', 'empty_name');
			elseif($this->settings->spam_cyr == 1 && !preg_match('/^[а-яё \t]+$/iu', $comment->name))
				$this->design->assign('error', 'wrong_name');
			elseif(!empty($this->settings->spam_symbols) && mb_strlen($comment->name,'UTF-8') > $this->settings->spam_symbols)
				$this->design->assign('error', 'captcha');
			elseif(!empty($comment->email) && filter_var($comment->email, FILTER_VALIDATE_EMAIL) === false)	
				$this->design->assign('error', 'wrong_email');	
			elseif (empty($comment->text))
				$this->design->assign('error', 'empty_comment');
			elseif(!$bttrue)
				$this->design->assign('error', 'captcha');
			elseif(!empty($btfalse))
				$this->design->assign('error', 'captcha');	
			else
			{
				$comment->object_id = $product->id;
				$comment->type      = 'product';
				$comment->ip        = $ip;
				$comment_id = $this->comments->add_comment($comment);
				
				if($this->settings->auto_subscribe == 1)
					$this->mailer->add_mail($comment->name, $comment->email);		
				
				$this->notify->email_comment_admin($comment_id);				
				//header('location: '.$_SERVER['REQUEST_URI'].'#comment_'.$comment_id);
				header('location: '.$_SERVER['REQUEST_URI']);
			}			
		}
		
		// Связанные товары	
		$related_ids = array();
		foreach($this->products->get_related_products($product->id) as $p)
		{
			$related_ids[] = $p->related_id;
		}
		if(!empty($related_ids))
		{
			$this->design->assign('related_ids', $related_ids);
		}

		$comments = $this->comments->get_comments(array('type'=>'product', 'object_id'=>$product->id, 'approved'=>1, 'ip'=>$ip));
		
		$files = $this->files->get_files(array('object_id'=>$product->id,'type'=>'product'));
		$this->design->assign('cms_files', $files);  

		$this->design->assign('product', $product);
		$this->design->assign('comments', $comments);
		
		$product->categories = $this->categories->get_categories(array('product_id'=>$product->id));
		$this->design->assign('brand', $this->brands->get_brand(intval($product->brand_id)));	
		$category = reset($product->categories);
        $this->design->assign('category', $category);	
		
		if(!empty($category->id)){
			$this->design->assign('next_product', $this->products->get_next_product($category->id, $product->position, $filter));
			$this->design->assign('prev_product', $this->products->get_prev_product($category->id, $product->position, $filter));
		}
		
		// Добавление в историю просмотренных товаров
        $max_visited_products = 100; // Максимальное число хранимых товаров в истории
        $expire = time()+60*60*24*365; // Время жизни - 365 дней
        if (!empty($_COOKIE['browsed_products'])) {
            $browsed_products = explode(',', $_COOKIE['browsed_products']);
            // Удалим текущий товар, если он был
            if (($exists = array_search($product->id, $browsed_products)) !== false) {
                unset($browsed_products[$exists]);
            }
        }
        // Добавим в просмотренные текущий товар
        $browsed_products[] = $product->id;
        $cookie_val = implode(',', array_slice($browsed_products, -$max_visited_products, $max_visited_products));
        setcookie("browsed_products", $cookie_val, $expire, "/");
		
		$this->design->assign('meta_title', $product->meta_title);
		$this->design->assign('meta_keywords', $product->meta_keywords);
		$this->design->assign('meta_description', $product->meta_description);
		
		//lastModify
        $this->setHeaderLastModify($product->created, 2592000); // expires 2592000 - month
		
		return $this->design->fetch('product.tpl');
	}

}
