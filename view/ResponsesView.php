<?PHP
require_once('View.php');

class ResponsesView extends View
{
	function fetch()
	{
		$url = $this->request->get('page_url', 'string');
		$page = $this->pages->get_page($url);
		
		// Получаем IP-посетителя
		$ip = $this->design->get_user_ip();
		
		// Отображать скрытые страницы только админу
		if(empty($page) || (!$page->visible && empty($_SESSION['admin'])))
			return false;
			
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
			
			// Проверяем заполнение формы
			if($this->settings->spam_ip == 1 && (
					(!empty($ip) && $ip == $this->settings->last_ip_response) || 
					(!empty(session_id()) && session_id() == $this->settings->session_id_response)
				)){
				$this->design->assign('error', 'ip');
			}		
			elseif (empty($comment->name))
				$this->design->assign('error', 'empty_name');
			elseif($this->settings->spam_cyr == 1 && !preg_match('/^[а-яё \t]+$/iu', $comment->name))
				$this->design->assign('error', 'wrong_name');
			elseif(!empty($this->settings->spam_symbols) && mb_strlen($comment->name,'UTF-8') > $this->settings->spam_symbols)
				$this->design->assign('error', 'captcha');
			elseif(empty($comment->email))
				$this->design->assign('error', 'empty_email');	
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
				$comment->object_id = $page->id;
				$comment->type      = 'response';
				$comment->ip        = $ip;
				
				// Добавляем комментарий в базу
				$comment_id = $this->comments->add_comment($comment);
				
				// Записываем сессию и IP для блокировки повторной отправки
				if(!empty($ip))
					$this->settings->last_ip_response = $ip;
				if(!empty(session_id()))
					$this->settings->session_id_response = session_id();
				
				if($this->settings->auto_subscribe == 1)
					$this->mailer->add_mail($name, $email);
				
				// Отправляем email админу
				$this->notify->email_comment_admin($comment_id);				
				header('location: '.$_SERVER['REQUEST_URI'].'#comment_'.$comment_id);
			}			
		}
		
		// Комментарии к посту
		$comments = $this->comments->get_comments(array('type'=>'response', 'object_id'=>$page->id, 'approved'=>1, 'ip'=>$ip));
		$this->design->assign('comments', $comments);
		
		$this->design->assign('page', $page);
		$this->design->assign('meta_title', $page->meta_title);
		$this->design->assign('meta_keywords', $page->meta_keywords);
		$this->design->assign('meta_description', $page->meta_description);
		
		// Метаданные страниц
		$currentURL=$_SERVER['REQUEST_URI'];
		$metadata_page=$this->metadatapages->get_metadata_page($currentURL);
        if(!empty($metadata_page)) {
            $this->design->assign('metadata_page',$metadata_page);
            if(!empty($metadata_page->meta_title)) 
            	$this->design->assign('meta_title', $metadata_page->meta_title);
            if(!empty($metadata_page->meta_keywords)) 
				$this->design->assign('meta_keywords', $metadata_page->meta_keywords);
			if(!empty($metadata_page->meta_description)) 
				$this->design->assign('meta_description', $metadata_page->meta_description);
			if(!empty($metadata_page->h1_title)) 
				$this->design->assign('h1_title', $metadata_page->h1_title);				
		}
		
		$this->setHeaderLastModify($page->last_modify, 2592000); // expires 2592000 - month
		
		return $this->design->fetch('responses.tpl');
	}
}