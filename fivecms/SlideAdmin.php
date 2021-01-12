<?php

require_once('api/Fivecms.php');

class SlideAdmin extends Fivecms
{
  private $allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico');

  function fetch()
  {
		if($this->request->method('post'))
		{
			$slide->id = $this->request->post('id', 'integer');
			$slide->name = $this->request->post('name');
			$slide->description = $this->request->post('description');
			$slide->url = $this->request->post('url');

				if(empty($slide->id))
				{
	  				$slide->id = $this->slides->add_slide($slide);
					$this->design->assign('message_success', 'added');
	  			}
  	    		else
  	    		{
  	    			$this->slides->update_slide($slide->id, $slide);
					$this->design->assign('message_success', 'updated');
  	    		}	
  	    		// Удаление изображения
  	    		if($this->request->post('delete_image'))
  	    		{
  	    			$this->slides->delete_image($slide->id);
  	    		}
  	    		// Загрузка изображения
				$image = preg_replace("/\s+/", '_', $this->request->files('image'));

  	    		if(!empty($image['name']) && in_array(strtolower(pathinfo($image['name'], PATHINFO_EXTENSION)), $this->allowed_image_extentions))
  	    		{
  	    			$this->slides->delete_image($slide->id);   	    			
  	    			move_uploaded_file($image['tmp_name'], $this->root_dir.$this->config->slides_images_dir.$image['name']);
  	    			$this->slides->update_slide($slide->id, array('image'=>$this->config->slides_images_dir.$image['name']));
  	    		}
	  			$slide = $this->slides->get_slide($slide->id);
			
		}
		else
		{
			$slide->id = $this->request->get('id', 'integer');
			$slide = $this->slides->get_slide($slide->id);
		}
		
 		$this->design->assign('slide', $slide);
		return  $this->design->fetch('slide.tpl');
	}
}