<?PHP

require_once('View.php');

class LoginView extends View
{
	function fetch()
	{
		// Получаем IP-посетителя
		$ip = $this->design->get_user_ip();
	
		// Выход
		if($this->request->get('action') == 'logout')
		{
			unset($_SESSION['user_id']);
			if(!empty($_SESSION['current_for_login']))
				header('Location: '.$_SESSION['current_for_login']);				
			else
				header('Location: '.$this->config->root_url.'/user');
			exit();
		}
		// Вспомнить пароль
		elseif($this->request->get('action') == 'password_remind')
		{
			// Если запостили email
			if($this->request->method('post') && $this->request->post('email'))
			{
				$email = $this->request->post('email');
				$this->design->assign('email', $email);
				
				// Выбираем пользователя из базы
				$user = $this->users->get_user($email);
				if(!empty($user))
				{
					$chars="qazxswedcvfrtgbnhyujmkiolp1234567890QAZXSWEDCVFRTGBNHYUJMKIOLP"; 
		    		$max=10; 
		    		$size=StrLen($chars)-1; 
		    		$password=null; 
		    		while($max--) $password.=$chars[rand(0,$size)];
					$this->users->update_user($user->id, array('password'=>$password));
					
					// Отправляем письмо пользователю для восстановления пароля
					$this->notify->email_password_remind($user->id, $password);
					$this->design->assign('email_sent', true);
				}
				else
				{
					$this->design->assign('error', 'user_not_found');
				}
			}
			return $this->design->fetch('password_remind.tpl');
		}
		// auth ULogin
		elseif(isset($_POST['token'])) {
			$h = mb_strtolower(getenv("HTTP_HOST"));
			$h = strtok($h, ':');
			$s = file_get_contents('https://ulogin.ru/token.php?token='.$_POST['token'].'&host='.$h);
			$fivecms = json_decode($s, true);
			
			if (isset($fivecms['identity'])) {
				$name = $fivecms['first_name'].' '.$fivecms['last_name'];
				$email = $fivecms['email'];
				$password = md5($fivecms['identity'].'newpass');
				//checking in DB if e-mail exists
				$this->db->query('SELECT count(*) as count, id FROM __users WHERE email=?', $email);
				$user_exists = $this->db->result();
				if($user_exists->count) {
					$_SESSION['user_id'] = $user_exists->id;
					if($this->settings->cart_storage == 2) {
						$this->cart->base_to_cart($user_exists->id);
						$this->cart->cart_to_base();
					}
					/*if(!empty($_SESSION['current_for_login']))
						header('Location: '.$_SESSION['current_for_login']);				
					else*/
						header('Location: '.$this->config->root_url.'/user');
				} else {
					$user_id = $this->users->add_user(
					array('name'=>$name,
					'email'=>$email,
					'password'=>$password,
					'enabled'=>1)
					);

					$_SESSION['user_id'] = $user_id;
					
					if($this->settings->cart_storage == 2) {
						$this->cart->base_to_cart($user_id);
						$this->cart->cart_to_base();
					}
					
					// add partner_id to user
					if(isset($_COOKIE['partner_id'])){
						if(isset($user_id) && intval($user_id) != intval($_COOKIE['partner_id'])) {
							$partner = $this->users->get_user(intval($_COOKIE['partner_id']));
							if(!empty($partner) && $partner->enabled)
								$this->users->update_user(intval($user_id), array('partner_id'=>$partner->id));
						}
					}
					
					$this->notify->email_user_registration($user_id, $password);
					
					if($this->settings->auto_subscribe == 1)
						$this->mailer->add_mail($name, $email);
					
					/*if(!empty($_SESSION['current_for_login']))
						header('Location: '.$_SESSION['current_for_login']);				
					else*/
						header('Location: '.$this->config->root_url.'/user');
				}
			}
		}
		elseif($this->request->method('get') && $this->request->get('unsubscribe'))
        {
			$mail = $this->request->get('unsubscribe');
            if(filter_var($mail, FILTER_VALIDATE_EMAIL)){
                $query = $this->db->placehold('select id from __maillist where email=?', $mail);
                $this->db->query($query);
                if($this->db->num_rows() > 0){
                	if($this->mailer->unsubscribe_mail($mail))
						$this->design->assign('error', 'Вы успешно отписались от рассылки');
                }else{
                    $this->design->assign('error', 'Email не найден в базе');
                }
            }else{
                $this->design->assign('error', 'Неверный Email');
            }
			$this->design->assign('hideform', 'y');
        }
        elseif($this->request->method('post') && $this->request->post('mailing_name') && $this->request->post('mailing_email'))
        {
			$mailing_name = trim($this->request->post('mailing_name'));
			$mailing_email = trim($this->request->post('mailing_email'));
			
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

			if($this->settings->spam_ip == 1 && (
					(!empty($ip) && $ip == $this->settings->last_ip_sub) || 
					(!empty(session_id()) && session_id() == $this->settings->session_id_sub)
				)){
				$this->design->assign('error', 'ip');
			}	
			elseif(empty($bttrue))
				$this->design->assign('error', 'captcha');
			elseif(!empty($btfalse))
				$this->design->assign('error', 'captcha');
			elseif($this->settings->spam_cyr == 1 && !preg_match('/^[а-яё \t]+$/iu', $mailing_name))
				$this->design->assign('error', 'wrong_name');	
			elseif(!empty($this->settings->spam_symbols) && mb_strlen($mailing_name,'UTF-8') > $this->settings->spam_symbols)
				$this->design->assign('error', 'captcha');	
            elseif(filter_var($mailing_email, FILTER_VALIDATE_EMAIL))
            {
                $this->mailer->add_mail($mailing_name, $mailing_email);
				$this->design->assign('error', 'Вы успешно подписались на рассылку');
				
				// Записываем сессию и IP для блокировки повторной подписки
				if(!empty($ip))
					$this->settings->last_ip_sub = $ip;
				if(!empty(session_id()))
					$this->settings->session_id_sub = session_id();
            }
            else
            {
                $this->design->assign('error', 'Подписка невозможна');
            }
			$this->design->assign('hideform', 'y');
        }
		// Вход
		elseif($this->request->method('post') && $this->request->post('login'))
		{
			$email			= $this->request->post('email');
			$password		= $this->request->post('password');
			
			$this->design->assign('email', $email);
		
			if($user_id = $this->users->check_password($email, $password))
			{
				$user = $this->users->get_user($email);
				if($user->enabled)
				{
					$_SESSION['user_id'] = $user_id;
					$this->users->update_user($user_id, array('last_ip'=>$ip));
					
					if($this->settings->cart_storage == 2) {
						$this->cart->base_to_cart($user_id);
						$this->cart->cart_to_base();
					}
					
					// Перенаправляем пользователя на прошлую страницу, если она известна
					/*if(!empty($_SESSION['current_for_login']))
						header('Location: '.$_SESSION['current_for_login']);				
					else*/
						header('Location: '.$this->config->root_url.'/user');				
				}
				else
				{
					$this->design->assign('error', 'user_disabled');
				}
			}
			else
			{
				$this->design->assign('error', 'login_incorrect');
			}				
		}
		// Если авторизован
		elseif(!empty($this->user)) 
		{
            header('Location: '.$this->config->root_url.'/user', true, 302);
            exit();
        } 
		return $this->design->fetch('login.tpl');
	}	
}
