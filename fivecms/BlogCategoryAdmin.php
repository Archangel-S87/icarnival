<?PHP

require_once('api/Fivecms.php');

class BlogCategoryAdmin extends Fivecms
{
	private	$allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico');
	
	public function fetch()
	{
		$category = new stdClass;
		if($this->request->method('post'))
		{
			$category->id = $this->request->post('id', 'integer');
			$category->name = $this->request->post('name');
			$category->visible = $this->request->post('visible', 'boolean');

			$category->url = $this->request->post('url', 'string');
			$category->meta_title = $this->request->post('meta_title');
			$category->meta_keywords = $this->request->post('meta_keywords');
			$category->meta_description = $this->request->post('meta_description');
			
			$category->annotation = $this->request->post('annotation');

 			// Не допустить одинаковые URL разделов.
			if(($a = $this->blog_categories->get_category($category->url)) && $a->id!=$category->id)
			{			
				$this->design->assign('message_error', 'url_exists');
			}
			else
			{
				if(empty($category->id))
				{
	  				$category->id = $this->blog_categories->add_category($category);
					$this->design->assign('message_success', 'added');
	  			}
  	    		else
  	    		{
  	    			$this->blog_categories->update_category($category->id, $category);
					$this->design->assign('message_success', 'updated');
  	    		}
  	    		
  	    		/* Изображение категории */
  	    		// Удаление изображения
  	    		if($this->request->post('delete_image'))
  	    		{
  	    			$this->blog_categories->delete_image($category->id);
  	    		}
  	    		// Загрузка изображения
  	    		$image = $this->request->files('image');
  	    		if(!empty($image['name']) && in_array(strtolower(pathinfo($image['name'], PATHINFO_EXTENSION)), $this->allowed_image_extentions))
  	    		{
  	    			$this->blog_categories->delete_image($category->id);
  	    			
  	    			// проверка имени
  	    			$fname = pathinfo($image['name'], PATHINFO_FILENAME);
					$fext = pathinfo($image['name'], PATHINFO_EXTENSION);
  	    			$testname = $this->root_dir.$this->config->blog_categories_images_dir.$fname.'.'.$fext;
					while(file_exists($testname))
					{
						if(preg_match('/(.+)_([0-9]+)$/', $fname, $parts)) {
							$fname = $parts[1].'_'.($parts[2]+1);
						}else{
							$fname = $fname.'_2';
						}
						$image['name'] = $fname.'.'.$fext;
						$testname = $this->root_dir.$this->config->blog_categories_images_dir.$image['name'];
					}
					// проверка имени end
  	    			
  	    			move_uploaded_file($image['tmp_name'], $this->root_dir.$this->config->blog_categories_images_dir.$image['name']);
  	    			$this->blog_categories->update_category($category->id, array('image'=>$image['name']));
  	    		}	
  	    		/* Изображение категории @ */
  	    		$category = $this->blog_categories->get_category($category->id);
			}
		}
		else
		{
			$category->id = $this->request->get('id', 'integer');
			$category = $this->blog_categories->get_category(intval($category->id));
		}

		if(empty($category))
		{
			$category = new stdClass;
		}
 		
		$this->design->assign('category', $category);
		
 	  	return $this->design->fetch('blog_category.tpl');
	}
}