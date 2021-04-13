<?php

	session_start();
	chdir('..');
	require_once('api/Fivecms.php');
	$fivecms = new Fivecms();
	
	if(!empty($fivecms->request->get('compare', 'integer'))){
		// Не даем добавить более 14 товаров в сравнение
		if(!empty($_SESSION['compare_cart']) && count($_SESSION['compare_cart'])>14){
			return false;
		}
		$product_id = $fivecms->request->get('compare', 'integer');
		$_SESSION['compare_cart'][$product_id] = $product_id;
    
    } elseif (!empty($fivecms->request->get('remove', 'integer'))){
    	$product_id = $fivecms->request->get('remove', 'integer');
    	$fivecms->compare->delete_item($product_id);
	}
	
	$compare = $fivecms->compare->get_compare_informer();
	$fivecms->design->assign('compare_informer', $compare);

	$result = $fivecms->design->fetch('comparemain_informer.tpl');
	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");
    print json_encode($result);
