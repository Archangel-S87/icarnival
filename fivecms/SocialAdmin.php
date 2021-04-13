<?PHP
require_once('api/Fivecms.php');

class SocialAdmin extends Fivecms
{	
	public function fetch()
	{	
		if($this->request->method('POST'))
		{
        	$this->settings->twitter = $this->request->post('twitter');
        	$this->settings->google = $this->request->post('google');
        	$this->settings->facebook = $this->request->post('facebook');
        	$this->settings->youtube = $this->request->post('youtube');
        	$this->settings->vk = $this->request->post('vk');
        	$this->settings->insta = $this->request->post('insta');
        	$this->settings->viber = $this->request->post('viber');
        	$this->settings->whatsapp = $this->request->post('whatsapp');
			$this->settings->odnoklassniki = $this->request->post('odnoklassniki');
			$this->settings->telegram = $this->request->post('telegram');
			
			$this->design->assign('message_success', 'saved');
		}

 	  	return $this->design->fetch('social.tpl');
	}
	
}
