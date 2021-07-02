<?php
	require_once('../api/Fivecms.php');
	$fivecms = new Fivecms();
	$limit = 100;
	
	$keyword = $fivecms->request->get('query', 'string');
	
	$kw = $fivecms->db->escape($keyword);
	
	// Без учета остатка на складе
	/*$fivecms->db->query("SELECT p.id, p.name, i.filename as image FROM __products p
	                    LEFT JOIN __images i ON i.product_id=p.id AND i.position=(SELECT MIN(position) FROM __images WHERE product_id=p.id LIMIT 1)
	                    WHERE (p.name LIKE '%$kw%' OR p.meta_keywords LIKE '%$kw%' OR p.id LIKE '%$kw%' OR p.id in (SELECT product_id FROM __variants WHERE sku LIKE '%$kw%')) AND p.visible=1 GROUP BY p.id ORDER BY p.name LIMIT ?", $limit);*/
	                    
	// Вывод только товаров в наличии
	$fivecms->db->query("SELECT p.id, p.name, i.filename as image FROM __products p 
						JOIN __variants v ON v.product_id=p.id
	                    LEFT JOIN __images i ON i.product_id=p.id AND i.position=(SELECT MIN(position) FROM __images WHERE product_id=p.id LIMIT 1)
	                    WHERE (p.name LIKE '%$kw%' OR p.meta_keywords LIKE '%$kw%' OR p.id LIKE '%$kw%' OR v.sku LIKE '%$kw%') AND p.visible=1 AND (v.stock>0 OR v.stock is NULL) GROUP BY p.id ORDER BY p.name LIMIT ?", $limit);                    

	$products = $fivecms->db->results();

	$suggestions = array();
	
	foreach($products as $product)
	{
		$suggestion = new stdClass();
		if(!empty($product->image))
			$product->image = $fivecms->design->resize_modifier($product->image, 100, 100);
			
		$suggestion->value = $product->name;
		$suggestion->data = $product;
		$suggestions[] = $suggestion;
	}
	$res = new stdClass;
	$res->query = $keyword;
	$res->suggestions = $suggestions;
	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");		
	print json_encode($res);
