<?PHP
require_once('api/Fivecms.php');

class SmtpAdmin extends Fivecms
{	
	public function fetch()
	{	
		$this->passwd_file = $this->config->root_dir.'/fivecms/.passwd';
		$this->htaccess_file = $this->config->root_dir.'/fivecms/.htaccess';
		
		$managers = $this->managers->get_managers();
		$this->design->assign('managers', $managers);

		if($this->request->method('POST'))
		{

			$this->settings->order_email = $this->request->post('order_email');
			$this->settings->comment_email = $this->request->post('comment_email');
			$this->settings->notify_from_email = $this->request->post('notify_from_email');

			$this->settings->smtp_enable = $this->request->post('smtp_enable');
			$this->settings->smtp_host = $this->request->post('smtp_host');
			$this->settings->smtp_port = $this->request->post('smtp_port');
			$this->settings->smtp_user = $this->request->post('smtp_user');
			$this->settings->smtp_password = $this->request->post('smtp_password');
			$this->settings->smtp_ssl = $this->request->post('smtp_ssl');

			$this->design->assign('message_success', 'saved');
		}


		//if (!empty($error)) $this->design->assign('message_success', $error);

 	  	return $this->design->fetch('smtp.tpl');
	}
	
}

