<?php

require_once('api/Fivecms.php');

class SlidemAdmin extends Fivecms
{
  private $allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg');

  function fetch()
  {
  		$slidem = new \stdClass();
		if($this->request->method('post'))
		{
			$slidem->id = $this->request->post('id', 'integer');
			$slidem->name = $this->request->post('name');
			//$slidem->description = $this->request->post('description');
			$slidem->url = $this->request->post('url');

				if(empty($slidem->id))
				{
	  				$slidem->id = $this->slidesm->add_slidem($slidem);
					$this->design->assign('message_success', 'added');
	  			}
  	    		else
  	    		{
  	    			$this->slidesm->update_slidem($slidem->id, $slidem);
					$this->design->assign('message_success', 'updated');
  	    		}	
  	    		// Удаление изображения
  	    		if($this->request->post('delete_image'))
  	    		{
  	    			$this->slidesm->delete_image($slidem->id);
  	    		}
  	    		// Загрузка изображения
				$image = preg_replace("/\s+/", '_', $this->request->files('image'));

  	    		if(!empty($image['name']) && in_array(strtolower(pathinfo($image['name'], PATHINFO_EXTENSION)), $this->allowed_image_extentions))
  	    		{
  	    			$this->slidesm->delete_image($slidem->id);   	    			
  	    			move_uploaded_file($image['tmp_name'], $this->root_dir.$this->config->slidesm_images_dir.$image['name']);
  	    			$this->slidesm->update_slidem($slidem->id, array('image'=>$this->config->slidesm_images_dir.$image['name']));
  	    		}
	  			$slidem = $this->slidesm->get_slidem($slidem->id);
			
		}
		else
		{
			$slidem->id = $this->request->get('id', 'integer');
			$slidem = $this->slidesm->get_slidem($slidem->id);
		}
		
 		$this->design->assign('slidem', $slidem);
		return  $this->design->fetch('slide_mob.tpl');
	}
}