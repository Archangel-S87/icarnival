<?php
	require_once('../../api/Fivecms.php');
	$fivecms = new Fivecms();
	$limit = 200;
	
	$keyword = $fivecms->request->get('keyword', 'string');
	if($fivecms->request->get('limit', 'integer'))
		$limit = $fivecms->request->get('limit', 'integer');
	
	$orders = array_values($fivecms->orders->get_orders(array('keyword'=>$keyword, 'limit'=>$limit)));
	

	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");		
	print json_encode($orders);
