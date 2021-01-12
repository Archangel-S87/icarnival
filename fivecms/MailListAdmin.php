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
        
	  	$mails_count = $this->mailer->count_mails();
	  	
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
