<?php

require_once('Fivecms.php');

class ReportStat extends Fivecms
{
    function get_stat($filter = array()) { //Выборка товара
        $weekdays = array('вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб');
    
        $all_filters = $this->make_filter($filter);
        
        $query = $this->db->placehold("SELECT 
                o.total_price, 
                DATE_FORMAT(o.date,'%d.%m.%y') date, 
                DATE_FORMAT(o.date,'%w') weekday, 
                DATE_FORMAT(o.date,'%H') hour, 
                DATE_FORMAT(o.date,'%d') day, 
                DATE_FORMAT(o.date,'%m') month, 
                DATE_FORMAT(o.date,'%Y') year,
                o.status
            FROM __orders o
            LEFT JOIN __orders_labels AS ol ON o.id=ol.order_id 
            WHERE 1 $all_filters GROUP BY o.id ORDER BY o.date");
        $this->db->query($query);
        $data = $this->db->results();

        $group = 'day';
        if(isset($filter['date_filter']))
        {
            switch ($filter['date_filter']){
                case 'today':       $group = 'hour';    break;
                case 'yesterday':   $group = 'hour';    break;
                case 'last_24hour': $group = 'hour';    break;
                case 'this_year':   $group = 'month';   break;
                case 'last_year':   $group = 'month';   break;
                case 'all':         $group = 'month';   break;
            }
        }        
        
        $results = array();
        
        foreach($data as $d)
        {
            switch($group) {
                case 'hour':
                    $date = $d->year.$d->month.$d->day.$d->hour;
                    $results[$date]['title'] = $d->day.'.'.$d->month.' '.$d->hour.':00';
                    break; 
                case 'day':
                    $date = $d->year.$d->month.$d->day;
                    $results[$date]['title'] = $d->date.' '.$weekdays[$d->weekday];
                    break;
                case 'month':
                    $date = $d->year.$d->month;
                    $results[$date]['title'] = $d->month.'.'.$d->year;
                    break;  
            }

            if(!isset($results[$date]['new'])) 
                $results[$date]['new'] = $results[$date]['newtwo'] = $results[$date]['confirm'] = $results[$date]['complite'] = $results[$date]['delete'] = 0;     

            switch($d->status) {
                case 0: $results[$date]['new'] += $d->total_price; break;
				case 4: $results[$date]['newtwo'] += $d->total_price; break;
                case 1: $results[$date]['confirm'] += $d->total_price; break;
                case 2: $results[$date]['complite'] += $d->total_price; break;
                case 3: $results[$date]['delete'] += $d->total_price; break;
            }
        }
        return $results;
    }
    
    function get_stat_orders($filter = array()) { //Выборка товара
        $weekdays = array('вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб');
    
        $all_filters = $this->make_filter($filter);
        
        $query = $this->db->placehold("SELECT 
        		o.id,
                DATE_FORMAT(o.date,'%d.%m.%y') date, 
                DATE_FORMAT(o.date,'%w') weekday, 
                DATE_FORMAT(o.date,'%H') hour, 
                DATE_FORMAT(o.date,'%d') day, 
                DATE_FORMAT(o.date,'%m') month, 
                DATE_FORMAT(o.date,'%Y') year,
                o.status
            FROM __orders o
            LEFT JOIN __orders_labels AS ol ON o.id=ol.order_id 
            WHERE 1 $all_filters GROUP BY o.id ORDER BY o.date");
        $this->db->query($query);
        $data = $this->db->results();
        
        $group = 'day';
        if(isset($filter['date_filter']))
        {
            switch ($filter['date_filter']){
                case 'today':       $group = 'hour';    break;
                case 'yesterday':   $group = 'hour';    break;
                case 'last_24hour': $group = 'hour';    break;
                case 'this_year':   $group = 'month';   break;
                case 'last_year':   $group = 'month';   break;
                case 'all':         $group = 'month';   break;
            }
        }        
        
        $results = array();
        
        foreach($data as $d)
        {
            switch($group) {
                case 'hour':
                    $date = $d->year.$d->month.$d->day.$d->hour;
                    $results[$date]['title'] = $d->day.'.'.$d->month.' '.$d->hour.':00';
                    break; 
                case 'day':
                    $date = $d->year.$d->month.$d->day;
                    $results[$date]['title'] = $d->date.' '.$weekdays[$d->weekday];
                    break;
                case 'month':
                    $date = $d->year.$d->month;
                    $results[$date]['title'] = $d->month.'.'.$d->year;
                    break;  
            }        

            if(!isset($results[$date]['new'])) 
                $results[$date]['new'] = $results[$date]['newtwo'] = $results[$date]['confirm'] = $results[$date]['complite'] = $results[$date]['delete'] = 0;     

            switch($d->status) {
                case 0:
                    $results[$date]['new']++;
                    break;
                case 4:
                    $results[$date]['newtwo']++;
                    break;
                case 1:
                    $results[$date]['confirm']++;
                    break;
                case 2:
                    $results[$date]['complite']++;
                    break;
                case 3:
                    $results[$date]['delete']++;
                    break;
            }
        }
        return $results;
    }
    
    function get_report_purchases($filter = array()) { //Выборка товара
        // По умолчанию
        $sort_prod = 'sum_price DESC';

        if(isset($filter['sort_prod'])){
            switch($filter['sort_prod']){
                case 'price':
                    $sort_prod = $this->db->placehold('sum_price DESC');
                break;
                case 'price_in':
                    $sort_prod = $this->db->placehold('sum_price ASC');
                break;
                case 'amount':
                    $sort_prod = $this->db->placehold('amount DESC');
                break;
                case 'amount_in':
                    $sort_prod = $this->db->placehold('amount ASC');
                break;    
            }
        }
        
        $all_filters = $this->make_filter($filter);
        
        // Выбираем заказы
        $query = $this->db->placehold("SELECT 
                o.id, 
                p.product_id, 
                p.variant_id, 
                p.product_name, 
                p.variant_name, 
                SUM(p.price * p.amount) as sum_price, 
                SUM(p.amount) as amount, 
                p.sku FROM __purchases AS p 
            LEFT JOIN __orders AS o ON o.id = p.order_id 
            WHERE 1 $all_filters 
            GROUP BY p.variant_id 
            ORDER BY $sort_prod");
                
        $this->db->query($query);
        return $this->db->results();
    }
    
    function get_report_purchase($filter = array()) { //Связанный товар

        $all_filters = $this->make_filter($filter);
        
        // Выбираем заказы
        $query = $this->db->placehold("SELECT 
                p.product_id, 
                o.id, p.variant_id, 
                p.product_name, 
                p.variant_name, 
                p.price, 
                p.amount, 
                p.sku 
            FROM __orders AS o 
            LEFT JOIN __purchases AS p ON o.id = p.order_id 
            WHERE 1 $all_filters");
                
        $this->db->query($query);
        return $this->db->results();
    }
    
    function get_report_product($filter = array(), $id) { 
        // По умолчанию
        $variant_id = '';

        if(isset($filter['variant_id']))
            $variant_id = $this->db->placehold('AND p.variant_id = ?', intval($filter['variant_id']));        

        $all_filters = $this->make_filter($filter);
        
        // Выбираем заказы
        $query = $this->db->placehold("SELECT 
                o.id, 
                DATE(o.date) as date, 
                p.product_id, 
                p.variant_id, 
                p.product_name, 
                p.variant_name, 
                SUM(p.price * p.amount) as price, 
                SUM(p.amount) as amount, 
                p.sku 
            FROM __orders AS o 
            LEFT JOIN __purchases AS p ON o.id = p.order_id 
            WHERE 1 AND p.product_id=? $variant_id $all_filters 
            GROUP BY DATE(o.date) 
            ORDER BY o.date", $id);
     
        $this->db->query($query);
        return $this->db->results();
    }
    
    private function make_filter($filter = array()) { 
        // По умолчанию
        $period_filter = '';
        $date_filter = '';
        $status_filter = '';
        $yclid_filter = '';
        $utm_filter = '';
        $referer_filter = '';
        $source_filter = '';
        $delivery_id_filter = '';
        $label_id_filter = '';
        
        if(isset($filter['status']))
            $status_filter = $this->db->placehold('AND o.status = ?', intval($filter['status']));
            
        if(isset($filter['yclid']))
			$yclid_filter = $this->db->placehold('AND o.yclid = ?', $filter['yclid']); 
        
        if(isset($filter['utm']))
			$utm_filter = $this->db->placehold('AND (o.utm LIKE "%'.$this->db->escape(trim($filter['utm'])).'%") ');
			
        if(isset($filter['referer']))
			$referer_filter = $this->db->placehold('AND (o.referer LIKE "%'.$this->db->escape(trim($filter['referer'])).'%") ');

        if(isset($filter['source']))
			$source_filter = $this->db->placehold('AND o.source = ?', intval($filter['source']));
			
		if(isset($filter['delivery_id']))
			$delivery_id_filter = $this->db->placehold('AND o.delivery_id = ?', intval($filter['delivery_id']));	
			
		if(isset($filter['label_id']))
            $label_id_filter = $this->db->placehold('AND ol.label_id = ?', intval($filter['label_id']));	
			
        if(isset($filter['date_from']) && !isset($filter['date_to'])){
            $period_filter = $this->db->placehold('AND o.date > ?', $filter['date_from']);
        }
        elseif(isset($filter['date_to']) && !isset($filter['date_from'])){
            $period_filter = $this->db->placehold('AND o.date < ?', $filter['date_to']);
        }
        elseif(isset($filter['date_to']) && isset($filter['date_from'])){
            $period_filter = $this->db->placehold('AND (o.date BETWEEN ? AND ?)', $filter['date_from'], $filter['date_to']);
        }
        
        if(isset($filter['date_filter']))
        {
            switch ($filter['date_filter']){
                case 'today':
                    $date_filter = 'AND DATE(o.date) = DATE(NOW())';
                    break;
                case 'this_week':
                    $date_filter = 'AND WEEK(o.date - INTERVAL 1 DAY) = WEEK(now()) AND YEAR(o.date) = YEAR(now())';
                    break;
                case 'this_month':
                    $date_filter = 'AND MONTH(o.date) = MONTH(now()) AND YEAR(o.date) = YEAR(now())';
                    break;
                case 'this_year':
                    $date_filter = 'AND YEAR(o.date) = YEAR(now())';
                    break;
                case 'yesterday':
                    $date_filter = 'AND DATE(o.date) = DATE(DATE_SUB(NOW(),INTERVAL 1 DAY))';
                    break;
                case 'last_week':
                    $date_filter = 'AND WEEK(o.date - INTERVAL 1 DAY) = WEEK(DATE_SUB(NOW(),INTERVAL 1 WEEK))';
                    break;
                case 'last_month':
                    $date_filter = 'AND MONTH(o.date) = MONTH(DATE_SUB(NOW(),INTERVAL 1 MONTH))';
                    break;
                case 'last_year':
                    $date_filter = 'AND YEAR(o.date) = YEAR(DATE_SUB(NOW(),INTERVAL 1 YEAR))';
                    break;
                case 'last_24hour':
                    $date_filter = 'AND o.date >= DATE_SUB(NOW(),INTERVAL 24 HOUR)';
                    break;
                case 'last_7day':
                    $date_filter = 'AND DATE(o.date) >= DATE(DATE_SUB(NOW(),INTERVAL 6 DAY))';
                    break;
                case 'last_30day':
                    $date_filter = 'AND DATE(o.date) >= DATE(DATE_SUB(NOW(),INTERVAL 29 DAY))';
                    break;                                                                                                                                                                
            }
        }
        
        return "$status_filter $yclid_filter $utm_filter $referer_filter $source_filter $delivery_id_filter $label_id_filter $date_filter $period_filter";
    }
        
}
