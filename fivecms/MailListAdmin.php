<?php

require_once('api/Fivecms.php');

class MailListAdmin extends Fivecms
{
	public function fetch()
	{
		// Обработка действий
		if($this->request->method('post'))
		{
			// Действия с выбранными
			$ids = $this->request->post('check');
			if(is_array($ids) && count($ids)>0)
			switch($this->request->post('action'))
			{   
                case 'disable':
			    {
			    	foreach($ids as $id)
						$this->mailer->update_mail($id, array('active'=>0));    
					break;
			    }
			    case 'enable':
			    {
			    	foreach($ids as $id)
						$this->mailer->update_mail($id, array('active'=>1));    
			        break;
			    }
			    case 'delete':
			    {
				    foreach($ids as $id)
						$this->mailer->delete_mail($id);    
			        break;
			    }
			}				
		}

		$filter = array();
		$filter['page'] = max(1, $this->request->get('page', 'integer')); 		
		$filter['limit'] = 20;
		
		// Поиск
		$keyword = $this->request->get('keyword');
		if(!empty($keyword))
		{
			$filter['keyword'] = $keyword;
			$this->design->assign('keyword', $keyword);
		}		
		
		// Сортировка пользователей, сохраняем в сессии, чтобы текущая сортировка не сбрасывалась
		if($sort = $this->request->get('sort', 'string'))
			$_SESSION['maillist_admin_sort'] = $sort;		
		if (!empty($_SESSION['maillist_admin_sort']))
			$filter['sort'] = $_SESSION['maillist_admin_sort'];			
		else
			$filter['sort'] = 'name';			
		$this->design->assign('sort', $filter['sort']);
        
	  	$mails_count = $this->mailer->count_mails($filter);
	  	
	  	// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$filter['limit'] = $mails_count;	
	  	
	  	$pages_count = ceil($mails_count/$filter['limit']);
	  	$filter['page'] = min($filter['page'], $pages_count);
	 	$this->design->assign('mails_count', $mails_count);
	 	$this->design->assign('pages_count', $pages_count);
	 	$this->design->assign('current_page', $filter['page']);

		$maillist = $this->mailer->get_maillist($filter);
				
		$this->design->assign('maillist', $maillist);
		return $this->design->fetch('maillist.tpl');
	}
}
