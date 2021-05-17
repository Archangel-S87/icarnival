{* Страница регистрации *}
{$meta_title = "Регистрация" scope=root}
{$page_name = "Регистрация" scope=root}
{$canonical="/user/register" scope=root}
<h1>Регистрация</h1>

{if isset($error)}
<div class="message_error">
	{if $error == 'empty_name'}Введите имя
	{elseif $error == 'empty_email'}Введите Email
	{elseif $error == 'empty_password'}Введите пароль
	{elseif $error == 'user_exists'}Пользователь с таким Email уже зарегистрирован
	{elseif $error == 'captcha'}Не пройдена проверка на бота
	{elseif $error == 'ip'}Вы уже регистрировались. Если забыли пароль - воспользуйтесь его востановлением.
	{elseif $error == 'wrong_name'}В поле ФИО может использоваться только кириллица
	{elseif $error == 'wrong_email'}Некорректный Email
	{else}{$error}{/if}
</div>
{/if}

<form class="form register_form" method="post">
	<label>* ФИО</label>
	<input type="text" name="name" id="name" data-format=".+" data-notice="Введите имя" value="{if isset($name)}{$name|escape}{/if}" maxlength="255" required/>
	
	<label>* Email</label>
	<input type="email" name="email" id="email" data-format="email" data-notice="Введите email" value="{if isset($email)}{$email|escape}{/if}" maxlength="255" required/>

	<label>* Телефон</label>
	<input type="tel" name="tel" id="tel" data-format=".+" data-notice="Введите телефон" value="{if isset($tel)}{$tel|escape}{/if}" maxlength="20" required/>

    <label>* Пароль</label>
    <input type="password" name="password" id="password" data-format=".+" data-notice="Введите пароль" value="" />

	{include file='conf.tpl'}
	{include file='antibot.tpl'}
	<input style="margin-top:15px;" id="logininput" type="submit" class="button hideablebutton" name="register" value="Зарегистрироваться">

</form>

{if !empty($settings->ulogin)}
	<div class="socialauth">Войти через соцсети:</div>
	{* Ulogin *}
	<script defer src="https://ulogin.ru/js/ulogin.js" ></script>
	<div id="uLogin" data-ulogin="display=panel;theme=flat;fields=first_name,last_name,email;providers=vkontakte,odnoklassniki,facebook,twitter,openid,googleplus,livejournal,yandex,google;hidden=;mobilebuttons=0;"></div>
	{* Ulogin @ *}
{/if}

