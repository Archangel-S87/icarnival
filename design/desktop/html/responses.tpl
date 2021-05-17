{* Канонический адрес страницы *}
{$canonical="/{$page->url}" scope=root}

<h1 data-page="{$page->id}">{if !empty($h1_title)}{$h1_title|escape}{else}{$page->header|escape}{/if}</h1>

<div itemscope itemtype="http://schema.org/Article">
	<meta content="{$meta_title|escape}" itemprop="name">
	<meta content="{$config->root_url}" itemprop="author" />
	<meta content="{$page->last_modify|date_format:'c'}" itemprop="datePublished" />
	<meta content="{$page->last_modify|date_format:'c'}" itemprop="dateModified" />
	<meta content="{$meta_title|escape}" itemprop="headline" />
	{$seo_description = $meta_title|cat:$settings->seo_description|cat:" ✩ "|cat:$settings->site_name|cat:" ✩"}
	<meta content="{if !empty($meta_description)}{$meta_description|escape}{elseif !empty($seo_description)}{$seo_description|escape}{/if}" itemprop="description" />
	<meta content="" itemscope itemprop="mainEntityOfPage" itemType="https://schema.org/WebPage" itemid="{$config->root_url}/{$page->url}" /> 
	<div style="display:none;" itemprop="image" itemscope itemtype="https://schema.org/ImageObject">
		{$img_url=$config->root_url|cat:'/files/logo/logo.png'}
		<img itemprop="url contentUrl" src="{$img_url}" alt="{$meta_title|escape}"/>
		<meta itemprop="image" content="{$img_url}" />
		{assign var="info" value=$img_url|getimagesize}
		<meta itemprop="width" content="{$info.0}" />
		<meta itemprop="height" content="{$info.1}" />
	</div>
	<div style="display:none;" itemprop="publisher" itemscope itemtype="https://schema.org/Organization">
		<div itemprop="logo" itemscope itemtype="https://schema.org/ImageObject">
			<img itemprop="url" src="{$config->root_url}/files/logo/logo.png" alt="{$settings->company_name|escape}" />
			<meta itemprop="image" content="{$config->root_url}/files/logo/logo.png" />
		</div>
		<meta itemprop="name" content="{$settings->company_name|escape}" />
		<meta itemprop="address" content="{$config->root_url}" />
		<meta itemprop="telephone" content="{$settings->phone|escape}" />
	</div>
	
	<div class="page-pg" itemprop="articleBody">
			{if !empty($metadata_page->description)}{$metadata_page->description}{elseif !empty($page->body)}{$page->body}{/if}
	</div>

</div>



{* Комментарии *}

<div id="comments" class="responses">

	<div class="comments-left">
		{if $comments}
			{* Список с комментариями *}
			<ul class="comment_list">
				{foreach $comments as $comment}
				<li>
					<div class="comment_header" id="comment_{$comment->id}">	
						{$comment->name|escape} <i>{$comment->date|date}, {$comment->date|time}</i>
						{if !$comment->approved}ожидает модерации</b>{/if}
					</div>
			
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
			{$comments_on_page = 6}
			{if $comments|count > $comments_on_page}	
				<script type="text/javascript" src="js/pagination/pagination.js"></script>
				<script>var show_per_page = {$comments_on_page};</script>
				<input type='hidden' id='current_page' />
				<input type='hidden' id='show_per_page' />	
				<div id="page_navigation" class="pagination"></div>
			{/if}
			{* Список с комментариями (The End) *}
		{else}
			<p>Пока нет отзывов</p>
		{/if}
	</div>
	{* Форма отправления комментария *}
	<form class="comment_form" method="post">
		<div class="comm-title">Написать отзыв</div>
			{if !empty($error)}
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
			
			<textarea class="comment_textarea" id="comment_text" name="text" data-format=".+" data-notice="Введите отзыв">{if !empty($comment_text)}{$comment_text}{/if}</textarea><br />
			<div>
			<label for="comment_name">Имя</label>
			<input class="input_name" type="text" id="comment_name" name="name" value="{if !empty($comment_name)}{$comment_name|escape}{/if}" data-format=".+" data-notice="Введите имя"/><br />

			<label for="comment_email">Email</label>
			<input class="input_name" type="email" id="comment_email" name="email" value="{if !empty($comment_email)}{$comment_email}{/if}" data-format=".+" data-notice="Введите Email"/><br />
		
			{include file='conf.tpl'}
			<input class="button hideablebutton" type="submit" name="comment" value="Отправить" />
		
			{include file='antibot.tpl'}
		</div>
	</form>
	{* Форма отправления комментария (The End) *}
	
</div>
{* Комментарии (The End) *}

<div class="adv_block">
	<!--noindex-->
	{$settings->advertpage}
	<!--/noindex-->
</div>

