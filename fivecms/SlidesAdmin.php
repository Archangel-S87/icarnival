<?PHP

require_once('api/Fivecms.php');

class SlidesAdmin extends Fivecms
{
	function fetch()
	{	
		if ($this->request->method('post') && $this->request->post('slidermode')) {
			$this->settings->slidermode = $this->request->post('slidermode');
		}
		elseif ($this->request->method('post'))
		{  	

			// Действия с выбранными
			$ids = $this->request->post('check');
			if(is_array($ids))
			switch($this->request->post('action'))
			{

				case 'disable':                
				{
                    foreach($ids as $id)
                        $this->slides->update_slide($id, array('visible'=>0));
                    break;
				}
				case 'enable':
				{
                    foreach($ids as $id)
                        $this->slides->update_slide($id, array('visible'=>1));
                    break;
				}

			    case 'delete':
			    {
			    	foreach($ids as $id)
			    	{
			    		$this->slides->delete_slide($id); 
					}
			        break;
			    }
			}		
	  	
			// Сортировка
			$positions = $this->request->post('positions');
	 		$ids = array_keys($positions);
			sort($positions);
			foreach($positions as $i=>$position)
				$this->slides->update_slide($ids[$i], array('position'=>$position)); 

		} 

		$filter = array();
		$slides = $this->slides->get_slides($filter);
		$this->design->assign('slides', $slides);
		return $this->body = $this->design->fetch('slides.tpl');
	}
}
