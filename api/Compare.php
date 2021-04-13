<?php

require_once('Fivecms.php');

class Compare extends Fivecms
{

	public function get_compare()
	{
		$compare = new stdClass();
		$compare->total = 0;

		// Берем из сессии список сравнений
		if(!empty($_SESSION['compare_cart']))
		{
            $product_ids = $_SESSION['compare_cart'];
            foreach($product_ids as $id)
              $session_items[$id] = $id;

			if($_products = $this->products->get_products(array('id'=>array_keys($session_items))))
			{
                foreach($_products as $p){
                	$products[$p->id] = $p;
                	$variants[$p->id] = array();
                }

                $products_ids = array_keys($products);

                $vrs = $this->variants->get_variants(array('product_id'=>$products_ids, 'in_stock'=>true));

                foreach($vrs as &$variant)
                {
                	$variants[$variant->product_id][] = $variant;
                }

				foreach($_products as $p)
				{
					$images = $this->products->get_images(array('product_id'=>$p->id));
					if(isset($images[0]))
						$products[$p->id]->image = $images[0]->filename;
				}

                $feature = array();
                $prt = $this->features->get_product_options($products_ids);
                
                if($prt){
					foreach($prt as $p)
					  $ftr[$p->name]['items'][$p->product_id] = $p->value;

					foreach($ftr as $k => $v){
						foreach($products as $p){
							if(!empty($v['items'][$p->id])){
								$feature[$k]['items'][$p->id] = $v['items'][$p->id];
							} else {
								$feature[$k]['items'][$p->id] = ' - ';
							}
						}
					}

					foreach($feature as $key => $value){
						$feature[$key] = $value;
						if(count(array_unique($value['items']))>1)$feature[$key]['diff'] = '1';
					}
                }

				$compare->products = $products;
				$compare->variants = $variants;
                $compare->features = $feature;

				$compare->total = count($products);
			}
		}

		return $compare;
	}


	public function get_compare_informer()
	{
		$compare = new stdClass();
		$compare->total = 0;

		// Берем из сессии список сравнений
		if(!empty($_SESSION['compare_cart']))
		{
			$compare->items_id = $_SESSION['compare_cart'];
			$compare->total = count($compare->items_id);
        }

    	return $compare;
    }

	public function add_item($compare_id)
	{
		// Выберем товар из базы, заодно убедившись в его существовании
		$product = $this->products->get_product($compare_id);

    	// Если товар существует, добавим его в сравнение
		if(!empty($product)){
			// Не даем добавить более 14 товаров в сравнение
			if(!empty($_SESSION['compare_cart']) && count($_SESSION['compare_cart'])>14){
            	return false;
        	}
        	// товар существует, добавим его в сравнение
        	$_SESSION['compare_cart'][$product->id] = $product->id;
    	}

    	return false;
	}

	public function delete_item($compare_id){
		unset($_SESSION['compare_cart'][$compare_id]);
	}

	public function clear_item($clear_id){
		unset($_SESSION['compare_cart']);
	}

}
