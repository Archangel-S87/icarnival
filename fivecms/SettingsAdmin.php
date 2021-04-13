<?PHP
require_once('api/Fivecms.php');

class SettingsAdmin extends Fivecms
{	
	private $allowed_image_extentions = array('png');
	private $allowed_ico_extentions = array('png', 'gif', 'ico');
	
	public function fetch()
	{	
		if($this->request->method('POST'))
		{
			if($this->request->post('lang_save')) {
				// Язык админки
				$admin_lang = $this->request->post('lang');
				setcookie('admin_lang', $admin_lang, time()+31536000, "/");
				$this->design->assign('admin_lang', $admin_lang);
                header('location: '.$this->config->root_url.'/fivecms/index.php?module=SettingsAdmin');
            } elseif($this->request->post('clear_db')) {
            	$this->db->truncate_table($this->config->db_prefix."carts");
            	$this->design->assign('message_success', 'db_cleared');
			} else {
				$this->settings->site_name = $this->request->post('site_name');
				$this->settings->company_name = $this->request->post('company_name');
				$this->settings->date_format = $this->request->post('date_format');
				$this->settings->admin_email = $this->request->post('admin_email');
				$this->settings->copyright = $this->request->post('copyright');
			
				$this->settings->addlinkurl = $this->request->post('addlinkurl');
				$this->settings->addlinkname = $this->request->post('addlinkname');
				$this->settings->phone = $this->request->post('phone');
				$this->settings->tel = $this->request->post('tel');
				$this->settings->worktime = $this->request->post('worktime');
			
				$this->settings->cart_storage = $this->request->post('cart_storage');
				$this->settings->purpose = $this->request->post('purpose');
				$this->settings->font = $this->request->post('font');
				$this->settings->bullet = $this->request->post('bullet');

				$this->settings->disclaimer = $this->request->post('disclaimer');
				$this->settings->apiid = $this->request->post('apiid');
				$this->settings->apifrom = $this->request->post('apifrom');
				$this->settings->allowsms = $this->request->post('allowsms');
				$this->settings->statussms = $this->request->post('statussms');
				$this->settings->smsadmin = $this->request->post('smsadmin');
				$this->settings->site_disabled = $this->request->post('site_disabled', 'integer');

				$this->settings->images_quality = $this->request->post('images_quality');
			
				// Водяной знак
				$clear_image_cache = false;
				$watermark = $this->request->files('watermark_file', 'tmp_name');
				if(!empty($watermark) && in_array(pathinfo($this->request->files('watermark_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions))
				{
					if(@move_uploaded_file($watermark, $this->config->root_dir.$this->config->watermark_file))
						$clear_image_cache = true;
					else
						$this->design->assign('message_error', 'watermark_is_not_writable');
				}
			
				if($this->settings->watermark_offset_x != $this->request->post('watermark_offset_x'))
				{
					$this->settings->watermark_offset_x = $this->request->post('watermark_offset_x');
					$clear_image_cache = true;
				}
				if($this->settings->watermark_offset_y != $this->request->post('watermark_offset_y'))
				{
					$this->settings->watermark_offset_y = $this->request->post('watermark_offset_y');
					$clear_image_cache = true;
				}
				if($this->settings->watermark_transparency != $this->request->post('watermark_transparency'))
				{
					$this->settings->watermark_transparency = $this->request->post('watermark_transparency');
					$clear_image_cache = true;
				}
				if($this->settings->images_sharpen != $this->request->post('images_sharpen'))
				{
					$this->settings->images_sharpen = $this->request->post('images_sharpen');
					$clear_image_cache = true;
				}
			
				$logoimg = $this->request->files('logoimg_file', 'tmp_name');
				if(!empty($logoimg) && in_array(pathinfo($this->request->files('logoimg_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions))
				{
					if(!@move_uploaded_file($logoimg, $this->config->root_dir.$this->config->logoimg_file))
						$this->design->assign('message_error', 'logoimg_is_not_writable');
				}

				$faviconimg = $this->request->files('faviconimg_file', 'tmp_name');
				if(!empty($faviconimg) && in_array(pathinfo($this->request->files('faviconimg_file', 'name'), PATHINFO_EXTENSION), $this->allowed_ico_extentions))
				{
					if(!@move_uploaded_file($faviconimg, $this->config->root_dir.$this->config->faviconimg_file))
						$this->design->assign('message_error', 'faviconimg_is_not_writable');
				}
			
				// Удаление заресайзеных изображений
				if($clear_image_cache)
				{
					$dir = $this->config->resized_images_dir;
					if($handle = opendir($dir))
					{
						while(false !== ($file = readdir($handle)))
						{
							if($file != "." && $file != "..")
							{
								@unlink($dir."/".$file);
							}
						}
						closedir($handle);
					}			
				}			
				$this->design->assign('message_success', 'saved');
			}
			
		}
		
		
		$languages = array();
        foreach (glob("fivecms/lang/??.php") as $f) {
            $languages[] = pathinfo($f, PATHINFO_FILENAME);
        }
        $this->design->assign('languages', $languages);
		
 	  	return $this->design->fetch('settings.tpl');
	}
	
}

