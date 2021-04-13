<?php
	require_once('../../api/Fivecms.php');
	$fivecms = new Fivecms();
	$limit = 200;
	
	$keyword = $fivecms->request->get('query', 'string');
	
	$kw = $fivecms->db->escape($keyword);
	                    
	$fivecms->db->query("SELECT p.id, p.name, i.filename as image FROM __articles p
						LEFT JOIN __images_article i ON i.post_id=p.id AND i.position=(SELECT MIN(position) FROM __images_article WHERE post_id=p.id LIMIT 1)
	                    WHERE (p.name LIKE '%$kw%' OR p.meta_keywords LIKE '%$kw%' OR p.id LIKE '%$kw%') AND p.visible=1 GROUP BY p.id ORDER BY p.name LIMIT ?", $limit);	                    
	                    
	$products = $fivecms->db->results();

	$suggestions = array();
	foreach($products as $product)
	{
		if(!empty($product->image))
			$product->image = $fivecms->design->resize_modifier($product->image, 100, 100, false, $fivecms->config->resized_articles_images_dir);
			
		$suggestion = new stdClass();
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
