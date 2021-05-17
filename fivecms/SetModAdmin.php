<?PHP
require_once('api/Fivecms.php');

class SetModAdmin extends Fivecms
{	
	private $allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico', 'webp', 'jp2', 'jxr');

	public function fetch()
	{			
		if($this->request->method('POST'))
		{
			$this->settings->main_cat_num = $this->request->post('main_cat_num');
			$this->settings->main_cat_columns = $this->request->post('main_cat_columns');
			
			$this->settings->mainhits = $this->request->post('mainhits');
			$this->settings->mainnew = $this->request->post('mainnew');
			$this->settings->mainsale = $this->request->post('mainsale');
			
			$this->settings->widebanner = $this->request->post('widebanner');
			
			$this->settings->main_blog = $this->request->post('main_blog');
			$this->settings->main_articles = $this->request->post('main_articles');
			
			$this->settings->action_description = $this->request->post('action_description');
			$this->settings->action_end_date_checked = $this->request->post('action_end_date_checked');
			$this->settings->action_end_date = $this->request->post('action_end_date');
			$this->settings->action_end_date_hours = $this->request->post('action_end_date_hours');
			$this->settings->action_end_date_minutes = $this->request->post('action_end_date_minutes');	

			$this->settings->b1manage = $this->request->post('b1manage');
			$this->settings->b2manage = $this->request->post('b2manage');
			$this->settings->b3manage = $this->request->post('b3manage');
			$this->settings->b4manage = $this->request->post('b4manage');
			$this->settings->b5manage = $this->request->post('b5manage');
			$this->settings->b6manage = $this->request->post('b6manage');
			$this->settings->b7manage = $this->request->post('b7manage');
			$this->settings->show_nav_cat = $this->request->post('show_nav_cat');
			$this->settings->hide_blog = $this->request->post('hide_blog');
			$this->settings->popup_cart = $this->request->post('popup_cart');
			$this->settings->b8manage = $this->request->post('b8manage');
			$this->settings->attachment = $this->request->post('attachment');
			$this->settings->maxattachment = $this->request->post('maxattachment');
			$this->settings->ulogin = $this->request->post('ulogin');
			$this->settings->cart_tabs = $this->request->post('cart_tabs');
			$this->settings->allow_comment_tags = $this->request->post('allow_comment_tags');
			$this->settings->comment_tags = $this->request->post('comment_tags');
			$this->settings->allow_views = $this->request->post('allow_views');
			
			$this->settings->spam_ip = $this->request->post('spam_ip');
			$this->settings->spam_cyr = $this->request->post('spam_cyr');
			$this->settings->spam_symbols = $this->request->post('spam_symbols');

			$this->settings->addfield3 = $this->request->post('addfield3');
			$this->settings->addf3name = $this->request->post('addf3name');
			
			$this->settings->advertblog = $this->request->post('advertblog');
			$this->settings->advertarticle = $this->request->post('advertarticle');
			$this->settings->advertservice = $this->request->post('advertservice');
			$this->settings->advertpage = $this->request->post('advertpage');
			
			$this->settings->cookshow = $this->request->post('cookshow');
			$this->settings->cookwarn = $this->request->post('cookwarn');
			
			$this->settings->consultant = $this->request->post('consultant');

			$this->design->assign('message_success', 'saved');

            $temp_position = $this->request->post('position_carousel');
            $position_carousel = [];
            $index = 0;
            asort($temp_position);
            while (count($temp_position)) {
                reset($temp_position);
                $key = key($temp_position);
                $position_carousel[$key] = ++$index;
                unset($temp_position[$key]);
            }
            $this->settings->position_carousel = $position_carousel;
		}

		$image = $this->request->files('bannerwide_file');
  	    if(!empty($image['name']) && in_array(strtolower(pathinfo($image['name'], PATHINFO_EXTENSION)), $this->allowed_image_extentions))
  	    {   	 
  	    	// проверка имени
  	    	$fname = pathinfo($image['name'], PATHINFO_FILENAME);
			$fext = pathinfo($image['name'], PATHINFO_EXTENSION);
  	    	$testname = $this->root_dir.$this->config->threebanners_images_dir.$fname.'.'.$fext;
			while(file_exists($testname))
			{
				if(preg_match('/(.+)_([0-9]+)$/', $fname, $parts)) {
					$fname = $parts[1].'_'.($parts[2]+1);
				}else{
					$fname = $fname.'_2';
				}
				$image['name'] = $fname.'.'.$fext;
				$testname = $this->root_dir.$this->config->threebanners_images_dir.$image['name'];
			}
			// проверка имени end
  	    	   			
  	    	if(!@move_uploaded_file($image['tmp_name'], $this->root_dir.$this->config->threebanners_images_dir.$image['name'])){
  	    		$this->design->assign('message_error', 'bannerwide_is_not_writable');
  	    	} else {	
  	    		unlink($this->root_dir.$this->config->threebanners_images_dir.$this->settings->widebanner_file);
  	    		$this->settings->widebanner_file = $image['name'];
  	    	}
  	    }

 	  	return $this->design->fetch('setmod.tpl');
	}
	
}

