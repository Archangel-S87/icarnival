<?php
ini_set("display_errors", 1);
require_once('api/Fivecms.php');

class ReceiptUr extends Fivecms
{

	public function checkout_form($order_id)
	{
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_settings = $this->payment->get_payment_settings($payment_method->id);				
		$amount = $this->money->convert($order->total_price, $payment_method->currency_id, false);		
		if(!$order->separate_delivery)
			$delivery_price = $this->money->convert($order->delivery_price, $payment_method->currency_id, false);
		else
			$delivery_price = 0;
		
		//	подготовить данные
		$recipient = $payment_settings['recipient'];
		$inn = $payment_settings['inn'];
		$account = $payment_settings['account'];
		$bank = $payment_settings['bank'];
		$bik = $payment_settings['bik'];
		$correspondent_account = $payment_settings['correspondent_account'];		
		$address_seller = $payment_settings['address_seller'];
		$index_seller = $payment_settings['index_seller'];
		$phone_seller = $payment_settings['phone_seller'];
		
		$kpp = $payment_settings['kpp'];
		$rukov = $payment_settings['rukov'];
		$sef = $payment_settings['sef'];
		
		$purchases = $this->orders->get_purchases(array('order_id'=>intval($order->id)));		
		$purchases_s = serialize($purchases);
		$purchases_s = htmlspecialchars($purchases_s,ENT_QUOTES);
			
		$button =	"<FORM class='form' ACTION='payment/ReceiptUr/callback.php' METHOD='POST'>
					<INPUT TYPE='HIDDEN' NAME='recipient' VALUE='".$payment_settings['recipient']."'>
					<INPUT TYPE='HIDDEN' NAME='inn' VALUE='".$payment_settings['inn']."'>
					<INPUT TYPE='HIDDEN' NAME='account' VALUE='".$payment_settings['account']."'>
					<INPUT TYPE='HIDDEN' NAME='bank' VALUE='".$payment_settings['bank']."'>
					<INPUT TYPE='HIDDEN' NAME='bik' VALUE='".$payment_settings['bik']."'>					
					<INPUT TYPE='HIDDEN' NAME='address_seller' VALUE='".$payment_settings['address_seller']."'>
					<INPUT TYPE='HIDDEN' NAME='index_seller' VALUE='".$payment_settings['index_seller']."'>
					<INPUT TYPE='HIDDEN' NAME='phone_seller' VALUE='".$payment_settings['phone_seller']."'>
					<INPUT TYPE='HIDDEN' NAME='kpp' VALUE='".$payment_settings['kpp']."'>
				    <INPUT TYPE='HIDDEN' NAME='rukov' VALUE='".$payment_settings['rukov']."'>
					<INPUT TYPE='HIDDEN' NAME='sef' VALUE='".$payment_settings['sef']."'>													
					<INPUT TYPE='HIDDEN' NAME='correspondent_account' VALUE='".$payment_settings['correspondent_account']."'>
					<INPUT TYPE='HIDDEN' NAME='banknote' VALUE='".$payment_settings['banknote']."'>
					<INPUT TYPE='HIDDEN' NAME='pence' VALUE='".$payment_settings['pense']."'>
					<INPUT TYPE='HIDDEN' NAME='vat' VALUE='".$payment_settings['vat']."'>		
					<INPUT TYPE='HIDDEN' NAME='order_id' VALUE='$order->id'>
					<INPUT TYPE='HIDDEN' NAME='amount' VALUE='".$amount."'>
					<INPUT TYPE='HIDDEN' NAME='delivery_price' VALUE='".$delivery_price."'>
					<INPUT TYPE='HIDDEN' NAME='purchases_s' VALUE='".$purchases_s."'>					
					<label>Название организации: </label><INPUT TYPE='text' NAME='name' VALUE=''>
					<label>ИНН плательщика: </label><INPUT TYPE='text' NAME='inn_plat' VALUE=''>
					<label>КПП: </label><INPUT TYPE='text' NAME='kpp_plat' VALUE=''>
					<label>Адрес организации: </label><INPUT TYPE='text' NAME='address_plat' VALUE=''>
					<label>Номер телефона плательщика: </label><INPUT TYPE='text' NAME='phone_plat' VALUE=''>
					<INPUT class=checkout_button TYPE='submit' VALUE='Сформировать счет  &#8594;'>
					</FORM>";
		
		return $button;
	}
}