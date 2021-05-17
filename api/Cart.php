<?php

require_once('Fivecms.php');

class Cart extends Fivecms
{

	/*
	*
	* Функция возвращает корзину
	*
	*/
	public function get_cart()
	{
		$cart = new stdClass();
		$cart->purchases = array();
		$cart->total_price = 0;
		$cart->total_products = 0;
		$cart->total_weight = 0;
		$cart->total_volume = 0;
		$cart->coupon = null;
		$cart->discount = 0;
		$cart->coupon_discount = 0;
        $cart->products_variants = [];
		
		// Берем из сессии список variant_id=>amount
		if($this->settings->cart_storage == 0) {
			foreach($_COOKIE as $key => $cookie)
			{
				if(strpos($key, 't_') != false)
				{
					$variant_id = str_replace('ct_', '', $key);
					$session_items[$variant_id] = $cookie;
				}
			}
		} elseif($this->settings->cart_storage == 2) {
			if(!isset($_COOKIE['ct_code'])){
				$sid=session_id();
				$_COOKIE['ct_code']=$sid;
				setcookie("ct_code", $sid, time()+365*24*3600, '/');
				$this->cart->base_to_cart($_COOKIE['ct_code']);
			}
			if(isset($_SESSION['user_id']) && empty($_SESSION['ct'])){
				$this->cart->base_to_cart($_SESSION['user_id']);
				//$this->cart->cart_to_base();
			}
		}
		
		if( ($this->settings->cart_storage == 1 && !empty($_SESSION['ct'])) || ($this->settings->cart_storage == 2 && !empty($_SESSION['ct'])) || ($this->settings->cart_storage == 0 && !empty($session_items)) ) 
		{
			if($this->settings->cart_storage == 1 || $this->settings->cart_storage == 2)
				$session_items = $_SESSION['ct'];

            $variants = $this->variants->get_variants(['id' => array_keys($session_items), 'sort' => 'product_id']);
			if(!empty($variants))
			{
				$items = array();
				$products_ids = array();
				foreach($variants as $variant)
				{
					$items[$variant->id] = new stdClass();
					$items[$variant->id]->variant = $variant;
					if($variant->stock > 0)
						$items[$variant->id]->amount = $session_items[$variant->id];
					else {
						$items[$variant->id]->amount = 0;
						$this->design->assign('cart_error', 'out_of_stock_order');	
					}	
					$products_ids[] = $variant->product_id;
				}
	
				$products = array();
				foreach($this->products->get_products(array('id'=>$products_ids, 'limit' => count($products_ids))) as $p)
					$products[$p->id]=$p;
				
				$images = $this->products->get_images(array('product_id'=>$products_ids));
				foreach($images as $image)
					$products[$image->product_id]->images[$image->id] = $image;
				
				// Если нужна категория товара в корзине и информере корзины
				// Пример в шаблоне {$purchase->product->category->id}	
                /*foreach($products as &$product){
					$product->categories = $this->categories->get_categories(array('product_id'=>$product->id));
					$product->category = reset($product->categories);        
				}*/

                // Варианты товаров для всплывашки
                $all_variants = $this->variants->get_variants(['product_id' => $products_ids]);
                foreach ($all_variants as $v) {
                    $cart->products_variants[$v->product_id][$v->id] = $v->name1;
                }
			
				foreach($items as $variant_id=>$item)
				{	
					$purchase = null;
					if(!empty($products[$item->variant->product_id]))
					{
						$purchase = new stdClass();
						$purchase->product = $products[$item->variant->product_id];						
						$purchase->variant = $item->variant;
						$purchase->amount = $item->amount;

						$cart->purchases[] = $purchase;
						$cart->total_price += $item->variant->price*$item->amount;
						if($this->request->get('module', 'string')=="CartView" || $this->request->ajax()){
							$cart->total_weight += $item->amount*$this->features->get_product_option_weight($item->variant->product_id); 
							$cart->total_volume += $item->amount*$this->features->get_product_option_volume($item->variant->product_id);
						}
						$cart->total_products += $item->amount;
					}
				}
				
				// Discount system
				
				if($this->design->is_android_browser() && !empty($this->settings->mob_discount)) {                      
                    $mob_discount = $this->settings->mob_discount;     
                } else {$mob_discount = 0;}
                
				$enable_discountgroup = $this->discountgroup->get_config_discount('enable_groupdiscount');
                switch ($enable_discountgroup){
                	case 1:
                        if(isset($_SESSION['user_id']) && $user = $this->users->get_user(intval($_SESSION['user_id']))){
                            $cart->discount2 = $user->discount;
                        }else{
                            $cart->discount2 = 0; 	
                        }    
                        $cart->total_price *= (100-($cart->discount2+$mob_discount))/100;
                        $cart->full_discount = $cart->discount2 + $mob_discount;            
                    break;
                	case 2:
                        $value_discountgroup = (int)$this->discountgroup->get_value_discount($cart->total_price);
                        if ($value_discountgroup==0){
                            $value_discountgroup = (int)$this->discountgroup->get_max_discount($cart->total_price); 
                        }
                        $cart->total_price *= (100-($value_discountgroup+$mob_discount))/100;
                        $cart->value_discountgroup = $value_discountgroup;
                        $cart->full_discount = $value_discountgroup + $mob_discount;
                    break;
					case 3:
                        $discount = 0;
                        if(isset($_SESSION['user_id']) && $user = $this->users->get_user(intval($_SESSION['user_id']))){
                            $cart->discount2 = $user->discount;
                        }else{
                            $cart->discount2 = 0; 	
                        }    
                        $price_total_vr = $cart->total_price;
                        $price_first_discount = $cart->total_price - $cart->total_price*$cart->discount2/100;
                        $value_discountgroup = (int)$this->discountgroup->get_value_discount($price_first_discount);
                        if ($value_discountgroup==0){
                            $value_discountgroup = (int)$this->discountgroup->get_max_discount($price_first_discount); 
                        }
                        $cart->total_price = $cart->total_price - $cart->total_price*($cart->discount2+$value_discountgroup+$mob_discount)/100;
						if ($cart->total_price<0)
							$cart->total_price==0;
                        $cart->value_discountgroup = $value_discountgroup;
                        $cart->full_discount = $cart->discount2 + $value_discountgroup + $mob_discount;
                    break;
					case 4:
                        $discount = 0;
                        if(isset($_SESSION['user_id']) && $user = $this->users->get_user(intval($_SESSION['user_id']))){
                            $cart->discount2 = $user->discount + $user->tdiscount;
                        }else{
                            $cart->discount2 = 0; 	
                        }    
                        $price_total_vr = $cart->total_price;
                        $price_first_discount = $cart->total_price - $cart->total_price*$cart->discount2/100;
                        $value_discountgroup = (int)$this->discountgroup->get_value_discount($price_first_discount);
                        if ($value_discountgroup==0){
                            $value_discountgroup = (int)$this->discountgroup->get_max_discount($price_first_discount); 
                        }
                        $cart->total_price = $cart->total_price - $cart->total_price*($cart->discount2+$value_discountgroup+$mob_discount)/100;
						if($cart->total_price<0)
							$cart->total_price = 0;
                        $cart->value_discountgroup = $value_discountgroup;
                        $cart->full_discount = $cart->discount2 + $value_discountgroup + $mob_discount;
                    break; 
					case 5:
                        if(isset($_SESSION['user_id']) && $user = $this->users->get_user(intval($_SESSION['user_id']))){
                            $cart->discount2 = $user->tdiscount;
                        }else{
                            $cart->discount2 = 0; 	
                        }    
                        $cart->total_price *= (100-($cart->discount2+$mob_discount))/100;                       
                        $cart->full_discount = $cart->discount2 + $mob_discount;           
                    break;
					default :
                        if (isset($cart->value_discountgroup)){
                            unset($cart->value_discountgroup);
                        }
                    break;   
                }
				// discount system end

				// Скидка по купону
				if(isset($_SESSION['coupon_code']))
				{
					$cart->coupon = $this->coupons->get_coupon($_SESSION['coupon_code']);
					if($cart->coupon && $cart->coupon->valid && $cart->total_price>=$cart->coupon->min_order_price)
					{
						if($cart->coupon->type=='absolute')
						{
							// Абсолютная скидка не более суммы заказа
							$cart->coupon_discount = $cart->total_price>$cart->coupon->value?$cart->coupon->value:$cart->total_price;
							$cart->total_price = max(0, $cart->total_price-$cart->coupon->value);
						}
						else
						{
							$cart->coupon_discount = $cart->total_price * ($cart->coupon->value)/100;
							$cart->total_price = $cart->total_price-$cart->coupon_discount;
						}
					}
					else
					{
						unset($_SESSION['coupon_code']);
					}
				}
				
			}
		}
			
		return $cart;
	}
	
	/*
	*
	* Добавление варианта товара в корзину
	*
	*/
	public function add_item($variant_id, $amount = 1)
	{ 
		
		if($this->settings->cart_storage == 0) {
			foreach($_COOKIE as $key => $cookie)
			{
				if(strpos($key, 't_') != false)
				{
					$id = str_replace('ct_', '', $key);
					$session_items[$id] = $cookie;
				}
			}
        }
	
		if($this->settings->cart_storage == 1 || $this->settings->cart_storage == 2) {
			if(isset($_SESSION['ct'][$variant_id]))
      			$amount = max(1, $amount+$_SESSION['ct'][$variant_id]);
		} else {
			if(isset($session_items[$variant_id]))
            	$amount = max(1, $amount+$session_items[$variant_id]);	
		}
		// Выберем товар из базы, заодно убедившись в его существовании
		$variant = $this->variants->get_variant($variant_id);

		// Если товар существует, добавим его в корзину
		if(!empty($variant) && ($variant->stock>0) )
		{
			// Не дадим больше чем на складе
			$amount = min($amount, $variant->stock);
	     
	     	if($this->settings->cart_storage == 1) {
				$_SESSION['ct'][$variant_id] = intval($amount); 
			} elseif($this->settings->cart_storage == 2) {
				$_SESSION['ct'][$variant_id] = intval($amount); 
				$this->cart_to_base();
			} else {
				setcookie("ct_".$variant_id,$amount,time()+31536000,"/");	
				header("Location: " . $_SERVER["PHP_SELF"]);
			}
		}
	}
	
	/*
	*
	* Обновление количества товара
	*
	*/
	public function update_item($variant_id, $amount = 1)
	{
		$amount = max(1, $amount);
		
		// Выберем товар из базы, заодно убедившись в его существовании
		$variant = $this->variants->get_variant($variant_id);

		// Если товар существует, добавим его в корзину
		if(!empty($variant) && $variant->stock>0)
		{
			// Не дадим больше чем на складе
			$amount = min($amount, $variant->stock);
	     
	     	if($this->settings->cart_storage == 1) {
				$_SESSION['ct'][$variant_id] = intval($amount); 
			} elseif($this->settings->cart_storage == 2) {
				$_SESSION['ct'][$variant_id] = intval($amount); 
				$this->cart_to_base();	
			} else {
				setcookie("ct_".$variant_id,$amount,time()+31536000,"/");
			}
		}
 
	}
	
	/*
	*
	* Удаление товара из корзины
	*
	*/
	public function delete_item($variant_id)
	{
		if($this->settings->cart_storage == 1) {
			unset($_SESSION['ct'][$variant_id]); 
		} elseif($this->settings->cart_storage == 2) {
			unset($_SESSION['ct'][$variant_id]);
			$this->cart_to_base();
		} else {
			setcookie("ct_".$variant_id,"",time()-31536000,"/");
		}
	}
	
	/*
	*
	* Очистка корзины
	*
	*/
	public function empty_cart()
	{
		if($this->settings->cart_storage == 1) {
			unset($_SESSION['ct']);
		} elseif($this->settings->cart_storage == 2) {
			unset($_SESSION['ct']);
			$this->cart_to_base();
		} else {
			foreach($_COOKIE as $key => $cookie)
			{
				if(strpos($key, 't_') != false)
				{
					setcookie($key, '', time()-31536000, "/");
				}
			}
		}
		unset($_SESSION['coupon_code']);
	}
 
	/*
	*
	* Применить купон
	*
	*/
	public function apply_coupon($coupon_code)
	{
		$coupon = $this->coupons->get_coupon((string)$coupon_code);
		if($coupon && $coupon->valid)
		{
			$_SESSION['coupon_code'] = $coupon->code;
		}
		else
		{
			unset($_SESSION['coupon_code']);
		}		
	} 
	
	/*
	*
	* Store cart in DB
	*
	*/
	public function cart_to_base()
	{
		$query = $this->db->placehold("DELETE FROM __carts WHERE code=?", $_COOKIE['ct_code']);
		$this->db->query($query);
		if($_SESSION['user_id']){
			$query = $this->db->placehold("DELETE FROM __carts WHERE user_id=?", $_SESSION['user_id']);
			$this->db->query($query);
		} 

		if($_SESSION['ct']){
			$query = $this->db->placehold("INSERT IGNORE INTO __carts SET code=?, user_id=?, cart=?", $_COOKIE['ct_code'], 0, serialize((array)$_SESSION['ct']));
			$this->db->query($query);
			if($_SESSION['user_id']){
				$query = $this->db->placehold("INSERT IGNORE INTO __carts SET code=?, user_id=?, cart=?", '', $_SESSION['user_id'], serialize((array)$_SESSION['ct']));
				$this->db->query($query);
			} 
		}
	}

	public function base_to_cart($param, $add='max')
	{
		if(empty($param)) return;

		$this->db->query("SELECT cart FROM __carts WHERE code=? OR (user_id>0 AND user_id=?) LIMIT 1", $param, $param);

		if($c=$this->db->result('cart'))
		$bcs = unserialize($c);

		if ($bcs){
		if($add=='max'){
			if(is_array($bcs))foreach ($bcs as $variant_id => $amount) {
				if(isset($_SESSION['ct'][$variant_id]))
					$_SESSION['ct'][$variant_id]=max($_SESSION['ct'][$variant_id], (int)$amount);
				else
					$_SESSION['ct'][$variant_id]=$amount;
			}
		}else
			$_SESSION['ct']=$bcs;
		}
		$this->check_cart();
	}

	public function check_cart()
	{
		$sc=(array)$_SESSION['ct'];
		$variant_ids=array_keys($sc);

		if(empty($variant_ids))
			return;

		$_SESSION['ct']=array(); 

		$variants=$this->variants->get_variants(array('id' => $variant_ids));
		if(is_array($variants))foreach ($variants as $variant) {
			$vids[]=$variant->id;
		}

		if(is_array($variants))foreach ($variants as $variant) {
			$id=$variant->id;
			if(!($sc[$id]>0))continue;
			if($variant->infinity)
				$_SESSION['ct'][$id]=$sc[$id]; 
			elseif($sc[$id]<=$variant->stock)
				$_SESSION['ct'][$id]=$sc[$id]; 
			elseif($variant->stock>0)
				$_SESSION['ct'][$id]=$variant->stock; 
		}
	}

	
}
