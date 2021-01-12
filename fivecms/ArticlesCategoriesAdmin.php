<?PHP

require_once('api/Fivecms.php');


class ArticlesCategoriesAdmin extends Fivecms
{
	function fetch()
	{
		if($this->request->method('post'))
		{
			// Действия с выбранными
			$ids = $this->request->post('check');
			if(is_array($ids))
			switch($this->request->post('action'))
			{
			    case 'disable':
			    {
			    	foreach($ids as $id)
						$this->articles_categories->update_articles_category($id, array('visible'=>0));    
					break;
			    }
			    case 'enable':
			    {
			    	foreach($ids as $id)
						$this->articles_categories->update_articles_category($id, array('visible'=>1));    
			        break;
			    }
			    case 'delete':
			    {
			    	foreach($ids as $id)
						$this->articles_categories->delete_articles_category($id);    
			        break;
			    }
			}		
	  	
			// Сортировка
			$positions = $this->request->post('positions');
	 		$ids = array_keys($positions);
			sort($positions);
			foreach($positions as $i=>$position)
				$this->articles_categories->update_articles_category($ids[$i], array('position'=>$position)); 

		}  
  
		$articles_categories = $this->articles_categories->get_articles_categories_tree();

		$this->design->assign('articles_categories', $articles_categories);
		return $this->design->fetch('articles_categories.tpl');
	}
}
