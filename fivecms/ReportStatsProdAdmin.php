<?PHP 

require_once('api/Fivecms.php');

class ReportStatsProdAdmin extends Fivecms
{
    public function fetch()
    {
    	$filter = array();
    	$variants = array();
        
        $variant_id = $this->request->post('variant_id');
        if(!empty($variant_id)){
        	$filter['variant_id'] = $variant_id;
            $this->design->assign('variant_id', $variant_id);
        }
        
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
        
        // Все способы доставки
		$deliveries = $this->delivery->get_deliveries();
		$this->design->assign('deliveries', $deliveries);
        
        // Фильтр по умолчанию
        if(empty($filter)) {
            $filter['date_filter'] = 'last_30day';
            $this->design->assign('date_filter', 'last_30day');  
        }

    	$id = $this->request->get('id', 'integer');
    	$product = $this->products->get_product(intval($id));
    	$this->design->assign('product', $product);
    	$this->design->assign('id', $id);
    
		if($product){                
			// Варианты товара
			$variants = $this->variants->get_variants(array('product_id'=>$product->id));        
			$this->design->assign('variants',$variants);
		}
    
    	$product_report = $this->reportstat->get_report_product($filter, $id);
    	$this->design->assign('product_report', $product_report);  

    	return $this->design->fetch('reportstatsprod.tpl');
    }
}
