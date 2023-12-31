<?php

/**
 *
 *
 * @copyright 	5CMS
 * @link 		http://5cms.ru
 *
 *
 * IPN Script for Paypal
 *
 */

// Working in root dir
chdir ('../../');

// Including fivecms API
require_once('api/Fivecms.php');
$fivecms = new Fivecms();


// Get the order
$order = $fivecms->orders->get_order(intval($fivecms->request->post('invoice')));
if(empty($order))
	die('Order not found');
 
// Get payment method from this order
$method = $fivecms->payment->get_payment_method(intval($order->payment_method_id));
if(empty($method))
	die("Unknown payment method");

// Payment method settings
$settings = unserialize($method->settings);
if($settings['mode'] == 'sandbox') $paypal_url = "https://www.sandbox.paypal.com/cgi-bin/webscr";
else $paypal_url = "https://www.paypal.com/cgi-bin/webscr";


// Verify transaction
$postdata = ""; 
foreach ($_POST as $key=>$value) $postdata.=$key."=".urlencode($value)."&"; 
$postdata .= "cmd=_notify-validate";  
$curl = curl_init($paypal_url); 
curl_setopt ($curl, CURLOPT_HEADER, 0);  
curl_setopt ($curl, CURLOPT_POST, 1); 
curl_setopt ($curl, CURLOPT_POSTFIELDS, $postdata); 
curl_setopt ($curl, CURLOPT_SSL_VERIFYPEER, 0);  
curl_setopt ($curl, CURLOPT_RETURNTRANSFER, 1); 
curl_setopt ($curl, CURLOPT_SSL_VERIFYHOST, 1); 
$response = curl_exec($curl); 
curl_close ($curl); 
if ($response != "VERIFIED")
	die("Could not verify transaction");
	
// Check payment status
if($_POST["payment_status"] != "Completed" )
	die('Incorrect status '.$_POST["payment_status"].$_POST["pending_reason"]);

// Verify merchant email
if ($fivecms->request->post('receiver_email') != $settings['business']) 
	die("Incorrect merchant email"); 

// Verify transaction type
if ($fivecms->request->post('txn_type') != 'cart') 
	die("Incorrect txn_type"); 

// Is order already paid
if($order->paid)
	die('Duplicate payment');


////////////////////////////////////
// Verify total payment amount
////////////////////////////////////
$total_price = 0;

// Get order purchases
$purchases = $fivecms->orders->get_purchases(array('order_id'=>intval($order->id)));
foreach($purchases as $purchase)
{			
	$price = $fivecms->money->convert($purchase->price, $method->currency_id, false);
	$price = round($price, 2);
	$total_price += $price*$purchase->amount;
}
// Substract the discount
if($order->discount)
{
	$total_price *= (100-$order->discount)/100;
	$total_price = round($total_price, 2);
}
// Adding delivery price
if($order->delivery_id && !$order->separate_delivery && $order->delivery_price>0)
{
	$delivery_price = $fivecms->money->convert($order->delivery_price, $payment_method->currency_id, false);
	$delivery_price =round($delivery_price, 2);
	$total_price += $delivery_price;
}
if($total_price != $fivecms->request->post('mc_gross'))
	die("Incorrect total price (".$total_price."!=".$fivecms->request->post('mc_gross').")");
       
// Set order status paid
//$fivecms->orders->update_order(intval($order->id), array('paid'=>1));
// Set order status paid and add bonuses | Ставим статус оплачен и начисляем баллы
$fivecms->orders->set_pay(intval($order->id));

// Write off products
$fivecms->orders->close(intval($order->id));
$fivecms->notify->email_order_user(intval($order->id));
$fivecms->notify->email_order_admin(intval($order->id));


function logg($str)
{
	file_put_contents('payment/Paypal/log.txt', file_get_contents('payment/Paypal/log.txt')."\r\n".date("m.d.Y H:i:s").' '.$str);
}
