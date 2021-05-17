{$canonical="/blog/{$post->url}" scope=root}

<h1 data-post="{$post->id}">{$post->name|escape}</h1>

<div {if $post->images|count>1}class="postcontent"{/if} itemscope itemtype="http://schema.org/Article">
	<meta content="{$meta_title|escape}" itemprop="name">
	<meta content="{$config->root_url}" itemprop="author" />
	<meta content="{$post->date|date_format:'c'}" itemprop="datePublished" />
	<meta content="{$post->last_modify|date_format:'c'}" itemprop="dateModified" />
	<meta content="{$meta_title|escape}" itemprop="headline" />
	{$seo_description = $meta_title|cat:$settings->seo_description|cat:" ✩ "|cat:$settings->site_name|cat:" ✩"}
	<meta content="{if !empty($meta_description)}{$meta_description|escape}{elseif !empty($seo_description)}{$seo_description|escape}{/if}" itemprop="description" />
	<meta content="" itemscope itemprop="mainEntityOfPage" itemType="https://schema.org/WebPage" itemid="{$config->root_url}/blog/{$post->url}" /> 
	<div style="display:none;" itemprop="publisher" itemscope itemtype="https://schema.org/Organization">
		<div itemprop="logo" itemscope itemtype="https://schema.org/ImageObject">
			<img itemprop="url" src="{$config->root_url}/files/logo/logo.png" alt="{$settings->company_name|escape}" />
			<meta itemprop="image" content="{$config->root_url}/files/logo/logo.png" />
		</div>
		<meta itemprop="name" content="{$settings->company_name|escape}" />
		<meta itemprop="address" content="{$config->root_url}" />
		<meta itemprop="telephone" content="{$settings->phone|escape}" />
	</div>

	<div class="postpage postdate dateico">
		<div class="left">
			<svg><use xlink:href='#calendar' /></svg>
			<span>{$post->date|date}</span>
		</div>
		{if !empty($category)}
		<div class="left">	
			<svg><use xlink:href='#folder' /></svg>
			<span><a href="sections/{$category->url}" title="{$category->name|escape}">{$category->name|escape}</a></span>
		</div>
		{/if}
		<div class="right">
			<svg style="margin-left:15px;"><use xlink:href='#comments_count' /></svg>
			<span class="anchor" data-anchor=".post-comments">Комментариев: {$comments|count}</span>
		</div>
		{if !empty($settings->allow_views)}
		<div class="right">
			<svg><use xlink:href='#views' /></svg>
			<span>Просмотров: {$post->views}</span>
		</div>
		{/if}
	</div>
	
	<div class="post-pg" itemprop="articleBody" role="article">
		{$post->text|hashtag}
		<div style="display:none;" itemprop="image" itemscope itemtype="https://schema.org/ImageObject">
			{if !empty($post->images[1])}
				{$img_url=$post->images[1]->filename|resize:1024:768:w:$config->resized_blog_images_dir}
			{elseif !empty($post->image)}
				{$img_url=$post->image->filename|resize:400:400:false:$config->resized_blog_images_dir}
			{else}
				{$img_url=$config->root_url|cat:'/files/logo/logo.png'}
			{/if}
				<img itemprop="url contentUrl" src="{$img_url}" alt="{$meta_title|escape}"/>
				<meta itemprop="image" content="{$img_url}" />
				{assign var="info" value=$img_url|getimagesize}
				<meta itemprop="width" content="{$info.0}" />
				<meta itemprop="height" content="{$info.1}" />
		</div>
	</div>

	<div itemprop="aggregateRating" itemscope itemtype="http://schema.org/AggregateRating">
		<meta itemprop="ratingValue" content="4.{'5'|mt_rand:9}">
		<meta itemprop="ratingCount" content="{'33'|mt_rand:54}">
		<meta itemprop="worstRating" content="1">
		<meta itemprop="bestRating" content="5">
	</div>
	
	{* tags *}
	{if !empty($post->tags)}
		<div class="nav_tags">
			{foreach $post->tags as $tag}
			<a href="tags?keyword={$tag->value|escape}" class="tag_item">
				<svg><use xlink:href='#tag' /></svg>
				<span>{$tag->value|escape}</span>
			</a>{*{if !$tag@last}, {/if}*}
			{/foreach}
		</div>
		<svg style="display:none;">
			<symbol id="tag" viewBox="0 0 24 24">
				<path fill="none" d="M0 0h24v24H0V0z"/><path d="M21.41 11.58l-9-9C12.05 2.22 11.55 2 11 2H4c-1.1 0-2 .9-2 2v7c0 .55.22 1.05.59 1.42l9 9c.36.36.86.58 1.41.58s1.05-.22 1.41-.59l7-7c.37-.36.59-.86.59-1.41s-.23-1.06-.59-1.42zM13 20.01L4 11V4h7v-.01l9 9-7 7.02z"/><circle cx="6.5" cy="6.5" r="1.5"/>
			</symbol>
		</svg>
	{/if}
	{* tags @ *}
</div>

{if !empty($post->images)}
	<ul id="gallerypic" class="tiny_products">	
		{foreach $post->images|cut as $i=>$image}
			<li class="product">
				<div class="image">
					<a rel="nofollow" data-rel="gallery" href="{$image->filename|resize:1024:768:w:$config->resized_blog_images_dir}" class="zoom" title="{$post->name|escape}">
						<img src="{$image->filename|resize:400:400:false:$config->resized_blog_images_dir}" alt="{$meta_title|escape}" />
					</a>
				</div>
			</li>
		{/foreach}
	</ul>
{/if}

	<!--noindex-->
	{$settings->advertblog}
	<!--/noindex-->

	{if !empty($category->id)}
		{get_posts var=last_posts category_id=$category->id limit=3 sort=rand}
	{else}
		{get_posts var=last_posts limit=3 sort=rand}
	{/if}
	{if !empty($last_posts)}
		<div class="mainproduct blog_also">Рекомендуем прочесть</div>
		<div class="blogposts">
		{include file='blogline_body.tpl'}
		</div>
	{/if}

	<div id="back_forward">
		{if $prev_post}
			<span class="prev_page_link">&laquo; <a class="prev_page_link" href="blog/{$prev_post->url}" title="{$prev_post->name|escape}">{$prev_post->name|escape|truncate:50:"...":true}</a></span>
		{/if}
		{if $next_post}
			<span class="next_page_link"><a class="next_page_link" href="blog/{$next_post->url}" title="{$next_post->name|escape}">{$next_post->name|escape|truncate:50:"...":true}</a> &raquo;</span>
		{/if}
	</div>

{* Комментарии *}
<h3 class="post-comments mainproduct">Отзывы</h3>
<div id="comments">
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
			{$comments_on_page = 5}
			{if $comments|count > $comments_on_page}	
				<script type="text/javascript" src="js/pagination/pagination.js"></script>
				<script>var show_per_page = {$comments_on_page};</script>
				<input type='hidden' id='current_page' />
				<input type='hidden' id='show_per_page' />	
				<div id="page_navigation" class="pagination"></div>
			{/if}
			{* Список с комментариями (The End) *}
		{else}
			<p>Пока нет сообщений</p>
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
				{/if}
			</div>
			{/if}
			
			{if !empty($settings->allow_comment_tags)}<div class="comment_help">{$settings->comment_tags}</div>{/if}
			
			<textarea class="comment_textarea" id="comment_text" name="text" data-format=".+" data-notice="Введите отзыв">{if !empty($comment_text)}{$comment_text|escape}{/if}</textarea><br />
			<div>
			<label for="comment_name">Имя</label>
			<input class="input_name" type="text" id="comment_name" name="name" value="{if !empty($comment_name)}{$comment_name|escape}{/if}" data-format=".+" data-notice="Введите имя"/><br />

			<label for="comment_email">Email</label>
			<input class="input_name" type="email" id="comment_email" name="email" value="{if !empty($comment_email)}{$comment_email|escape}{/if}" data-format=".+" data-notice="Введите Email"/><br />
		
			{include file='conf.tpl'}
			<input class="button hideablebutton" type="submit" name="comment" value="Отправить" />
		
			{include file='antibot.tpl'}
		</div>
	</form>
	{* Форма отправления комментария (The End) *}
	
</div>
{* Комментарии (The End) *}
