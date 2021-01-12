<?PHP

require_once('View.php');

class ArticlesView extends View
{
	public function fetch()
	{
		$url = $this->request->get('article_url', 'string');
		
		// Articles categories
		$filter_cat = array();
		$filter_cat['visible'] = 1;
		$this->design->assign('articles_categories', $this->articles_categories->get_articles_categories_tree($filter_cat));	
		
		// Если указан адрес поста,
		if(!empty($url))
		{
			// Выводим пост
			return $this->fetch_article($url);
		}
		else
		{
			// Иначе выводим ленту блога
			return $this->fetch_articles($url);
		}
	}
	
	private function fetch_article($url)
	{	
		// Выбираем статью из базы
		$post = $this->articles->get_article($url);
		
		// Если не найдено - ошибка
		if(!$post || (!$post->visible && empty($_SESSION['admin'])))
			return false;
		
		// Выводим изображения статьи	
		$post->images = $this->articles->get_images(array('post_id'=>$post->id));
		$post->image = &$post->images[0];	
		
		// Выводим текущую категорию
		$cat = $this->articles_categories->get_articles_category(intval($post->category_id));
		$this->design->assign('category', $cat);
			
		// Изменим кол-во просмотров	
		if($post->visible && empty($_SESSION['admin']))
			$this->articles->update_views($post->id); 	
		
		$this->design->assign('post', $post);
		
		// Соседние записи
		$this->design->assign('next_post', $this->articles->get_next_article($post->id));
		$this->design->assign('prev_post', $this->articles->get_prev_article($post->id));
		
		// Мета-теги
		$this->design->assign('meta_title', $post->meta_title);
		$this->design->assign('meta_keywords', $post->meta_keywords);
		$this->design->assign('meta_description', $post->meta_description);
		
		$this->setHeaderLastModify($post->last_modify, 2592000); // expires 2592000 - month
		
		return $this->design->fetch('article.tpl');
	}	
	
	// Отображение списка статей
	private function fetch_articles()
	{
		$filter = array();
	
		// GET-Параметры
		$category_url = $this->request->get('category', 'string');
		
		// Выберем текущую категорию
		if (!empty($category_url))
		{
			$category = $this->articles_categories->get_articles_category((string)$category_url);
			if (empty($category) || (!$category->visible && empty($_SESSION['admin'])))
				return false;
			$this->design->assign('category', $category);
			
			$filter['category_id'] = $category->children;
		}    	

		$keyword = $this->request->get('keyword', 'string');
        if (!empty($keyword))
        {
            $this->design->assign('keyword', $keyword);
            $filter['keyword'] = $keyword;
        }

		// Сортировка, сохраняем в сесси, чтобы текущая сортировка оставалась для всего сайта
		if($sort = $this->request->get('articles_sort', 'string'))
			$_SESSION['articles_sort'] = $sort;		
		if (!empty($_SESSION['articles_sort']))
			$filter['sort'] = $_SESSION['articles_sort'];			
		else
			$filter['sort'] = 'position';			
		$this->design->assign('sort', $filter['sort']);
	
		// Количество постов на 1 странице
		if($this->design->is_mobile_browser())
			$items_per_page = $this->settings->mob_products_num;
		else
			$items_per_page = 12;

		// Выбираем только видимые посты
		$filter['visible'] = 1;
		
		// Текущая страница в постраничном выводе
		$current_page = $this->request->get('page', 'integer');
		
		// Если не задана, то равна 1
		$current_page = max(1, $current_page);
		$this->design->assign('current_page_num', $current_page);

		// Вычисляем количество страниц
		$posts_count = $this->articles->count_articles($filter);

		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$items_per_page = $posts_count;	

		$pages_num = ceil($posts_count/$items_per_page);
		$this->design->assign('total_pages_num', $pages_num);

		$filter['page'] = $current_page;
		$filter['limit'] = $items_per_page;
		
		// Выбираем статьи из базы
		$posts = $this->articles->get_articles($filter);

		// Передаем в шаблон
		$this->design->assign('posts', $posts);
		
		// Устанавливаем мета-теги и LastModify в зависимости от запроса
		if($this->page->url == 'articles')
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
			
			$this->db->query("SELECT c.last_modify FROM __articles_categories c");
			$last_modify = $this->db->results('last_modify');
			$last_modify[] = $this->page->last_modify;
			$this->setHeaderLastModify(max($last_modify), 604800); // expires 604800 - week
		}	
		elseif($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
			$this->setHeaderLastModify($this->page->last_modify, 2592000); // expires 2592000 - month
		}
		elseif(isset($category))
		{
			$this->design->assign('meta_title', $category->meta_title);
			$this->design->assign('meta_keywords', $category->meta_keywords);
			$this->design->assign('meta_description', $category->meta_description);
			$this->setHeaderLastModify($category->last_modify, 604800); // expires 604800 - week
		}
		
		foreach($posts as &$post) { 
			// изображения для статей
			$post->images = array(); 
			$post->images = $this->articles->get_images(array('post_id'=>$post->id)); 
			$post->image = &$post->images[0]; 
			// категории для статей
			$post->section = array(); 
			$post->section = $this->articles_categories->get_articles_category(intval($post->category_id));
		}

		$body = $this->design->fetch('articles.tpl');
		
		return $body;
	}	
}