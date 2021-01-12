<?PHP

require_once('api/Fivecms.php');


class ServicesCategoriesAdmin extends Fivecms
{
	function fetch()
	{
		if($this->request->method('post'))
		{
			// Действия с выбранными
			$ids = $this->request->post('check');
			if(is_array($ids))
			switch($this->request->post('action'))
			{
			    case 'disable':
			    {
			    	foreach($ids as $id)
						$this->services_categories->update_services_category($id, array('visible'=>0));    
					break;
			    }
			    case 'enable':
			    {
			    	foreach($ids as $id)
						$this->services_categories->update_services_category($id, array('visible'=>1));    
			        break;
			    }
			    case 'delete':
			    {
			    	foreach($ids as $id)
						$this->services_categories->delete_services_category($id);    
			        break;
			    }
			}		
	  	
			// Сортировка
			$positions = $this->request->post('positions');
	 		$ids = array_keys($positions);
			sort($positions);
			foreach($positions as $i=>$position)
				$this->services_categories->update_services_category($ids[$i], array('position'=>$position)); 

		}  
  
		$services_categories = $this->services_categories->get_services_categories_tree();

		$this->design->assign('services_categories', $services_categories);
		return $this->design->fetch('services_categories.tpl');
	}
}
