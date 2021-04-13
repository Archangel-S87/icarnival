<?php

require_once('Fivecms.php');

class Products extends Fivecms
{
	/**
     * Функция возвращает товары
     *
     * @param array $filter
     * @return array|bool
     */
	public function get_products($filter = array())
	{		
		$limit = 400;
		$page = 1;
		$category_id_filter = '';
		$without_category_filter = '';
		$brand_id_filter = '';
		$product_id_filter = '';
		$features_filter = '';
		$keyword_filter = '';
		$visible_filter = '';
		$is_featured_filter = '';
		$is_new_filter = '';
		$to_yandex_filter = '';
		$discounted_filter = '';
		$in_stock_filter = '';
		$group_by = '';
		$order = 'p.position DESC';
		$variant_filter = '';
		$variant_filter1 = '';
		$variant_filter2 = '';
        $variant_join = '';
        $products_stock_null_sort = '';

		if(isset($filter['limit']))
			$limit = max(1, intval($filter['limit']));

		if(isset($filter['page']))
			$page = max(1, intval($filter['page']));

		$sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);

		if(!empty($filter['id']))
			$product_id_filter = $this->db->placehold('AND p.id in(?@)', (array)$filter['id']);

		if(!empty($filter['category_id']))
		{
			$category_id_filter = $this->db->placehold('INNER JOIN __products_categories pc ON pc.product_id = p.id AND pc.category_id in(?@)', (array)$filter['category_id']);
			$group_by = "GROUP BY p.id";
		}
		
		if(isset($filter['without_category'])) {
            $without_category_filter = $this->db->placehold(' AND (SELECT count(*)=0 FROM __products_categories pc WHERE pc.product_id=p.id) = ?', intval($filter['without_category']));
        }

		if(!empty($filter['brand_id']))
			$brand_id_filter = $this->db->placehold('AND p.brand_id in(?@)', (array)$filter['brand_id']);

		if(isset($filter['featured']))
			{
			$is_featured_filter = $this->db->placehold('AND p.featured=?', intval($filter['featured']));
			}

		if(isset($filter['is_new']))
			{
		    $is_new_filter = $this->db->placehold('AND p.is_new=?', intval($filter['is_new']));
			}
			
		if(isset($filter['discounted']))
			{	
			$discounted_filter = $this->db->placehold('AND (SELECT 1 FROM __variants pv WHERE pv.product_id=p.id AND pv.compare_price>0 LIMIT 1) = ?', intval($filter['discounted']));
			}
			
		if(isset($filter['to_yandex']))
		    $to_yandex_filter = $this->db->placehold('AND p.to_yandex=?', intval($filter['to_yandex']));

		if(isset($filter['in_stock']))
			$in_stock_filter = $this->db->placehold('AND (SELECT count(*)>0 FROM __variants pv WHERE pv.product_id=p.id AND pv.price>0 AND (pv.stock IS NULL OR pv.stock>0) LIMIT 1) = ?', intval($filter['in_stock']));

		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND p.visible=?', intval($filter['visible']));

 		if(!empty($filter['sort']))
			switch ($filter['sort'])
			{
				case 'position':
					if(empty($this->settings->showinstock) || $this->settings->showinstock == 1){
					$order = 'p.position DESC';
					} elseif($this->settings->showinstock == 2){
					$order = 'IF((SELECT COUNT(*) FROM __variants WHERE (stock>0 OR stock IS NULL) AND product_id=p.id LIMIT 1), 1, 0) DESC, p.position DESC';
					}
				break;
				case 'name':
					if(empty($this->settings->showinstock) || $this->settings->showinstock == 1){
					$order = 'p.name';
					} elseif($this->settings->showinstock == 2){
					$order = 'IF((SELECT COUNT(*) FROM __variants WHERE (stock>0 OR stock IS NULL) AND product_id=p.id LIMIT 1), 1, 0) DESC, p.name';
					}
				break;
				case 'created':
					if(empty($this->settings->showinstock) || $this->settings->showinstock == 1){
					$order = 'p.created DESC';
					} elseif($this->settings->showinstock == 2){
					$order = 'IF((SELECT COUNT(*) FROM __variants WHERE (stock>0 OR stock IS NULL) AND product_id=p.id LIMIT 1), 1, 0) DESC, p.created DESC';
					}
				break;
				case 'date':
					if(empty($this->settings->showinstock) || $this->settings->showinstock == 1){
					$order = 'p.created DESC';
					} elseif($this->settings->showinstock == 2){
					$order = 'IF((SELECT COUNT(*) FROM __variants WHERE (stock>0 OR stock IS NULL) AND product_id=p.id LIMIT 1), 1, 0) DESC, p.created DESC';
					}
				break;
				// multicurrency
				case 'priceup':
					$currency_tmp = $this->money->get_currencies();		
					$currency = reset($currency_tmp);
					if(empty($this->settings->showinstock) || $this->settings->showinstock == 1){
					$order = '(SELECT IF((pv.currency_id !='.$currency->id.' AND pv.currency_id > 0), 
						(-pv.price*(SELECT rate_to FROM __currencies AS c WHERE c.id =pv.currency_id)/(SELECT rate_from FROM __currencies AS c WHERE c.id = pv.currency_id)),
						-pv.price) FROM __variants pv WHERE p.id = pv.product_id LIMIT 1) DESC';
					} elseif($this->settings->showinstock == 2){
					$order = '(SELECT IF((pv.currency_id !='.$currency->id.' AND pv.currency_id > 0), 
						(-pv.price*(SELECT rate_to FROM __currencies AS c WHERE c.id =pv.currency_id)/(SELECT rate_from FROM __currencies AS c WHERE c.id = pv.currency_id)),
						-pv.price) FROM __variants pv WHERE (pv.stock IS NULL OR pv.stock>0) AND p.id = pv.product_id AND pv.position=(SELECT MIN(position) FROM __variants WHERE (stock>0 OR stock IS NULL) AND product_id=p.id LIMIT 1) LIMIT 1) DESC';
					}
				break;
				case 'pricedown':
					$currency_tmp = $this->money->get_currencies();		
					$currency = reset($currency_tmp);
					if(empty($this->settings->showinstock) || $this->settings->showinstock == 1){
					$order = '(SELECT IF((pv.currency_id !='.$currency->id.' AND pv.currency_id > 0), 
						(pv.price*(SELECT rate_to FROM __currencies AS c WHERE c.id =pv.currency_id)/(SELECT rate_from FROM __currencies AS c WHERE c.id = pv.currency_id)),
						pv.price) FROM __variants pv WHERE p.id = pv.product_id LIMIT 1) DESC';
					} elseif($this->settings->showinstock == 2){
					$order = '(SELECT IF((pv.currency_id !='.$currency->id.' AND pv.currency_id > 0), 
						(pv.price*(SELECT rate_to FROM __currencies AS c WHERE c.id =pv.currency_id)/(SELECT rate_from FROM __currencies AS c WHERE c.id = pv.currency_id)),
						pv.price) FROM __variants pv WHERE (pv.stock IS NULL OR pv.stock>0) AND p.id = pv.product_id AND pv.position=(SELECT MIN(position) FROM __variants WHERE (stock>0 OR stock IS NULL) AND product_id=p.id LIMIT 1) LIMIT 1) DESC';
					}
				break;
				// multicurrency end
				case 'stock':
					$order = '(SELECT pv.stock FROM __variants pv WHERE (pv.stock IS NULL OR pv.stock>0) AND p.id = pv.product_id AND pv.position=(SELECT MIN(position) FROM __variants WHERE (stock>0 OR stock IS NULL) AND product_id=p.id LIMIT 1) LIMIT 1) DESC, p.position';
					$order = 'IF(v.stock < 1,1,0),'.$order;
					$group_by = 'GROUP BY p.id';
					$products_stock_null_sort = 'INNER JOIN __variants v ON p.id = v.product_id';
				break;
				case 'rating':
					if(empty($this->settings->showinstock) || $this->settings->showinstock == 1){
					$order = 'p.rating DESC, p.position DESC';
					} elseif($this->settings->showinstock == 2){
					$order = 'IF((SELECT COUNT(*) FROM __variants WHERE (stock>0 OR stock IS NULL) AND product_id=p.id LIMIT 1), 1, 0) DESC, p.rating DESC, p.position DESC';
					}
				break;
				case 'rand':
					$order = 'RAND()';
				break;
			}

		if(!empty($filter['variants']))
        {
			$namevar='name';
            $variant_filter = $this->db->placehold(' AND pv.'.$namevar.' in(?@) AND (pv.stock IS NULL OR pv.stock>0)', (array)$filter['variants']);
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
        }
        
        if(!empty($filter['variants1']))
        {
			$namevar1='name1';
            $variant_filter1 = $this->db->placehold(' AND pv.'.$namevar1.' in(?@) AND (pv.stock IS NULL OR pv.stock>0)', (array)$filter['variants1']);
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
        }

		if(!empty($filter['variants2']))
        {
			$namevar2='name2';
            $variant_filter2 = $this->db->placehold(' AND pv.'.$namevar2.' in(?@) AND (pv.stock IS NULL OR pv.stock>0)', (array)$filter['variants2']);
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
        }

		if(!empty($filter['keyword']))
 		{
 			$keywords = explode(' ', $filter['keyword']);
 			foreach($keywords as $keyword)
			{
				$kw = $this->db->escape(trim($keyword));
				$keyword_filter .= $this->db->placehold("AND (p.name LIKE '%$kw%' OR p.meta_keywords LIKE '%$kw%' OR p.id LIKE '%$kw%' OR p.id in (SELECT product_id FROM __variants WHERE sku LIKE '%$kw%' OR name LIKE '%$kw%'))");
			}
 		}

		if(!empty($filter['features']))
			foreach($filter['features'] as $feature=>$value)
				  $features_filter .= $this->db->placehold('AND p.id in (SELECT product_id FROM __options WHERE feature_id=? AND value in (?@) ) ', $feature, $value);

		if(!empty($filter['min']))
			foreach($filter['min'] as $feature=>$value)
				$features_filter .= $this->db->placehold('AND p.id in (SELECT product_id FROM __options WHERE feature_id=? AND -value <=? ) ', $feature, -$value);

		if(!empty($filter['max']))
			foreach($filter['max'] as $feature=>$value)
				$features_filter .= $this->db->placehold('AND p.id in (SELECT product_id FROM __options WHERE feature_id=? AND -value >=? ) ', $feature, -$value);
		
		$currency_tmp = $this->money->get_currencies();		
		$currency = reset($currency_tmp);	
		$price_curr_temp = "IF((v.currency_id !='.$currency->id.' AND v.currency_id > 0),(v.price*(SELECT rate_to FROM __currencies AS c WHERE c.id =v.currency_id)/(SELECT rate_from FROM __currencies AS c WHERE c.id = v.currency_id)),v.price)";

		$query = "SELECT  
					p.id,
					p.url,
					p.brand_id,
					p.name,
					p.annotation,
					p.body,
					p.rating,
					p.votes,
					p.visible, 
					p.position,
					p.meta_title, 
					p.meta_keywords, 
					p.meta_description, 
					p.created as created,
					p.featured, 
					p.is_new,
					p.to_yandex,
					p.ref_url,
                    p.video,
					b.name as brand,
					b.url as brand_url
				FROM __products p	
				$variant_join	
				$category_id_filter
				LEFT JOIN __brands b ON p.brand_id = b.id
				$products_stock_null_sort
				WHERE 
					1
					$without_category_filter 
					$product_id_filter
					$brand_id_filter
					$features_filter
					$keyword_filter
					$variant_filter
					$variant_filter1
					$variant_filter2
					$is_featured_filter
					$is_new_filter
					$to_yandex_filter
					$discounted_filter
					$in_stock_filter
					$visible_filter
					".(isset($filter['minCurr']) ? "AND (SELECT 1 FROM __variants v WHERE v.product_id=p.id AND ".$price_curr_temp.">='".$filter['minCurr']."' LIMIT 1) = 1" : '')."
					".(isset($filter['maxCurr']) ? "AND (SELECT 1 FROM __variants v WHERE v.product_id=p.id AND ".$price_curr_temp."<='".$filter['maxCurr']."' LIMIT 1) = 1" : '')."
				$group_by
				ORDER BY $order
					$sql_limit";

		if($this->settings->cached == 1 && empty($_SESSION['admin'])){
			if($result = $this->cache->get($query)) {
				return $result; // возвращаем данные из memcached
			} else {
				$this->db->query($query); // иначе тянем из БД
				$result=$this->db->results();
				$this->cache->set($query, $result); //помещаем в кеш
				return $result;
			}
		} else {
			$this->db->query($query);
			return $this->db->results();
		}
	}
	
	/**
     * Функция возвращает количество товаров
     *
     * @param array $filter
     * @return bool|object|string
     */
	public function count_products($filter = array(), $type='')
	{		
		$category_id_filter = '';
		$without_category_filter = '';
		$brand_id_filter = '';
		$product_id_filter = '';
		$keyword_filter = '';
		$visible_filter = '';
		$is_featured_filter = '';
		$is_new_filter = '';
		$to_yandex_filter = '';
		$in_stock_filter = '';
		$discounted_filter = '';
		$features_filter = '';
		$variant_filter = '';
		$variant_filter1 = '';
		$variant_filter2 = '';
        $variant_join = '';
		
		if(!empty($filter['category_id']))
			$category_id_filter = $this->db->placehold('INNER JOIN __products_categories pc ON pc.product_id = p.id AND pc.category_id in(?@)', (array)$filter['category_id']);
			
		if(isset($filter['without_category'])) {
            $without_category_filter = $this->db->placehold(' AND (SELECT count(*)=0 FROM __products_categories pc WHERE pc.product_id=p.id) = ?', intval($filter['without_category']));
        }	

		if(!empty($filter['brand_id']))
			$brand_id_filter = $this->db->placehold('AND p.brand_id in(?@)', (array)$filter['brand_id']);
		
		if(!empty($filter['id']))
		$product_id_filter = $this->db->placehold('AND p.id in(?@)', (array)$filter['id']);

		if(isset($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
			{
				$kw = $this->db->escape(trim($keyword));
				$keyword_filter .= $this->db->placehold("AND (p.name LIKE '%$kw%' OR p.meta_keywords LIKE '%$kw%' OR p.id LIKE '%$kw%' OR p.id in (SELECT product_id FROM __variants WHERE sku LIKE '%$kw%' OR name LIKE '%$kw%'))");
			}
		}

		if(!empty($filter['variants']))
        {
			$namevar='name';
            $variant_filter = $this->db->placehold(' AND pv.'.$namevar.' in(?@) AND (pv.stock IS NULL OR pv.stock>0)', (array)$filter['variants']);
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
        }

        if(!empty($filter['variants1']))
        {
			$namevar1='name1';
            $variant_filter1 = $this->db->placehold(' AND pv.'.$namevar1.' in(?@) AND (pv.stock IS NULL OR pv.stock>0)', (array)$filter['variants1']);
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
        }

		if(!empty($filter['variants2']))
        {
			$namevar2='name2';
            $variant_filter2 = $this->db->placehold(' AND pv.'.$namevar2.' in(?@) AND (pv.stock IS NULL OR pv.stock>0)', (array)$filter['variants2']);
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
        }

		if(isset($filter['featured']))
			$is_featured_filter = $this->db->placehold('AND p.featured=?', intval($filter['featured']));

		if(isset($filter['is_new']))
			$is_new_filter = $this->db->placehold('AND p.is_new=?', intval($filter['is_new']));

		if(isset($filter['to_yandex']))
			$to_yandex_filter = $this->db->placehold('AND p.to_yandex=?', intval($filter['to_yandex']));

		if(isset($filter['in_stock']))
			$in_stock_filter = $this->db->placehold('AND (SELECT count(*)>0 FROM __variants pv WHERE pv.product_id=p.id AND pv.price>0 AND (pv.stock IS NULL OR pv.stock>0) LIMIT 1) = ?', intval($filter['in_stock']));

		if(isset($filter['discounted']))
			$discounted_filter = $this->db->placehold('AND (SELECT 1 FROM __variants pv WHERE pv.product_id=p.id AND pv.compare_price>0 LIMIT 1) = ?', intval($filter['discounted']));

		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND p.visible=?', intval($filter['visible']));
		
		if(!empty($filter['features']))
			foreach($filter['features'] as $feature=>$value)
				$features_filter .= $this->db->placehold('AND p.id in (SELECT product_id FROM __options WHERE feature_id=? AND value in (?@) ) ', $feature, $value);
		
		if(!empty($filter['min']))
			foreach($filter['min'] as $feature=>$value)
				$features_filter .= $this->db->placehold('AND p.id in (SELECT product_id FROM __options WHERE feature_id=? AND -value <=? ) ', $feature, -$value);

		if(!empty($filter['max']))
			foreach($filter['max'] as $feature=>$value)
				$features_filter .= $this->db->placehold('AND p.id in (SELECT product_id FROM __options WHERE feature_id=? AND -value >=? ) ', $feature, -$value);
				
		$currency_tmp = $this->money->get_currencies();		
		$currency = reset($currency_tmp);		
		$price_curr_temp = "IF((v.currency_id !='.$currency->id.' AND v.currency_id > 0),(v.price*(SELECT rate_to FROM __currencies AS c WHERE c.id =v.currency_id)/(SELECT rate_from FROM __currencies AS c WHERE c.id = v.currency_id)),v.price)";
		
		$query = "SELECT count(distinct p.id) as count ".($type=='all' ? ', min('.$price_curr_temp.') minCost, max('.$price_curr_temp.') maxCost ' : '')." 
			FROM __products AS p ".($type=='all' ? 'INNER JOIN __variants v ON (v.product_id = p.id) ' : '')."
			$variant_join
			$category_id_filter
			WHERE 1
					$without_category_filter
					$product_id_filter
					$brand_id_filter
					$keyword_filter
					$variant_filter
					$variant_filter1
					$variant_filter2
					$is_featured_filter
					$is_new_filter
					$to_yandex_filter
					$discounted_filter
					$in_stock_filter
					$visible_filter
					$features_filter
					".(isset($filter['minCurr']) ? "AND (SELECT 1 FROM __variants v WHERE v.product_id=p.id AND ".$price_curr_temp.">='".$filter['minCurr']."' LIMIT 1) = 1" : '')."
					".(isset($filter['maxCurr']) ? "AND (SELECT 1 FROM __variants v WHERE v.product_id=p.id AND ".$price_curr_temp."<='".$filter['maxCurr']."' LIMIT 1) = 1" : '')."
		";
			
		if($this->settings->cached == 1 && empty($_SESSION['admin'])){
			if($result = $this->cache->get($query)) {
				return $result; // возвращаем данные из memcached
			} else {
				$this->db->query($query); // иначе тянем из БД
				if($type=='all') {
					$result = $this->db->result();
					$this->cache->set($query, $result); //помещаем в кеш
					return $result;
				} else {
					$result = $this->db->result('count');
					$this->cache->set($query, $result); //помещаем в кеш
					return $result;
				}
			}	
		} else {
			$this->db->query($query);	
			if($type=='all')
				return $this->db->result();
			else
				return $this->db->result('count');
		}	
	}

	/**
	* Функция возвращает товар по id
	*
	* @param	$id
	* @retval	object
	*/
	public function get_product($id)
	{
		if(is_int($id))
			$filter = $this->db->placehold('p.id = ?', $id);
		else
			$filter = $this->db->placehold('p.url = ?', $id);
			
		$query = "SELECT DISTINCT
					p.id,
					p.url,
					p.brand_id,
					p.name,
					p.annotation,
					p.body,
					p.rating,
					p.votes,
					p.visible, 
					p.position,
					p.meta_title, 
					p.meta_keywords, 
					p.meta_description,
					p.created as created,
					p.featured, 
            		p.is_new, 
            		p.to_yandex, 
					p.external_id,
					p.ref_url,
                    p.video
				FROM __products AS p
                LEFT JOIN __brands b ON p.brand_id = b.id
                WHERE $filter
                GROUP BY p.id
                LIMIT 1";
		$this->db->query($query);
		$product = $this->db->result();
		return $product;
	}

	/**
     * @param  int $id
     * @param  array|object $product
     * @return int|false
     */
	public function update_product($id, $product)
	{
		$query = $this->db->placehold("UPDATE __products SET ?% WHERE id in (?@) LIMIT ?", $product, (array)$id, count((array)$id));
		if($this->db->query($query))
			return $id;
		else
			return false;
	}
	
	/**
	 * Добавление товара
	 *
     * @param  array|object $product
     * @return int|false
     */
	public function add_product($product)
	{	
		$product = (array) $product;
		
		if(empty($product['url']))
			$product['url'] = $this->translit($product['name']);
			
		while($this->get_product((string)$product['url']))
		{
			if(preg_match('/(.+)_([0-9]+)$/', $product['url'], $parts))
				$product['url'] = $parts[1].'_'.($parts[2]+1);
			else
				$product['url'] = $product['url'].'_2';
		}

		if($this->db->query("INSERT INTO __products SET ?%", $product))
		{
			$id = $this->db->insert_id();
			$this->db->query("UPDATE __products SET position=id WHERE id=?", $id);					
			return $id;
		}
		else
			return false;
	}
	
	/**
     * Удаление товара
     *
     * @param  int $id
     * @return bool
     */
	public function delete_product($id)
	{
		if(!empty($id))
		{
			$variants = $this->variants->get_variants(array('product_id'=>$id));
			foreach($variants as $v)
				$this->variants->delete_variant($v->id);
			
			$images = $this->get_images(array('product_id'=>$id));
			foreach($images as $i)
				$this->delete_image($i->id);
			
			$categories = $this->categories->get_categories(array('product_id'=>$id));
			foreach($categories as $c)
				$this->categories->delete_product_category($id, $c->id);

			$options = $this->features->get_options(array('product_id'=>$id));
			foreach($options as $o)
				$this->features->delete_option($id, $o->feature_id);
			
			// Удаляем связанные товары
			$related = $this->get_related_products($id);
			foreach($related as $r)
				$this->delete_related_product($id, $r->related_id);

			// Удаляем товар из связанных с другими
			$query = $this->db->placehold("DELETE FROM __related_products WHERE (related_id=? OR product_id=?)", intval($id), intval($id));
            $this->db->query($query);
			
			// Удаляем связь со статьями если есть
			$this->articles->delete_related_object_type($id, 'product');

			$comments = $this->comments->get_comments(array('object_id'=>$id, 'type'=>'product'));
			foreach($comments as $c)
				$this->comments->delete_comment($c->id);
			
			$this->db->query('UPDATE __purchases SET product_id=NULL WHERE product_id=?', intval($id));
			
			// удаление прикрепленных файлов
			$current_files = $this->files->get_files(array('object_id'=>$id,'type'=>'product'));
			foreach($current_files as $file)
				$this->files->delete_file($file->id);
			// удаление прикрепленных файлов end
			
			$query = $this->db->placehold("DELETE FROM __products WHERE id=? LIMIT 1", intval($id));
			if($this->db->query($query))
				return true;			
		}
		return false;
	}	
	
	/**
	 * Дублирование товара
	 *
     * @param  int $id
     * @return bool|mixed
     */
	public function duplicate_product($id)
	{
    	$product = $this->get_product($id);
    	$product->id = null;
		$product->external_id = '';
    	$product->visible = 0;
    	unset($product->created);

		$product->rating = 0;
		$product->votes = 0;

		// Сдвигаем товары вперед и вставляем копию на соседнюю позицию
    	$this->db->query('UPDATE __products SET position=position+1 WHERE position>?', $product->position);
		$product->name = $product->name.' COPY';
		$product->url = $product->url.'-copy';
    	$new_id = $this->products->add_product($product);
    	$this->db->query('UPDATE __products SET position=? WHERE id=?', $product->position+1, $new_id);

		// Дублируем категории
		$categories = $this->categories->get_product_categories($id);
		foreach($categories as $c)
			$this->categories->add_product_category($new_id, $c->category_id);
    	
    	// Дублируем изображения
    	$images = $this->get_images(array('product_id'=>$id));
    	foreach($images as $image)
    		$this->add_image($new_id, $image->filename, $image->color);
    		
    	// Дублируем варианты	
        $variants = $this->variants->get_variants(array('product_id'=>$id));
    	foreach($variants as $variant)
    	{
    		$variant->product_id = $new_id;
    		unset($variant->id);
    		if($variant->infinity)
    			$variant->stock = null;
    		unset($variant->infinity);
			if($variant->oprice){
                $variant->price=$variant->oprice;
            }
            if($variant->compare_oprice){
                $variant->compare_price=$variant->compare_oprice; 
            }
            unset($variant->oprice); 
            unset($variant->compare_oprice);
			$variant->external_id = '';
    		$this->variants->add_variant($variant);
    	}
    	
    	// Дублируем свойства
		$options = $this->features->get_options(array('product_id'=>$id));
		foreach($options as $o)
			$this->features->update_option($new_id, $o->feature_id, $o->value);
		
		// Дублируем связанные товары	
		$related = $this->get_related_products($id);
		foreach($related as $r)
			$this->add_related_product($new_id, $r->related_id);
			
    	return $new_id;
	}
	
	/**
	 * Выборка связанных товаров
	 *
     * @param  array $product_id
     * @return array|bool
     */
	public function get_related_products($product_id = array())
	{
		if(empty($product_id))
			return array();

		$product_id_filter = $this->db->placehold('AND product_id in(?@)', (array)$product_id);
				
		$query = $this->db->placehold("SELECT product_id, related_id, position
					FROM __related_products
					WHERE 
					1
					$product_id_filter   
					ORDER BY position       
					");
		
		$this->db->query($query);
		return $this->db->results();
	}
	
	/**
     * Функция возвращает связанные товары
     *
     * @param int $product_id
     * @param int $related_id
     * @param int $position
     * @return mixed
     */
	public function add_related_product($product_id, $related_id, $position=0)
	{
		$query = $this->db->placehold("INSERT IGNORE INTO __related_products SET product_id=?, related_id=?, position=?", $product_id, $related_id, $position);
		$this->db->query($query);
		return $related_id;
	}
	
	/**
     * Удаление связанного товара
     *
     * @param int $product_id
     * @param int $related_id
     */
	public function delete_related_product($product_id, $related_id)
	{
		$query = $this->db->placehold("DELETE FROM __related_products WHERE product_id=? AND related_id=? LIMIT 1", intval($product_id), intval($related_id));
		$this->db->query($query);
	}
	
	/**
	 * Выборка изображений товаров
	 *
     * @param  array $filter
     * @return array|bool
     */
	function get_images($filter = array())
	{		
		$product_id_filter = '';
		$group_by = '';

		if(!empty($filter['product_id']))
			$product_id_filter = $this->db->placehold('AND i.product_id in(?@)', (array)$filter['product_id']);

		$query = $this->db->placehold("SELECT * FROM __images AS i WHERE 1 $product_id_filter $group_by ORDER BY i.product_id, i.position");
		$this->db->query($query);
		return $this->db->results();
	}
	
	/**
	 * Добавление изображений товаров
	 *
     * @param  $product_id
     * @param  $filename
     * @return bool|mixed|object|string
     */
	public function add_image($product_id, $filename, $color = '')
	{
		$query = $this->db->placehold("SELECT id FROM __images WHERE product_id=? AND filename=?", $product_id, $filename);
		$this->db->query($query);
		$id = $this->db->result('id');
		if(empty($id))
		{
			$query = $this->db->placehold("INSERT INTO __images SET product_id=?, filename=?, color=?", $product_id, $filename, $color);
			$this->db->query($query);
			$id = $this->db->insert_id();
			$query = $this->db->placehold("UPDATE __images SET position=id WHERE id=?", $id);
			$this->db->query($query);
		}
		return($id);
	}
	
	// Обновление изображений
	public function update_image($id, $image)
	{
		$query = $this->db->placehold("UPDATE __images SET ?% WHERE id=?", $image, $id);
		$this->db->query($query);
		return($id);
	}
	
	// Удаление изображений
	public function delete_image($id)
	{
		$query = $this->db->placehold("SELECT filename FROM __images WHERE id=?", $id);
		$this->db->query($query);
		$filename = $this->db->result('filename');
		$query = $this->db->placehold("DELETE FROM __images WHERE id=? LIMIT 1", $id);
		$this->db->query($query);
		$query = $this->db->placehold("SELECT count(*) as count FROM __images WHERE filename=? LIMIT 1", $filename);
		$this->db->query($query);
		$count = $this->db->result('count');
		if($count == 0)
		{			
			$file = pathinfo($filename, PATHINFO_FILENAME);
			$ext = pathinfo($filename, PATHINFO_EXTENSION);
			
			$rezised_images = glob($this->config->root_dir.$this->config->resized_images_dir.$file.".*x*.".$ext);
			if(is_array($rezised_images))
			foreach (glob($this->config->root_dir.$this->config->resized_images_dir.$file.".*x*.".$ext) as $f)
				@unlink($f);

			@unlink($this->config->root_dir.$this->config->original_images_dir.$filename);		
		}
	}
		
	// Выборка "соседних" товаров
	public function get_next_product($category_id, $position, $filter = array())
	{
		$in_stock_filter = '';
		if(isset($filter['in_stock'])){
			$in_stock_filter = $this->db->placehold('AND (SELECT count(*)>0 FROM __variants pv WHERE pv.product_id=p.id AND pv.price>0 AND (pv.stock IS NULL OR pv.stock>0) LIMIT 1) = ?', intval($filter['in_stock']));
		}
		$query = $this->db->placehold("SELECT id FROM __products p, __products_categories pc
										WHERE pc.product_id=p.id AND p.position>? 
										AND pc.position=(SELECT MIN(pc2.position) FROM __products_categories pc2 WHERE pc.product_id=pc2.product_id)
										AND pc.category_id=? 
										AND p.visible 
										$in_stock_filter 
										ORDER BY p.position limit 1", $position, $category_id);
		$this->db->query($query);
		return $this->get_product((integer)$this->db->result('id'));
	}
	
	public function get_prev_product($category_id, $position, $filter = array())
	{
		$in_stock_filter = '';
		if(isset($filter['in_stock'])){
			$in_stock_filter = $this->db->placehold('AND (SELECT count(*)>0 FROM __variants pv WHERE pv.product_id=p.id AND pv.price>0 AND (pv.stock IS NULL OR pv.stock>0) LIMIT 1) = ?', intval($filter['in_stock']));
		}
		$query = $this->db->placehold("SELECT id FROM __products p, __products_categories pc
										WHERE pc.product_id=p.id AND p.position<? 
										AND pc.position=(SELECT MIN(pc2.position) FROM __products_categories pc2 WHERE pc.product_id=pc2.product_id)
										AND pc.category_id=? 
										AND p.visible 
										$in_stock_filter 
										ORDER BY p.position DESC limit 1", $position, $category_id);
		$this->db->query($query);
		return $this->get_product((integer)$this->db->result('id'));	
	}
	
	// Все категории, в которых есть товары определенного бренда
    public function brands_category($brand_c_id) 
    {
        $query = $this->db->placehold("
            SELECT c.id, c.name, c.url, b.url AS brand
            FROM __categories AS c
            LEFT JOIN __products_categories AS pc
            ON pc.category_id = c.id
            LEFT JOIN __products AS p
            ON p.id = pc.product_id
            LEFT JOIN __brands AS b
            ON b.id = p.brand_id
            WHERE b.id=? 
            AND c.visible = 1
            GROUP BY c.id
            ORDER BY c.name ASC
        ", $brand_c_id); 
        
		if($this->settings->cached == 1 && empty($_SESSION['admin'])){
			if($result = $this->cache->get($query)) {
				$brand_categories = $result; // возвращаем данные из memcached
        		return $brand_categories;
			} else {
				$this->db->query($query); // иначе тянем из БД
				$result = $this->db->results();
				$this->cache->set($query, $result); //помещаем в кеш
				$brand_categories = $result;
        		return $brand_categories;
			}
		} else {
			$this->db->query($query);
        	$brand_categories = $this->db->results();
        	return $brand_categories;
		}
        
    }    
    
    private function translit($text)
	{
		$ru = explode('-', "А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я"); 
		$en = explode('-', "A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch---Y-y---E-e-YU-yu-YA-ya");

	 	$res = str_replace($ru, $en, $text);
		$res = preg_replace("/[\s]+/ui", '-', $res);
		$res = preg_replace('/[^\p{L}\p{Nd}\d-]/ui', '', $res);
	 	$res = strtolower($res);
	    return $res;  
	}
	
}
