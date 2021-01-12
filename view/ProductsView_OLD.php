<?PHP

require_once('View.php');

class ProductsView extends View
{
	function fetch()
	{
		// GET-Параметры
		$category_url = $this->request->get('category', 'string');
		$brand_url    = $this->request->get('brand', 'string');
		
		$filter = array();
		$filter['visible'] = 1;	

		if($this->settings->showinstock == '1')
			$filter['in_stock'] = 1;
				
		$mode = $this->request->get('mode', 'string');
		if($mode == 'hits')
			$filter['featured'] = 1;
		if($mode == 'is_new')
			$filter['is_new'] = 1;
		if($mode == 'discounted')
			$filter['discounted'] = 1;
		if($mode == 'new')
			$filter['in_stock'] = 1;
		if($mode == 'rated')
			$filter['in_stock'] = 1;
		if($mode == 'popular')
			$filter['in_stock'] = 1;

		// Если задан бренд, выберем его из базы
		if ($val = $this->request->get('b')) {
            $filter['brand_id'] = $val;
        } elseif (!empty($brand_url)) {
            $brand = $this->brands->get_brand((string) $brand_url);
            if (empty($brand))
                return false;
            $this->design->assign('brand', $brand);
            $filter['brand_id'] = $brand->id;
            
            //Получаем категории бренда и передаем их в шаблон
			$brand_cat = $this->products->brands_category($brand->id);
			$this->design->assign('brand_cat', $brand_cat);
        }
		
		$variants = $this->request->get('v'); 
        if(!empty($variants)) $filter['variants'] = $variants; 
        
        $variants1 = $this->request->get('v1'); 
        if(!empty($variants1)) $filter['variants1'] = $variants1; 

		$variants2 = $this->request->get('v2'); 
        if(!empty($variants2)) $filter['variants2'] = $variants2; 

		// Выберем текущую категорию
		if (!empty($category_url))
		{
			$category = $this->categories->get_category((string)$category_url);
			if (empty($category) || (!$category->visible && empty($_SESSION['admin'])))
				return false;
			$this->design->assign('category', $category);
			$filter['category_id'] = $category->children;
		}

		// Если задано ключевое слово
		$keyword = $this->request->get('keyword');
		if (!empty($keyword))
		{
			$this->design->assign('keyword', $keyword);
			$filter['keyword'] = $keyword;
		}

		// Сортировка товаров, сохраняем в сессии, чтобы текущая сортировка оставалась для всего сайта
		if($sort = $this->request->get('sort', 'string'))
			$_SESSION['sort'] = $sort;		
		if(!empty($_SESSION['sort']))
			$filter['sort'] = $_SESSION['sort'];	
		else {
			if(isset($this->settings->sort_by))
				$filter['sort'] = $this->settings->sort_by;
			else
				$filter['sort'] = 'position';
		}		
		$this->design->assign('sort', $filter['sort']);

		if($this->design->is_mobile_browser())
			$_SESSION['on_page'] = $this->settings->mob_products_num;

		if($on_page = $this->request->get('on_page', 'string'))
			$_SESSION['on_page'] = $on_page;		
			
		if(!empty($_SESSION['on_page']))
			$filter['on_page'] = $_SESSION['on_page'];			
		else
			$filter['on_page'] = $this->settings->products_num;			
		$this->design->assign('on_page', $filter['on_page']);
		$this->design->assign('on_pages', $this->settings->products_num);
		
		// Свойства товаров
		if(!empty($category))
		{
			$features = array();
			$filter['features'] = array();

			$min=$this->request->get('min');
		    $max=$this->request->get('max');

			foreach($this->features->get_features(array('category_id'=>$category->id, 'in_filter'=>1)) as $feature)
			{ 
				$features[$feature->id] = $feature;
				if(($val = $this->request->get($feature->id))!='')
					$filter['features'][$feature->id] = $val;
				if($min[$feature->id] !='')
					$filter['min'][$feature->id] = $min[$feature->id];
        			if($max[$feature->id] !='')
					$filter['max'][$feature->id] = $max[$feature->id];	
        			if($min[$feature->id] !='' && $max[$feature->id] !='' && $min[$feature->id] > $max[$feature->id]){
					$temp = $filter['max'][$feature->id];	
					$filter['max'][$feature->id] = $filter['min'][$feature->id];
					$filter['min'][$feature->id] = $temp;
				}
			}

			$options_filter['visible'] = 1;
			
			$features_ids = array_keys($features);
			if(!empty($features_ids))
				$options_filter['feature_id'] = $features_ids;
			$options_filter['category_id'] = $category->children;
			if(isset($filter['features']))
				$options_filter['features'] = $filter['features'];

			if(isset($filter['brand_id'])){
				if($filter['brand_id']) {
	               $options_filter['brand_id'] = $filter['brand_id'];
	            }
				elseif(!empty($brand))
					$options_filter['brand_id'] = $brand->id;
			}
			
			$options = $this->features->get_options($options_filter);

			foreach($options as $option)
			{
				if(isset($features[$option->feature_id]))
					$features[$option->feature_id]->options[] = $option;
			}
			
			foreach($features as $i=>&$feature)
			{ 
				if(empty($feature->options))
					unset($features[$i]);
			}

			$this->design->assign('features', $features);
 		}
		//if(isset($filter['features']))
		//	$this->design->assign('ff', $filter['features']);
		if(isset($filter['features']))
			$this->design->assign('filter_features', $filter['features']);
		
		$pmm = $this->products->count_products($filter, 'all');
		$pmm->minCost=floor($pmm->minCost);
		$pmm->maxCost=ceil($pmm->maxCost);

		$pmm->minCost = floor($this->money->noFormat($pmm->minCost,'convert'));
		$pmm->maxCost = ceil($this->money->noFormat($pmm->maxCost,'convert'));

		$this->design->assign('minCost', (int)$pmm->minCost);
		$this->design->assign('maxCost', (int)$pmm->maxCost);

		$minCurr = (int)$this->request->get('minCurr');
		if(empty($minCurr)) 
			$minCurr=(int)$pmm->minCost;
		if(!empty($minCurr))
		{
			$this->design->assign('minCurr', $minCurr);
			$filter['minCurr'] = $minCurr;
		}

		$maxCurr = (int)$this->request->get('maxCurr');
		if(empty($maxCurr)) 
			$maxCurr=(int)$pmm->maxCost;
		if($maxCurr < $pmm->minCost) 
			$maxCurr=ceil($pmm->minCost);
		if(!empty($maxCurr))
		{
			$this->design->assign('maxCurr', $maxCurr);
			$filter['maxCurr'] = $maxCurr;
		}

		$filter['minCurr'] = $this->money->noFormat($filter['minCurr'],'deconvert');
		$filter['maxCurr'] = $this->money->noFormat($filter['maxCurr'],'deconvert');

		// Постраничная навигация
		
		$items_per_page = $filter['on_page'];	
		// Текущая страница в постраничном выводе
		//$current_page = $this->request->get('page', 'int');	
		$current_page = $this->request->get('page', 'integer');	
		// Если не задана, то равна 1
		$current_page = max(1, $current_page);
		$this->design->assign('current_page_num', $current_page);
		// Вычисляем количество страниц
		$products_count = $this->products->count_products($filter);
		
		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$items_per_page = $products_count;	
		
		$pages_num = ceil($products_count/$items_per_page);
		$this->design->assign('total_pages_num', $pages_num);
		$this->design->assign('total_products_num', $products_count);

		$filter['page'] = $current_page;
		$filter['limit'] = $items_per_page;
		
		// Постраничная навигация @
			
		// Товары 
		$products = array();
		foreach($this->products->get_products($filter) as $p)
			$products[$p->id] = $p;
		// Если искали товар и найден ровно один - перенаправляем на него
		if(!empty($keyword) && $products_count == 1)
			header('Location: '.$this->config->root_url.'/products/'.$p->url);
		
		if(!empty($products))
		{
			$products_ids = array_keys($products);

			$categories = $this->categories->get_product_categories($products_ids);
			foreach($categories as $cat)
				$products[$cat->product_id]->category = $this->categories->get_category((int)$cat->category_id);

			/*foreach($products as &$product)
			{
				$product->variants = array();
				$product->images = array();
			}*/
	
			$variants = $this->variants->get_variants(array('product_id'=>$products_ids, 'in_stock'=>true));
			
			foreach($variants as &$variant)
			{
				$products[$variant->product_id]->variants[] = $variant;
			}
	
			$images = $this->products->get_images(array('product_id'=>$products_ids));
			foreach($images as $image)
				$products[$image->product_id]->images[] = $image;
				
			// Проверка загрузки всех изображений из интернета
			/*foreach($images as $url){
				if(!empty($url->filename) && (substr($url->filename,0,7) == 'http://' || substr($url->filename,0,8) == 'https://')){
					$new_name=$this->image->download_image($url->filename);
				}
			}
			$images = $this->products->get_images(array('product_id'=>$products_ids));
			foreach($images as $image)
				$products[$image->product_id]->images[] = $image;*/
			//	Проверка загрузки всех изображений из интернета @	

			foreach($products as &$product)
			{
				$product->category = reset($this->categories->get_categories(array('product_id'=>$product->id)));
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
			
			// Фильтр по вариантам (должен быть ниже всех $filter)
			if($this->settings->b10manage==1 || $this->settings->sizemanage==1 || $this->settings->colormanage==1){
				$filter['page'] = '';
				// Выбираем id товаров без привязки к странице пагинации
				$products_all = array();
				foreach($this->products->get_products($filter) as $p)
					$products_all[$p->id] = $p;
				$products_all_ids = array_keys($products_all);
			}
			
			if($this->settings->b10manage==1){
				$namevar='name';
				$features_variants = array();
				$temp_variants = $this->variants->get_value_variants(array('product_id'=>$products_all_ids, 'in_stock'=>true), $namevar);
				foreach($temp_variants as &$variant)
					$features_variants[$variant->$namevar] = $variant->$namevar;  
				asort($features_variants);
				$this->design->assign('features_variants', $features_variants);     
			}
			if($this->settings->sizemanage==1){
				$namevar1='name1';
				$features_variants1 = array();
				$temp_variants1 = $this->variants->get_value_variants(array('product_id'=>$products_all_ids, 'in_stock'=>true), $namevar1);
				foreach($temp_variants1 as &$variant)
					$features_variants1[$variant->$namevar1] = $variant->$namevar1;  
				asort($features_variants1);
				$this->design->assign('features_variants1', $features_variants1);    
            }
            if($this->settings->colormanage==1){
				$namevar2='name2';
				$features_variants2 = array();
				$temp_variants2 = $this->variants->get_value_variants(array('product_id'=>$products_all_ids, 'in_stock'=>true), $namevar2);
				foreach($temp_variants2 as &$variant)
					$features_variants2[$variant->$namevar2] = $variant->$namevar2;  
				asort($features_variants2);
				$this->design->assign('features_variants2', $features_variants2);    
            } 
            // Фильтр по вариантам @
  
            // вывод свойств товара в products.tpl
			/*$properties = $this->features->get_product_options($products_ids);
			foreach($properties as $property) {
				$products[$property->product_id]->options[] = $property;
			}*/
			// вывод свойств товара в products.tpl end
			
			$this->design->assign('products', $products);
 		}

		// Выбираем бренды, они нужны нам в шаблоне	
		if(!empty($category))
		{
			$brands = $this->brands->get_brands(array('category_id'=>$category->children, 'visible'=>1, 'active'=>1));
			$category->brands = $brands;		
		}
		
		// Устанавливаем мета-теги в зависимости от запроса
		
		if(isset($category)){
			if(!empty($category->meta_title))
				$category_mt = $category->meta_title;
			else
				$category_mt = $category->name;
		}
		
		if(isset($brand)){
			if(!empty($brand->meta_title))
				$brand_mt = $brand->meta_title;
			else
				$brand_mt = $brand->name;
		}
		
		if($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
			$this->setHeaderLastModify($this->page->last_modify, 2592000); // expires 2592000 - month
		}
		elseif(isset($category) && isset($brand))
		{
			$this->design->assign('meta_title', $category_mt.' | '.$brand_mt);
			$this->design->assign('meta_keywords', $category->meta_keywords);
			$this->design->assign('meta_description', $category->meta_description.' Бренд: '.$brand->name);
			$this->setHeaderLastModify($category->last_modify, 604800); // expires 604800 - week
		}
		elseif(isset($category))
		{
			$this->design->assign('meta_title', $category_mt);
			$this->design->assign('meta_keywords', $category->meta_keywords);
			$this->design->assign('meta_description', $category->meta_description);
			$this->setHeaderLastModify($category->last_modify, 604800); // expires 604800 - week
		}
		elseif(isset($brand))
		{
			$this->design->assign('meta_title', $brand_mt);
			$this->design->assign('meta_keywords', $brand->meta_keywords);
			$this->design->assign('meta_description', $brand->meta_description);
			$this->setHeaderLastModify($brand->last_modify, 604800); // expires 604800 - week
		}
		elseif(isset($keyword))
		{
			$this->design->assign('meta_title', $keyword);
		}
		
		// Метаданные страниц
		$currentURL=$_SERVER['REQUEST_URI'];
		$metadata_page=$this->metadatapages->get_metadata_page($currentURL);
        if(!empty($metadata_page)) {
            $this->design->assign('metadata_page',$metadata_page);
            if(!empty($metadata_page->meta_title)) 
            	$this->design->assign('meta_title', $metadata_page->meta_title);
            if(!empty($metadata_page->meta_keywords)) 
				$this->design->assign('meta_keywords', $metadata_page->meta_keywords);
			if(!empty($metadata_page->meta_description)) 
				$this->design->assign('meta_description', $metadata_page->meta_description);
			if(!empty($metadata_page->h1_title)) 
				$this->design->assign('h1_title', $metadata_page->h1_title);
		}
		
		// ajax filter
		if ($this->request->get('aj_f') == 'true') {
            $return = array(
                'content' => $this->body,
                'filter_block' => $this->design->fetch('cfeatures.tpl'),
            );
            die(json_encode($return));
        } elseif ($this->request->get('aj_mf') == 'true') {
            $return = array(
                'content' => $this->body,
                'filter_block' => $this->design->fetch('mfeatures.tpl'),
            );
            die(json_encode($return));
        } else {
        	$this->body = $this->design->fetch('products.tpl');
        	return $this->body;
        }
		// ajax filter end
	}

}
