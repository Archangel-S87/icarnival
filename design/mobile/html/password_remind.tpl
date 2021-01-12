{$meta_title = "Восстановление пароля" scope=root}
{$page_name = "Восстановление пароля" scope=root}

<div class="page-pg">
	{if isset($email_sent)}
		<p>На {$email|escape} отправлено письмо для восстановления пароля.</p>
	{else}

		{if isset($error)}
			<div class="message_error">
				{if $error == 'user_not_found'}Пользователь не найден
				{else}{$error}
				{/if}
			</div>
		{/if}
		
		<form class="form separator" method="post">
			<label>Введите email, который вы указывали при регистрации</label>
			<input type="email" name="email" data-format="email" data-notice="Введите email" value="{if !empty($email)}{$email|escape}{/if}" maxlength="255" required />
			<input id="logininput" type="submit" class="button" value="Вспомнить" />
		</form>
	{/if}
</div>