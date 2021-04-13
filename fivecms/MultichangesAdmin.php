<?PHP
require_once('api/Fivecms.php');

class MultichangesAdmin extends Fivecms
{	
	public function fetch()
	{
		if($this->request->method('post') && ($this->request->post("sent")))
		{
			$category_id = (int)$this->request->post("category_id");
			$brand_id = (int)$this->request->post("brand_id");
			$percent = (float)$this->request->post("percent");
			$round = $this->request->post("round");
			$old_price_mode = $this->request->post("old_price_mode");
			$allow_children = $this->request->post("allow_children");
			$discount = $this->request->post("discount");
			$stock_case = $this->request->post("stock_case");
			$change_stock = $this->request->post("change_stock");
			$stock = $this->request->post("stock");
			
			// Формируем набор параметров для выборки из БД
			$w=array();
			
			// Выборка из товаров
			// По бренду
			if($brand_id>0)
				$w[]=$this->db->placehold("product_id IN (SELECT id FROM __products WHERE brand_id=? )", $brand_id);
			
			// По категории	
			// Применять ли к вложенным категориям	
			if($allow_children == 1){
				if($category_id>0)
					$w[]=$this->db->placehold("product_id IN (SELECT distinct product_id FROM __products_categories WHERE category_id=? )", $category_id);
			} else {	
				$category_children = array();
				if(!empty($category_id))
				{
					$category = $this->categories->get_category((int)$category_id);
					if(isset($category))
						$category_children = $category->children;
				}	
				if(!empty($category_children)){
					$w[]=$this->db->placehold("product_id IN (SELECT distinct product_id FROM __products_categories WHERE category_id in(?@) )", (array)$category_children);
				}
			}
			// Выборка по из товаров @
			
			// Выборка из вариантов товаров
			// По остатку
			if(!empty($stock_case)){
				if($stock_case == 1)
					$w[]=$this->db->placehold("stock=0");
				elseif($stock_case == 2)
					$w[]=$this->db->placehold("stock IS NULL");
				elseif($stock_case == 3)
					$w[]=$this->db->placehold("stock<0");
				elseif($stock_case == 4)
					$w[]=$this->db->placehold("stock>0");	
			}
			// Выборка из вариантов товаров @
			
			if($w)
				$w="WHERE ". join(' AND ', $w);
			else
				$w='';
			
			// Формируем набор параметров для выборки из БД @
			
			// Изменение цены и старой цены
			if(!empty($percent)){
				$q="UPDATE __variants SET price=price*(1+$percent/100) ".$w;
				$o="UPDATE __variants SET compare_price=compare_price*(1+$percent/100) ".$w;
			
				if($round!='none' || $round!='cel'){
					if($round>2) $round=2;
					if($round<-3) $round=-3;
					$q="UPDATE __variants SET price=round(price*(1+$percent/100),$round) ".$w;
					$o="UPDATE __variants SET compare_price=round(compare_price*(1+$percent/100),$round) ".$w;
				}
			
				if($round=='cel'){
					$q="UPDATE __variants SET price=round(price*(1+$percent/100)) ".$w;
					$o="UPDATE __variants SET compare_price=round(compare_price*(1+$percent/100)) ".$w;
				}

				if($round=='none'){
					$q="UPDATE __variants SET price=price*(1+$percent/100) ".$w;
					$o="UPDATE __variants SET compare_price=compare_price*(1+$percent/100) ".$w;
				}
				
				if($old_price_mode != 1){
					if($old_price_mode == 2)
						$o="UPDATE __variants SET compare_price=price ".$w;
					elseif($old_price_mode == 3)
						$o="UPDATE __variants SET compare_price=0 ".$w;
				}
			
				$o = $this->db->placehold($o, $brand_id);
				$this->db->query($o);
			
				$q = $this->db->placehold($q, $brand_id);
				$this->db->query($q);
			}
			// Изменение цены и старой цены @	
			
			// Изменение скидкм в варианте товара
			if(isset($discount)){
				if(is_numeric($discount)){
					$d="UPDATE __variants SET discount=$discount ".$w;
					$d = $this->db->placehold($d);
					$this->db->query($d);
					// До какой даты скидка
					if(!empty($this->request->post('discount_date'))) {
						$discount_date = date('Y-m-d H:i', strtotime($this->request->post('discount_date')));
						$dd="UPDATE __variants SET discount_date='".$discount_date."' ".$w;
					} else {
						$dd="UPDATE __variants SET discount_date=null ".$w;	
					}
					$dd = $this->db->placehold($dd);
					$this->db->query($dd);
					
				} elseif(!empty($discount)) {
					$this->design->assign('message_error',  'non_numeric');
				}
			}
			// Изменение скидки в варианте товара @
			
			// Изменение остатка варианта товара
			if(!empty($change_stock) && isset($stock)){
				if(is_numeric($stock)){
					$stock = (int)$stock;
					if(is_int($stock)){
						$s="UPDATE __variants SET stock=$stock ".$w;
						$s = $this->db->placehold($s);
						$this->db->query($s);
					} else {
						$this->design->assign('message_error',  'non_integer');
					}
				} elseif($stock == 'null') {
					$s="UPDATE __variants SET stock=null ".$w;
					$s = $this->db->placehold($s);
					$this->db->query($s);
				}
			}
			// Изменение остатка варианта товара @
			
			$this->design->assign('message_success',  'Выполнено');
		}

		if(isset($brand_id))
			$this->design->assign('brand_id', $brand_id);
		if(isset($category_id))	
			$this->design->assign('category_id', $category_id);
		if(isset($percent))		
			$this->design->assign('percent', $percent);
		if(isset($round))			
			$this->design->assign('round', $round);
		if(isset($old_price_mode))			
			$this->design->assign('old_price_mode', $old_price_mode);
		if(isset($allow_children))		
			$this->design->assign('allow_children', $allow_children);
		if(isset($discount))		
			$this->design->assign('discount', $discount);
		if(isset($discount_date))		
			$this->design->assign('discount_date', $discount_date);
		if(isset($stock_case))		
			$this->design->assign('stock_case', $stock_case);
		if(isset($change_stock))			
			$this->design->assign('change_stock', $change_stock);
		if(isset($stock))		
			$this->design->assign('stock', $stock);

		$categories = $this->categories->get_categories_tree();
		$this->design->assign('categories', $categories);

		$brands = $this->brands->get_brands();
		$this->design->assign('brands', $brands);
		
		return $this->design->fetch('multichanges.tpl');
	}
	
}
