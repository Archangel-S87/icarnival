<?php

require_once('api/Fivecms.php');

class ArticlesCategoryAdmin extends Fivecms
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
			if(($c = $this->articles_categories->get_articles_category($category->url)) && $c->id!=$category->id)
			{			
				$this->design->assign('message_error', 'url_exists');
			}
			else
			{
				if(empty($category->id))
				{
	  				$category->id = $this->articles_categories->add_articles_category($category);
					$this->design->assign('message_success', 'added');
	  			}
  	    		else
  	    		{
  	    			$this->articles_categories->update_articles_category($category->id, $category);
					$this->design->assign('message_success', 'updated');
  	    		}
  	    		// Удаление изображения
  	    		if($this->request->post('delete_image'))
  	    		{
  	    			$this->articles_categories->delete_image($category->id);
  	    		}
  	    		// Загрузка изображения
  	    		$image = $this->request->files('image');
  	    		if(!empty($image['name']) && in_array(strtolower(pathinfo($image['name'], PATHINFO_EXTENSION)), $this->allowed_image_extentions))
  	    		{
  	    			$this->articles_categories->delete_image($category->id);
  	    			
  	    			// проверка имени
  	    			$fname = pathinfo($image['name'], PATHINFO_FILENAME);
					$fext = pathinfo($image['name'], PATHINFO_EXTENSION);
  	    			$testname = $this->root_dir.$this->config->articles_categories_images_dir.$fname.'.'.$fext;
					while(file_exists($testname))
					{
						if(preg_match('/(.+)_([0-9]+)$/', $fname, $parts)) {
							$fname = $parts[1].'_'.($parts[2]+1);
						}else{
							$fname = $fname.'_2';
						}
						$image['name'] = $fname.'.'.$fext;
						$testname = $this->root_dir.$this->config->articles_categories_images_dir.$image['name'];
					}
					// проверка имени end
  	    			
  	    			move_uploaded_file($image['tmp_name'], $this->root_dir.$this->config->articles_categories_images_dir.$image['name']);
  	    			$this->articles_categories->update_articles_category($category->id, array('image'=>$image['name']));
  	    		}
  	    		$category = $this->articles_categories->get_articles_category(intval($category->id));
			}
		}
		else
		{
			$category->id = $this->request->get('id', 'integer');
			$category = $this->articles_categories->get_articles_category($category->id);
		}
		
		$articles_categories = $this->articles_categories->get_articles_categories_tree();

		$this->design->assign('category', $category);
		$this->design->assign('articles_categories', $articles_categories);
		return  $this->design->fetch('articles_category.tpl');
	}
}