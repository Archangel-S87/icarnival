<?PHP 

require_once('api/Fivecms.php');

########################################
class MenuAdmin extends Fivecms
{

  public function fetch()
  {
	   	// Обработка действий
	  	if($this->request->method('post'))
	  	{
			foreach($this->request->post('menu') as $n=>$va){
				foreach($va as $i=>$v){
					$menus[$i]->$n = $v;
				}	
			}
  		    
			$menus_ids = array();
			foreach($menus as $menu)
			{
				if($menu->id)
					$this->pages->update_menu($menu->id, $menu);
				else
					$menu->id = $this->pages->add_menu($menu);
		 		$menus_ids[] = $menu->id;
			}

			// Удалить непереданные меню
			$query = $this->db->placehold('DELETE FROM __menu WHERE id NOT IN(?@)', $menus_ids);
			$this->db->query($query);
			
			
			// Отсортировать меню
			asort($menus_ids);
			$i = 0;
			foreach($menus_ids as $menu_id)
			{ 
				$this->pages->update_menu($menus_ids[$i], array('position'=>$menu_id));
				$i++;
			}

			// Действия с выбранными
			$action = $this->request->post('action');
			$id = $this->request->post('action_id');
			
			if(!empty($action) && !empty($id))
			switch($action)
			{
			    case 'delete':
			    {
				    $this->pages->delete_menu($id);    
			        break;
			    }
			    case 'disable':
			    {
					$this->pages->update_menu($id, array('enabled'=>0));	      
					break;
			    }
			    case 'enable':
			    {
					$this->pages->update_menu($id, array('enabled'=>1));	      
			        break;
			    }
			}		
			
	 	}

		// Отображение
	  	$menus = $this->pages->get_menus();
	  	if(isset($menu_id)){
	  		$menu = $this->pages->get_menu($menu_id);
	 		$this->design->assign('menu', $menu);
	 	}
	 	$this->design->assign('menus', $menus);
		return $this->design->fetch('menu.tpl');
	}
}