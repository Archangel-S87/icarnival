<?PHP

require_once('api/Fivecms.php');

class SlidesmAdmin extends Fivecms
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
                        $this->slidesm->update_slidem($id, array('visible'=>0));
                    break;
				}
				case 'enable':
				{
                    foreach($ids as $id)
                        $this->slidesm->update_slidem($id, array('visible'=>1));
                    break;
				}
			    case 'delete':
			    {
			    	foreach($ids as $id)
			    	{
			    			$this->slidesm->delete_slidem($id); 
					}
			        break;
			    }
			}		
	  	
			// Сортировка
			$positions = $this->request->post('positions');
	 		$ids = array_keys($positions);
			sort($positions);
			foreach($positions as $i=>$position)
				$this->slidesm->update_slidem($ids[$i], array('position'=>$position)); 

		} 

		$filter = array();
		$slidesm = $this->slidesm->get_slidesm($filter);
		$this->design->assign('slidesm', $slidesm);
		return $this->body = $this->design->fetch('slides_mob.tpl');
	}
}
