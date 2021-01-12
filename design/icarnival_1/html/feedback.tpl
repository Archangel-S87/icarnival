{$canonical="/{$page->url}" scope=root}

<h1 {if $page}data-page="{$page->id}"{/if}>{$page->name|escape}</h1>

<div class="feedback-left">
	{$page->body}
</div>

<div class="feedback-right">
	<div class="feedb-title">Обратная связь</div>
	{if isset($message_sent)}
		<div class="sent">{$name|escape}, ваше сообщение отправлено.</div>
	{else}
		<form class="form feedback_form" method="post">
			{if isset($error)}
			<div class="message_error">
				{if $error=='captcha'}
				Не пройдена проверка на бота
				{elseif $error=='empty_name'}
				Введите имя
				{elseif $error=='empty_email'}
				Введите email
				{elseif $error=='empty_text'}
				Введите сообщение
				{elseif $error == 'wrong_name'}
				В поле 'Имя' может использоваться только кириллица				
				{/if}
			</div>
			{/if}
			<label>Имя</label>
			<input data-format=".+" data-notice="Введите имя" value="{if isset($name)}{$name|escape}{/if}" name="name" maxlength="255" type="text"/>
			<label>Email</label>
			<input data-format="email" data-notice="Введите email" value="{if isset($email)}{$email|escape}{/if}" name="email" maxlength="255" type="email"/>
			<label>Сообщение</label>
			<textarea data-format=".+" data-notice="Введите сообщение" name="message">{if isset($message)}{$message|escape}{/if}</textarea>
			{include file='conf.tpl'}
			<input class="button hideablebutton" type="submit" name="feedback" value="Отправить" />
			{include file='antibot.tpl'}
		</form>
	{/if}
</div>
