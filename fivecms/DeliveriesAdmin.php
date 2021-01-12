<?PHP 

require_once('api/Fivecms.php');

class DeliveriesAdmin extends Fivecms
{

  public function fetch()
  {
  
	   	// Обработка действий
	  	if($this->request->method('post'))
	  	{			
	  		// Настройки
	  		$this->settings->feature_weight = $this->request->post('feature_weight');
			$this->settings->feature_volume = $this->request->post('feature_volume');
			$this->settings->min_weight = $this->request->post('min_weight');
			$this->settings->min_volume = $this->request->post('min_volume');
			
			// Действия с выбранными
			$ids = $this->request->post('check');
			
			if(is_array($ids))
			switch($this->request->post('action'))
			{
			    case 'disable':
			    {
					$this->delivery->update_delivery($ids, array('enabled'=>0));	      
					break;
			    }
			    case 'enable':
			    {
					$this->delivery->update_delivery($ids, array('enabled'=>1));	      
			        break;
			    }
			    case 'delete':
			    {
				    foreach($ids as $id)
						$this->delivery->delete_delivery($id);    
			        break;
			    }
			}	
				
			// Сортировка
			$positions = $this->request->post('positions'); 		
	 		$ids = array_keys($positions);
			sort($positions);
			foreach($positions as $i=>$position)
				$this->delivery->update_delivery($ids[$i], array('position'=>$position)); 
			
	 	}

		// Отображение
	  	$deliveries = $this->delivery->get_deliveries();
	 	$this->design->assign('deliveries', $deliveries);
		return $this->design->fetch('deliveries.tpl');
	}
}