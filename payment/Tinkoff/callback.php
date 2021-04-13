<?php
set_error_handler('exceptions_error_handler', E_ALL);
function exceptions_error_handler($severity)
{
    if (error_reporting() == 0) {
        return;
    }
    if (error_reporting() & $severity) {
        die('NOTOK');
    }
}

try {
    chdir('../../');
    require_once('api/Fivecms.php');
    $fivecms = new Fivecms();
    $request = json_decode(file_get_contents("php://input"));
    $request->Success = $request->Success ? 'true' : 'false';

    foreach ($request as $key => $item) {
        $requestData[$key] = $item;
    }

    $order = $fivecms->orders->get_order(intval($requestData['OrderId']));
    $method = $fivecms->payment->get_payment_method(intval($order->payment_method_id));
    $settings = unserialize($method->settings);

    $requestData['Password'] = $settings['tinkoff_secret'];
    $originalToken = $requestData['Token'];
    ksort($requestData);

    if (isset($requestData['Token'])) {
        unset($requestData['Token']);
    }

    $values = implode('', array_values($requestData));
    $genToken = hash('sha256', $values);

    if ($genToken != $originalToken) {
        die('NOTOK');
    }

	// Если деньги на карте захолдированы но стоит метка оплачен
    if ($requestData['Status'] == 'AUTHORIZED' && $order->paid) {
        die('OK');
    }
    
    // Если произведен возврат денег
    if ($requestData['Status'] == 'REFUNDED') {
    	// Ставим статус не оплачен и списываем баллы
		$fivecms->orders->unset_pay(intval($order->id));
		
		// Вернем товары на склад
        $fivecms->orders->open(intval($order->id));
		
		// Отправляем уведомление администратору
        $fivecms->notify->email_order_admin((int)$order->id);
		
        die('OK');
    }

    if ($requestData['Status'] == 'CONFIRMED') {
        /*$update_array = array('paid' => 1, 'status' => 2);
        $simpla->orders->update_order(intval($order->id), $update_array);
        $simpla->orders->close(intval($order->id));*/
        
        // Ставим статус оплачен и начисляем баллы
		$fivecms->orders->set_pay(intval($order->id));
        
        // Спишем товары со склада
        $fivecms->orders->close(intval($order->id));
        
        // Отправляем уведомление администратору
        $fivecms->notify->email_order_admin((int)$order->id);
        // Отправляем уведомление пользователю
        $fivecms->notify->email_order_user((int)$order->id);
    }
    die('OK');
} catch (Exception $e) {
    die('NOTOK');
}
