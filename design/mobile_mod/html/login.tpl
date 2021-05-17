{* Страница входа пользователя *}
{$meta_title = "Вход" scope=root}
{$page_name = "Вход" scope=root}
{$canonical="/user/login" scope=root}
<div class="page-pg">
	{if isset($error)}
	<div class="message_error">
		{if $error == 'login_incorrect'}Неверный логин или пароль
		{elseif $error == 'user_disabled'}Ваш аккаунт еще не активирован
		{elseif $error == 'captcha'}Не пройдена проверка на бота
		{elseif $error == 'ip'}Подозрительная активность
		{elseif $error == 'wrong_name'}В поле Имя может использоваться только кириллица
		{else}{$error}{/if}
	</div>
	{/if}
	{* Если не отписка от рассылки*}
	{if !isset($hideform)}	
		<form class="form login_form separator" method="post">
			<label>Email</label>
			<input type="email" name="email" data-format="email" data-notice="Введите email" value="{if !empty($email)}{$email|escape}{/if}" maxlength="255" />
	
			<label>Пароль (<a href="user/preminder">напомнить</a>)</label>
			<input type="password" name="password" data-format=".+" data-notice="Введите пароль" value="" />
	
			<input type="submit" class="button" name="login" value="Войти">
			<a class="button logreg" href="/user/register">Зарегистрироваться</a>
		</form>
	
		{if !empty($settings->ulogin)}
			<div class="socialauth">Войти через соцсети:</div>
			{* Ulogin *}
			<script defer src="https://ulogin.ru/js/ulogin.js" ></script>
			<div id="uLogin" data-ulogin="display=panel;theme=flat;fields=first_name,last_name,email;providers=vkontakte,odnoklassniki,facebook,twitter,openid,googleplus,livejournal,yandex,google;hidden=;mobilebuttons=0;"></div>
			{* Ulogin end *}
		{/if}
	{/if}
</div>
