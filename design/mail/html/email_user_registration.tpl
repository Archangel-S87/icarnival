{* Письмо регистрации нового пользователя *}
	
{$subject = "Регистрация на сайте `$config->root_url`" scope=root}
<p>Добрый день!</p>
<p>Вы зарегистрировались на сайте <a href='{$config->root_url}/'>{$settings->site_name|escape}</a>.</p>
<p>Ваш логин: {$user->email|escape}</p>
<p>Ваш пароль: {$password|escape}</p>
