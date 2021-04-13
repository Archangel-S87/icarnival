<?php
	session_start();
	require_once('../../api/Fivecms.php');
	$fivecms = new Fivecms();
	$limit = 300;
	
	if(!$fivecms->managers->access('orders'))
		return false;
	
	$keyword = $fivecms->request->get('query', 'string');
	
	$kw = $fivecms->db->escape($keyword);
	
	$fivecms->db->query("SELECT p.id, p.name, i.filename as image FROM __products p
	                    LEFT JOIN __images i ON i.product_id=p.id AND i.position=(SELECT MIN(position) FROM __images WHERE product_id=p.id LIMIT 1)
	                    WHERE (p.name LIKE '%$kw%' OR p.meta_keywords LIKE '%$kw%' OR p.id LIKE '%$kw%' OR p.id in (SELECT product_id FROM __variants WHERE sku LIKE '%$kw%')) AND visible=1 GROUP BY p.id ORDER BY p.name LIMIT ?", $limit);
	foreach($fivecms->db->results() as $product)
		$products[$product->id] = $product;	
	
	$variants = array();
	if(!empty($products))
	{
		$fivecms->db->query('SELECT v.id, v.name, v.price, v.discount, v.discount_date, IFNULL(v.stock, ?) as stock, v.currency_id, v.unit, (v.stock IS NULL) as infinity, v.product_id FROM __variants v WHERE v.product_id in(?@) AND (v.stock IS NULL OR v.stock>0) AND v.price>0 ORDER BY v.position', $fivecms->settings->max_order_amount, array_keys($products));
		$variants = $fivecms->db->results();
	}
			
	/* Multicurrency */
	$currencies = $fivecms->money->get_currencies();
	foreach($variants as &$variant){
		if(isset($products[$variant->product_id])){
		
			// Скидка в варианте товара
			if($fivecms->settings->variant_discount && $variant->discount > 0){
				if( (!empty($variant->discount_date) && strtotime($variant->discount_date) > time()) || empty($variant->discount_date) ){
					$variant->compare_price = $variant->price;
					$variant->price = $variant->price*(100-$variant->discount)/100;
				}
			}
			// Скидка в варианте товара @
		
			$variant->oprice = $variant->price;
			if(isset($variant->compare_price))
            	$variant->compare_oprice = $variant->compare_price;
            //делаем пересчет в базовый курс
            if($variant->currency_id > 0) {
                $variant->price = $variant->price * $currencies[$variant->currency_id]->rate_to / $currencies[$variant->currency_id]->rate_from;
                if(isset($variant->compare_price)){
                	$variant->compare_price = $variant->compare_price * $currencies[$variant->currency_id]->rate_to / $currencies[$variant->currency_id]->rate_from;
                }
            }
			$products[$variant->product_id]->variants[] = $variant;
		}
	}
	/* Multicurrency end */		
	
	$suggestions = array();
	foreach($products as $product)
	{
		if(!empty($product->variants))
		{
			$suggestion = new stdClass;
			if(!empty($product->image))
				$product->image = $fivecms->design->resize_modifier($product->image, 100, 100);
			$suggestion->value = $product->name;		
			$suggestion->data = $product;		
			$suggestions[] = $suggestion;
		}
	}

	$res = new stdClass;
	$res->query = $keyword;
	$res->suggestions = $suggestions;
	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");		
	
	print json_encode($res);
