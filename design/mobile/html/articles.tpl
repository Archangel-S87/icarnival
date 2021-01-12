{if isset($smarty.server.HTTP_X_REQUESTED_WITH) && $smarty.server.HTTP_X_REQUESTED_WITH|strtolower == 'xmlhttprequest'}
    {$wrapper = '' scope=root}
    	
	<input class="refresh_title" type="hidden" value="{$meta_title|escape}{if !empty($current_page_num) && $current_page_num>1} - страница {$current_page_num}{/if}" />
{/if}

{if !empty($keyword)}
	{$canonical="/articles?keyword={$keyword|escape}" scope=root}
{elseif !empty($category)}
	{$canonical="/articles/{$category->url}{if $current_page_num>1}?page={$current_page_num}{/if}" scope=root}
{else}
	{$canonical="/articles{if $current_page_num>1}?page={$current_page_num}{/if}" scope=root}
{/if}

<input class="curr_page" type="hidden" data-url="{url page=$current_page_num}" value="{$current_page_num}" />
<input class="refresh_curr_page" type="hidden" data-url="{url page=$current_page_num}" value="{$current_page_num}" />
{if $current_page_num<$total_pages_num}<input class="refresh_next_page" type="hidden" data-url="{url page=$current_page_num+1}" value="{$current_page_num+1}" />{/if}
{if $current_page_num==2}<input class="refresh_prev_page" type="hidden" data-url="{url page=null}" value="{$current_page_num-1}" />{/if}
{if $current_page_num>2}<input class="refresh_prev_page" type="hidden" data-url="{url page=$current_page_num-1}" value="{$current_page_num-1}" />{/if}
<input class="total_pages" type="hidden" value="{$total_pages_num}" />

{* subcat *}
{if $page && $page->url == 'articles'}
	{function name=articles_categories_tree2 level=1}
			{if $articles_categories}
				<ul class="category_products separator">
					{foreach $articles_categories as $ac2}
						{if $ac2->visible}
							<li class="product" onClick="window.location='articles/{$ac2->url}'">
								<div class="image">
								{if $ac2->image}
									<img alt="{$ac2->name|escape}" title="{$ac2->name|escape}" src="{$config->articles_categories_images_dir}{$ac2->image}" />
								{else}
									<svg class="nophoto"><use xlink:href='#folder' /></svg>
								{/if}
								</div>
								<div class="product_info">
									<h3>{$ac2->name|escape}</h3>
								</div>
							</li>
						{/if}
					{/foreach}
				</ul>
			{/if}
	{/function}
	{articles_categories_tree2 articles_categories=$articles_categories}
{else}
	{if !empty($category->subcategories)}
		<ul class="category_products separator">
			{foreach name=cats from=$category->subcategories item=c}
				{if $c->visible}
					<li class="product" onClick="window.location='articles/{$c->url}'">
						<div class="image">
						{if !empty($c->image)}
							<img alt="{$c->name|escape}" title="{$c->name|escape}" src="{$config->articles_categories_images_dir}{$c->image}" />
						{else}
							<svg class="nophoto"><use xlink:href='#folder' /></svg>
						{/if}
						</div>
						<div class="product_info">
							<h3>{$c->name|escape}</h3>
						</div>
					</li>
				{/if}
			{/foreach}
		</ul>
	{/if}

{/if}
{* subcat end *}

{if !empty($page->body) || !empty($category->description)}
	<div class="blog-pg">	
		{if !empty($page->body)}{$page->body}{/if}
		{if !empty($category->description) && $current_page_num==1}
			{$category->description}
		{/if}
	</div>
{/if}

{* Каталог статей *}
{if $posts}
	<div class="ajax_pagination">

		{*{if $posts|count>1}
		<div class="sort blog-pg">
			Сортировать по: 
			<a {if $sort=='position'} class="selected"{/if} href="{url articles_sort=position page=null}">порядку</a>&nbsp;|&nbsp;<a {if $sort=='date'}    class="selected"{/if} href="{url articles_sort=date page=null}">дате</a>&nbsp;|&nbsp;<a {if $sort=='name'}     class="selected"{/if} href="{url articles_sort=name page=null}">имени</a>
		</div>
		{/if}*}

		{*{if $total_pages_num>1}
			<div class="blog-pg">
				{include file='pagination.tpl'}
			</div>
		{/if}*}
	
		{if $current_page_num >= 2}
			<div class="infinite_prev" style="display:none;">
				<div class="trigger_prev infinite_button">Загрузить пред. страницу</div>
			</div>
		{/if}

		<ul class="comment_list infinite_load" style="margin-top:0;">
			{foreach $posts as $post}
			<li>
				<h3 class="blog_title">{if !empty($post->text)}<a data-article="{$post->id}" href="article/{$post->url}" title="{$post->name|escape}">{$post->name|escape}</a>{else}{$post->name|escape}{/if}</h3>
				<div class="postdate dateico">
					<div class="left">
						<svg><use xlink:href='#calendar' /></svg>
						<span>{$post->date|date}</span>
					</div>
					<div class="right">
						<svg><use xlink:href='#views' /></svg>
						<span>Просмотров: {$post->views}</span>
					</div>
				</div>
				{if !empty($post->annotation)}<div class="post-annotation">{$post->annotation}</div>{/if}
				{*{if !empty($post->text)}<p class="readmore"><a href="article/{$post->url}">Далее ...</a></p>{/if}*}
				{if !empty($post->section)}
					<div class="path">
						<svg><use xlink:href='#folder' /></svg>
						<a href="articles/{$post->section->url}" title="{$post->section->name|escape}">{$post->section->name|escape}</a>
					</div>
				{/if}		
			</li>
			{/foreach}
		</ul>

		{*{include file='pagination.tpl'}*}
		{if $total_pages_num >1}
			<div class="infinite_pages infinite_button" style="display:none;margin:15px auto;">
				<div>Стр. {$current_page_num} из {$total_pages_num}</div>
			</div>
			<div class="infinite_trigger"></div>
		{/if}

	</div>
{else}
	{if isset($keyword) && empty($posts)}<div class="blog-pg">Статьи не найдены</div>{/if}
{/if}	
{* Каталог статей end *}

