<?php

require_once('api/Fivecms.php');

class MailerAdmin extends Fivecms
{
	public function fetch()
	{
		// Обработка действий
		if($this->request->method('post'))
		{
			if($this->request->post('mass_mailing'))
			{
                $title = $this->request->post('title');   
                $body = $this->request->post('body');

                $mails = $this->mailer->get_maillist(array("active"=>1));
                foreach ($mails as $mail)
                {
                   $this->mailer->save_spam($mail, $title, $body);
                }  
                $error = 1;
			}
            if($this->request->post('settings'))
            {
                $this->settings->mails_from = $this->request->post('mails_from');
				$this->settings->mails_hello = $this->request->post('mails_hello');
				$this->settings->mails_hello_noname = $this->request->post('mails_hello_noname');
               	$this->settings->mails_round = $this->request->post('mails_round');
                $this->settings->mails_pause = $this->request->post('mails_pause');
                $this->settings->subscribe_form = $this->request->post('subscribe_form');
                $this->settings->auto_subscribe = $this->request->post('auto_subscribe');
          	}
			if($this->request->post('delete_mailing'))
			{
				if($this->mailer->clear_spam()){
					usleep(50000);
					$error = 2;
				} else {
					$error = 'clear_error';
				}
			}
        }
		$this->design->assign('count_added', count($mails));
        $this->design->assign('count_total', $this->mailer->count_spam());
		$this->design->assign('error', $error);
		return $this->design->fetch('mailer.tpl');
	}
}
