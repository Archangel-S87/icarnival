<?PHP

require_once('api/Fivecms.php');

class StatsAdmin extends Fivecms
{
 
    public function fetch()
    {
        $filter = array();
       
        $date_filter = $this->request->post('date_filter');
        
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

		$status = $this->request->post('status', 'integer');
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
        
        if(!empty($yclid = $this->request->post('yclid'))){
        	$filter['yclid'] = $yclid;
        	$this->design->assign('yclid', $yclid);
        }
        
        if(!empty($utm = $this->request->post('utm'))){
        	$filter['utm'] = $utm;
        	$this->design->assign('utm', $utm);
        }
        
        if(!empty($referer = $this->request->post('referer'))){
        	$filter['referer'] = $referer;
        	$this->design->assign('referer', $referer);
        }
        
        if(!empty($source = $this->request->post('source'))){
        	$filter['source'] = $source;
        	$this->design->assign('source', $source);
        }
        
        if(!empty($delivery_id = $this->request->post('delivery_id'))){
        	$filter['delivery_id'] = $delivery_id;
        	$this->design->assign('delivery_id', $delivery_id);
        }
        
        if(!empty($label_id = $this->request->post('label_id'))){
        	$filter['label_id'] = $label_id;
        	$this->design->assign('label_id', $label_id);
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
