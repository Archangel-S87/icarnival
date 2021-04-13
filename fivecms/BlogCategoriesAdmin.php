<?php

require_once('api/Fivecms.php');

class BlogCategoriesAdmin extends Fivecms
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
			foreach($positions as $i=>$position)
				$this->blog_categories->update_category($ids[$i], array('position'=>$position)); 
			
			// Действия с выбранными
			$ids = $this->request->post('check');
			if(is_array($ids))
			switch($this->request->post('action'))
			{
				case 'disable':
			    {
			    	foreach($ids as $id)
						$this->blog_categories->update_category($id, array('visible'=>0));    
					break;
			    }
			    case 'enable':
			    {
			    	foreach($ids as $id)
						$this->blog_categories->update_category($id, array('visible'=>1));    
			        break;
			    }
			    case 'delete':
			    {
				    foreach($ids as $id)
						$this->blog_categories->delete_category($id); 
			        break;
			    }
			}			
				
		}
	
		$categories = $this->blog_categories->get_categories();
		
		$this->design->assign('categories', $categories);
		return $this->design->fetch('blog_categories.tpl');
	}
}
