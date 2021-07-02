<?PHP 

require_once('api/Fivecms.php');

class ProductsAdmin extends Fivecms
{
	function fetch()
	{		
		$filter = array();
		$filter['page'] = max(1, $this->request->get('page', 'integer'));
			
		$filter['limit'] = $this->settings->products_num_admin;
	
		// Категории
		$categories = $this->categories->get_categories_tree();
		$this->design->assign('categories', $categories);
		
		// Текущая категория
		$category_id = $this->request->get('category_id', 'integer'); 
	  	if($category_id && $category = $this->categories->get_category($category_id)) {
            $filter['category_id'] = $category->children;
        } elseif ($category_id==-1) {
            $filter['without_category'] = 1;
        }
        $this->design->assign('category_id', $category_id);	
		      
		// Бренды категории
		if(isset($filter['category_id']))
			$brands = $this->brands->get_brands(array('category_id'=>$filter['category_id']));
		else
			$brands = $this->brands->get_brands();
		$this->design->assign('brands', $brands);
		
		
		// Все бренды
		$all_brands = $this->brands->get_brands();
		$this->design->assign('all_brands', $all_brands);
		
		// Текущий бренд
		$brand_id = $this->request->get('brand_id', 'integer'); 		
		if($brand_id && $brand = $this->brands->get_brand($brand_id)) {
            $filter['brand_id'] = $brand->id;
        } elseif ($brand_id==-1) {
            $filter['brand_id'] = array(0);
        }
        $this->design->assign('brand_id', $brand_id);
		
		// Текущий фильтр
		if($f = $this->request->get('filter', 'string'))
		{
			if($f == 'featured')
				$filter['featured'] = 1; 
			elseif($f == 'is_new')
				$filter['is_new'] = 1;
			elseif($f == 'to_yandex')
				$filter['to_yandex'] = 1;
            elseif($f == 'on_request')
                $filter['on_request'] = 1;
            elseif($f == 'out_of')
                $filter['out_of'] = 1;
			elseif($f == 'discounted')
				$filter['discounted'] = 1; 
			elseif($f == 'visible')
				$filter['visible'] = 1; 
			elseif($f == 'hidden')
				$filter['visible'] = 0; 
			elseif($f == 'outofstock')
				$filter['in_stock'] = 0;
            elseif($f == 'video')
                $filter['video'] = 1;
            elseif($f == 'not_video')
                $filter['video'] = 0;
            elseif($f == 'brands') {
                $brand_ids = [];
                foreach ($this->brands->get_brands() as $brand) {
                    $brand_ids[] = $brand->id;
                }
                $filter['brand_id'] = $brand_ids;
            }
            elseif($f == 'not_brands')
                $filter['brand_id'] = [0];
            $this->design->assign('filter', $f);
		}
		
		if($srt = $this->request->get('sort')){
			$filter['sort'] = $this->request->get('sort');
			$this->design->assign('sort', $srt);
		}
		
		/* фильтр цены */
		$pmm = $this->products->count_products($filter, 'all');

		$pmm->minCost = floor($this->money->noFormat($pmm->minCost,'no_precision'));
		$pmm->maxCost = ceil($this->money->noFormat($pmm->maxCost,'no_precision'));

		$this->design->assign('minCost', (int)$pmm->minCost);
		$this->design->assign('maxCost', (int)$pmm->maxCost);

		$minCurr = (int)$this->request->get('minCurr');
		if (empty($minCurr)) $minCurr=(int)$pmm->minCost;
		if (true || !empty($minCurr))
		{
			$this->design->assign('minCurr', $minCurr);
			$filter['minCurr'] = $minCurr;
		}

		$maxCurr = (int)$this->request->get('maxCurr');
		if (empty($maxCurr)) $maxCurr=(int)$pmm->maxCost;
		if ($maxCurr < $pmm->minCost) $maxCurr=ceil($pmm->minCost);
		if (true || !empty($maxCurr))
		{
			$this->design->assign('maxCurr', $maxCurr);
			$filter['maxCurr'] = $maxCurr;
		}

		$filter['minCurr'] = $this->money->noFormat($filter['minCurr'],'deconvert');
		$filter['maxCurr'] = $this->money->noFormat($filter['maxCurr'],'deconvert');
		/* фильтр цены @ */
		
		// Поиск
		$keyword = $this->request->get('keyword');
		if(!empty($keyword))
		{
	  		$filter['keyword'] = $keyword;
			$this->design->assign('keyword', $keyword);
		}
			
		// Обработка действий 	
		if($this->request->method('post'))
		{
			// Сохранение цен и наличия
			$prices = $this->request->post('price');
			$stocks = $this->request->post('stock');
			
			if(!empty($prices) && !empty($stocks)) {
                foreach ($prices as $id=>$price) {
                    $stock = $stocks[$id];
                    if ($stock == '∞' || $stock == '') {
                        $stock = null;
                    }
                    $this->variants->update_variant($id, array('price'=>$price, 'stock'=>$stock));
                }
            }
		
			// Сортировка
			$positions = $this->request->post('positions'); 		
				$ids = array_keys($positions);
			sort($positions);
			$positions = array_reverse($positions);
			foreach($positions as $i=>$position)
				$this->products->update_product($ids[$i], array('position'=>$position)); 
		
			
			// Действия с выбранными
			$ids = $this->request->post('check');
			if(!empty($ids))
			switch($this->request->post('action'))
			{
			    case 'disable':
			    {
			    	$this->products->update_product($ids, array('visible'=>0));
					break;
			    }
			    case 'enable':
			    {
			    	$this->products->update_product($ids, array('visible'=>1));
			        break;
			    }
			    case 'set_featured':
			    {
			    	$this->products->update_product($ids, array('featured'=>1));
					break;
			    }
			    case 'unset_featured':
			    {
			    	$this->products->update_product($ids, array('featured'=>0));
					break;
			    }
				case 'set_is_new':
			    {
			    	$this->products->update_product($ids, array('is_new'=>1));
					break;
			    }
				case 'unset_is_new':
			    {
			    	$this->products->update_product($ids, array('is_new'=>0));
					break;
			    }
				case 'set_yandex':
				{
			    	$this->products->update_product($ids, array('to_yandex'=>1));
			    	break;
				}
				case 'unset_yandex':
				{
			    	$this->products->update_product($ids, array('to_yandex'=>0));
			    	break;
				}
			    case 'delete':
			    {
				    foreach($ids as $id)
						$this->products->delete_product($id);    
			        break;
			    }
			    case 'duplicate':
			    {
				    foreach($ids as $id)
				    	$this->products->duplicate_product(intval($id));
			        break;
			    }
			    case 'move_to_page':
			    {
			    	$target_page = $this->request->post('target_page', 'integer');
			    	
			    	// Сразу потом откроем эту страницу
			    	$filter['page'] = $target_page;
		
				    // До какого товара перемещать
				    $limit = $filter['limit']*($target_page-1);
				    if($target_page > $this->request->get('page', 'integer'))
				    	$limit += count($ids)-1;
				    else
				    	$ids = array_reverse($ids, true);
		
					$temp_filter = $filter;
					$temp_filter['page'] = $limit+1;
					$temp_filter['limit'] = 1;
					$target_product = array_pop($this->products->get_products($temp_filter));
					$target_position = $target_product->position;
				   	
				   	// Если вылезли за последний товар - берем позицию последнего товара в качестве цели перемещения
					if($target_page > $this->request->get('page', 'integer') && !$target_position)
					{
				    	$query = $this->db->placehold("SELECT distinct p.position AS target FROM __products p LEFT JOIN __products_categories AS pc ON pc.product_id = p.id WHERE 1 $category_id_filter $brand_id_filter ORDER BY p.position DESC LIMIT 1", count($ids));	
				   		$this->db->query($query);
				   		$target_position = $this->db->result('target');
					}
				   	
			    	foreach($ids as $id)
			    	{		    	
				    	$query = $this->db->placehold("SELECT position FROM __products WHERE id=? LIMIT 1", $id);	
				    	$this->db->query($query);	      
				    	$initial_position = $this->db->result('position');
		
				    	if($target_position > $initial_position)
				    		$query = $this->db->placehold("	UPDATE __products set position=position-1 WHERE position>? AND position<=?", $initial_position, $target_position);	
				    	else
				    		$query = $this->db->placehold("	UPDATE __products set position=position+1 WHERE position<? AND position>=?", $initial_position, $target_position);	
				    		
			    		$this->db->query($query);	      			    	
			    		$query = $this->db->placehold("UPDATE __products SET __products.position = ? WHERE __products.id = ?", $target_position, $id);	
			    		$this->db->query($query);	
				    }
			        break;
				}
			    case 'move_to_category':
			    {
			    	$category_id = $this->request->post('target_category', 'integer');
			    	$filter['page'] = 1;
					$category = $this->categories->get_category($category_id);
	  				$filter['category_id'] = $category->children;
	  				
	  				// Добавляем свойства товара к категории
	  				if(isset($ids))
					{
						$pc = array();
						foreach($this->categories->get_product_categories($ids) as $c)
						{
							$pc[$c->category_id] = $c;
						}
	
						if(!empty($pc))
						{
							foreach($this->features->get_features(array('category_id'=>array_keys($pc))) as $f)
							{
								$this->features->add_feature_category($f->id, $category_id);
							}
						}
					}
			    	
			    	foreach($ids as $id)
			    	{
			    		$query = $this->db->placehold("DELETE FROM __products_categories WHERE category_id=? AND product_id=? LIMIT 1", $category_id, $id);	
			    		$this->db->query($query);	      			    	
			    		$query = $this->db->placehold("UPDATE IGNORE __products_categories set category_id=? WHERE product_id=? ORDER BY position DESC LIMIT 1", $category_id, $id);	
			    		$this->db->query($query);
			    		if($this->db->affected_rows() == 0)
							$query = $this->db->query("INSERT IGNORE INTO __products_categories set category_id=?, product_id=?", $category_id, $id);	

				    }
			        break;
				}
				case 'add_to_category':
                {
                    $category_id = $this->request->post('target_category', 'integer');
                    //$filter['page'] = 1;
                    
                    foreach ($ids as $id) {
                        $this->db->query("INSERT IGNORE INTO __products_categories (category_id, product_id, position)
                                SELECT ?, ?, IFNULL(MAX(position), -1)+1
                                FROM __products_categories  
                                WHERE product_id = ?", $category_id, $id, $id);
                	}
                    break;
                }
                case 'del_from_category':
                {
                    $category_id = $this->request->post('target_category', 'integer');
                    $filter['page'] = 1;
                    $category = $this->categories->get_category($category_id);
                    $filter['category_id'] = $category->children;

                    foreach($ids as $id)
                    {
                        $query = $this->db->placehold('DELETE FROM __products_categories WHERE product_id=? AND category_id=?', $id, $category_id);
                        $this->db->query($query);

                    }
                    break;
                }
			    case 'move_to_brand':
			    {
			    	$brand_id = $this->request->post('target_brand', 'integer');
			    	$brand = $this->brands->get_brand($brand_id);
			    	$filter['page'] = 1;
	  				$filter['brand_id'] = $brand_id;
			    	$query = $this->db->placehold("UPDATE __products set brand_id=? WHERE id in (?@)", $brand_id, $ids);	
			    	$this->db->query($query);	

					// Заново выберем бренды категории
					$brands = $this->brands->get_brands(array('category_id'=>$category_id));
					$this->design->assign('brands', $brands);
			    	      			    	
			        break;
				}
                // Увеличиваем цену товара
                case 'up_price':
                {
                    $percent = $this->request->post('percent_price', 'integer');
                    $type_recalc = $this->request->post('type_recalc');

                    if ($percent) {
                        // Сначала делаем типа-бэкап, записываем текущую цену в отдельно созданное для этого поле
                        $query = $this->db->placehold("UPDATE __variants SET old_price = price WHERE product_id in (?@)", $ids);
                        $this->db->query($query);
                        // Потом обновляем цену (если она есть и больше нуля) на величину нашего процента или рубля
                        if ($type_recalc == 'percent')
                            $query = $this->db->placehold("UPDATE __variants SET price = CEILING( (price+(price*?/100)) / 10 ) * 10 WHERE price>0 AND product_id in (?@)", intval($percent), $ids);
                        elseif ($type_recalc == 'rub')
                            $query = $this->db->placehold("UPDATE __variants SET price = price+? WHERE price>0 AND product_id in (?@)", intval($percent), $ids);
                        else break;
                        $this->db->query($query);
                    }

                    // После выполнения действия, если нам известен REQUEST_URI, то делаем перенаправление на эту страницу
                    // Это позволит избежать случайного повторения POST при обновлении страницы!
                    if (isset($_SERVER['REQUEST_URI'])) {
                        header('Location: '.$_SERVER['REQUEST_URI']);
                        exit;
                    }

                    break;
                }
                // Уменьшаем цену товара
                case 'down_price':
                {
                    $percent = $this->request->post('percent_price', 'integer');
                    $type_recalc = $this->request->post('type_recalc');

                    if ($percent) {
                        // Сначала делаем типа-бэкап, записываем текущую цену в отдельно созданное для этого поле
                        $query = $this->db->placehold("UPDATE __variants SET old_price = price WHERE product_id in (?@)", $ids);
                        $this->db->query($query);
                        // Потом обновляем цену (если она есть и больше нуля) на величину нашего процента
                        if ($type_recalc == 'percent')
                            $query = $this->db->placehold("UPDATE __variants SET price = CEILING( (price-(price*?/100)) / 10 ) * 10 WHERE price>0 AND product_id in (?@)", intval($percent), $ids);
                        elseif ($type_recalc == 'rub')
                            $query = $this->db->placehold("UPDATE __variants SET price = price-? WHERE price>0 AND product_id in (?@)", intval($percent), $ids);
                        else break;
                        $this->db->query($query);
                    }

                    // После выполнения действия, если нам известен REQUEST_URI, то делаем перенаправление на эту страницу
                    // Это позволит избежать случайного повторения POST при обновлении страницы!
                    if (isset($_SERVER['REQUEST_URI'])) {
                        header('Location: '.$_SERVER['REQUEST_URI']);
                        exit;
                    }

                    break;
                }
                // Откат цены
                case 'retrieve_price':
                {
                    // Сначала делаем типа-бэкап, записываем текущую цену в отдельно созданное для этого поле
                    $query = $this->db->placehold("UPDATE __variants SET price = old_price WHERE old_price is not null AND product_id in (?@)", $ids);
                    $this->db->query($query);

                    // После выполнения действия, если нам известен REQUEST_URI, то делаем перенаправление на эту страницу
                    // Это позволит избежать случайного повторения POST при обновлении страницы!
                    if (isset($_SERVER['REQUEST_URI'])) {
                        header('Location: '.$_SERVER['REQUEST_URI']);
                        exit;
                    }

                    break;
                }
            }
		}

		// Отображение
		if(isset($brand))
			$this->design->assign('brand', $brand);
		if(isset($category))
			$this->design->assign('category', $category);
		
	  	$products_count = $this->products->count_products($filter);
	  	
		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$filter['limit'] = $products_count;	
	  	
		if($filter['limit']>0)	 
	  	$pages_count = ceil($products_count/$filter['limit']);
		else
		  	$pages_count = 0;
		
	  	$filter['page'] = min($filter['page'], $pages_count);
	 	$this->design->assign('products_count', $products_count);
	 	$this->design->assign('pages_count', $pages_count);
	 	$this->design->assign('current_page', $filter['page']);

		$products = array();
		foreach($this->products->get_products($filter) as $p)
			$products[$p->id] = $p;

		if(!empty($products))
		{
			// Товары 
			$products_ids = array_keys($products);
			foreach($products as &$product)
			{
				$product->variants = array();
				$product->images = array();
				$product->properties = array();
			}
		
			$variants = $this->variants->get_variants(array('product_id'=>$products_ids), 1);
		
			foreach($products as &$product){
				$get_categories = $this->categories->get_categories(array('product_id'=>$product->id));
				$product->category = reset($get_categories);
			}
		 
			foreach($variants as &$variant)
			{
				$products[$variant->product_id]->variants[] = $variant;
			}
		
			$images = $this->products->get_images(array('product_id'=>$products_ids));
			foreach($images as $image)
				$products[$image->product_id]->images[$image->id] = $image;

			// Проверка загрузки всех изображений из интернета
			if(!empty($this->settings->check_download)){
				foreach($images as $url){
					if(!empty($url->filename) && (substr($url->filename,0,7) == 'http://' || substr($url->filename,0,8) == 'https://')){
						$new_name=$this->image->download_image($url->filename);
					}
				}
				$images = $this->products->get_images(array('product_id'=>$products_ids));
				foreach($images as $image)
					$products[$image->product_id]->images[$image->id] = $image;
			}	
			//	Проверка загрузки всех изображений из интернета @			
		}
	 
		$this->design->assign('products', $products);
		
		// Multicurrency
		// Все валюты
		$this->design->assign('currencies', $this->money->get_currencies(array('enabled'=>1)));
		// Multicurrency end
	
		return $this->design->fetch('products.tpl');
	}
}
