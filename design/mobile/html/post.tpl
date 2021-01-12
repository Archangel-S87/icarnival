{$canonical="/blog/{$post->url}" scope=root}

<div class="post-pg">
	{if !empty($category)}
		<div class="path bottom_line">
			<svg><use xlink:href='#folder' /></svg>
			<span><a href="sections/{$category->url}" title="{$category->name|escape}">{$category->name|escape}</a></span>
		</div>
	{/if}
	<div class="postdate dateico">
		<div class="left">
			<svg><use xlink:href='#calendar' /></svg>
			<span>{$post->date|date}</span>
		</div>
		<div class="right">
			<svg class="comments_icon"><use xlink:href='#comments_count' /></svg>
			<span class="anchor" data-anchor="#comments">{$comments|count}</span>
		</div>
		<div class="right">
			<svg><use xlink:href='#views' /></svg>
			<span>Просмотров: {$post->views}</span>
		</div>
	</div>

	<div class="post_text">{$post->text|hashtag}</div>
	
	{* tags *}
	{if !empty($post->tags)}
		<div class="nav_tags">
			{foreach $post->tags as $tag}
			<a href="tags?keyword={$tag->value|escape}" class="tag_item">
				<svg><use xlink:href='#tag' /></svg>
				<span>{$tag->value|escape}</span>
			</a>
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

{if !empty($post->images[0])}
	<ul id="gallerypic" class="tiny_products">
		{foreach $post->images|cut as $i=>$image}
			<li class="product"><div class="image">
			<a rel="gallery" href="{$image->filename|resize:800:600:w:$config->resized_blog_images_dir}" class="swipebox" title="{$post->name|escape}">
			<img alt="{$post->name|escape}" title="{$post->name|escape}" src="{$image->filename|resize:400:400:false:$config->resized_blog_images_dir}" /></a></div>
			</li>
		{/foreach}
	</ul>
{/if}

<div id="back_forward">
	{if $prev_post}
		<span class="prev_page_link"><a class="next_page_link" href="blog/{$prev_post->url}" title="{$prev_post->name}"><img src="/design/{$settings->theme|escape}/images/dark_prev.gif" alt="Пред." class="v-middle"/></a> <a class="prev_page_link" href="blog/{$prev_post->url}" title="{$prev_post->name}">{$prev_post->name|escape|truncate:35:"...":true}</a></span>
	{/if}
	{if $next_post}
		<span class="next_page_link"><a class="next_page_link" href="blog/{$next_post->url}" title="{$next_post->name}">{$next_post->name|escape|truncate:35:"...":true}</a> <a class="next_page_link" href="blog/{$next_post->url}" title="{$next_post->name}"><img src="/design/{$settings->theme|escape}/images/dark_next.gif" alt="След." class="v-middle"/></a></span>
	{/if}
</div>

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
					<div class="comment_body">{$comment->text|escape|nl2br}</div>
			
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
		{/if}
	
		{* Форма отправления комментария *}
	
		<form class="comment_form" method="post" action="">
			<h2>Написать отзыв</h2>
			{if isset($error)}
			<div class="message_error">
				{if $error=='captcha'}
				Не пройдена проверка на бота
				{elseif $error=='empty_name'}
				Введите имя
				{elseif $error=='empty_comment'}
				Введите комментарий
				{elseif $error=='empty_email'}
				Введите E-Mail
				{elseif $error == 'wrong_name'}
				В поле 'Имя' может использоваться только кириллица	
				{/if}
			</div>
			{/if}
			<textarea class="comment_textarea" id="comment_text" name="text" data-format=".+" data-notice="Введите комментарий" required>{if !empty($comment_text)}{$comment_text|escape}{/if}</textarea>
			<div>

			<input style="margin-top:7px;" placeholder="* Имя" class="input_name" type="text" id="comment_name" name="name" value="{if !empty($comment_name)}{$comment_name|escape}{/if}" data-format=".+" data-notice="Введите имя" required/>

			<input style="margin-top:10px;" placeholder="* E-mail" class="input_name" type="email" id="comment_email" name="email" value="{if !empty($comment_email)}{$comment_email|escape}{/if}" data-format=".+" data-notice="Введите E-Mail" required/>

			<div class="captcha-block">
				{include file='antibot.tpl'}
			</div>
			{include file='conf.tpl'}
			<input class="button hideablebutton" type="submit" name="comment" value="Отправить" />

			</div>
		</form>

	</div>
{/if}

