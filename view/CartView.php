<?PHP
 
require_once('View.php');

class CartView extends View
{
  public function __construct()
  {
	parent::__construct();

    // Если передан id варианта, добавим его в корзину
    if($variant_id = $this->request->get('variant', 'integer'))
    {
		$this->cart->add_item($variant_id, $this->request->get('amount', 'integer'));
	    header('location: '.$this->config->root_url.'/cart/');
    }

    // Удаление товара из корзины
    if($delete_variant_id = intval($this->request->get('delete_variant')))
    {
      $this->cart->delete_item($delete_variant_id);
      if(!isset($_POST['submit_order']) || $_POST['submit_order']!=1)
			header('location: '.$this->config->root_url.'/cart/');
	}
	
    // Если нажали оформить заказ
    if(isset($_POST['checkout']))
    {
    	$order = new stdClass;
    	$order->delivery_id = $this->request->post('delivery_id', 'integer');
		$order->payment_method_id = $this->request->post('payment_method_id', 'integer');
    	$order->name        = $this->request->post('name');
		$bonus              = $this->request->post('bonus','integer');
    	$order->email       = $this->request->post('email');
    	$order->address     = $this->request->post('address');
    	$order->phone       = $this->request->post('phone');
    	$order->comment     = $this->request->post('comment');
    	if($this->request->post('calc')) $order->calc = $this->request->post('calc');
		$order->ip      	= $_SERVER['REMOTE_ADDR'];
		if($this->request->post('cdek')) $cdek = $this->request->post('cdek', 'float');
		if($this->request->post('boxberry')) $boxberry = $this->request->post('boxberry', 'float');
		if($this->request->post('shiptor')) $shiptor = $this->request->post('shiptor', 'float');
		$this->design->assign('delivery_id', $order->delivery_id);
		$this->design->assign('name', $order->name);
		$this->design->assign('bonus', $bonus);
		$this->design->assign('email', $order->email);
		$this->design->assign('phone', $order->phone);
		$this->design->assign('address', $order->address);
		// Antibot
		if($this->request->post('bttrue')) {
			$bttrue = $this->request->post('bttrue');
			$this->design->assign('bttrue', $bttrue);
		}	
		if($this->request->post('btfalse')) {
			$btfalse = $this->request->post('btfalse');
			$this->design->assign('btfalse', $btfalse);
		}
		// Antibot @
		
		$cart = $this->cart->get_cart();
		
		// Скидка | Discount
		if(!empty($cart->discount2))
        	$order->discount2 = $cart->discount2;
        if(!empty($cart->value_discountgroup))	
            $order->discount_group = $cart->value_discountgroup;   
        if(!empty($cart->full_discount))                 
            $order->discount = $cart->full_discount;
        
        unset($cart->value_discountgroup);
        unset($cart->full_discount);
		
		// Пишем реферера
		if(!empty($sess_referer = $_SESSION['referer']))
			$order->referer = $sess_referer;
		// Пишем UTM
		if(!empty($sess_utm = $_SESSION['utm']))
			$order->utm = $sess_utm;
		// Пишем yclid
		if(!empty($yclid = $_COOKIE['yclid']))
			$order->yclid = $yclid;	
			
		// Источник заказа (в десктопе)
		$order->source = 1;	

		if($this->design->is_mobile_browser()) {
			// Источник заказа (в мобильном дизайне)
			$order->source = 2;	
		}
		
		// Отслеживаем заказы из моб.приложения
        if($this->design->is_android_browser()) {
			$user_agent = $_SERVER['HTTP_USER_AGENT']; 
			if(preg_match('/iPad|iPhone/i', $user_agent)) {
				// Источник заказа (в мобильном приложении iOS)
				$order->source = 3;
			} elseif(preg_match('/Android/i', $user_agent)) {
				// Источник заказа (в мобильном приложении Android)
				$order->source = 4;
			}
		}

		if($cart->coupon)
		{
			$order->coupon_discount = $cart->coupon_discount;
			$order->coupon_code = $cart->coupon->code;
		}
		    	
    	if(!empty($this->user->id))
	    	$order->user_id = $this->user->id;
    	
    	if(empty($order->name))
    	{
    		$this->design->assign('error', 'empty_name');
    	}
    	elseif(empty($order->email))
    	{
    		$this->design->assign('error', 'empty_email');
    	}
		elseif(!$bttrue)
		{
			$this->design->assign('error', 'captcha');
		}
		elseif($btfalse)
		{
			$this->design->assign('error', 'captcha');
		}		
    	elseif($cart->total_price < $this->settings->minorder)
    	{
    		$this->design->assign('error', 'min_order');
    	}
    	elseif($cart->total_price == 0)
    	{
    		$this->design->assign('error_stock', 'out_of_stock_order');
    	}
    	else
    	{
			if($bonus && $this->settings->bonus_limit && $this->user->balance) {
			    if(($cart->total_price * $this->settings->bonus_limit / 100) > floatval($this->user->balance))
			      $order->bonus_discount = floatval($this->user->balance);
			    else
			      $order->bonus_discount = ($cart->total_price * $this->settings->bonus_limit / 100);
			 
			    $this->user->balance = $this->user->balance - $order->bonus_discount;
			    $this->users->update_user($this->user->id, array('balance' => $this->user->balance));
			}

	    	// Добавляем заказ в базу
	    	$order_id = $this->orders->add_order($order);

	    	$_SESSION['order_id'] = $order_id;
	    	
	    	// Если использовали купон, увеличим количество его использований
	    	if($cart->coupon)
	    		$this->coupons->update_coupon($cart->coupon->id, array('usages'=>$cart->coupon->usages+1));
	    	
	    	// Добавляем товары к заказу
	    	foreach($this->request->post('amounts') as $variant_id=>$amount)
	    	{
	    		$this->orders->add_purchase(array('order_id'=>$order_id, 'variant_id'=>intval($variant_id), 'amount'=>intval($amount)));
	    	}
	    	$order = $this->orders->get_order($order_id);
	    	
	    	// Стоимость доставки
			$delivery = $this->delivery->get_delivery($order->delivery_id);
			
			// Delivery calc
            if ($cart->total_weight > 3) {
                $weight = ceil($cart->total_weight);
            } else {
                $weight = 0;
            }
            if ($delivery->price2 > 0) {
                $delivery->price = $delivery->price + ($weight * $delivery->price2);
            }
			// Delivery calc end

            if ($order->delivery_id == 3) {
                $delivery->price = $shiptor;
            } elseif ($order->delivery_id == 114) {
                $delivery->price = $cdek;
            } elseif ($order->delivery_id == 121) {
                $delivery->price = $boxberry;
            } elseif ($delivery->widget == 1) {
                $delivery->price = $this->request->post('widget_' . $delivery->id, 'float');
            } elseif ($delivery->additional_cost > 0) {
                // Дополнительная стоимость доставки взымается всегда, кроме бесплатно от
                $delivery->price += $delivery->additional_cost;
            }

	    	if(!empty($delivery) && ($delivery->free_from > $order->total_price || $delivery->free_from == 0)) {
	    		$this->orders->update_order($order->id, array('delivery_price'=>$delivery->price, 'separate_delivery'=>$delivery->separate_payment));
	    	}
			
			// for mobile app don`t delete or change!!!
			// Автоматически регистрируем нового пользователя если не залогинен
		 		if (!empty($_SERVER['HTTP_CLIENT_IP'])) { $ip=$_SERVER['HTTP_CLIENT_IP']; }
					elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) { $ip=$_SERVER['HTTP_X_FORWARDED_FOR']; }
					else { $ip=$_SERVER['REMOTE_ADDR']; }
		 		if(!$this->user) {
		    		$this->db->query('SELECT count(*) as count FROM __users WHERE email=?', $order->email);
		  			$user_exists = $this->db->result('count');
		  			if($user_exists) { 
		    			$this->db->query('SELECT * FROM __users WHERE email=?', $order->email);
		    			$user_exists_id = $this->db->result('id');
		  			  $this->orders->update_order($order->id, array('user_id'=>$user_exists_id));
					} else { 
		    		$chars="qazxswedcvfrtgbnhyujmkiolp1234567890QAZXSWEDCVFRTGBNHYUJMKIOLP"; 
		    		$max=10; 
		    		$size=StrLen($chars)-1; 
		    		$password=null; 
		    		while($max--) $password.=$chars[rand(0,$size)]; 
		    		$user_id = $this->users->add_user(array('email'=>$order->email, 'password'=>$password, 'name'=>$order->name, 'phone'=>$order->phone, 'enabled'=>'1', 'last_ip'=>$ip));
		    		$this->orders->update_order($order->id, array('user_id'=>$user_id));
		    		$this->notify->email_user_registration($user_id, $password);
					$_SESSION['user_id'] = $user_id;
					}
		  		}
			// for mobile app end don`t delete or change!!!
			
			// add partner_id to user
			if(isset($_COOKIE['partner_id'])){
				if(!empty($this->user->id)) 
					$user_id = $this->user->id;
	
				if(!empty($user_id) && intval($user_id) != intval($_COOKIE['partner_id']) && empty($this->user->partner_id)) {
					$partner = $this->users->get_user(intval($_COOKIE['partner_id']));
					if(!empty($partner) && $partner->enabled)
						$this->users->update_user(intval($user_id), array('partner_id'=>$partner->id));
				}
			} /*elseif(empty($this->user->partner_id)) {
				// не даем делать рефералами уже имеющихся клиентов
				// пользователь с id=1 должен быть системным
				if(!empty($this->user->id)) 
					$user_id = $this->user->id;
				if(!empty($user_id))
					$this->users->update_user(intval($user_id), array('partner_id'=>'1'));
			}*/

			if($this->settings->auto_subscribe == 1)
				$this->mailer->add_mail($order->name, $order->email);

			// Отправляем письмо пользователю
			$this->notify->email_order_user($order->id);
	    	
			// Отправляем письмо администратору
			$this->notify->email_order_admin($order->id);
			
			// функция прикрепления файлов 
			if ($this->settings->attachment == 1) {
					$files 		= array();
					$files 		= (array)$this->request->post('files');
					// Удаление файлов
					/*$current_files = $this->files->get_files(array('object_id'=>$order->id,'type'=>'order'));
					foreach($current_files as $file)
						if(!in_array($file->id, $files['id']))
								$this->files->delete_file($file->id);*/
					// Порядок файлов
					/*if($files = $this->request->post('files')){
						$i=0;
						foreach($files['id'] as $k=>$id)
						{
							$this->files->update_file($id, array('name'=>$files['name'][$k],'position'=>$i));
							$i++;
						}
					}*/
					// Загрузка файлов
					$upload_max_filesize = $this->settings->maxattachment * 1024 * 1024;
					if($files = $this->request->files('files')){
						for($i=0; $i<count($files['name']); $i++)
						{
							if($files['name']['size'] < $upload_max_filesize) {
								if ($file_name = $this->files->upload_file($files['tmp_name'][$i], $files['name'][$i])){
									$this->files->add_file($order->id, 'order', $file_name);
								}
								else {
									$this->design->assign('error', 'error uploading file');
								}
							}
						}
					}
					$files = $this->files->get_files(array('object_id'=>$order->id,'type'=>'order')); 	
			}
			// функция прикрепления файлов end
			
	    	// Очищаем корзину (сессию)
			$this->cart->empty_cart();
						
			// Перенаправляем на страницу заказа
			header('Location: '.$this->config->root_url.'/order/'.$order->url);
		}
    }   
    else
    {

	    // Если нам запостили amounts, обновляем их
	    if($amounts = $this->request->post('amounts'))
	    {
			foreach($amounts as $variant_id=>$amount)
			{
				$this->cart->update_item($variant_id, $amount);         
			}
			if($variants=$this->request->post('variant'))
				{
					foreach($variants as $old_v=>$new_v)
						{
							if($new_v!=$old_v)
								$this->cart-> update_item_v($old_v, $new_v );
						}
				}
	    	$coupon_code = trim($this->request->post('coupon_code', 'string'));
	    	if(empty($coupon_code))
	    	{
	    		$this->cart->apply_coupon('');
				header('location: '.$this->config->root_url.'/cart');	    		
	    	}
	    	else
	    	{
				$coupon = $this->coupons->get_coupon((string)$coupon_code);

				if(empty($coupon) || !$coupon->valid)
				{
		    		$this->cart->apply_coupon($coupon_code);
					$this->design->assign('coupon_error', 'invalid');
				}
				else
				{
					$this->cart->apply_coupon($coupon_code);
					header('location: '.$this->config->root_url.'/cart');
				}
	    	}
		}
	    
	}
              
  }

	//////////////////////////////////////////
	// Основная функция
	//////////////////////////////////////////
	function fetch()
	{  
		// Способы доставки
		$deliveries = $this->delivery->get_deliveries(array('enabled'=>1));

    	foreach($deliveries as $delivery)
            $delivery->payment_methods = $this->payment->get_payment_methods(array('delivery_id'=>$delivery->id, 'enabled'=>1));
                
		$this->design->assign('deliveries', $deliveries);
		
		$payment_methods = $this->payment->get_payment_methods(array('enabled'=>1));
        $this->design->assign('payment_methods', $payment_methods);

		// Данные пользователя
		if($this->user)
		{
			$last_order = $this->orders->get_orders(array('user_id'=>$this->user->id, 'limit'=>1));
			$last_order = reset($last_order);
			
			if(!empty($last_order->name)) {
				$this->design->assign('name', $last_order->name);
			} else {
				$this->design->assign('name', $this->user->name);
			}
			if(!empty($last_order->email)) {
				$this->design->assign('email', $last_order->email);
			} else {
				$this->design->assign('email', $this->user->email);
			}
			if(!empty($last_order->phone)) {
				$this->design->assign('phone', $last_order->phone);
			} elseif (!empty($this->user->phone)) {
				$this->design->assign('phone', $this->user->phone);
			}
			if(!empty($last_order->address))
				$this->design->assign('address', $last_order->address);
		}
		
		// Если существуют валидные купоны, нужно вывести инпут для купона
		if($this->coupons->count_coupons(array('valid'=>1))>0)
			$this->design->assign('coupon_request', true);
		// Выводим корзину
		return $this->design->fetch('cart.tpl');
	}
	
}
