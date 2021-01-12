<?PHP 

require_once('api/Fivecms.php');

class DiscountGroupAdmin extends Fivecms
{

  public function fetch()
  {
	   	//enable_groupdiscount - параметр в таблице _settings, если 1-вкл, 0-выкл
        $enable_groupdiscount = 'enable_groupdiscount';
        // Обработка действий
	  	if($this->request->method('post'))
	  	{
	  		$this->settings->variant_discount = $this->request->post('variant_discount');
        	$this->settings->bonus_order = $this->request->post('bonus_order');
      		$this->settings->bonus_limit = $this->request->post('bonus_limit'); 
      		$this->settings->bonus_link = $this->request->post('bonus_link');
      		
      		$this->settings->ref_cookie = $this->request->post('ref_cookie');
      		$this->settings->ref_link = $this->request->post('ref_link');
      		$this->settings->ref_order = $this->request->post('ref_order');

			$t=array();
			$td = $this->request->post('td');
			if(is_array($td[0]))foreach ($td[0] as $k => $v) {
				$td[0][$k]=(int)$td[0][$k];
				$td[1][$k]=(int)$td[1][$k];
				if($td[0][$k]>0 &&$td[1][$k]>0)
					$t[$td[0][$k]]=$td[1][$k];
			}
			ksort($t);
			$tx='';
			if(is_array($t))foreach ($t as $k => $v) {
				if($tx) $tx.=';';
				$tx.=$k.';'.$v;
			}	
			$this->settings->discount_table = $tx;

			foreach($this->request->post('discountgroup') as $n=>$va)
				foreach($va as $i=>$v)
					$discountgroups[$i]->$n = $v;
                          		    
			$discountgroups_ids = array();
			foreach($discountgroups as $discountgroup)
			{
				if($discountgroup->id)
					$this->discountgroup->update_discountgroup($discountgroup->id, $discountgroup);
				else
					$discountgroup->id = $this->discountgroup->add_discountgroup($discountgroup);
		 		$discountgroups_ids[] = $discountgroup->id;
			}
            //проверяем включены групповые скидки
            $enable_discount = 99;
            switch ($this->request->post('check_discount')){
                            case 1:
                                $enable_discount = 1;
                                break;
                            case 2:
                                $enable_discount = 2;
                                break;
                            case 3:
                                $enable_discount = 3;
                                break;
							case 4:
                                $enable_discount = 4;
                                break;
							case 5:
                                $enable_discount = 5;
                                break;
                            default :
                                $enable_discount = 99;
                                break;
            }

            $this->discountgroup->update_config($enable_groupdiscount, $enable_discount);
			// Удалить непереданные валюты
			$query = $this->db->placehold('DELETE FROM __discountgroup WHERE id NOT IN(?@)', $discountgroups_ids);
			$this->db->query($query);			
		
			// Действия с выбранными
			$action = $this->request->post('action_d');
			$id = $this->request->post('action_id_d');
			
			if(!empty($action) && !empty($id))
			switch($action)
			{
			    case 'disable':
			    {
					$this->discountgroup->update_discountgroup($id, array('enabled'=>0));	      
					break;
			    }
			    case 'enable':
			    {
					$this->discountgroup->update_discountgroup($id, array('enabled'=>1));	      
			        break;
			    }			   
			    case 'delete':
			    {
				    $this->discountgroup->delete_discountgroup($id);    
			        break;
			    }
			}		
	 	}

		// Отображение
        $enablediscounts = $this->discountgroup->get_config_discount($enable_groupdiscount);
	  	$discountgroups = $this->discountgroup->get_discountgroups();
	  	$discountgroup = $this->discountgroup->get_discountgroup();
	 	$this->design->assign('discountgroup', $discountgroup);
        $this->design->assign('discountgroups', $discountgroups);
        $this->design->assign('enablediscounts', $enablediscounts);

		$t=explode(';', $this->settings->discount_table);	
		$td=array();
		for($i=0;$i<count($t); $i+=2){
			if($t[$i]>0 && $t[$i+1]>0)
				$td[]=array($t[$i], $t[$i+1]);
		}
		$this->design->assign('td', $td);

		return $this->design->fetch('discountgroup.tpl');
	}
}
