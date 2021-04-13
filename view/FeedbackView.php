<?PHP

require_once('View.php');

class FeedbackView extends View
{
	function fetch()
	{
		// Получаем IP-посетителя
		$ip = $this->design->get_user_ip();
		
		if(!empty($this->user)){
			$this->design->assign('name', $this->user->name);
			$this->design->assign('email', $this->user->email); 
		}
		
		$feedback = new stdClass;
		if($this->request->method('post') && $this->request->post('feedback'))
		{
			$feedback->name         = $this->request->post('name');
			$feedback->email        = $this->request->post('email');
			$feedback->message      = $this->request->post('message');			
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
			
			$this->design->assign('name',  $feedback->name);
			$this->design->assign('email', $feedback->email);
			$this->design->assign('message', $feedback->message);
			
			if(empty($feedback->name))
				$this->design->assign('error', 'empty_name');
			elseif($this->settings->spam_cyr == 1 && !preg_match('/^[а-яё \t]+$/iu', $feedback->name))
				$this->design->assign('error', 'wrong_name');
			elseif(!empty($this->settings->spam_symbols) && mb_strlen($feedback->name,'UTF-8') > $this->settings->spam_symbols)
				$this->design->assign('error', 'captcha');	
			elseif(empty($feedback->email))
				$this->design->assign('error', 'empty_email');
			elseif(!empty($feedback->email) && filter_var($feedback->email, FILTER_VALIDATE_EMAIL) === false)	
				$this->design->assign('error', 'wrong_email');
			elseif(empty($feedback->message))
				$this->design->assign('error', 'empty_text');
			elseif(!$bttrue)
				$this->design->assign('error', 'captcha');
			elseif(!empty($btfalse))
				$this->design->assign('error', 'captcha');
			else
			{
				$this->design->assign('message_sent', true);
				$feedback->ip = $ip;
				$feedback_id = $this->feedbacks->add_feedback($feedback);
				// Отправляем email
				$this->notify->email_feedback_admin($feedback_id);
				if($this->settings->auto_subscribe == 1)
					$this->mailer->add_mail($feedback->name, $feedback->email);								
			}
		}

		if($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
			$this->setHeaderLastModify($this->page->last_modify, 2592000);  // expires 2592000 - month
		}

		$body = $this->design->fetch('feedback.tpl');
		
		return $body;
	}
}
