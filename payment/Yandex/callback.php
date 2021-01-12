<?php


// Работаем в корневой директории
chdir ('../../');
require_once('api/Fivecms.php');
$fivecms = new Fivecms();

// Проверка статуса
//if($_POST['notification_type'] !== 'p2p-incoming')
if($_POST['notification_type'] !== 'p2p-incoming' && $_POST['notification_type'] !== 'card-incoming')
{
	error('Плохой статус');
}
	
// Выберем заказ из базы
$order = $fivecms->orders->get_order(intval($_POST['label']));
if(empty($order))
{
	error('Оплачиваемый заказ не найден');
}
 
// Выбираем из базы соответствующий метод оплаты
$method = $fivecms->payment->get_payment_method(intval($order->payment_method_id));
if(empty($method))
{
	error("Неизвестный метод оплаты");
}
	
$settings = unserialize($method->settings);
$payment_currency = $fivecms->money->get_currency(intval($method->currency_id));

// Проверяем контрольную подпись
$hash = sha1($_POST['notification_type'].'&'.$_POST['operation_id'].'&'.$_POST['amount'].'&'.$_POST['currency'].'&'.$_POST['datetime'].'&'.$_POST['sender'].'&'.$_POST['codepro'].'&'.$settings['yandex_secret'].'&'.$_POST['label']);

if($hash !== $_POST['sha1_hash'])
{
	error('Не верный секретный ключ');
}

// Нельзя оплатить уже оплаченный заказ  
if($order->paid)
{
	error('Этот заказ уже оплачен');
}

// Учет комиссии Яндекса
$amount = round($fivecms->money->convert($order->total_price, $method->currency_id, false), 2);

if($_POST['amount'] != $amount || $_POST['amount']<=0)
	error("Не корректная цена");

// Установим статус оплачен
//$fivecms->orders->update_order(intval($order->id), array('paid'=>1));
$fivecms->orders->set_pay(intval($order->id));

// Спишем товары  
$fivecms->orders->close(intval($order->id));

// Отправим уведомление на email
$fivecms->notify->email_order_user(intval($order->id));
$fivecms->notify->email_order_admin(intval($order->id));

function error($msg)
{
	header($_SERVER['SERVER_PROTOCOL'].' 400 Bad Request', true, 400);
	mail($fivecms->settings->order_email, "yandex: $msg", $msg);
	die($msg);
}
