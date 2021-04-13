<?PHP

require_once('api/Fivecms.php');

class StatsAdmin extends Fivecms
{
 
    public function fetch()
    {
        $filter = array();
       
       	// Период
        if(!empty($date_filter = $this->request->post('date_filter')))
			$_SESSION['stats_date_filter'] = $date_filter;		
		if(!empty($_SESSION['stats_date_filter']))
			$date_filter = $_SESSION['stats_date_filter'];	
        
        $date_from = $this->request->post('date_from');
        $date_to = $this->request->post('date_to');
        $filter_check = $this->request->post('filter_check');
        
        if(!empty($filter_check)){ 
        	$date_filter = "";
        	
            if(!empty($date_from)){
                $filter['date_from'] = date("Y-m-d 00:00:01",strtotime($date_from));
                $this->design->assign('date_from', $date_from);
            }
    
            if(!empty($date_to)){
                $filter['date_to'] = date("Y-m-d 23:59:00",strtotime($date_to));
                $this->design->assign('date_to', $date_to);
            }
            $this->design->assign('filter_check', $filter_check);                    
        }
        
        if(isset($date_filter)){
            $filter['date_filter'] = $date_filter;
            $this->design->assign('date_filter', $date_filter);
        }

		// Статус заказа
		$status = $this->request->post('status');
		if(isset($status))
			$_SESSION['stats_status'] = $status;
		if(isset($_SESSION['stats_status']))
			$status = $_SESSION['stats_status'];	

        if(!empty($status)){
            switch($status){
                case '1': $stat_o = 0;
                break;
                case '2': $stat_o = 1;
                break;
                case '3': $stat_o = 2;
                break;
                case '4': $stat_o = 3;
                break;
				case '5': $stat_o = 4;
                break;
            }
            $filter['status'] = $stat_o;
            $this->design->assign('status', $status);
        }
        
        // YCLID
        $yclid = $this->request->post('yclid');
		if(isset($yclid))
			$_SESSION['stats_yclid'] = $yclid;
		if(isset($_SESSION['stats_yclid']))
			$yclid = $_SESSION['stats_yclid'];	
			
        $this->design->assign('yclid', $yclid);
        if(!empty($yclid)){
        	$filter['yclid'] = $yclid;
        }
        
        // UTM
        $utm = $this->request->post('utm');
		if(isset($utm))
			$_SESSION['stats_utm'] = $utm;
		if(isset($_SESSION['stats_utm']))
			$utm = $_SESSION['stats_utm'];	
			
        $this->design->assign('utm', $utm);
        if(!empty($utm)){
        	$filter['utm'] = $utm;
        }
        
        // Referer
        $referer = $this->request->post('referer');
		if(isset($referer))
			$_SESSION['stats_referer'] = $referer;
		if(isset($_SESSION['stats_referer']))
			$referer = $_SESSION['stats_referer'];	
			
        $this->design->assign('referer', $referer);
        if(!empty($referer)){
        	$filter['referer'] = $referer;
        }
        
        // Источник заказа
        $source = $this->request->post('source');
        if(isset($source))
			$_SESSION['stats_source'] = $source;
		if(isset($_SESSION['stats_source']))
			$source = $_SESSION['stats_source'];
			
		$this->design->assign('source', $source);	
        if(!empty($source)){
        	$filter['source'] = $source;
        }
        
        // Доставка
        $delivery_id = $this->request->post('delivery_id');
        if(isset($delivery_id))
			$_SESSION['stats_delivery_id'] = $delivery_id;
		if(isset($_SESSION['stats_delivery_id']))
			$delivery_id = $_SESSION['stats_delivery_id'];
			
		$this->design->assign('delivery_id', $delivery_id);	
        if(!empty($delivery_id)){
        	$filter['delivery_id'] = $delivery_id;
        }
        
        // Метки заказа чекбоксами
        /*$label_id = $this->request->post('label_id');
        if(isset($label_id))
			$_SESSION['stats_label_id'] = $label_id;
		if(isset($_SESSION['stats_label_id']))
			$label_id = $_SESSION['stats_label_id'];
			
		$this->design->assign('label_id', $label_id);	
        if(!empty($label_id)){
        	$filter['label_id'] = $label_id;
        }*/
        
        // Метки заказа селектом
        $label_id = $this->request->post('label_id');
        if(isset($label_id))
			$_SESSION['stats_label_in'] = $label_id;
		if(isset($_SESSION['stats_label_in']))
			$label_id = $_SESSION['stats_label_in'];
			
		$this->design->assign('label_id', $label_id);	
        if(!empty($label_id)){
        	$filter['label_id_in'] = $label_id;
        }
        
        // Фильтр по пользователю
        $user_id = $this->request->post('user_id');
        if(isset($user_id))
			$_SESSION['stats_user_id'] = $user_id;
		if(isset($_SESSION['stats_user_id']))
			$user_id = $_SESSION['stats_user_id'];
			
        if(!empty($user_id)){
        	$user = $this->users->get_user(intval($user_id));
        	if(!empty($user)){
        		$filter['user_id'] = $user_id;
        		$this->design->assign('user', $user);
        	}	
        }
        
        // Все способы доставки
		$deliveries = $this->delivery->get_deliveries();
		$this->design->assign('deliveries', $deliveries);
		
		// Все метки заказов
		$labels = $this->orders->get_labels();
		$this->design->assign('labels', $labels);
        
        // Фильтр по умолчанию
        if(empty($filter)) {
            $filter['date_filter'] = 'last_30day';
            $this->design->assign('date_filter', 'last_30day');  
        }
      
        $this->design->assign('stat', $this->reportstat->get_stat($filter));
        $this->design->assign('stat_orders', $this->reportstat->get_stat_orders($filter));
        
 	    return $this->design->fetch('stats.tpl');
    }
}
