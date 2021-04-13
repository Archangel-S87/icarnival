<?php

// Работаем в корневой директории
chdir('../../');
require_once('api/Fivecms.php');
require_once('payment/Sberbank/RBS.php');

$fivecms = new Fivecms();

$order_id = $fivecms->request->get('order');
$prefix = explode('-', $order_id);

$order = $fivecms->orders->get_order(intval($fivecms->request->get('order', 'integer')));
if (empty($order)) {
    die('Оплачиваемый заказ не найден');
}

$method = $fivecms->payment->get_payment_method(intval($order->payment_method_id));
if (empty($method)) {
    die("Неизвестный метод оплаты");
}

$settings = unserialize($method->settings);
$payment_currency = $fivecms->money->get_currency(intval($method->currency_id));

/**
 * Проверим статус заказа
 */
$rbs = new RBS($settings['sbr_login'], $settings['sbr_password'], FALSE, $settings['sbr_mode'] ? TRUE : FALSE);
$order_merchant_id = $fivecms->request->get('orderId');

$response = $rbs->get_order_status_by_orderId($order_merchant_id);

// Если указана ошибка оплаты
if ($response['errorCode']) {
    die($response['errorMessage']);
}

if ($response['actionCode'] != 0) {
    header('Location: ' . $fivecms->config->root_url . '/order/' . $order->url);
    die("Ошибка оплаты. " . $response['actionCodeDescription']);
}

// Нельзя оплатить уже оплаченный заказ  
if ($order->paid) {
    header('Location: ' . $fivecms->config->root_url . '/order/' . $order->url);
}

// Проверяем оплаченный заказ
$total_price = round($order->total_price, 2) * 100;
if ($response['amount'] != (int)$total_price || $response['amount'] <= 0) {
    die("incorrect price");
}

// Установим статус "оплачен"
//$fivecms->orders->update_order(intval($order->id), ['paid' => 1, 'payment_date' => date('Y-m-d H:i:s')]);
// Ставим статус оплачен и начисляем баллы
$fivecms->orders->set_pay(intval($order->id));

// Спишем товары
$fivecms->orders->close(intval($order->id));

// Отправим уведомление на email
$fivecms->notify->email_order_user(intval($order->id));
$fivecms->notify->email_order_admin(intval($order->id));

header('Location: ' . $fivecms->config->root_url . '/order/' . $order->url);

exit();