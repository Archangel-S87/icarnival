<?PHP
require_once('api/Fivecms.php');

class TriggerAdmin extends Fivecms
{	
	private $allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico');
	
	public function fetch()
	{	
		$this->passwd_file = $this->config->root_dir.'/fivecms/.passwd';
		$this->htaccess_file = $this->config->root_dir.'/fivecms/.htaccess';
		
		$managers = $this->managers->get_managers();
		$this->design->assign('managers', $managers);

		if($this->request->method('POST'))
		{

			/*$this->trigger->site_name = $this->request->post('site_name');
			$this->trigger->company_name = $this->request->post('company_name');
			$this->trigger->date_format = $this->request->post('date_format');
			$this->trigger->admin_email = $this->request->post('admin_email');*/
			
        	$this->settings->trigger_id = $this->request->post('trigger_id');
			
			$this->design->assign('message_success', 'saved');
		
		}

		//$this->design->assign('trigger',	$this->trigger);

 	  	return $this->design->fetch('trigger.tpl');
	}
	
}

