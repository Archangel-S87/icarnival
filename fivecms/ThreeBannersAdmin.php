<?PHP
require_once('api/Fivecms.php');

class ThreeBannersAdmin extends Fivecms
{	
	private $allowed_image_extentions = array('png');

	public function fetch()
	{	
		if($this->request->method('POST'))
		{
        	$this->settings->addfield2 = $this->request->post('addfield2');
        	$this->settings->bannerfirstvis = $this->request->post('bannerfirstvis', 'boolean');
			$this->settings->bannerfirst = $this->request->post('bannerfirst');
			$this->settings->bannersecondvis = $this->request->post('bannersecondvis', 'boolean');
			$this->settings->bannersecond = $this->request->post('bannersecond');
			$this->settings->bannerthirdvis = $this->request->post('bannerthirdvis', 'boolean');
			$this->settings->bannerthird = $this->request->post('bannerthird');
			$this->settings->bannerfourvis = $this->request->post('bannerfourvis', 'boolean');
			$this->settings->bannerfour = $this->request->post('bannerfour');
			
			$this->settings->bbanners = $this->request->post('bbanners');
        	$this->settings->bbannerfirstvis = $this->request->post('bbannerfirstvis', 'boolean');
			$this->settings->bbannerfirst = $this->request->post('bbannerfirst');
			$this->settings->bbannersecondvis = $this->request->post('bbannersecondvis', 'boolean');
			$this->settings->bbannersecond = $this->request->post('bbannersecond');
			$this->settings->bbannerthirdvis = $this->request->post('bbannerthirdvis', 'boolean');
			$this->settings->bbannerthird = $this->request->post('bbannerthird');
			$this->settings->bbannerfourvis = $this->request->post('bbannerfourvis', 'boolean');
			$this->settings->bbannerfour = $this->request->post('bbannerfour');
			
			$this->design->assign('message_success', 'saved');
		}

		$banner1img = $this->request->files('banner1img_file', 'tmp_name');
			if(!empty($banner1img))
			{
				if(in_array(pathinfo($this->request->files('banner1img_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions)) 
				{
					if(!@move_uploaded_file($banner1img, $this->config->root_dir.$this->config->banner1img_file))
					$this->design->assign('message_error', 'banner_is_not_writable');
				} else {
					$this->design->assign('message_error', 'not_allowed_extention');
				}
			}

		$banner2img = $this->request->files('banner2img_file', 'tmp_name');
			if(!empty($banner2img))
			{
				if(in_array(pathinfo($this->request->files('banner2img_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions)) 
				{
					if(!@move_uploaded_file($banner2img, $this->config->root_dir.$this->config->banner2img_file))
					$this->design->assign('message_error', 'banner_is_not_writable');
				} else {
					$this->design->assign('message_error', 'not_allowed_extention');
				}
			}

		$banner3img = $this->request->files('banner3img_file', 'tmp_name');
			if(!empty($banner3img))
			{
				if(in_array(pathinfo($this->request->files('banner3img_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions)) 
				{
					if(!@move_uploaded_file($banner3img, $this->config->root_dir.$this->config->banner3img_file))
					$this->design->assign('message_error', 'banner_is_not_writable');
				} else {
					$this->design->assign('message_error', 'not_allowed_extention');
				}
			}

		$banner4img = $this->request->files('banner4img_file', 'tmp_name');
			if(!empty($banner4img))
			{
				if(in_array(pathinfo($this->request->files('banner4img_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions)) 
				{
					if(!@move_uploaded_file($banner4img, $this->config->root_dir.$this->config->banner4img_file))
					$this->design->assign('message_error', 'banner_is_not_writable');
				} else {
					$this->design->assign('message_error', 'not_allowed_extention');
				}
			}
			
		$bbanner1img = $this->request->files('bbanner1img_file', 'tmp_name');
			if(!empty($bbanner1img))
			{
				if(in_array(pathinfo($this->request->files('bbanner1img_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions)) 
				{
					if(!@move_uploaded_file($bbanner1img, $this->config->root_dir.$this->config->bbanner1img_file))
					$this->design->assign('message_error', 'banner_is_not_writable');
				} else {
					$this->design->assign('message_error', 'not_allowed_extention');
				}
			}

		$bbanner2img = $this->request->files('bbanner2img_file', 'tmp_name');
			if(!empty($bbanner2img))
			{
				if(in_array(pathinfo($this->request->files('bbanner2img_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions)) 
				{
					if(!@move_uploaded_file($bbanner2img, $this->config->root_dir.$this->config->bbanner2img_file))
					$this->design->assign('message_error', 'banner_is_not_writable');
				} else {
					$this->design->assign('message_error', 'not_allowed_extention');
				}
			}

		$bbanner3img = $this->request->files('bbanner3img_file', 'tmp_name');
			if(!empty($bbanner3img))
			{
				if(in_array(pathinfo($this->request->files('bbanner3img_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions)) 
				{
					if(!@move_uploaded_file($bbanner3img, $this->config->root_dir.$this->config->bbanner3img_file))
					$this->design->assign('message_error', 'banner_is_not_writable');
				} else {
					$this->design->assign('message_error', 'not_allowed_extention');
				}
			}

		$bbanner4img = $this->request->files('bbanner4img_file', 'tmp_name');
			if(!empty($bbanner4img))
			{
				if(in_array(pathinfo($this->request->files('bbanner4img_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions)) 
				{
					if(!@move_uploaded_file($bbanner4img, $this->config->root_dir.$this->config->bbanner4img_file))
					$this->design->assign('message_error', 'banner_is_not_writable');
				} else {
					$this->design->assign('message_error', 'not_allowed_extention');
				}
			}

 	  	return $this->design->fetch('threebanners.tpl');
	}
	
}
