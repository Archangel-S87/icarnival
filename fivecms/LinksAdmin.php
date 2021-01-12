<?PHP 

require_once('api/Fivecms.php');

class LinksAdmin extends Fivecms
{
  public function fetch()
  {
    // Меню
    $menus = $this->pages->get_menus();
 	$this->design->assign('menus', $menus);
 	
   	// Обработка действий
  	if($this->request->method('post'))
  	{
		// Сортировка
		$positions = $this->request->post('positions'); 		
 		$ids = array_keys($positions);
		sort($positions);
		foreach($positions as $i=>$position)
			$this->links->update_link($ids[$i], array('position'=>$position)); 

		// Действия с выбранными
		$ids = $this->request->post('check');
		if(is_array($ids))
		switch($this->request->post('action'))
		{
		    case 'disable':
		    {
				$this->links->update_link($ids, array('visible'=>0));	      
				break;
		    }
		    case 'enable':
		    {
				$this->links->update_link($ids, array('visible'=>1));	      
		        break;
		    }
		    case 'delete':
		    {
			    foreach($ids as $id)
					$this->links->delete_link($id);    
		        break;
		    }
		}		
 	}

	// Пагинация
	$filter = array();
	$filter['page'] = max(1, $this->request->get('page', 'integer')); 		
	$filter['limit'] = 20;
	$links_count = $this->links->count_links($filter);
	// Показать все страницы сразу
	if($this->request->get('page') == 'all')
		$filter['limit'] = $links_count;
	$this->design->assign('posts_count', $links_count);	
	$this->design->assign('pages_count', ceil($links_count/$filter['limit']));
	$this->design->assign('current_page', $filter['page']);	
	// Пагинация end

	// Отображение
  	$links = $this->links->get_links($filter);

 	$this->design->assign('links', $links);
	return $this->design->fetch('links.tpl');
  }
}

?>
