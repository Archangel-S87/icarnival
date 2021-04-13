<?php
	session_start();
	require_once('../api/Fivecms.php');
	$fivecms = new Fivecms();
	
	$variant = $fivecms->request->get('variant', 'integer');
    $amount = $fivecms->request->get('amount', 'integer');
	$amount = empty($amount)?1:$amount;
    
    // user, currency, settings
	$fivecms->currencies = $fivecms->money->get_currencies(array('enabled'=>1));
	if($currency_id = $fivecms->request->get('currency_id', 'integer'))
	{
		$_SESSION['currency_id'] = $currency_id;
		header("Location: ".$fivecms->request->url(array('currency_id'=>null)));
	}
	if(isset($_SESSION['currency_id']))
		$fivecms->currency = $fivecms->money->get_currency($_SESSION['currency_id']);
	else
		$fivecms->currency = reset($fivecms->currencies);
	
	if(isset($_SESSION['user_id']))
	{
		$u = $fivecms->users->get_user(intval($_SESSION['user_id']));
		if($u && $u->enabled)
		{
			$fivecms->user = $u;
			$fivecms->group = $fivecms->users->get_group($fivecms->user->group_id);
		}
	}
	$fivecms->design->assign('currencies',	$fivecms->currencies);
	$fivecms->design->assign('currency',	$fivecms->currency);
	$fivecms->design->assign('user',       $fivecms->user);
	$fivecms->design->assign('group',      $fivecms->group);
	$fivecms->design->assign('settings',	$fivecms->settings);
    // user, currency, settings end
    
    if($fivecms->request->get('mode', 'string')=='remove'){
		$fivecms->cart->delete_item($variant);
		header("Location: " . $_SERVER["PHP_SELF"]);
	} else {
		$fivecms->cart->add_item($variant, $amount);
		$cart = $fivecms->cart->get_cart();	
		$fivecms->design->assign('cart', $cart);
	}
	
	$result = $fivecms->design->fetch('cart_informer.tpl');
	
	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");		
	print json_encode($result);
