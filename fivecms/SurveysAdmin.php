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

class SurveysAdmin extends Fivecms
{
	public function fetch()
	{
		// Обработка действий
		if($this->request->method('post'))
		{
		
			// Сортировка
			$positions = $this->request->post('positions'); 		
				$ids = array_keys($positions);
			sort($positions);
			$positions = array_reverse($positions);
			foreach($positions as $i=>$position)
				$this->surveys->update_survey($ids[$i], array('position'=>$position));		
		
			// Действия с выбранными
			$ids = $this->request->post('check');
			if(is_array($ids))
			switch($this->request->post('action'))
			{
			    case 'disable':
			    {
					$this->surveys->update_survey($ids, array('visible'=>0));	      
					break;
			    }
			    case 'enable':
			    {
					$this->surveys->update_survey($ids, array('visible'=>1));	      
			        break;
			    }
			    case 'delete':
			    {
				    foreach($ids as $id)
						$this->surveys->delete_survey($id);    
			        break;
			    }
			}				
		}

		$filter = array();
		$filter['page'] = max(1, $this->request->get('page', 'integer')); 		
		$filter['limit'] = 20;

		// Категории
		$surveys_categories = $this->surveys_categories->get_surveys_categories_tree();
		$this->design->assign('surveys_categories', $surveys_categories);
		
		// Текущая категория
		$category_id = $this->request->get('category_id', 'integer');
    $category = $this->surveys_categories->get_surveys_category($category_id);
    $this->design->assign('category', $category); 
		if($category_id && $category)
	  		$filter['category_id'] = $category->children;		

		// Поиск
		$keyword = $this->request->get('keyword', 'string');
		if(!empty($keyword))
		{
			$filter['keyword'] = $keyword;
			$this->design->assign('keyword', $keyword);
		}		
		
		$posts_count = $this->surveys->count_surveys($filter);
		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$filter['limit'] = $posts_count;	
		
		$posts = $this->surveys->get_surveys($filter);
		$this->design->assign('posts_count', $posts_count);
		
		$this->design->assign('pages_count', ceil($posts_count/$filter['limit']));
		$this->design->assign('current_page', $filter['page']);
		
		$this->design->assign('posts', $posts);
		return $this->design->fetch('surveys.tpl');
	}
}
