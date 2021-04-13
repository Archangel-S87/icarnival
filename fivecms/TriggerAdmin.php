<?PHP
require_once('api/Fivecms.php');

class TriggerAdmin extends Fivecms
{	
	public function fetch()
	{	
		if($this->request->method('POST'))
		{
        	$this->settings->trigger_id = $this->request->post('trigger_id');
			
			$this->design->assign('message_success', 'saved');
		}

 	  	return $this->design->fetch('trigger.tpl');
	}
	
}

