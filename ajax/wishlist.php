<?php
    chdir('..');
    require_once('api/Fivecms.php');
    $fivecms = new Fivecms();
    
    $limit = 150;
    
    $id = $fivecms->request->get('id', 'integer');
    
    if(!empty($_COOKIE['wished_products'])) {
        $products_ids = explode(',', $_COOKIE['wished_products']);
        $products_ids = array_reverse($products_ids);
    }
    else
        $products_ids = array();
        
    if($fivecms->request->get('action', 'string') == 'delete') {
        $key = array_search($id, $products_ids);
        unset($products_ids[$key]);    
    }   
    else {
        array_push($products_ids, $id);
        $products_ids = array_unique($products_ids);        
    }

    $products_ids = array_slice($products_ids, 0, $limit);
    $products_ids = array_reverse($products_ids);
    
    if(!count($products_ids)) {
        unset($_COOKIE['wished_products']);
        setcookie('wished_products', '', time()-365*24*3600, '/');
    }
    else
        setcookie('wished_products', implode(',', $products_ids), time()+365*24*3600, '/');        

    $fivecms->design->assign('wished_products', $products_ids);
    
    header("Content-type: text/html; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");        
    print $fivecms->design->fetch('wishlist_informer.tpl');
