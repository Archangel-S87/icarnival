<?php

require_once('Fivecms.php');

class Orders extends Fivecms
{
	/* Выборка конкретного заказа */
	public function get_order($id)
	{
		if (empty($id)) {
            return false;
        }
		if(is_int($id))
			$where = $this->db->placehold(' WHERE o.id=? ', intval($id));
		else
			$where = $this->db->placehold(' WHERE o.url=? ', $id);
		
		$query = $this->db->placehold("SELECT * FROM __orders o $where LIMIT 1");

		if($this->db->query($query))
			return $this->db->result();
		else
			return false; 
	}
	
	/* Выборка всех заказов */
	function get_orders($filter = array())
	{
		// По умолчанию
		$limit = 200;
		$page = 1;
		$keyword_filter = '';	
		$label_filter = '';	
		$status_filter = '';
		$user_filter = '';	
		$modified_since_filter = '';	
		$id_filter = '';
		$date_filter = '';
		$order = 'status';
		
		if(isset($filter['limit']))
			$limit = max(1, intval($filter['limit']));

		if(isset($filter['page']))
			$page = max(1, intval($filter['page']));

		$sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
		
		if(isset($filter['status']))
			$status_filter = $this->db->placehold('AND o.status = ?', intval($filter['status']));
		
		if(isset($filter['id']))
			$id_filter = $this->db->placehold('AND o.id in(?@)', (array)$filter['id']);
		
		if(isset($filter['user_id']))
			$user_filter = $this->db->placehold('AND o.user_id = ?', intval($filter['user_id']));	

		/* Фильтр по дате */
		// Заказа
		if(isset($filter['date_from']) && !isset($filter['date_to'])){
			$date_filter = $this->db->placehold('AND o.date > ?', $filter['date_from']);
		}
		elseif(isset($filter['date_to']) && !isset($filter['date_from'])){
			$date_filter = $this->db->placehold('AND o.date < ?', $filter['date_to']);
		}
		elseif(isset($filter['date_to']) && isset($filter['date_from'])){
			$date_filter = $this->db->placehold('AND (o.date BETWEEN ? AND ?)', $filter['date_from'], $filter['date_to']);
		}
		// Отправки
		if(isset($filter['date_from_ship']) && !isset($filter['date_to_ship'])){
			$date_filter = $this->db->placehold('AND o.shipping_date > ?', $filter['date_from_ship']);
			$order = 'shipping_date';
		}
		elseif(isset($filter['date_to_ship']) && !isset($filter['date_from_ship'])){
			$date_filter = $this->db->placehold('AND o.shipping_date < ?', $filter['date_to_ship']);
			$order = 'shipping_date';
		}
		elseif(isset($filter['date_to_ship']) && isset($filter['date_from_ship'])){
			$date_filter = $this->db->placehold('AND (o.shipping_date BETWEEN ? AND ?)', $filter['date_from_ship'], $filter['date_to_ship']);
			$order = 'shipping_date';
		}
		/* Фильтр по дате @*/
		
		if(isset($filter['modified_since']))
			$modified_since_filter = $this->db->placehold('AND o.modified > ?', $filter['modified_since']);

		if(!empty($filter['label']))
			$label_filter = $this->db->placehold('AND ol.label_id in(?@)', (array)$filter['label']); 	
		
		if(!empty($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
				$keyword_filter .= $this->db->placehold('AND (o.id = "'.$this->db->escape(trim($keyword)).'" OR o.name LIKE "%'.$this->db->escape(trim($keyword)).'%" OR o.email LIKE "%'.$this->db->escape(trim($keyword)).'%" OR REPLACE(o.phone, "-", "")  LIKE "%'.$this->db->escape(str_replace('-', '', trim($keyword))).'%" OR o.address LIKE "%'.$this->db->escape(trim($keyword)).'%" OR o.comment LIKE "%'.$this->db->escape(trim($keyword)).'%" )');
		}
		
		// Выбираем заказы
		$query = $this->db->placehold("SELECT o.id, o.delivery_id, o.delivery_price, o.separate_delivery,
										o.payment_method_id, o.paid, o.payment_date, o.closed, o.discount, o.bonus_discount, o.discount2, o.discount_group, o.coupon_code, o.coupon_discount,
										o.date, o.user_id, o.name, o.address, o.phone, o.email, o.comment, o.status,
										o.url, o.total_price, o.note, o.track, o.bonused, o.shipping_date, o.referer, o.source, o.utm, o.yclid
									FROM __orders AS o 
									LEFT JOIN __orders_labels AS ol ON o.id=ol.order_id 
									WHERE 1
									$id_filter $status_filter $user_filter $keyword_filter $date_filter $label_filter $modified_since_filter GROUP BY o.id ORDER BY $order, id DESC $sql_limit", "%Y-%m-%d");
		$this->db->query($query);
		$orders = array();
		foreach($this->db->results() as $order)
			$orders[$order->id] = $order;
		return $orders;
	}

	function count_orders($filter = array())
	{
		$keyword_filter = '';	
		$label_filter = '';	
		$modified_since_filter = '';
		$status_filter = '';
		$user_filter = '';
		$date_filter = '';
		
		if(isset($filter['status']))
			$status_filter = $this->db->placehold('AND o.status = ?', intval($filter['status']));
		
		if(isset($filter['user_id']))
			$user_filter = $this->db->placehold('AND o.user_id = ?', intval($filter['user_id']));

		if(!empty($filter['label']))
			$label_filter = $this->db->placehold('AND ol.label_id in(?@)', (array)$filter['label']); 	
			
		/* Фильтр по дате */
		// Заказа
		if(isset($filter['date_from']) && !isset($filter['date_to'])){
			$date_filter = $this->db->placehold('AND o.date > ?', $filter['date_from']);
		}
		elseif(isset($filter['date_to']) && !isset($filter['date_from'])){
			$date_filter = $this->db->placehold('AND o.date < ?', $filter['date_to']);
		}
		elseif(isset($filter['date_to']) && isset($filter['date_from'])){
			$date_filter = $this->db->placehold('AND (o.date BETWEEN ? AND ?)', $filter['date_from'], $filter['date_to']);
		}
		// Отправки
		if(isset($filter['date_from_ship']) && !isset($filter['date_to_ship'])){
			$date_filter = $this->db->placehold('AND o.shipping_date > ?', $filter['date_from_ship']);
		}
		elseif(isset($filter['date_to_ship']) && !isset($filter['date_from_ship'])){
			$date_filter = $this->db->placehold('AND o.shipping_date < ?', $filter['date_to_ship']);
		}
		elseif(isset($filter['date_to_ship']) && isset($filter['date_from_ship'])){
			$date_filter = $this->db->placehold('AND (o.shipping_date BETWEEN ? AND ?)', $filter['date_from_ship'], $filter['date_to_ship']);
		}
		/* Фильтр по дате @*/	
			
		if (isset($filter['modified_since'])) {
			$modified_since_filter = $this->db->placehold('AND o.modified > ?', $filter['modified_since']);
        }
		
		if(!empty($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
				$keyword_filter .= $this->db->placehold('AND (o.name LIKE "%'.$this->db->escape(trim($keyword)).'%" OR o.email LIKE "%'.$this->db->escape(trim($keyword)).'%" OR REPLACE(o.phone, "-", "")  LIKE "%'.$this->db->escape(str_replace('-', '', trim($keyword))).'%" OR o.address LIKE "%'.$this->db->escape(trim($keyword)).'%" )');
				
		}
		
		// Выбираем заказы
		$query = $this->db->placehold("SELECT COUNT(DISTINCT id) as count
									FROM __orders AS o 
									LEFT JOIN __orders_labels AS ol ON o.id=ol.order_id 
									WHERE 1
									$status_filter $user_filter $keyword_filter $date_filter $label_filter $modified_since_filter");
		$this->db->query($query);
		return $this->db->result('count');
	}

	function all_count_orders()
	{
		$all_count = array();
		$query = $this->db->placehold("SELECT status, count(status) kolvo FROM __orders GROUP BY status");
		$this->db->query($query);	
		foreach ($this->db->results() as $v)
			$all_count[$v->status] = $v->kolvo;
		return $all_count;
	}

	public function update_order($id, $order)
	{
		$query = $this->db->placehold("UPDATE __orders SET ?%, modified=now() WHERE id=? LIMIT 1", $order, intval($id));
		$this->db->query($query);
		$this->update_total_price(intval($id));
		
		$order = $this->get_order(intval($id));

		return $id;
	}

	public function delete_order($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __purchases WHERE order_id=?", $id);
			$this->db->query($query);
			
			$query = $this->db->placehold("DELETE FROM __orders_labels WHERE order_id=?", $id);
			$this->db->query($query);

			$query = $this->db->placehold("DELETE FROM __orders WHERE id=? LIMIT 1", $id);
			$this->db->query($query);
			
			// удаление прикрепленных файлов
			$current_files = $this->files->get_files(array('object_id'=>$id,'type'=>'order'));
			foreach($current_files as $file)
				$this->files->delete_file($file->id);
			// удаление прикрепленных файлов end
		}
	}
	
	public function add_order($order)
	{
		$order = (object)$order;
		$order->url = md5(uniqid($this->config->salt, true));
		$set_curr_date = '';
		if(empty($order->date))
			$set_curr_date = ', date=now()';
		$query = $this->db->placehold("INSERT INTO __orders SET ?%$set_curr_date", $order);
		$this->db->query($query);
		$id = $this->db->insert_id();		
		return $id;
	}

	public function get_label($id)
	{
		$query = $this->db->placehold("SELECT * FROM __labels WHERE id=? LIMIT 1", intval($id));
		$this->db->query($query);
		return $this->db->result();
	}

	public function get_labels()
	{
		$query = $this->db->placehold("SELECT * FROM __labels ORDER BY position");
		$this->db->query($query);
		return $this->db->results();
	}

	/*
	* Создание метки заказов
	* @param $label
	*/	
	public function add_label($label)
	{	
		$query = $this->db->placehold('INSERT INTO __labels SET ?%', $label);
		if(!$this->db->query($query))
			return false;

		$id = $this->db->insert_id();
		$this->db->query("UPDATE __labels SET position=id WHERE id=?", $id);	
		return $id;
	}
	
	/*
	* Обновить метку
	* @param $id, $label
	*/	
	public function update_label($id, $label)
	{
		$query = $this->db->placehold("UPDATE __labels SET ?% WHERE id in(?@) LIMIT ?", $label, (array)$id, count((array)$id));
		$this->db->query($query);
		return $id;
	}

	/*
	* Удалить метку
	* @param $id
	*/	
	public function delete_label($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __orders_labels WHERE label_id=?", intval($id));
			if($this->db->query($query))
			{
				$query = $this->db->placehold("DELETE FROM __labels WHERE id=? LIMIT 1", intval($id));
				return $this->db->query($query);
			}
			else
			{
				return false;
			}
		}
	}	
	
	function get_order_labels($order_id = array())
	{
		if(empty($order_id))
			return array();

		$label_id_filter = $this->db->placehold('AND order_id in(?@)', (array)$order_id);
				
		$query = $this->db->placehold("SELECT ol.order_id, l.id, l.name, l.color, l.position
					FROM __labels l LEFT JOIN __orders_labels ol ON ol.label_id = l.id
					WHERE 
					1
					$label_id_filter   
					ORDER BY position       
					");
		
		$this->db->query($query);
		return $this->db->results();
	}
	
	public function update_order_labels($id, $labels_ids)
	{
		$labels_ids = (array)$labels_ids;
		$query = $this->db->placehold("DELETE FROM __orders_labels WHERE order_id=?", intval($id));
		$this->db->query($query);
		if(is_array($labels_ids))
		foreach($labels_ids as $l_id)
			$this->db->query("INSERT INTO __orders_labels SET order_id=?, label_id=?", $id, $l_id);
	}

	public function add_order_labels($id, $labels_ids)
	{
		$labels_ids = (array)$labels_ids;
		if(is_array($labels_ids))
		foreach($labels_ids as $l_id)
		{
			$this->db->query("INSERT IGNORE INTO __orders_labels SET order_id=?, label_id=?", $id, $l_id);
		}
	}

	public function delete_order_labels($id, $labels_ids)
	{
		$labels_ids = (array)$labels_ids;
		if(is_array($labels_ids))
		foreach($labels_ids as $l_id)
			$this->db->query("DELETE FROM __orders_labels WHERE order_id=? AND label_id=?", $id, $l_id);
	}

	/* Выборка покупки по его ID */
	public function get_purchase($id)
	{
		$query = $this->db->placehold("SELECT * FROM __purchases WHERE id=? LIMIT 1", intval($id));
		$this->db->query($query);
		return $this->db->result();
	}

	/* Выборка списка покупок с заказов */
	public function get_purchases($filter = array())
	{
		$order_id_filter = '';
		if(!empty($filter['order_id']))
			$order_id_filter = $this->db->placehold('AND order_id in(?@)', (array)$filter['order_id']);

		$query = $this->db->placehold("SELECT * FROM __purchases WHERE 1 $order_id_filter ORDER BY id");
		$this->db->query($query);
		return $this->db->results();
	}
	
	/* Обновление покупки (товара) */
	public function update_purchase($id, $purchase)
	{	
		$purchase = (object)$purchase;
		$old_purchase = $this->get_purchase($id);
		if(!$old_purchase)
			return false;
			
		$order = $this->get_order(intval($old_purchase->order_id));
		if(!$order)
			return false;
			
		// Не допустить нехватки на складе
        $variant = $this->variants->get_variant($purchase->variant_id);
        if($order->closed && !empty($purchase->amount) && !empty($variant) && !$variant->infinity && $variant->stock<($purchase->amount-$old_purchase->amount)) {
            return false;
        }
			
		// Если заказ закрыт, нужно обновить склад при изменении покупки
		if($order->closed && !empty($purchase->amount))
		{
			if($old_purchase->variant_id != $purchase->variant_id)
			{
				if(!empty($old_purchase->variant_id))
				{
					$query = $this->db->placehold("UPDATE __variants SET stock=stock+? WHERE id=? AND stock IS NOT NULL LIMIT 1", $old_purchase->amount, $old_purchase->variant_id);
					$this->db->query($query);
				}
				if(!empty($purchase->variant_id))
				{
					$query = $this->db->placehold("UPDATE __variants SET stock=stock-? WHERE id=? AND stock IS NOT NULL LIMIT 1", $purchase->amount, $purchase->variant_id);
					$this->db->query($query);
				}
			}
			elseif(!empty($purchase->variant_id))
			{
				$query = $this->db->placehold("UPDATE __variants SET stock=stock+(?) WHERE id=? AND stock IS NOT NULL LIMIT 1", $old_purchase->amount - $purchase->amount, $purchase->variant_id);
				$this->db->query($query);
			}
		}
		
		$query = $this->db->placehold("UPDATE __purchases SET ?% WHERE id=? LIMIT 1", $purchase, intval($id));
		$this->db->query($query);
		$this->update_total_price($order->id);		
		return $id;
	}
	
	/* Добавление покупки (товара в заказе) */
	public function add_purchase($purchase)
	{
		$purchase = (object)$purchase;
		if(!empty($purchase->variant_id))
		{
			$variant = $this->variants->get_variant($purchase->variant_id);
			if(empty($variant))
				return false;
			$product = $this->products->get_product(intval($variant->product_id));
			if(empty($product))
				return false;
		}			

		$order = $this->get_order(intval($purchase->order_id));
		if(empty($order))
			return false;				
	
		// Не допустить нехватки на складе
        if($order->closed && !empty($purchase->amount) && !$variant->infinity && $variant->stock<$purchase->amount) {
            return false;
        }
        
        // Не дать добавить в новый заказ отсутствующий товар 
        if(!$order->closed && !empty($purchase->amount) && !$variant->infinity && $variant->stock == 0) {
            return false;
        }
        
		if(!isset($purchase->product_id) && isset($variant))
			$purchase->product_id = $variant->product_id;
				
		if(!isset($purchase->product_name)  && !empty($product))
			$purchase->product_name = $product->name;
			
		if(!isset($purchase->sku) && !empty($variant))
			$purchase->sku = $variant->sku;
			
		if(!isset($purchase->unit)){
			if(!empty($variant->unit))
				$purchase->unit = $variant->unit;
			else
				$purchase->unit = $this->settings->units;
		}	
			
		if(!isset($purchase->variant_name) && !empty($variant))
			$purchase->variant_name = $variant->name;
			
		if(!isset($purchase->price) && !empty($variant))
			$purchase->price = $variant->price;
			
		if(!isset($purchase->amount))
			$purchase->amount = 1;

		// Если заказ закрыт, нужно обновить склад при добавлении покупки
		if($order->closed && !empty($purchase->amount) && !empty($variant->id))
		{
			$stock_diff = $purchase->amount;
			$query = $this->db->placehold("UPDATE __variants SET stock=stock-? WHERE id=? AND stock IS NOT NULL LIMIT 1", $stock_diff, $variant->id);
			$this->db->query($query);
		}

		$query = $this->db->placehold("INSERT INTO __purchases SET ?%", $purchase);
		$this->db->query($query);
		$purchase_id = $this->db->insert_id();
		
		$this->update_total_price($order->id);		
		return $purchase_id;
	}

	/* Удаление покупки */
	public function delete_purchase($id)
	{
		$purchase = $this->get_purchase($id);
		if(!$purchase)
			return false;
			
		$order = $this->get_order(intval($purchase->order_id));
		if(!$order)
			return false;

		// Если заказ закрыт, нужно обновить склад при изменении покупки
		if($order->closed && !empty($purchase->amount))
		{
			$stock_diff = $purchase->amount;
			$query = $this->db->placehold("UPDATE __variants SET stock=stock+? WHERE id=? AND stock IS NOT NULL LIMIT 1", $stock_diff, $purchase->variant_id);
			$this->db->query($query);
		}
		
		$query = $this->db->placehold("DELETE FROM __purchases WHERE id=? LIMIT 1", intval($id));
		$this->db->query($query);
		$this->update_total_price($order->id);				
		return true;
	}

	/* Закрытие заказа (списание со склада) */
	public function close($order_id)
	{
		$order = $this->get_order(intval($order_id));
		if(empty($order))
			return false;
		
		if(!$order->closed)
		{
			$variants_amounts = array();
			$purchases = $this->get_purchases(array('order_id'=>$order->id));
			foreach($purchases as $purchase)
			{
				if(isset($variants_amounts[$purchase->variant_id]))
					$variants_amounts[$purchase->variant_id] += $purchase->amount;
				else
					$variants_amounts[$purchase->variant_id] = $purchase->amount;
			}

			foreach($variants_amounts as $id=>$amount)
			{
				$variant = $this->variants->get_variant($id);
				if(empty($variant) || ($variant->stock<$amount))
					return false;
			}
			foreach($purchases as $purchase)
			{	
				$variant = $this->variants->get_variant($purchase->variant_id);
				if(!$variant->infinity)
				{
					$new_stock = $variant->stock-$purchase->amount;
					$this->variants->update_variant($variant->id, array('stock'=>$new_stock));
				}
			}				
			$query = $this->db->placehold("UPDATE __orders SET closed=1, modified=NOW() WHERE id=? LIMIT 1", $order->id);
			$this->db->query($query);
		}
		return $order->id;
	}

	/* Открытие заказа (возвращение на склад) */
	public function open($order_id)
	{
		$order = $this->get_order(intval($order_id));
		if(empty($order))
			return false;
		// Кроме выполненных и удаленных заказов
		if($order->closed && $order->status!=2 && $order->status!=3)
		{
			$purchases = $this->get_purchases(array('order_id'=>$order->id));
			foreach($purchases as $purchase)
			{
				$variant = $this->variants->get_variant($purchase->variant_id);				
				if($variant && !$variant->infinity)
				{
					$new_stock = $variant->stock+$purchase->amount;
					$this->variants->update_variant($variant->id, array('stock'=>$new_stock));
				}
			}				
			$query = $this->db->placehold("UPDATE __orders SET closed=0, modified=NOW() WHERE id=? LIMIT 1", $order->id);
			$this->db->query($query);
		}
		return $order->id;
	}
	
	/* Закрытие заказа для 1С(без списания со склада) */
	public function close_for_1c($order_id)
	{
		$order = $this->get_order(intval($order_id));
		if(empty($order))
			return false;
		
		if(!$order->closed)
		{
			$query = $this->db->placehold("UPDATE __orders SET closed=1, modified=NOW() WHERE id=? LIMIT 1", $order->id);
			$this->db->query($query);
		}
		return $order->id;
	}
	
	/* Открытие заказа для 1С(без возвращения на склад) */
	public function open_for_1c($order_id)
	{
		$order = $this->get_order(intval($order_id));
		if(empty($order))
			return false;
		
		if($order->closed)
		{	
			$query = $this->db->placehold("UPDATE __orders SET closed=0, modified=NOW() WHERE id=? LIMIT 1", $order->id);
			$this->db->query($query);
		}
		return $order->id;
	}
	
	/* может использоваться в старых платежных модулях*/
	public function pay($order_id)
	{
		$order = $this->get_order(intval($order_id));
		if(empty($order))
			return false;
		
		if(!$this->close($order->id))
			return false;
		
		$query = $this->db->placehold("UPDATE __orders SET paid=1, payment_date=NOW(), modified=NOW() WHERE id=? LIMIT 1", $order->id);
		$this->db->query($query);
		
		$this->bonus_add($order);
		
		return $order->id;
	}
	
	/* При смене статуса оплачен */
	public function set_pay($order_id)
	{
		$order = $this->get_order(intval($order_id));
		if(empty($order))
			return false;
		if($order->paid == 1 && $order->bonused == 1)
			return false;

		$query = $this->db->placehold("UPDATE __orders SET paid=1, payment_date=NOW(), modified=NOW() WHERE id=? LIMIT 1", $order->id);
		$this->db->query($query);
		
		$this->bonus_add($order);

		return $order->id;
	}
	
	public function unset_pay($order_id)
	{
		$order = $this->get_order(intval($order_id));
		if(empty($order))
			return false;
		if($order->paid == 0 && $order->bonused != 1)
			return false;

		$query = $this->db->placehold("UPDATE __orders SET paid=0, modified=NOW() WHERE id=? LIMIT 1", $order->id);
		$this->db->query($query);

		$this->bonus_remove($order);

		return $order->id;
	}
	
	/* Операции с бонусными баллами и обновление суммы оплаченных заказов */
	function bonus_add($order){
		if (isset($order->user_id) && $order->bonused != 1) {
			$query = $this->db->placehold("UPDATE __orders SET bonused=1 WHERE id=? LIMIT 1", $order->id);
			$this->db->query($query);
			$user = $this->users->get_user(intval($order->user_id));
			if(!empty($user)) {
				$this->users->update_user($user->id, array('order_payd' => ($user->order_payd + $order->total_price)));
			}	
			if(!empty($user) && $this->settings->bonus_order > 0) {
				$this->users->update_user($user->id, array('balance' => ($user->balance + $order->total_price * $this->settings->bonus_order / 100 )));
			}			
			if(!empty($user) && !empty($user->partner_id) && $this->settings->ref_order > 0) {
				$partner = $this->users->get_user(intval($user->partner_id));
				if(!empty($partner) && $partner->enabled) {
					$this->users->update_user($partner->id, array('balance' => ($partner->balance + $order->total_price * $this->settings->ref_order / 100 )));
				}
			}
		}
	}
	
	function bonus_remove($order){
		if(isset($order->user_id) && $order->bonused == 1) {
			$query = $this->db->placehold("UPDATE __orders SET bonused=0 WHERE id=? LIMIT 1", $order->id);
			$this->db->query($query);
			$user = $this->users->get_user(intval($order->user_id));
			if(!empty($user)) {
				$this->users->update_user($user->id, array('order_payd' => ($user->order_payd - $order->total_price)));
			}	
			if(!empty($user) && $this->settings->bonus_order > 0) {
				$this->users->update_user($user->id, array('balance' => ($user->balance - $order->total_price * $this->settings->bonus_order / 100 )));
			}			
			if(!empty($user) && !empty($user->partner_id) && $this->settings->ref_order > 0) {
				$partner = $this->users->get_user(intval($user->partner_id));
				if(!empty($partner) && $partner->enabled) {
					$this->users->update_user($partner->id, array('balance' => ($partner->balance - $order->total_price * $this->settings->ref_order / 100 )));
				}
			}
		}
	}
	
	/* Обновление итого заказа */
	private function update_total_price($order_id)
    {
        $order = $this->get_order(intval($order_id));
        if (empty($order)) {
            return false;
        }
        $query = $this->db->placehold("UPDATE __orders o SET o.total_price=IFNULL((SELECT SUM(p.price*p.amount)*(100-o.discount)/100 FROM __purchases p WHERE p.order_id=o.id), 0)+o.delivery_price*(1-o.separate_delivery)-o.coupon_discount-o.bonus_discount, modified=NOW() WHERE o.id=? LIMIT 1", $order->id);
        
        $this->db->query($query);
        return $order->id;
    }
	
	public function get_next_order($id, $status = null)
	{
		$f = '';
		if($status!==null)
			$f = $this->db->placehold('AND status=?', $status);
		$this->db->query("SELECT MIN(id) as id FROM __orders WHERE id>? $f LIMIT 1", $id);
		$next_id = $this->db->result('id');
		if($next_id)
			return $this->get_order(intval($next_id));
		else
			return false; 
	}
	
	public function get_prev_order($id, $status = null)
	{
		$f = '';
		if($status !== null)
			$f = $this->db->placehold('AND status=?', $status);
		$this->db->query("SELECT MAX(id) as id FROM __orders WHERE id<? $f LIMIT 1", $id);
		$prev_id = $this->db->result('id');
		if($prev_id)
			return $this->get_order(intval($prev_id));
		else
			return false; 
	}

    /**
     * Возвращает сумму прописью
     * @uses morph(...)
     * $onlyrub = true - выводить только рубли прописью, без единиц измерения и копеек
     */
    public function num2str($num, $onlyrub = false) {
        $nul='ноль';
        $ten=array(
            array('','один','два','три','четыре','пять','шесть','семь', 'восемь','девять'),
            array('','одна','две','три','четыре','пять','шесть','семь', 'восемь','девять'),
        );
        $a20=array('десять','одиннадцать','двенадцать','тринадцать','четырнадцать' ,'пятнадцать','шестнадцать','семнадцать','восемнадцать','девятнадцать');
        $tens=array(2=>'двадцать','тридцать','сорок','пятьдесят','шестьдесят','семьдесят' ,'восемьдесят','девяносто');
        $hundred=array('','сто','двести','триста','четыреста','пятьсот','шестьсот', 'семьсот','восемьсот','девятьсот');
        $unit=array( // Units
            array('копейка' ,'копейки' ,'копеек',	 1),
            array('рубль'   ,'рубля'   ,'рублей'    ,0),
            array('тысяча'  ,'тысячи'  ,'тысяч'     ,1),
            array('миллион' ,'миллиона','миллионов' ,0),
            array('миллиард','милиарда','миллиардов',0),
        );
        //
        list($rub,$kop) = explode('.',sprintf("%015.2f", floatval($num)));
        $out = array();
        if (intval($rub)>0) {
            foreach(str_split($rub,3) as $uk=>$v) { // by 3 symbols
                if (!intval($v)) continue;
                $uk = sizeof($unit)-$uk-1; // unit key
                $gender = $unit[$uk][3];
                list($i1,$i2,$i3) = array_map('intval',str_split($v,1));
                // mega-logic
                $out[] = $hundred[$i1]; # 1xx-9xx
                if ($i2>1) $out[]= $tens[$i2].' '.$ten[$gender][$i3]; # 20-99
                else $out[]= $i2>0 ? $a20[$i3] : $ten[$gender][$i3]; # 10-19 | 1-9
                // units without rub & kop
                if ($uk>1) $out[]= $this->morph($v,$unit[$uk][0],$unit[$uk][1],$unit[$uk][2]);
            } //foreach
        }
        else $out[] = $nul;
        if (!$onlyrub) {
            $out[] = $this->morph(intval($rub), $unit[1][0],$unit[1][1],$unit[1][2]); // rub
            $out[] = $kop.' '.$this->morph($kop,$unit[0][0],$unit[0][1],$unit[0][2]); // kop
        }
        return trim(preg_replace('/ {2,}/', ' ', join(' ',$out)));
    }

    /**
     * Склоняем словоформу
     */
    private function morph($n, $f1, $f2, $f5) {
        $n = abs(intval($n)) % 100;
        if ($n>10 && $n<20) return $f5;
        $n = $n % 10;
        if ($n>1 && $n<5) return $f2;
        if ($n==1) return $f1;
        return $f5;
    }

}
