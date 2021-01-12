<?PHP

/**
 *
 * 5CMS
 *
 */

require_once('View.php');

class TagsView extends View
{
	public function fetch()
	{
        // Если задано ключевое слово
        $keyword = $this->request->get('keyword');
        if (empty($keyword))
            $this->design->assign('tags', $this->blog->get_tags(array('group'=>1)));
        else {
            $this->design->assign('keyword', $keyword);  
            $tags = $this->blog->get_tags(array('keyword'=>$keyword));
            
            // Выбирает объекты, которые привязаны к тегу:
            $posts_ids = array();
            foreach($tags as $tag)
            {
                if($tag->type == 'blog')
                    $posts_ids[] = $tag->object_id;
            }
             
            //Блог
            if(count($posts_ids) > 0) {
                $posts = array();
                foreach($this->blog->get_posts(array('id'=>$posts_ids)) as $p)
                    $posts[$p->id] = $p;
                    
                foreach($posts as &$post) { 
                	// Изображения
                	$post->images = array(); 
                	$post->images = $this->blog->get_images(array('post_id'=>$post->id)); 
                	$post->image = &$post->images[0]; 
                	// Раздел блога для данного поста
                	$post->section = array(); 
					$post->section = $this->blog_categories->get_category(intval($post->category));
					// Комментарии
					$post->comments_count = array(); 
					$post->comments_count = $this->comments->count_comments(array('type'=>'blog', 'object_id'=>$post->id, 'approved'=>1));
                }
                
                // Передаем в шаблон    
                $this->design->assign('posts', $posts);  
                
                // Разделы блога
				$blog_categories = $this->blog_categories->get_categories();
				$this->design->assign('blog_categories', $blog_categories);
            }
        }
        
        // Устанавливаем мета-теги в зависимости от запроса
        if($this->page)
        {
            $this->design->assign('meta_title', $this->page->meta_title);
            $this->design->assign('meta_keywords', $this->page->meta_keywords);
            $this->design->assign('meta_description', $this->page->meta_description);
        }
        elseif(isset($keyword))
        {
            $this->design->assign('meta_title', $keyword);
        }
        
        return $this->design->fetch('tags.tpl');
	}

}
