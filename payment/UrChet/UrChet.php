<?php
require_once('api/Fivecms.php');

class UrChet extends Fivecms
{

	public function checkout_form($order_id, $button_text = null)
	{
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_settings = $this->payment->get_payment_settings($payment_method->id);
		
		//	подготовить данные
		/*
		$recipient = $payment_settings['recipient'];
		$inn = $payment_settings['inn'];
		$account = $payment_settings['account'];
		$bank = $payment_settings['bank'];
		$bik = $payment_settings['bik'];
		$correspondent_account = $payment_settings['correspondent_account'];		
		*/
		
		$button = "<form class='form' action='payment/UrChet/callback.php' method='post' style='width: 100%;'>
					</br>
					<div style='font-weight:700;'>Заполните форму и нажмите Сформировать счет  &#8594; для загрузки счета на оплату</div>
					</br>
					<input type='hidden' name='poluchatel' value='".$payment_settings['poluchatel']."'>
					<input type='hidden' name='inn' value='".$payment_settings['inn']."'>
					<input type='hidden' name='kpp' value='".$payment_settings['kpp']."'>
					<input type='hidden' name='bank' value='".$payment_settings['bank']."'>
					<input type='hidden' name='bik' value='".$payment_settings['bik']."'>
					<input type='hidden' name='schet' value='".$payment_settings['schet']."'>
					<input type='hidden' name='korchet' value='".$payment_settings['korchet']."'>
					<input type='hidden' name='banknote' value='".$payment_settings['banknote']."'>
					<input type='hidden' name='payment_method' value='".$payment_method->id."'>
					<input type='hidden' name='order_id' value='$order->id'>
					<label>Плательщик: </label><input type='text' name='platelschik' value='' style='width:100%; display:block'>
					<label>Грузополучатель: </label><input type='text' name='gruzopoluchatel' value='' style='width:100%; display:block'>
					</br>
					<input class=checkout_button type='submit' value='Сформировать счет  &#8594;'>
					</form>";
		
		return $button;
	}
}
