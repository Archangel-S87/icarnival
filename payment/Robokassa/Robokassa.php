<?php

require_once('api/Fivecms.php');

class Robokassa extends Fivecms {
    
    public function checkout_form($order_id) 
    {
        $order = $this->orders->get_order((int)$order_id);
        $payment_method = $this->payment->get_payment_method($order->payment_method_id);
        $payment_settings = $this->payment->get_payment_settings($payment_method->id);

        $price = $this->money->convert($order->total_price, $payment_method->currency_id, false);
        
        $test = $payment_settings['test'];
        
        // регистрационная информация (логин, пароль #1)
        // registration info (login, password #1)
        $mrh_login = $payment_settings['login'];
        $mrh_pass1 = $payment_settings['password1'];

        // номер заказа
        // number of order
        $inv_id = $order->id;

        // описание заказа
        // order description
        $inv_desc = 'Оплата заказа №' . $inv_id;
        
        // предлагаемая валюта платежа
        // default payment e-currency
        $in_curr = "PCR";

        // язык
        // language
        $culture = $payment_settings['language'];

        // список товаров
        // products list
        $total_price = (float)$order->total_price;
        
		if(!$order->separate_delivery)
        	$total_price -= (float)$order->delivery_price; //Скидка не применяется к доставке

        $purchases = $this->orders->get_purchases(array('order_id' => (int)$order->id));

        $full_total_price = 0;

        foreach ($purchases as $p) {
            $full_total_price += (float)$p->price * (int)$p->amount;
        }

		if(!empty($full_total_price))
        	$discount = $total_price / $full_total_price;
        else	
			$discount = 1;
			
        $receipt = array('sno' => $payment_settings['sno']);

        $receipt['items'] = array();
        
        function endKey($array){
		 end($array);
		 return key($array);
		}

        foreach ($purchases as $key => $p) {
            $one_product = array();
            $one_product['name'] = mb_substr(htmlentities($p->product_name . ($p->variant_name ? ' ' . $p->variant_name : '')), 0, 64);
            if ($key == endKey($purchases)) {
                $one_product['sum'] = $total_price;
            } else {
                $total_price -= floor((float)$p->price * (float)$p->amount * $discount);
                $one_product['sum'] = floor((float)$p->price * (float)$p->amount * $discount);
            }
            $one_product['quantity'] = (float)$p->amount;
            $one_product['payment_method'] = $payment_settings['payment_method'];
            $one_product['payment_object'] = $payment_settings['payment_object'];
            $one_product['tax'] = $payment_settings['vat'];
            $receipt['items'][] = $one_product;
        }
        // delivery 
        if ($order->delivery_id && $order->delivery_price > 0 && !$order->separate_delivery) {
            $delivery = $this->delivery->get_delivery($order->delivery_id);
            
        	$one_product = array();
            $one_product['name'] = mb_substr(htmlentities($delivery->name), 0, 64);
            $one_product['sum'] = (float)$order->delivery_price;
            $one_product['quantity'] = 1;
            $one_product['payment_method'] = $payment_settings['payment_method'];
            $one_product['payment_object'] = $payment_settings['payment_object'];
            $one_product['tax'] = $payment_settings['vat'];
            $receipt['items'][] = $one_product;
        }
        // delivery @

        $url_json_receipt = urlencode(json_encode($receipt));

        // формирование подписи
        // generate signature
        $crc = md5("$mrh_login:$price:$inv_id:$url_json_receipt:$mrh_pass1");
      
        $button =	"<form accept-charset='cp1251' action='https://merchant.roboxchange.com/Index.aspx' method=POST>".
					"<input type=hidden name=MrchLogin value='$mrh_login'>".
					"<input type=hidden name=OutSum value='$price'>".
					"<input type=hidden name=InvId value='$inv_id'>".
					"<input type=hidden name=Receipt value='$url_json_receipt'>".
					"<input type=hidden name=Desc value='$inv_desc'>".
					"<input type=hidden name=IsTest value='$test'>".
					"<input type=hidden name=SignatureValue value='$crc'>".
					"<input type=hidden name=IncCurrLabel value='$in_curr'>".
					"<input type=hidden name=Culture value='$culture'>".
					"<input type=submit class=checkout_button value='Перейти к оплате'>".
					"</form>";
		return $button;
    }

}