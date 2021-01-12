<?PHP
require_once('api/Fivecms.php');

class ColorAdmin extends Fivecms
{	
	public function fetch()
	{	
		$this->passwd_file = $this->config->root_dir.'/fivecms/.passwd';
		$this->htaccess_file = $this->config->root_dir.'/fivecms/.htaccess';
		
		$managers = $this->managers->get_managers();
		$this->design->assign('managers', $managers);

		if($this->request->method('POST'))
		{

			$this->settings->colortheme = $this->request->post('colortheme');

			$this->design->assign('message_success', 'saved');
		}

 	  	return $this->design->fetch('color.tpl');
	}
	
}

