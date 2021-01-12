<?php
session_start();
chdir('..');
require_once('api/Fivecms.php');
$fivecms = new Fivecms();
	
$variant_id = $fivecms->request->get('variant', 'integer');
$amount = $fivecms->request->get('amount', 'integer');
$amount = empty($amount)?1:$amount;

$order = new StdClass;
$order->name = $fivecms->request->get('name');
$order->email = $fivecms->request->get('email');
$order->phone = $fivecms->request->get('phone');

// Система скидок
// получаем стоимость товаров
if(!empty($variant_id)){
	$variant = $fivecms->variants->get_variant($variant_id);
	$cart_total_price = $variant->price*$amount;
}

// сохраним структуру из api/Cart.php, заменив this на fivecms и cart-> на cart_
if($fivecms->design->is_android_browser() && !empty($fivecms->settings->mob_discount)) {                      
    $mob_discount = $fivecms->settings->mob_discount;     
} else {$mob_discount = 0;}
                
$enable_discountgroup = $fivecms->discountgroup->get_config_discount('enable_groupdiscount');
switch ($enable_discountgroup){
	case 1:
        if(isset($_SESSION['user_id']) && $user = $fivecms->users->get_user(intval($_SESSION['user_id']))){
            $cart_discount2 = $user->discount;
        }else{
            $cart_discount2 = 0; 	
        }    
        $cart_total_price *= (100-($cart_discount2+$mob_discount))/100;
        $cart_full_discount = $cart_discount2 + $mob_discount;            
    break;
	case 2:
        $value_discountgroup = (int)$fivecms->discountgroup->get_value_discount($cart_total_price);
        if ($value_discountgroup==0){
            $value_discountgroup = (int)$fivecms->discountgroup->get_max_discount($cart_total_price); 
        }
        $cart_total_price *= (100-($value_discountgroup+$mob_discount))/100;
        $cart_value_discountgroup = $value_discountgroup;
        $cart_full_discount = $value_discountgroup + $mob_discount;
    break;
	case 3:
        $discount = 0;
        if(isset($_SESSION['user_id']) && $user = $fivecms->users->get_user(intval($_SESSION['user_id']))){
            $cart_discount2 = $user->discount;
        }else{
            $cart_discount2 = 0; 	
        }    
        $price_total_vr = $cart_total_price;
        $price_first_discount = $cart_total_price - $cart_total_price*$cart_discount2/100;
        $value_discountgroup = (int)$fivecms->discountgroup->get_value_discount($price_first_discount);
        if ($value_discountgroup==0){
            $value_discountgroup = (int)$fivecms->discountgroup->get_max_discount($price_first_discount); 
        }
        $cart_total_price = $cart_total_price - $cart_total_price*($cart_discount2+$value_discountgroup+$mob_discount)/100;
		if ($cart_total_price<0)
			$cart_total_price==0;
        $cart_value_discountgroup = $value_discountgroup;
        $cart_full_discount = $cart_discount2 + $value_discountgroup + $mob_discount;
    break;
	case 4:
        $discount = 0;
        if(isset($_SESSION['user_id']) && $user = $fivecms->users->get_user(intval($_SESSION['user_id']))){
            $cart_discount2 = $user->discount + $user->tdiscount;
        }else{
            $cart_discount2 = 0; 	
        }    
        $price_total_vr = $cart_total_price;
        $price_first_discount = $cart_total_price - $cart_total_price*$cart_discount2/100;
        $value_discountgroup = (int)$fivecms->discountgroup->get_value_discount($price_first_discount);
        if ($value_discountgroup==0){
            $value_discountgroup = (int)$fivecms->discountgroup->get_max_discount($price_first_discount); 
        }
        $cart_total_price = $cart_total_price - $cart_total_price*($cart_discount2+$value_discountgroup+$mob_discount)/100;
		if($cart_total_price<0)
			$cart_total_price = 0;
        $cart_value_discountgroup = $value_discountgroup;
        $cart_full_discount = $cart_discount2 + $value_discountgroup + $mob_discount;
    break; 
	case 5:
        if(isset($_SESSION['user_id']) && $user = $fivecms->users->get_user(intval($_SESSION['user_id']))){
            $cart_discount2 = $user->tdiscount;
        }else{
            $cart_discount2 = 0; 	
        }    
        $cart_total_price *= (100-($cart_discount2+$mob_discount))/100;       
        $cart_full_discount = $cart_discount2 + $mob_discount;           
    break;
	default :
        if (isset($cart_value_discountgroup)){
            unset($cart_value_discountgroup);
        }
    break;   
}
// сохраним структуру из api/Cart.php end			

// передаем скидку
	if(!empty($cart_discount2))
		$order->discount2 = $cart_discount2;
    if(!empty($cart_value_discountgroup))	
        $order->discount_group = $cart_value_discountgroup;   
    if(!empty($cart_full_discount))                 
        $order->discount = $cart_full_discount;
        
    unset($cart_value_discountgroup);
    unset($cart_full_discount);
// Система скидок @

// Пишем реферера
if(!empty($sess_referer = $_SESSION['referer']))
	$order->referer = $sess_referer;
// Пишем UTM
if(!empty($sess_utm = $_SESSION['utm']))
	$order->utm = $sess_utm;
// Пишем yclid
if(!empty($yclid = $_COOKIE['yclid']))
	$order->yclid = $yclid;		
			
// Источник заказа 
//(в десктопе)
$order->source = 1;	

if($fivecms->design->is_mobile_browser()) {
	// (в мобильном дизайне)
	$order->source = 2;	
}

// Отслеживаем заказы из моб.приложения
if($fivecms->design->is_android_browser()) {
	$user_agent = $_SERVER['HTTP_USER_AGENT']; 
	if(preg_match('/iPad|iPhone/i', $user_agent)) {
		// (в мобильном приложении iOS)
		$order->source = 3;
	} elseif(preg_match('/Android/i', $user_agent)) {
		// (в мобильном приложении Android)
		$order->source = 4;
	}
}
// Источник заказа @

if(!empty($variant_id)) $order_id = $fivecms->orders->add_order($order);
	
$fivecms->orders->add_purchase(array('order_id'=>$order_id, 'variant_id'=>intval($variant_id), 'amount'=>intval($amount)));

$order = $fivecms->orders->get_order($order_id);

$fivecms->notify->email_order_admin($order_id);

if (!empty($order->email)) {

	if(isset($_SESSION['user_id']))
		$user_id = $_SESSION['user_id'];
	else {
		$fivecms->db->query('SELECT id FROM __users WHERE email=? LIMIT 1', $order->email);
		$user_id = $fivecms->db->result('id');
	}

	if (!empty($user_id)) {
	    $fivecms->orders->update_order($order_id, array('user_id' => intval($user_id)));
	} else {
	    $user           = new \stdClass();
	    $user->email    = $order->email;
	    $user->password = generate_rand_password();
	    $user->name     = $order->name;
		$user->phone    = $order->phone;
	    $user->enabled  = 1;
	    $user_id        = $fivecms->users->add_user($user);

	    if (!empty($user_id)) {
	        $fivecms->orders->update_order($order_id, array('user_id' => $user_id));
	        $fivecms->notify->email_user_registration($user_id, $user->password);
	    }
	}
	
	$fivecms->notify->email_order_user($order_id);
	if($fivecms->settings->auto_subscribe == 1)
		$fivecms->mailer->add_mail($order->name, $order->email);
}

echo $order_id;

function generate_rand_password()
{
    $chars    = "qazxswedcvfrtgbnhyujmkiolp1234567890QAZXSWEDCVFRTGBNHYUJMKIOLP";
    $max      = 10;
    $size     = StrLen($chars) - 1;
    $password = null;
    while ($max--) {
        $password .= $chars[rand(0, $size)];
    }
    return $password;
}
