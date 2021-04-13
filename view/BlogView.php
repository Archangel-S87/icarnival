<?PHP

require_once('View.php');

class BlogView extends View
{
	public function fetch()
	{
		$url = $this->request->get('url', 'string');
		
		// Если указан адрес поста,
		if(!empty($url))
		{
			// Выводим пост
			return $this->fetch_post($url);
		}
		else
		{
			// Иначе выводим ленту блога
			return $this->fetch_blog();
		}	
	}
	
	private function fetch_post($url)
	{
		// Выбираем пост из базы
		$post = $this->blog->get_post($url);
		
		// Получаем IP-посетителя
		$ip = $this->design->get_user_ip();
	
		// Если не найден - ошибка
		if(empty($post) || (!$post->visible && empty($_SESSION['admin'])))
			return false;
		
		// Выводим изображения поста	
		$post->images = $this->blog->get_images(array('post_id'=>$post->id));
		$post->image = &$post->images[0];	
			
		// Разделы блога	
		// Вывод категорий
		$blog_categories = $this->blog_categories->get_categories();
		$this->design->assign('blog_categories', $blog_categories);
		//выводим текущую категорию
		$cat = $this->blog_categories->get_category(intval($post->category));
		$this->design->assign('category', $cat);
		// Разделы блога @
		
		// Автозаполнение имени для формы комментария
		if(!empty($this->user)){
			$this->design->assign('comment_name', $this->user->name);
			$this->design->assign('comment_email', $this->user->email); 
		}
		// Изменим кол-во просмотров	
		if($post->visible && empty($_SESSION['admin']))
			$this->blog->update_views($post->id); 
		
		// Принимаем комментарий
		if ($this->request->method('post') && $this->request->post('comment'))
		{
			$comment = new stdClass;
			$comment->name = $this->request->post('name');
			$comment->text = $this->request->post('text');
			$comment->email = $this->request->post('email');
			// antibot
			if($this->request->post('bttrue')) {
				$bttrue = $this->request->post('bttrue');
				$this->design->assign('bttrue', $bttrue);
			}	
			if($this->request->post('btfalse')) {
				$btfalse = $this->request->post('btfalse');
				$this->design->assign('btfalse', $btfalse);
			}
			// antibot end
			
			// Передадим комментарий обратно в шаблон - при ошибке нужно будет заполнить форму
			$this->design->assign('comment_text', $comment->text);
			$this->design->assign('comment_name', $comment->name);
			$this->design->assign('comment_email', $comment->email);
			
			// Проверяем капчу и заполнение формы
			if (empty($comment->name))
				$this->design->assign('error', 'empty_name');
			elseif($this->settings->spam_cyr == 1 && !preg_match('/^[а-яё \t]+$/iu', $comment->name))
				$this->design->assign('error', 'wrong_name');
			elseif(!empty($this->settings->spam_symbols) && mb_strlen($comment->name,'UTF-8') > $this->settings->spam_symbols)
				$this->design->assign('error', 'captcha');	
			elseif(!empty($comment->email) && filter_var($comment->email, FILTER_VALIDATE_EMAIL) === false)	
				$this->design->assign('error', 'wrong_email');		
			elseif(empty($comment->text))
				$this->design->assign('error', 'empty_comment');
			elseif(empty($bttrue))
				$this->design->assign('error', 'captcha');
			elseif(!empty($btfalse))
				$this->design->assign('error', 'captcha');
			else
			{
				// Создаем комментарий
				$comment->object_id = $post->id;
				$comment->type      = 'blog';
				$comment->ip        = $ip;
				
				// Если были одобренные комментарии от текущего ip, одобряем сразу
				// $this->db->query("SELECT 1 FROM __comments WHERE approved=1 AND ip=? LIMIT 1", $comment->ip);
				// if($this->db->num_rows()>0)
				//	$comment->approved = 1;
				
				// Добавляем комментарий в базу
				$comment_id = $this->comments->add_comment($comment);
				
				if($this->settings->auto_subscribe == 1)
					$this->mailer->add_mail($comment->name, $comment->email);
				
				// Отправляем email
				$this->notify->email_comment_admin($comment_id);				
				header('location: '.$_SERVER['REQUEST_URI'].'#comment_'.$comment_id);
			}			
		}
		
		// Комментарии к посту
		$comments = $this->comments->get_comments(array('type'=>'blog', 'object_id'=>$post->id, 'approved'=>1, 'ip'=>$ip));
		$this->design->assign('comments', $comments);
		$post->tags = $this->blog->get_tags(array('object_id'=>$post->id, 'type' => 'blog'));
		$this->design->assign('post',      $post);
		
		// Соседние записи
		$this->design->assign('next_post', $this->blog->get_next_post($post->id));
		$this->design->assign('prev_post', $this->blog->get_prev_post($post->id));
		
		// Мета-теги
		$this->design->assign('meta_title', $post->meta_title);
		$this->design->assign('meta_keywords', $post->meta_keywords);
		$this->design->assign('meta_description', $post->meta_description);
		
		//lastModify
        $this->setHeaderLastModify($post->last_modify, 2592000);  // expires 2592000 - month
		
		return $this->design->fetch('post.tpl');
	}	
	
	// Отображение списка постов
	private function fetch_blog()
	{
		// Количество постов на 1 странице
		if($this->design->is_mobile_browser())
			$items_per_page = $this->settings->mob_products_num;
		else
			$items_per_page = 12;

		$filter = array();

		$keyword = $this->request->get('keyword', 'string');
        if (!empty($keyword))
        {
            $this->design->assign('keyword', $keyword);
            $filter['keyword'] = $keyword;
        }
		
		// Выбираем только видимые посты
		$filter['visible'] = 1;
		
		// Текущая страница в постраничном выводе
		$current_page = $this->request->get('page', 'integer');
		
		// Если не задана, то равна 1
		$current_page = max(1, $current_page);
		$this->design->assign('current_page_num', $current_page);
		
		// Разделы блога
		$category = $this->request->get('category', 'string');
		if($category){
			$cat = $this->blog_categories->get_category($category);
			//$this->design->assign('cat', $cat);
			$filter['category_id'] = $cat->id;
		}
		// Вывод категорий
		$filter_cat = array();
		$filter_cat['visible'] = 1;
		$blog_categories = $this->blog_categories->get_categories($filter_cat);
		$this->design->assign('blog_categories', $blog_categories);
		// Выводим текущую категорию
		$cat = $this->blog_categories->get_category($category);
		$this->design->assign('category', $cat);
		// Разделы блога @

		// Вычисляем количество страниц
		$posts_count = $this->blog->count_posts($filter);

		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$items_per_page = $posts_count;	

		$pages_num = ceil($posts_count/$items_per_page);
		$this->design->assign('total_pages_num', $pages_num);

		$filter['page'] = $current_page;
		$filter['limit'] = $items_per_page;
		
		// Выбираем статьи из базы
		$posts = $this->blog->get_posts($filter);
		//if(empty($posts))
		//	return false;

		// Передаем в шаблон
		$this->design->assign('posts', $posts);
		
		// Метатеги
		if($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
		} elseif($category) {
			$this->design->assign('meta_title', $cat->meta_title);
			$this->design->assign('meta_keywords', $cat->meta_keywords);
			$this->design->assign('meta_description', $cat->meta_description);
		}
		
		// last modify
		$this->db->query("SELECT b.last_modify FROM __blog b");
        $last_modify = $this->db->results('last_modify');
        if($this->page) {
            $last_modify[] = $this->page->last_modify;
        } elseif($category) {
        	$last_modify[] = $cat->last_modify;
        }
        $this->setHeaderLastModify(max($last_modify), 604800);  // expires 604800 - week
        // last modify end
        
		foreach($posts as &$post) { 
			// изображения для записей блога
			$post->images = array(); 
			$post->images = $this->blog->get_images(array('post_id'=>$post->id)); 
			$post->image = &$post->images[0]; 
			// категории для записей блога
			$post->section = array(); 
			$post->section = $this->blog_categories->get_category(intval($post->category));
			// комментарии
			$post->comments_count = array(); 
			$post->comments_count = $this->comments->count_comments(array('type'=>'blog', 'object_id'=>$post->id, 'approved'=>1));
		}

		$body = $this->design->fetch('blog.tpl');
		
		return $body;
	}	
	
}