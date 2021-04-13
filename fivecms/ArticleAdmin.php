<?PHP

require_once('api/Fivecms.php');

class ArticleAdmin extends Fivecms
{
	public function fetch()
	{
		$images = array();

		$post = new \stdClass();
		if($this->request->method('post'))
		{
			$post->id = $this->request->post('id', 'integer');
			$post->name = $this->request->post('name');
			$post->date = date('Y-m-d', strtotime($this->request->post('date')));
			$post->visible = $this->request->post('visible', 'boolean');
			$post->category_id = $this->request->post('category_id', 'integer');
			$post->url = $this->request->post('url', 'string');
			$post->meta_title = $this->request->post('meta_title');
			$post->meta_keywords = $this->request->post('meta_keywords');
			$post->meta_description = $this->request->post('meta_description');
			$post->annotation = $this->request->post('annotation');
			$post->text = $this->request->post('body');

			// Связанные товары
            if(is_array($this->request->post('related_products')))
            {
                foreach($this->request->post('related_products') as $p)
                {
                    @$rp[$p]->related_id = $p;
                    $rp[$p]->type = 'product';
                }
                $related_objects = $rp;
            }   

            // Связанные статьи
            if(is_array($this->request->post('related_articles')))
            {
                foreach($this->request->post('related_articles') as $p)
                {
                    @$rp[$p]->related_id = $p;
                    $rp[$p]->type = 'article';
                }
                $related_objects = $rp;
            } 

 			// Не допустить одинаковые URL разделов.
			if(($a = $this->articles->get_article($post->url)) && $a->id!=$post->id)
			{			
				$this->design->assign('message_error', 'url_exists');
			}
			else
			{
				if(empty($post->id))
				{
	  				$post->id = $this->articles->add_article($post);
	  				$post = $this->articles->get_article($post->id);
					$this->design->assign('message_success', 'added');
	  			}
  	    		else
  	    		{
  	    			$this->articles->update_article($post->id, $post);
  	    			$post = $this->articles->get_article($post->id);
					$this->design->assign('message_success', 'updated');
  	    		}	

				// Удаляем изображения
				$images = (array)$this->request->post('images');
				if(!empty($post->id)){
					$current_images = $this->articles->get_images(array('post_id'=>$post->id));
					foreach($current_images as $image)
					{
						if(!in_array($image->id, $images))
							$this->articles->delete_image($image->id);
					}
				}
				
				// Обновляем изображения
				if($images = $this->request->post('images'))
				{
					$i=0;
					foreach($images as $id)
					{
						$this->articles->update_image($id, array('position'=>$i));
						$i++;
					}
				}

				// Загружаем изображения
				if($images = $this->request->files('images'))
				{
					for($i=0; $i<count($images['name']); $i++)
					{
						if ($image_name = $this->image->upload_image($images['tmp_name'][$i], $images['name'][$i], 'articles'))
						{
							$this->articles->add_image($post->id, $image_name);
						}
						else
						{
							$this->design->assign('error', 'error uploading image');
						}
					}
				}
   	    		
			}
			
			if(!empty($post->id))
				$images = $this->articles->get_images(array('post_id'=>$post->id));
			
			// Связанные объекты
            $query = $this->db->placehold('DELETE FROM __article_objects WHERE article_id=?', $post->id);
            $this->db->query($query);
            if(!empty($related_objects) && is_array($related_objects))
            {
              $pos = 0;
              foreach($related_objects  as $i=>$related_object)
                   $this->articles->add_related_object($post->id, $related_object->related_id, $related_object->type);
            }   
			
		}
		else
		{
			$post->id = $this->request->get('id', 'integer');
			$post = $this->articles->get_article(intval($post->id));

			if(!empty($post))
				$images = $this->articles->get_images(array('post_id'=>$post->id));
		}

		if(empty($post)){
			$post = new stdClass;
			$post->date = date($this->settings->date_format, time());
		} else {
			$related_objects = $this->articles->get_related_objects(array('id'=>$post->id));
		}
		
		// Связанные объекты
        if(!empty($related_objects))
        {
            $r_products = array();
            $r_articles = array();
            
            foreach($related_objects as &$r_p)
                if($r_p->type == 'product') $r_products[$r_p->object_id] = &$r_p;
                elseif($r_p->type == 'article') $r_articles[$r_p->object_id] = &$r_p;
             
            if(!empty($r_products)) {
                $temp_products = $this->products->get_products(array('id'=>array_keys($r_products)));
                foreach($temp_products as $temp_product)
                    $r_products[$temp_product->id] = $temp_product;
            }
            
            if(!empty($r_articles)) {
                $temp_articles = $this->articles->get_articles(array('id'=>array_keys($r_articles)));
                foreach($temp_articles as $temp_article)
                    $r_articles[$temp_article->id] = $temp_article;
            }
        
            $this->design->assign('related_products', $r_products);
            $this->design->assign('related_articles', $r_articles);
        }
 		
		$this->design->assign('post_images', $images);

		$this->design->assign('post', $post);

		// Категории
		$articles_categories = $this->articles_categories->get_articles_categories_tree();
		$this->design->assign('articles_categories', $articles_categories);		
		
 	  	return $this->design->fetch('article.tpl');
	}
}