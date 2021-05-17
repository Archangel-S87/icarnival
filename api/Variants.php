<?php

require_once('Fivecms.php');

class Variants extends Fivecms
{

	public function get_value_variants($filter = array(), $field)
    {        
        $product_id_filter = '';
        $instock_filter = '';

        if(!empty($filter['product_id']))
           $product_id_filter = $this->db->placehold('AND v.product_id in(?@)', (array)$filter['product_id']);
        if(!empty($filter['in_stock']) && $filter['in_stock'])
           $instock_filter = $this->db->placehold('AND (v.stock>0 OR v.stock IS NULL)');

        if(!$product_id_filter)
           return array();

        $query = $this->db->placehold("SELECT v.$field
                   FROM __variants AS v
                   WHERE
                   v.$field <> ''
                   $product_id_filter                  
                   $instock_filter
                   GROUP BY v.$field                  
                   ");

        $this->db->query($query);    
        return $this->db->results();
    } 

	public function get_variants($filter = array(), $admin = 0)
	{		
		$product_id_filter = '';
		$variant_id_filter = '';
		$instock_filter = '';
		$order_filter = 'ORDER BY v.position';
		
		$currencies = $this->money->get_currencies();
		
		if(!empty($filter['product_id']))
			$product_id_filter = $this->db->placehold('AND v.product_id in(?@)', (array)$filter['product_id']);
		
		if(!empty($filter['id']))
			$variant_id_filter = $this->db->placehold('AND v.id in(?@)', (array)$filter['id']);

		if(!empty($filter['in_stock']) && $filter['in_stock'])
			$instock_filter = $this->db->placehold('AND (v.stock>0 OR v.stock IS NULL)');

		if(!$product_id_filter && !$variant_id_filter)
			return array();

        if(!empty($filter['sort'])) {
            switch ($filter['sort']) {
                case 'product_id':
                    $order_filter = 'ORDER BY v.product_id';
            }
        }
		
		$query = $this->db->placehold("SELECT v.id, v.product_id , v.price, NULLIF(v.compare_price, 0) as compare_price, v.sku, IFNULL(v.stock, ?) as stock, (v.stock IS NULL) as infinity, v.name, v.name1, v.name2, v.unit, v.currency_id, v.attachment, v.position, v.discount, v.discount_date
					FROM __variants AS v
					WHERE 
					1
					$product_id_filter
					$variant_id_filter
					$instock_filter
					$order_filter
					", $this->settings->max_order_amount);
		
		$this->db->query($query);	
		//return $this->db->results();
		
		// multicurrency
		$variants = $this->db->results();
        
        foreach($variants as &$v) {
        
            // Скидка в варианте товара 1
            if($admin == 0 && $this->settings->variant_discount && $v->discount > 0){
            	if( (!empty($v->discount_date) && strtotime($v->discount_date) > time()) || empty($v->discount_date) ){
					$v->compare_price = $v->price;
					$v->price = $v->price*(100-$v->discount)/100;
				}
         	}
            // Скидка в варианте товара 1 @
            
            $v->oprice = $v->price;
            $v->compare_oprice = $v->compare_price;
            
            //делаем пересчет в базовый курс
            if($v->currency_id > 0 && !empty($currencies[$v->currency_id])) {
                $v->price = $v->price * $currencies[$v->currency_id]->rate_to / $currencies[$v->currency_id]->rate_from;
                $v->compare_price = $v->compare_price * $currencies[$v->currency_id]->rate_to / $currencies[$v->currency_id]->rate_from;
            }
            
            // округление копеек
            $base_currency = reset($currencies);
            $v->precision = isset($base_currency->cents)?$base_currency->cents:2;	
			$v->price = round($v->price, $v->precision);
			// округление копеек @
        }
        
        return $variants;
        // multicurrency end
	}
	
	public function get_variant($id, $admin = 0)
	{	
		if(empty($id))
			return false;
			
		$currencies = $this->money->get_currencies();
			
		$query = $this->db->placehold("SELECT v.id, v.product_id , v.price, NULLIF(v.compare_price, 0) as compare_price, v.sku, IFNULL(v.stock, ?) as stock, (v.stock IS NULL) as infinity, v.name, v.name1, v.name2, v.unit, v.currency_id, v.attachment, v.discount, v.discount_date
					FROM __variants v WHERE id=?
					LIMIT 1", $this->settings->max_order_amount, $id);
		
		$this->db->query($query);
		$variant = $this->db->result();
		
        // Скидка в варианте товара 2
        if($admin == 0 && $this->settings->variant_discount && $variant->discount > 0){
            if( (!empty($variant->discount_date) && strtotime($variant->discount_date) > time()) || empty($variant->discount_date) ){
				$variant->compare_price = $variant->price;
				$variant->price = $variant->price*(100-$variant->discount)/100;
			}
        }
        // Скидка в варианте товара 2 @
        
        // multicurrency
        $variant->oprice = $variant->price;
        $variant->compare_oprice = $variant->compare_price;
        //делаем пересчет в базовый курс
        if($variant->currency_id > 0 && !empty($currencies[$variant->currency_id])) {
            $variant->price = $variant->price * $currencies[$variant->currency_id]->rate_to / $currencies[$variant->currency_id]->rate_from;
            $variant->compare_price = $variant->compare_price * $currencies[$variant->currency_id]->rate_to / $currencies[$variant->currency_id]->rate_from;
        }
        // multicurrency end
        
        // округление копеек
        $base_currency = reset($currencies);
        $variant->precision = isset($base_currency->cents)?$base_currency->cents:2;	
		$variant->price = round($variant->price, $variant->precision);
        // округление копеек @
        
		return $variant;
	}
	
	public function update_variant($id, $variant)
	{
		$query = $this->db->placehold("UPDATE __variants SET ?% WHERE id=? LIMIT 1", $variant, intval($id));
		$this->db->query($query);
		return $id;
	}
	
	public function add_variant($variant)
	{
		$query = $this->db->placehold("INSERT INTO __variants SET ?%", $variant);
		$this->db->query($query);
		return $this->db->insert_id();
	}

	public function delete_variant($id)
	{
		if(!empty($id))
		{
			$this->delete_attachment($id);
			$query = $this->db->placehold("DELETE FROM __variants WHERE id = ? LIMIT 1", intval($id));
			$this->db->query($query);
			$this->db->query('UPDATE __purchases SET variant_id=NULL WHERE variant_id=?', intval($id));
		}
	}
	
	public function delete_attachment($id)
	{
		$query = $this->db->placehold("SELECT attachment FROM __variants WHERE id=?", $id);
		$this->db->query($query);
		$filename = $this->db->result('attachment');
		$query = $this->db->placehold("SELECT 1 FROM __variants WHERE attachment=? AND id!=?", $filename, $id);
		$this->db->query($query);
		$exists = $this->db->num_rows();
		if(!empty($filename) && $exists == 0)
			@unlink($this->config->root_dir.'/'.$this->config->downloads_dir.$filename);
		$this->update_variant($id, array('attachment'=>null));
	}
	
}
