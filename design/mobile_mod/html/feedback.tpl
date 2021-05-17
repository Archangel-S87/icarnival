{$canonical="/{$page->url}" scope=root}

<div class="page-pg">
	{$page->body}
</div>

{if isset($message_sent)}
	<div class="page-pg">
		<strong>{$name|escape}, ваше сообщение отправлено.</strong>
	</div>
{else}
<form class="form feedback_form" method="post">
	<h2>Обратная связь:</h2>
	{if isset($error)}
	<div class="message_error">
		{if $error=='captcha'}
		Не пройдена проверка на бота
		{elseif $error=='empty_name'}
		Введите имя
		{elseif $error=='empty_email'}
		Введите Email
		{elseif $error=='empty_text'}
		Введите сообщение
		{elseif $error == 'wrong_name'}
		В поле 'Имя' может использоваться только кириллица
		{elseif $error == 'wrong_email'}
		Некорректный Email
		{/if}
	</div>
	{/if}
	<input placeholder="* Имя" data-format=".+" data-notice="Введите имя" value="{if !empty($name)}{$name|escape}{/if}" name="name" maxlength="255" type="text" required />
 
	<input placeholder="* E-mail" data-format="email" data-notice="Введите E-mail" value="{if !empty($email)}{$email|escape}{/if}" name="email" maxlength="255" type="email" required />
	
	<textarea placeholder="Сообщение" data-format=".+" data-notice="Введите сообщение" name="message" required >{if !empty($message)}{$message|escape}{/if}</textarea>

	<div class="captcha-block">
		{include file='antibot.tpl'}
	</div>
	{include file='conf.tpl'}
	<input class="button hideablebutton" type="submit" name="feedback" value="Отправить" />

</form>
{/if}

