{* ajax pagination *}
{if isset($smarty.server.HTTP_X_REQUESTED_WITH) && $smarty.server.HTTP_X_REQUESTED_WITH|strtolower == 'xmlhttprequest'}
    {$wrapper = '' scope=root}
    	
	<input class="refresh_title" type="hidden" value="{$meta_title|escape}{if $current_page_num>1} - страница {$current_page_num}{/if}" />
{/if}
{* ajax pagination end *}

{if !empty($keyword)}
	{$canonical="/articles?keyword={$keyword|escape}" scope=root}
{elseif !empty($category)}
	{$canonical="/articles/{$category->url}{if $current_page_num>1}?page={$current_page_num}{/if}" scope=root}
{else}
	{$canonical="/articles{if $current_page_num>1}?page={$current_page_num}{/if}" scope=root}
{/if}

{* Заголовок страницы *}
{if !empty($keyword)}
<h1>Результаты поиска по: "{$keyword|escape}"</h1>
{elseif isset($page->name)}
<h1>{$page->name|escape}</h1>
{elseif isset($category->name)}
<h1 data-articlescategory="{$category->id}">{$category->name|escape}</h1>
{/if}

{if !empty($page->body) || ( !empty($category->description) && !empty($current_page_num) && $current_page_num==1 )}
<div itemscope itemtype="http://schema.org/Article">
	<meta content="{$meta_title|escape}" itemprop="name" />
	<meta content="{$config->root_url}" itemprop="author" />
	{if !empty($category)}
		<meta content="{$category->last_modify|date_format:'c'}" itemprop="datePublished" />
		<meta content="{$category->last_modify|date_format:'c'}" itemprop="dateModified" />
	{elseif !empty($page->last_modify)}
		<meta content="{$page->last_modify|date_format:'c'}" itemprop="datePublished" />
		<meta content="{$page->last_modify|date_format:'c'}" itemprop="dateModified" />
	{/if}
	<meta content="{$meta_title|escape}" itemprop="headline" />
	{$seo_description = $meta_title|cat:$settings->seo_description|cat:" ✩ "|cat:$settings->site_name|cat:" ✩"}
	<meta content="{if !empty($meta_description)}{$meta_description|escape}{elseif !empty($seo_description)}{$seo_description|escape}{/if}" itemprop="description" />
	<meta content="" itemscope itemprop="mainEntityOfPage" itemType="https://schema.org/WebPage" itemid="{$config->root_url}{$canonical}" /> 
	<div style="display:none;" itemprop="image" itemscope itemtype="https://schema.org/ImageObject">				
		{if !empty($category->image)}
			{$img_url=$config->root_url|cat:'/'|cat:$config->articles_categories_images_dir|cat:$category->image}
		{else}
			{$img_url=$config->root_url|cat:'/files/logo/logo.png'}
		{/if}
			<img itemprop="url contentUrl" src="{$img_url}" alt="{$meta_title|escape}"/>
			<meta itemprop="image" content="{$img_url}" />
			{assign var="info" value=$img_url|getimagesize}
			<meta itemprop="width" content="{$info.0}" />
			<meta itemprop="height" content="{$info.1}" />
	</div>
	<div style="display:none;" itemprop="publisher" itemscope itemtype="https://schema.org/Organization">
		<div itemprop="logo" itemscope itemtype="https://schema.org/ImageObject">
			<img itemprop="url" src="{$config->root_url}/files/logo/logo.png" alt="{$settings->company_name|escape}"/>
			<meta itemprop="image" content="{$config->root_url}/files/logo/logo.png" />
		</div>
		<meta itemprop="name" content="{$settings->company_name|escape}" />
		<meta itemprop="address" content="{$config->root_url}" />
		<meta itemprop="telephone" content="{$settings->phone|escape}" />
	</div>
	
	<div class="post-pg" itemprop="articleBody">
		{if !empty($page->body)}{$page->body}{/if}
		{if $current_page_num==1 && !empty($category->description)}
			{$category->description}
		{/if}
	</div>
</div>
{/if}

{if $page && $page->url == 'articles'}
	{function name=articles_categories_tree2 level=1}
		{if !empty($articles_categories)}
				<ul class="relcontent tiny_products parentscat" style="margin-bottom: -6px !important;">
					{foreach $articles_categories as $ac2}
						{if $ac2->visible}
							<li class="product" onClick="window.location='/articles/{$ac2->url}'" style="cursor:pointer;">
								<div class="image">
								{if $ac2->image}
									<img src="{$config->articles_categories_images_dir}{$ac2->image}" alt="{$ac2->name}" title="{$ac2->name}" />
								{else}
									<svg class="nophoto"><use xlink:href='#folder' /></svg>
								{/if}
								</div>
								<div class="product_info">
									<h3 class="product_title"><a data-articlescategory="{$ac2->id}" href="articles/{$ac2->url}">{$ac2->name}</a></h3>
								</div>
							</li>
						{/if}
					{/foreach}
				</ul>
		{/if}
	{/function}
	{articles_categories_tree2 articles_categories=$articles_categories}
{elseif !empty($category->subcategories)}
	<ul class="relcontent tiny_products parentscat" style="margin-bottom: 0px !important;">
		{foreach name=cats from=$category->subcategories item=c}
		{if $c->visible}
		<li class="product" onClick="window.location='/articles/{$c->url}'" style="cursor:pointer;">
			<div class="image">
			{if $c->image}
				<img src="{$config->articles_categories_images_dir}{$c->image}" alt="{$c->name}" title="{$c->name}" />
			{else}
				<svg class="nophoto"><use xlink:href='#folder' /></svg>
			{/if}
			</div>
			<div class="product_info">
			<h3 class="product_title"><a data-articlescategory="{$c->id}" href="articles/{$c->url}">{$c->name}</a></h3>
			</div>
		</li>
		{/if}
		{/foreach}
	</ul>
{/if}

{* Каталог *}
{if $posts}

	{* Сортировка *}
	{if $posts|count>1}
		<div class="sort">
			Сортировать по 
			<a {if $sort=='position'} class="selected"{/if} href="{url articles_sort=position page=null}">умолчанию</a>
			<a {if $sort=='date'}    class="selected"{/if} href="{url articles_sort=date page=null}">дате</a>
			<a {if $sort=='name'}     class="selected"{/if} href="{url articles_sort=name page=null}">названию</a>
		</div>
	{/if}
	
	{include file='pagination.tpl'}
	
	<ul class="blogline blogposts">
		{foreach $posts as $post}
		<li class="blogitem_wrapper">
			<div class="postimage shine" {if $post->text}onclick="window.location='/article/{$post->url}'"{/if}
			style="{if $post->text}cursor:pointer;{/if} {if !empty($post->image)}background-image: url({$post->image->filename|resize:400:400:false:$config->resized_articles_images_dir});{/if}">
				{if empty($post->image)}
					<svg class="no_photo"><use xlink:href='#no_photo' /></svg>
				{/if}
				<h3 class="post_title">{if !empty($post->text)}<a data-article="{$post->id}" href="article/{$post->url}" title="{$post->name|escape}">{$post->name|escape}</a>{else}{$post->name|escape}{/if}
				</h3>
			</div>
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
			{if !empty($post->annotation)}<div class="blog_annotation {if !empty($post->section)}has_category{/if}">{$post->annotation}</div>{/if}
			{if !empty($post->section)}
				<div class="path">
					<svg><use xlink:href='#folder' /></svg>
					<a href="articles/{$post->section->url}" title="{$post->section->name|escape}">{$post->section->name|escape}</a>
				</div>
			{/if}				
		</li>
		{if $post@iteration%3 == 0 && !$post@last}
		</ul><ul class="blogline blogposts">
		{/if}
		{/foreach}
	</ul>

	{include file='pagination.tpl'}	

{else}
	<p>Статьи не найдены</p>
{/if}	
{* Каталог end *}
