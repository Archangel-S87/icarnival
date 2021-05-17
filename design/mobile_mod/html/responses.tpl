{* Канонический адрес страницы *}
{$canonical="/{$page->url}" scope=root}

{if !empty($metadata_page->description) || !empty($page->body)}
	<div class="page-pg" itemprop="description">
		{if !empty($metadata_page->description)}{$metadata_page->description}{elseif !empty($page->body)}{$page->body}{/if}
	</div>
{/if}

{if $settings->hidecomment == 0}
	{* Комментарии *}
	<div id="comments">
		{if $comments}
			<div class="post-pg">
				<h2 class="comments_title">Отзывы</h2>
			</div>
			{* Список с комментариями *}
			<ul class="comment_list">
				{foreach $comments as $comment}
				<li>
					<a name="comment_{$comment->id}"></a>
					<div class="comment_header" id="comment_{$comment->id}">	
						{$comment->name|escape} <i>{$comment->date|date}, {$comment->date|time}</i>
					</div>
					{if !$comment->approved}<div class="moderation">(на модерации)</div>{/if}
					<div class="comment_body">{if !empty($settings->allow_comment_tags)}{$comment->text|escape|nl2br|bbcode}{else}{$comment->text|escape|nl2br}{/if}</div>
			
					{if $comment->otvet}
					<div class="comment_admint">Администрация:</div>
					<div class="comment_admin">
						{$comment->otvet}
					</div>
					{/if}
				</li>
				{/foreach}
			</ul>
			{if $comments|count >10}	
				<input type='hidden' id='current_page' />
				<input type='hidden' id='show_per_page' />	
				<div class="separator"><div id="page_navigation" class="pagination"></div></div>
			{/if}
			{* Список с комментариями (The End) *}
		{else}
			<p class="post-pg">Пока нет отзывов</p>	
		{/if}
	
		{* Форма отправления комментария *}
	
		<form class="comment_form" method="post" action="">
			<h2>Написать отзыв</h2>
			{if isset($error)}
			<div class="message_error">
				{if $error=='captcha'}Не пройдена проверка на бота
				{elseif $error=='empty_name'}Введите имя
				{elseif $error=='empty_comment'}Введите отзыв
				{elseif $error=='empty_email'}Введите Email
				{elseif $error == 'wrong_name'}В поле 'Имя' может использоваться только кириллица
				{elseif $error == 'wrong_email'}Некорректный Email
				{elseif $error == 'ip'}Вы уже оставляли отзыв
				{/if}
			</div>
			{/if}
			
			{if !empty($settings->allow_comment_tags)}<div class="comment_help">{$settings->comment_tags}</div>{/if}
			
			<textarea class="comment_textarea" id="comment_text" name="text" data-format=".+" data-notice="Введите отзыв" required>{if !empty($comment_text)}{$comment_text}{/if}</textarea>
			<div>

			<input style="margin-top:7px;" placeholder="* Имя" class="input_name" type="text" id="comment_name" name="name" value="{if !empty($comment_name)}{$comment_name|escape}{/if}" data-format=".+" data-notice="Введите имя" required/>

			<input style="margin-top:10px;" placeholder="* Email" class="input_name" type="email" id="comment_email" name="email" value="{if !empty($comment_email)}{$comment_email}{/if}" data-format=".+" data-notice="Введите Email" required/>

			<div class="captcha-block">
				{include file='antibot.tpl'}
			</div>
			{include file='conf.tpl'}
			<input class="button hideablebutton" type="submit" name="comment" value="Отправить" />

			</div>
		</form>

	</div>
{/if}