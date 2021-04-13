<?PHP
require_once('api/Fivecms.php');

class MailuserAdmin extends Fivecms
{	
	public function fetch()
	{
		$send = new \stdClass();
		if(!empty($_POST['user_send']))
		{
			$send->id = $this->request->post('id', 'integer');
			$send->name = $this->request->post('name');
			$send->email = $this->request->post('email');
			$send->active = $this->request->post('active', 'boolean');
			
			## Не допустить одинаковые email пользователей.

			if(empty($send->email))
			{			
				$this->design->assign('message_error', 'empty_email');
			}
			elseif(empty($send->id))
				{
	  				$send->id = $this->mailer->add_mail($send->name, $send->email);
	  				$send = $this->mailer->get_mail(intval($send->id));	
					$this->design->assign('message_success', 'added');
	  			}
  	    		else
  	    		{
  	    			$this->mailer->update_mail($send->id, $send);
  	    			$send = $this->mailer->get_mail($send->id);
					$this->design->assign('message_success', 'updated');
  	    		}
		$send = $this->mailer->get_mail(intval($send->id));	
		}
		else 
		{
			$send->id = $this->request->get('id', 'integer');
			$send = $this->mailer->get_mail(intval($send->id));		
		}

		$this->design->assign('send', $send);
 	  	return $this->design->fetch('mailuser.tpl');
	}
	
}

