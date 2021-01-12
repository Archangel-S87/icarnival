<?PHP

require_once('api/Fivecms.php');


class SurveysCategoriesAdmin extends Fivecms
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
						$this->surveys_categories->update_surveys_category($id, array('visible'=>0));    
					break;
			    }
			    case 'enable':
			    {
			    	foreach($ids as $id)
						$this->surveys_categories->update_surveys_category($id, array('visible'=>1));    
			        break;
			    }
			    case 'delete':
			    {
			    	foreach($ids as $id)
						$this->surveys_categories->delete_surveys_category($id);    
			        break;
			    }
			}		
	  	
			// Сортировка
			$positions = $this->request->post('positions');
	 		$ids = array_keys($positions);
			sort($positions);
			foreach($positions as $i=>$position)
				$this->surveys_categories->update_surveys_category($ids[$i], array('position'=>$position)); 

		}  
  
		$surveys_categories = $this->surveys_categories->get_surveys_categories_tree();

		$this->design->assign('surveys_categories', $surveys_categories);
		return $this->design->fetch('surveys_categories.tpl');
	}
}
