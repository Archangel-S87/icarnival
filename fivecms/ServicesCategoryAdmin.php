<?php

require_once('api/Fivecms.php');

class ServicesCategoryAdmin extends Fivecms
{
  private	$allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico');
  
  function fetch()
  {
  		$category = new \stdClass();
		if($this->request->method('post'))
		{
			$category->id = $this->request->post('id', 'integer');
			$category->parent_id = $this->request->post('parent_id', 'integer');
			$category->name = $this->request->post('name');
			$category->menu = $this->request->post('menu');
			$category->visible = $this->request->post('visible', 'boolean');

			$category->url = $this->request->post('url', 'string');
			$category->meta_title = $this->request->post('meta_title');
			$category->meta_keywords = $this->request->post('meta_keywords');
			$category->meta_description = $this->request->post('meta_description');
			
			$category->description = $this->request->post('description');
	
			// Не допустить одинаковые URL разделов.
			if(($c = $this->services_categories->get_services_category($category->url)) && $c->id!=$category->id)
			{			
				$this->design->assign('message_error', 'url_exists');
				if(!empty($category->id))
					$images = $this->services_categories->get_images(array('post_id'=>$category->id));
			}
			else
			{
				if(empty($category->id))
				{
	  				$category->id = $this->services_categories->add_services_category($category);
					$this->design->assign('message_success', 'added');
	  			}
  	    		else
  	    		{
  	    			$this->services_categories->update_services_category($category->id, $category);
					$this->design->assign('message_success', 'updated');
  	    		}
  	    		// Удаление изображения
  	    		if($this->request->post('delete_image'))
  	    		{
  	    			$this->services_categories->delete_image($category->id);
  	    		}
  	    		// Загрузка изображения
  	    		$image = $this->request->files('image');
  	    		if(!empty($image['name']) && in_array(strtolower(pathinfo($image['name'], PATHINFO_EXTENSION)), $this->allowed_image_extentions))
  	    		{
  	    			$this->services_categories->delete_image($category->id);
  	    			
  	    			// проверка имени
  	    			$fname = pathinfo($image['name'], PATHINFO_FILENAME);
					$fext = pathinfo($image['name'], PATHINFO_EXTENSION);
  	    			$testname = $this->root_dir.$this->config->services_categories_images_dir.$fname.'.'.$fext;
					while(file_exists($testname))
					{
						if(preg_match('/(.+)_([0-9]+)$/', $fname, $parts)) {
							$fname = $parts[1].'_'.($parts[2]+1);
						}else{
							$fname = $fname.'_2';
						}
						$image['name'] = $fname.'.'.$fext;
						$testname = $this->root_dir.$this->config->services_categories_images_dir.$image['name'];
					}
					// проверка имени end
						
  	    			move_uploaded_file($image['tmp_name'], $this->root_dir.$this->config->services_categories_images_dir.$image['name']);
  	    			$this->services_categories->update_services_category($category->id, array('image'=>$image['name']));
  	    		}
  	    		$category = $this->services_categories->get_services_category(intval($category->id));
  	    		
  	    		// доп изображения
  	    		$images = (array)$this->request->post('images');
  	    		if(!empty($category->id)){
					$current_images = $this->services_categories->get_images(array('post_id'=>$category->id));
					foreach($current_images as $image)
					{
						if(!in_array($image->id, $images))
							$this->services_categories->delete_images($image->id);
					}
				}
				if($images = $this->request->post('images'))
				{
					$i=0;
					foreach($images as $id)
					{
						$this->services_categories->update_image($id, array('position'=>$i));
						$i++;
					}
				}

				if($images = $this->request->files('images'))
				{
					for($i=0; $i<count($images['name']); $i++)
					{
						if ($image_name = $this->image->upload_image($images['tmp_name'][$i], $images['name'][$i], 'services'))
						{
							$this->services_categories->add_image($category->id, $image_name);
						}
						else
						{
							$this->design->assign('error', 'error uploading image');
						}
					}
				}
				if(!empty($category->id))
					$images = $this->services_categories->get_images(array('post_id'=>$category->id));
				// доп изображения end
			}
		}
		else
		{
			$category->id = $this->request->get('id', 'integer');
			$category = $this->services_categories->get_services_category($category->id);
			
			if($category && !empty($category->id))
			{
				$images = $this->services_categories->get_images(array('post_id'=>$category->id));
			}
			
		}
		if(!empty($images))
			$this->design->assign('post_images', $images);

		$services_categories = $this->services_categories->get_services_categories_tree();

		$this->design->assign('category', $category);
		$this->design->assign('services_categories', $services_categories);
		return  $this->design->fetch('services_category.tpl');
	}
}