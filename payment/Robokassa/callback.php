<?php

/**
 *
 *
 * @copyright 	5CMS
 * @link 		http://5cms.ru
 *
 *
 */
 
// Работаем в корневой директории
chdir ('../../');
require_once('api/Fivecms.php');
$fivecms = new Fivecms();


// Кошелек продавца
// Кошелек продавца, на который покупатель совершил платеж. Формат - буква и 12 цифр.
$merchant_purse = $_POST['LMI_PAYEE_PURSE'];

// Сумма, которую заплатил покупатель. Дробная часть отделяется точкой.
$amount = $_POST['OutSum'];

// Внутренний номер покупки продавца
// В этом поле передается id заказа в нашем магазине.
$order_id = intval($_POST['InvId']);

// Контрольная подпись
$crc = strtoupper($_POST['SignatureValue']);

////////////////////////////////////////////////
// Выберем заказ из базы
////////////////////////////////////////////////
$order = $fivecms->orders->get_order(intval($order_id));
if(empty($order))
	die('Оплачиваемый заказ не найден');
 
// Нельзя оплатить уже оплаченный заказ  
if($order->paid)
	die('Этот заказ уже оплачен');


////////////////////////////////////////////////
// Выбираем из базы соответствующий метод оплаты
////////////////////////////////////////////////
$method = $fivecms->payment->get_payment_method(intval($order->payment_method_id));
if(empty($method))
	die("Неизвестный метод оплаты");
 
$settings = unserialize($method->settings);

$mrh_pass2 = $settings['password2'];
      
// Проверяем контрольную подпись
$my_crc = strtoupper(md5("$amount:$order_id:$mrh_pass2"));  
if($my_crc !== $crc)
	die("bad sign\n");

if($amount != $fivecms->money->convert($order->total_price, $method->currency_id, false) || $amount<=0)
	die("incorrect price\n");
	
////////////////////////////////////
// Проверка наличия товара
////////////////////////////////////
$purchases = $fivecms->orders->get_purchases(array('order_id'=>intval($order->id)));
foreach($purchases as $purchase)
{
	$variant = $fivecms->variants->get_variant(intval($purchase->variant_id));
	if(empty($variant) || (!$variant->infinity && $variant->stock < $purchase->amount))
	{
		die("Нехватка товара $purchase->product_name $purchase->variant_name");
	}
}
       
// Установим статус оплачен
//$fivecms->orders->update_order(intval($order->id), array('paid'=>1));
// Ставим статус оплачен и начисляем баллы
$fivecms->orders->set_pay(intval($order->id));

// Спишем товары  
$fivecms->orders->close(intval($order->id));

$fivecms->notify->email_order_user(intval($order->id));
$fivecms->notify->email_order_admin(intval($order->id));


die("OK".$order_id."\n");
