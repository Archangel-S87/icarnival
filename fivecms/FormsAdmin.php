<?PHP

require_once('api/Fivecms.php');

class FormsAdmin extends Fivecms
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
                        $this->forms->update_form($id, array('visible'=>0));
                    break;
				}
				case 'enable':
				{
                    foreach($ids as $id)
                        $this->forms->update_form($id, array('visible'=>1));
                    break;
				}
			    case 'delete':
			    {
			    	foreach($ids as $id)
			    	{
			    			$this->forms->delete_form($id); 
					}
			        break;
			    }
			}		
		} 

		$filter = array();
		$forms = $this->forms->get_forms($filter);
		$this->design->assign('forms', $forms);
		return $this->body = $this->design->fetch('forms.tpl');
	}
}
