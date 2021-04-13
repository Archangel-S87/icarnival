<?php

require_once('api/Fivecms.php');


############################################
# Class Category - Edit the good gategory
############################################
class SurveysCategoryAdmin extends Fivecms
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
			$category->visible = $this->request->post('visible', 'boolean');

			$category->url = $this->request->post('url', 'string');
			$category->meta_title = $this->request->post('meta_title');
			$category->meta_keywords = $this->request->post('meta_keywords');
			$category->meta_description = $this->request->post('meta_description');
			
			$category->description = $this->request->post('description');
	
			// Не допустить одинаковые URL разделов.
			if(($c = $this->surveys_categories->get_surveys_category($category->url)) && $c->id!=$category->id)
			{			
				$this->design->assign('message_error', 'url_exists');
			}
			else
			{
				if(empty($category->id))
				{
	  				$category->id = $this->surveys_categories->add_surveys_category($category);
					$this->design->assign('message_success', 'added');
	  			}
  	    		else
  	    		{
  	    			$this->surveys_categories->update_surveys_category($category->id, $category);
					$this->design->assign('message_success', 'updated');
  	    		}
  	    		// Удаление изображения
  	    		if($this->request->post('delete_image'))
  	    		{
  	    			$this->surveys_categories->delete_image($category->id);
  	    		}
  	    		// Загрузка изображения
  	    		$image = $this->request->files('image');
  	    		if(!empty($image['name']) && in_array(strtolower(pathinfo($image['name'], PATHINFO_EXTENSION)), $this->allowed_image_extentions))
  	    		{
  	    			$this->surveys_categories->delete_image($category->id);
  	    			
  	    			// проверка имени
  	    			$fname = pathinfo($image['name'], PATHINFO_FILENAME);
					$fext = pathinfo($image['name'], PATHINFO_EXTENSION);
  	    			$testname = $this->root_dir.$this->config->surveys_categories_images_dir.$fname.'.'.$fext;
					while(file_exists($testname))
					{
						if(preg_match('/(.+)_([0-9]+)$/', $fname, $parts)) {
							$fname = $parts[1].'_'.($parts[2]+1);
						}else{
							$fname = $fname.'_2';
						}
						$image['name'] = $fname.'.'.$fext;
						$testname = $this->root_dir.$this->config->surveys_categories_images_dir.$image['name'];
					}
					// проверка имени end
  	    			
  	    			move_uploaded_file($image['tmp_name'], $this->root_dir.$this->config->surveys_categories_images_dir.$image['name']);
  	    			$this->surveys_categories->update_surveys_category($category->id, array('image'=>$image['name']));
  	    		}
  	    		$category = $this->surveys_categories->get_surveys_category(intval($category->id));
			}
		}
		else
		{
			$category->id = $this->request->get('id', 'integer');
			$category = $this->surveys_categories->get_surveys_category($category->id);
		}
		

		$surveys_categories = $this->surveys_categories->get_surveys_categories_tree();

		$this->design->assign('category', $category);
		$this->design->assign('surveys_categories', $surveys_categories);
		return  $this->design->fetch('surveys_category.tpl');
	}
}