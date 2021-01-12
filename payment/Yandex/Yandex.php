<?php

require_once('api/Fivecms.php');
class Yandex extends Fivecms
{

	// Комиссия Яндекса, %
	private $fee = 0.5;

	public function checkout_form($order_id, $button_text = null)
	{
		if(empty($button_text))
			$button_text = 'Перейти к оплате';
		
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_currency = $this->money->get_currency(intval($payment_method->currency_id));
		$settings = $this->payment->get_payment_settings($payment_method->id);
		
		$price = round($this->money->convert($order->total_price, $payment_method->currency_id, false), 2);
		
		// Учесть комиссию Яндекса
		$price = $price+max(0.01, $price*$this->fee/100);

		// описание заказа
		$desc = 'Оплата заказа №'.$order->id.' на сайте '.$this->settings->site_name;
							
		$button = '<form method="POST" action="https://money.yandex.ru/quickpay/confirm.xml">
					<input name="receiver" type="hidden" value="'.$settings['yandex_id'].'">
					<input name="formcomment" type="hidden" value="'.$desc.'">
					<input name="short-dest" type="hidden" value="'.$desc.'">
					<input name="targets" type="hidden" value="'.$desc.'">
					<input name="comment" type="hidden" value="'.$desc.'"/>
					<input name="quickpay-form" type="hidden" value="shop">
					<input name="sum" data-type="number" type="hidden" value="'.$price.'">
					<input name="label" type="hidden" value="'.$order->id.'">   
					<input name="paymentType" type="hidden" value="PC">   
					<input name="submit-button" type="submit" value="'.$button_text.'"  class="checkout_button">
					</form>';
		return $button;
	}
}