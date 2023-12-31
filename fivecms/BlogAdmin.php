<?php

/**
 *
 *
 * @copyright	5CMS
 * @link		http://5cms.ru
 *
 *
 */
 
require_once('api/Fivecms.php');

class BlogAdmin extends Fivecms
{
	public function fetch()
	{
		// Обработка действий
		if($this->request->method('post'))
		{
			// Действия с выбранными
			$ids = $this->request->post('check');
			if(is_array($ids))
			switch($this->request->post('action'))
			{
			    case 'disable':
			    {
					$this->blog->update_post($ids, array('visible'=>0));	      
					break;
			    }
			    case 'enable':
			    {
					$this->blog->update_post($ids, array('visible'=>1));	      
			        break;
			    }
			    case 'delete':
			    {
				    foreach($ids as $id)
						$this->blog->delete_post($id);    
			        break;
			    }
			}				
		}

		$filter = array();
		$filter['page'] = max(1, $this->request->get('page', 'integer')); 		
		$filter['limit'] = 20;
  	
		// Поиск
		$keyword = $this->request->get('keyword', 'string');
		if(!empty($keyword))
		{
			$filter['keyword'] = $keyword;
			$this->design->assign('keyword', $keyword);
		}		
		
		$posts_count = $this->blog->count_posts($filter);
		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$filter['limit'] = $posts_count;	
			
		// Разделы блога
		$category_id = $this->request->get('category_id', 'integer');
		if(!empty($category_id)){
		  $cat = $this->blog_categories->get_category($category_id);
		  $this->design->assign('cat', $cat);
		  $filter['category_id'] = $category_id;
		}
		// Вывод категорий
		$blog_categories = $this->blog_categories->get_categories();
		$this->design->assign('blog_categories', $blog_categories);
		
		// Разделы блога @
		
		$posts = $this->blog->get_posts($filter);
		$this->design->assign('posts_count', $posts_count);
		
		$this->design->assign('pages_count', ceil($posts_count/$filter['limit']));
		$this->design->assign('current_page', $filter['page']);
		
		$this->design->assign('posts', $posts);
		return $this->design->fetch('blog.tpl');
	}
}
