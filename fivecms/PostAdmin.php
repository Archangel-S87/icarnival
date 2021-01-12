<?PHP

require_once('api/Fivecms.php');

class PostAdmin extends Fivecms
{
	public function fetch()
	{
		$images = array();
		$post = new stdClass;
		if($this->request->method('post'))
		{
			$post->id = $this->request->post('id', 'integer');
			$post->name = $this->request->post('name');
			$post->date = date('Y-m-d', strtotime($this->request->post('date')));
			$post->category = $this->request->post('category', 'integer');
			$post->visible = $this->request->post('visible', 'boolean');
			$post->url = $this->request->post('url', 'string');
			$post->meta_title = $this->request->post('meta_title');
			$post->meta_keywords = $this->request->post('meta_keywords');
			$post->meta_description = $this->request->post('meta_description');
			$post->annotation = $this->request->post('annotation');
			$post->text = $this->request->post('body');

 			// Не допустить одинаковые URL разделов.
			if(($a = $this->blog->get_post($post->url)) && $a->id!=$post->id)
			{			
				$this->design->assign('message_error', 'url_exists');
				if(!empty($post->id))
					$images = $this->blog->get_images(array('post_id'=>$post->id));
			}
			else
			{
				if(empty($post->id))
				{
	  				$post->id = $this->blog->add_post($post);
	  				$post = $this->blog->get_post($post->id);
					$this->design->assign('message_success', 'added');
	  			}
  	    		else
  	    		{
  	    			$this->blog->update_post($post->id, $post);
  	    			$post = $this->blog->get_post($post->id);
					$this->design->assign('message_success', 'updated');
  	    		}	

				// Удаляем изображения
				$images = (array)$this->request->post('images');
				if(!empty($post->id)){
					$current_images = $this->blog->get_images(array('post_id'=>$post->id));
					foreach($current_images as $image)
					{
						if(!in_array($image->id, $images))
							$this->blog->delete_image($image->id);
					}
				}
				// Обновляем изображения
				if($images = $this->request->post('images'))
				{
					$i=0;
					foreach($images as $id)
					{
						$this->blog->update_image($id, array('position'=>$i));
						$i++;
					}
				}
				// Загружаем изображения
				if($images = $this->request->files('images'))
				{
					for($i=0; $i<count($images['name']); $i++)
					{
						if ($image_name = $this->image->upload_image($images['tmp_name'][$i], $images['name'][$i], 'blog'))
						{
							$this->blog->add_image($post->id, $image_name);
						}
						else
						{
							$this->design->assign('error', 'error uploading image');
						}
					}
				}
				if(!empty($post->id))
					$images = $this->blog->get_images(array('post_id'=>$post->id));
			}
			
			// Теги
			if(!empty($post->id)) {
				$this->blog->delete_tags('blog', $post->id);
				if(!empty($this->request->post('tags')))
					$this->blog->add_tags('blog', $post->id, $this->request->post('tags'));
			}
		}
		else
		{
			$post->id = $this->request->get('id', 'integer');
			$post = $this->blog->get_post(intval($post->id));

			if($post && !empty($post->id))
			{
				$images = $this->blog->get_images(array('post_id'=>$post->id));
			}
		}

		if(empty($post))
		{
			$post = new stdClass;
			$post->date = date($this->settings->date_format, time());
		}
 		
		$this->design->assign('post_images', $images);
		
		$categories = $this->blog_categories->get_categories();
		$this->design->assign('categories', $categories);
		
		// Теги
		if(!empty($post->id))
        	$post->tags = $this->blog->get_tags(array('object_id'=>$post->id, 'type' => 'blog'));  

		$this->design->assign('post', $post);
				
 	  	return $this->design->fetch('post.tpl');
	}
}