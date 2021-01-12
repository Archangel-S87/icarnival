<?PHP

require_once('View.php');

class ProductAjaxView extends View
{

	function fetch()
	{   
		$product_url = $this->request->get('product_url', 'integer');
		$ip = $this->design->get_user_ip();
		
		if(empty($product_url))
			return false;

		$product = $this->products->get_product(intval($product_url));
		if(empty($product) || (!$product->visible && empty($_SESSION['admin'])))
			return false;

		if($product->visible && empty($_SESSION['admin']))
		$this->products->update_views($product->id); 
		
		$product->images = $this->products->get_images(array('product_id'=>$product->id));
		
		// Проверка загрузки всех изображений из интернета
		foreach($product->images as $url){
			if(!empty($url->filename) && (substr($url->filename,0,7) == 'http://' || substr($url->filename,0,8) == 'https://')){
				$new_name=$this->image->download_image($url->filename);
			}
		}
		$product->images = $this->products->get_images(array('product_id'=>$product->id));
		// Проверка загрузки всех изображений из интернета @
		
		$product->image = reset($product->images);

		$variants = array();
		// выбираем варианты в наличии
		//foreach($this->variants->get_variants(array('product_id'=>$product->id, 'in_stock'=>true)) as $v)
		// выбираем даже отсутствующие варианты
		foreach($this->variants->get_variants(array('product_id'=>$product->id)) as $v)
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
		if(is_array($ids[$i]))foreach ($ids[$i] as $name => $ids1) {
			$classes[$i][$name]='c'.join(' c', $ids1);
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
	


				


		$this->design->assign('product', $product);

		
		$product->categories = $this->categories->get_categories(array('product_id'=>$product->id));
		$this->design->assign('brand', $this->brands->get_brand(intval($product->brand_id)));	
		$category = reset($product->categories);
        $this->design->assign('category', $category);	
		

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
		
		return $this->design->fetch('product_ajax.tpl');
	}

}
