<?PHP
require_once('api/Fivecms.php');

class MobsetAdmin extends Fivecms
{	
	public function fetch()
	{	
		$this->passwd_file = $this->config->root_dir.'/fivecms/.passwd';
		$this->htaccess_file = $this->config->root_dir.'/fivecms/.htaccess';
		
		$managers = $this->managers->get_managers();
		$this->design->assign('managers', $managers);

		if($this->request->method('POST'))
		{
			$this->settings->hidecomment = $this->request->post('hidecomment');
			$this->settings->hidereview = $this->request->post('hidereview');
			$this->settings->hideblog = $this->request->post('hideblog', 'integer');
			$this->settings->cutmob = $this->request->post('cutmob');
			$this->settings->show_cart_wishcomp = $this->request->post('show_cart_wishcomp');
			$this->settings->mob_products_num = $this->request->post('mob_products_num', 'integer');
			$this->settings->mob_discount = $this->request->post('mob_discount', 'integer');
			
			$this->design->assign('message_success', 'saved');
		}
 	  	return $this->design->fetch('mobset.tpl');
	}
	
}

