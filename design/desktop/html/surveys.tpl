{* ajax pagination *}
{if isset($smarty.server.HTTP_X_REQUESTED_WITH) && $smarty.server.HTTP_X_REQUESTED_WITH|strtolower == 'xmlhttprequest'}
    {$wrapper = '' scope=root}
    	
	<input class="refresh_title" type="hidden" value="{$meta_title|escape}{if $current_page_num>1} - страница {$current_page_num}{/if}" />
{/if}
{* ajax pagination end *}

{if !empty($category)}
	{$canonical="/surveys/{$category->url}{if $current_page_num>1}?page={$current_page_num}{/if}" scope=root}
{else}
	{$canonical="/surveys{if $current_page_num>1}?page={$current_page_num}{/if}" scope=root}
{/if}

<link rel="stylesheet" type="text/css" href="/design/{$settings->theme|escape}/css/survey.css?v={filemtime("design/{$settings->theme|escape}/css/survey.css")}"/>

{if $page}
	<h1>{$page->name|escape}</h1>
{else}
	<h1 data-surveyscategory="{$category->id}">{$category->name|escape}</h1>
{/if}

{if isset($page->url) && $page->url == 'surveys'}
	{* subcat start *}
	{if !empty($category->subcategories)}
		<ul class="relcontent tiny_products parentscat">
			{foreach name=cats from=$category->subcategories item=ac}
				{if $ac->visible}
					<li class="product" onClick="window.location='/surveys/{$ac->url}'">
						<div class="image">
							{if $c->image}
								<img src="files/surveys-categories/{$c->image}" alt="{$ac->name}" title="{$ac->name}" />
							{else}
								<svg class="nophoto"><use xlink:href='#folder' /></svg>
							{/if}
						</div>
						<div class="product_info">
							<h3 class="product_title" data-surveyscategory="{$ac->id}">{$ac->name}</h3>
						</div>
					</li>
				{/if}
			{/foreach}
		</ul>
	{else}
		{function name=surveys_categories_tree2 level=1}
			{if isset($surveys_categories) && $surveys_categories|count>1}
				<ul class="relcontent tiny_products parentscat">
					{foreach $surveys_categories as $ac2}
						{if $ac2->visible}
							<li class="product" onClick="window.location='/surveys/{$ac2->url}'">
								<div class="image">
								{if $ac2->image}
									<img src="files/surveys-categories/{$ac2->image}" alt="{$ac2->name}" title="{$ac2->name}" />
								{else}
									<svg class="nophoto"><use xlink:href='#folder' /></svg>
								{/if}
								</div>
								<div class="product_info">
									<h3 class="product_title" data-surveyscategory="{$ac2->id}">{$ac2->name}</h3>
								</div>
							</li>
						{/if}
					{/foreach}
				</ul>
			{/if}
		{/function}
		{surveys_categories_tree2 surveys_categories=$surveys_categories}
	{/if}
	{* subcat end *}
{/if}

{if !empty($page->body) || !empty($category->description)}
	<section itemscope itemtype="http://schema.org/Article">
		<meta content="{$meta_title|escape}" itemprop="name">
		<div class="post-pg" itemprop="description">
			{if !empty($page->body)}{$page->body}{/if}
			{if !empty($category->description) && $current_page_num==1}
				{$category->description}
			{/if}
		</div>
	</section>
{/if}

{if $total_posts_num == 0}
	<div class="nomore_polls">
		<div class="nomore_mbody">
			<svg fill="#1B6F9F" height="48" viewBox="0 0 24 24" width="48" xmlns="http://www.w3.org/2000/svg">
			    <path d="M0 0h24v24H0z" fill="none"/>
			    <path d="M1 21h4V9H1v12zm22-11c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 1 7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.83 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73v-1.91l-.01-.01L23 10z"/>
			</svg>
			<p>На сегодня задания закончились :(</p>
			<p>Но скоро здесь появятся новые!</p>
		</div>
	</div>
{/if}

{* Каталог заданий *}
{if $posts && empty($category->subcategories)}

	{*{if $posts|count>1}
	<div class="sort blog-pg">
		Сортировать по: 
		<a {if $sort=='position'} class="selected"{/if} href="{url surveys_sort=position page=null}">порядку</a>&nbsp;|&nbsp;<a {if $sort=='date'}    class="selected"{/if} href="{url surveys_sort=date page=null}">дате</a>&nbsp;|&nbsp;<a {if $sort=='name'}     class="selected"{/if} href="{url surveys_sort=name page=null}">имени</a>
	</div>
	{/if}*}

	{if $total_pages_num>1}
		<div class="blog-pg">
			{include file='pagination.tpl'}
		</div>
	{/if}
	{* Список заданий *}

	<ul id="blogposts" class="comment_list polls" style="margin-top:0;">
		{foreach $posts as $post}
			<li id="poll_{$post->id}" class="polls_item color_{if !empty($post->is_actual)}{$post->poll_type}{else}grey{/if}" onclick="window.location='/survey/{$post->url}'">
				<div class="poll_icon">
					{if $post->vote_type == 1}
					<svg fill="#FFFFFF" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
					    <path d="M0 0h24v24H0z" fill="none"/>
					    <path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
					</svg>
					{elseif $post->vote_type == 2}
					<svg fill="#FFFFFF" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
					    <path d="M0 0h24v24H0z" fill="none"/>
					    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
					</svg>
					{elseif $post->vote_type == 3}
					<svg fill="#FFFFFF" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
					    <path d="M0 0h24v24H0z" fill="none"/>
					    <path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zm4.24 16L12 15.45 7.77 18l1.12-4.81-3.73-3.23 4.92-.42L12 5l1.92 4.53 4.92.42-3.73 3.23L16.23 18z"/>
					</svg>
					{elseif $post->vote_type == 4}
					<svg fill="#FFFFFF" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
					    <path d="M20 6h-2.18c.11-.31.18-.65.18-1 0-1.66-1.34-3-3-3-1.05 0-1.96.54-2.5 1.35l-.5.67-.5-.68C10.96 2.54 10.05 2 9 2 7.34 2 6 3.34 6 5c0 .35.07.69.18 1H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2zm-5-2c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zM9 4c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm11 15H4v-2h16v2zm0-5H4V8h5.08L7 10.83 8.62 12 11 8.76l1-1.36 1 1.36L15.38 12 17 10.83 14.92 8H20v6z"/>
					    <path d="M0 0h24v24H0z" fill="none"/>
					</svg>
					{/if}
				</div>
				<div class="poll_name" data-survey="{$post->id}">{$post->name|escape}</div>
				{if $post->points > 0}
					<div class="poll_bonus">
						<div class="bonus_number">+{$post->points}</div>
						<div class="bonus_text">{$post->points|plural:'балл':'баллов':'балла'}</div>
					</div>
				{/if}
			</li>

		{/foreach}
	</ul>
	<div style="display:none;">
		<div id="none_userid" class="poll_popup" style="width:270px;">
			<div class="vote_mtitle">Вы не авторизованы</div>
			<div class="twobutton">
				<div class="leftbutton" onclick="window.location='/user/login?goto=auth'">Логин</div>
				<div class="rightbutton" onclick="window.location='/user/register?goto=signup'">Регистрация</div>
			</div>
		</div>
	</div>

	{if empty($user->id)}
		<script>
			$(window).on('load', function() { 
				$(document).ready(function(){ 
							$.fancybox({ 
				             		'href' : '#none_userid',
									'hideOnContentClick' : false,
									'hideOnOverlayClick' : false,
									'enableEscapeButton' : false,
									'showCloseButton' : false,
									'padding' : 0,
									'scrolling' : 'no'
			             	});
							return false;
				});
			})
		</script>
	{/if}

	{include file='pagination.tpl'}	
	{* Список заданий (The End) *}
{else}
	{if $keyword && $posts|count==0}<div class="blog-pg">Статьи не найдены</div>{/if}
{/if}	
{* Каталог заданий end*}

