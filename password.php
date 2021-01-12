<?php
session_start();
?>

<html>
<head>
	<title>Восстановления пароля администратора</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
	<meta http-equiv="Content-Language" content="ru" />
</head>
<style>
	h1{font-size:20px;font-weight:700;color:#e6e5e5;text-transform:uppercase;}
	p{font-size:18px;color:#e6e5e5;}
	input{font-size:16px;background-color:#f4f4f4;border-radius:5px;padding: 10px;border:0;width:300px;margin-right:15px;}
	input[type='submit']{font-size:16px;font-weight:700;background-color:#e6e5e5;border-radius:12px;padding: 10px 15px;width:auto;text-transform:uppercase;cursor:pointer;}
	p.error{color:red;}
	div.maindiv{width: 600px; height: 300px; position: relative; left: 50%; top: 100px; margin-left: -300px; }
	body{background-color: rgba(53, 73, 101, 0.9);font-family:Arial;}
	a{color:#e6e5e5;text-decoration:none;border-bottom:1px dashed #e6e5e5;}	
</style>
<body>
<div style='width:100%; height:100%;'> 
  <div class="maindiv">

<?php
require_once('api/Fivecms.php');
$fivecms = new Fivecms();

// Получаем IP-посетителя
$ip = $fivecms->design->get_user_ip();

// Если пришли по ссылке из письма
if($c = $fivecms->request->get('code'))
{
	// Код не совпадает - прекращяем работу
	if(empty($_SESSION['admin_password_recovery_code']) || empty($c) || $_SESSION['admin_password_recovery_code'] !== $c)
	{
		header('Location:password.php');
		exit();
	}
	
	// IP не совпадает - прекращяем работу
	if(empty($_SESSION['admin_password_recovery_ip'])|| empty($ip) || $_SESSION['admin_password_recovery_ip'] !== $ip)
	{
		header('Location:password.php');
		exit();
	}
	
	// Если запостили пароль
	if($new_password = $fivecms->request->post('new_password'))
	{
		// Файл с паролями
		$passwd_file = $fivecms->config->root_dir.'fivecms/.passwd';
		
		// Удаляем из сессии код, чтобы больше никто не воспользовался ссылкой
		unset($_SESSION['admin_password_recovery_code']);
		unset($_SESSION['admin_password_recovery_ip']);

		// Если в файлы запрещена запись - предупреждаем об этом
		if(!is_writable($passwd_file))
		{
			print "
				<h1>Восстановление пароля администратора</h1>
				<p class='error'>
				Файл /fivecms/.passwd недоступен для записи.
				</p>
				<p>Вам нужно зайти по FTP и изменить права доступа к этому файлу, после чего повторить процедуру восстановления пароля.</p>
			";
		}
		else
		{
			// Новый логин и пароль
			$new_login = $fivecms->request->post('new_login');
			$new_password = $fivecms->request->post('new_password');
			if(!$fivecms->managers->update_manager($new_login, array('password'=>$new_password)))
				$fivecms->managers->add_manager(array('login'=>$new_login, 'password'=>$new_password));
			
			print "
				<h1>Восстановление пароля администратора</h1>
				<p>Новый пароль установлен</p>
				<p><a href='".$fivecms->root_url."/fivecms/index.php?module=ManagersAdmin'>Перейти в панель управления</a></p>
			";
		}
	}
	else
	{
	// Форма указалия нового логина и пароля
	print "
		<h1>Восстановление пароля администратора</h1>
		<p>
		<form method=post>
			<p>Новый логин:<br><input type='text' name='new_login'></p>
			<p>Новый пароль:<br><input type='password' name='new_password'></p><br>
			<input type='submit' value='Сохранить логин и пароль'>
		</form>
		</p>
		";
	}
}
else
{
	print "
		<h1>Восстановление пароля администратора</h1>
		<p>Введите email администратора</p>
		<form method='post' action='".$fivecms->root_url."/password.php'>
			<input type='text' name='email'>
			<input type='submit' value='Восстановить пароль'>
		</form>
	";

	$admin_email = $fivecms->settings->admin_email;
	
	if(isset($_POST['email']))
	{
		if($_POST['email'] === $admin_email)
		{
			$code = $fivecms->config->token(mt_rand(1, mt_getrandmax()).mt_rand(1, mt_getrandmax()).mt_rand(1, mt_getrandmax()));
			$_SESSION['admin_password_recovery_code'] = $code;
			$_SESSION['admin_password_recovery_ip'] = $ip;
			
			$message = 'Вы или кто-то другой запросил ссылку на восстановление пароля администратора.<br>';
			$message .= 'Для смены пароля перейдите по ссылке '.$fivecms->config->root_url.'/password.php?code='.$code.'<br>';
			$message .= 'Если письмо пришло вам по ошибке, проигнорируйте его.';
			
			$fivecms->notify->email($admin_email, 'Восстановление пароля администратора '.$fivecms->settings->site_name, $message, $fivecms->settings->notify_from_email);
		}
		print "<p>Вам отправлена ссылка для восстановления пароля. Если письмо вам не пришло, значит вы неверно указали email или что-то не так с хостингом</p>";
	}

}
?>

  </div>
</div>
</body>
</html>
