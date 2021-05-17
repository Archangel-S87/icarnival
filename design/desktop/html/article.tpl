{* Канонический адрес страницы *}
{$canonical="/article/{$post->url}" scope=root}

<h1 data-article="{$post->id}">{$post->name|escape}</h1>

<div {if $post->images|count>1}class="postcontent"{/if} itemscope itemtype="http://schema.org/Article">
		<meta content="{$meta_title|escape}" itemprop="name">
		<meta content="{$config->root_url}" itemprop="author" />
		<meta content="{$post->date|date_format:'c'}" itemprop="datePublished" />
		<meta content="{$post->last_modify|date_format:'c'}" itemprop="dateModified" />
		<meta content="{$meta_title|escape}" itemprop="headline" />
		{$seo_description = $meta_title|cat:$settings->seo_description|cat:" ✩ "|cat:$settings->site_name|cat:" ✩"}
		<meta content="{if !empty($meta_description)}{$meta_description|escape}{elseif !empty($seo_description)}{$seo_description|escape}{/if}" itemprop="description" />
		<meta content="" itemscope itemprop="mainEntityOfPage" itemType="https://schema.org/WebPage" itemid="{$config->root_url}/article/{$post->url}" /> 
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
				<span><a href="articles/{$category->url}" title="{$category->name|escape}">{$category->name|escape}</a></span>
			</div>
			{/if}
			{if !empty($settings->allow_views)}
			<div class="right">
				<svg><use xlink:href='#views' /></svg>
				<span>Просмотров: {$post->views}</span>
			</div>
			{/if}
		</div>
		<div class="page-pg" itemprop="description">
			{$post->text}
			<div style="display:none;" itemprop="image" itemscope itemtype="https://schema.org/ImageObject">
				{if !empty($post->images[1])}
					{$img_url=$post->images[1]->filename|resize:1024:768:w:$config->resized_articles_images_dir}
				{elseif !empty($post->image)}
					{$img_url=$post->image->filename|resize:400:400:false:$config->resized_articles_images_dir}
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
</div>

{if !empty($post->images)}
	<ul id="gallerypic" class="tiny_products">
		{foreach $post->images|cut as $i=>$image}
			<li class="product">
				<div class="image">
					<a rel="nofollow" data-rel="gallery" href="{$image->filename|resize:1024:768:w:$config->resized_articles_images_dir}" class="zoom" title="{$post->name|escape}">
						<img src="{$image->filename|resize:400:400:false:$config->resized_articles_images_dir}" alt="{$post->name|escape}" />
					</a>
				</div>
			</li>
		{/foreach}
	</ul>
{/if}
<!--noindex-->
{$settings->advertarticle}
<!--/noindex-->

{* related products *}
{if !empty($rel_prod_ids)}
	{get_products var=related_products id=$rel_prod_ids}
	{if !empty($related_products)}
		<div class="mainproduct blue">Связанные товары</div>
		<div id="hitcontent" class="tiny_products hoverable">
			{foreach $related_products as $product}
				<div class="product_wrap">
					{include file='products_item.tpl'}
				</div>
			{/foreach}
		</div>
	{/if}
{/if}
{* related products @ *}

{if !empty($rel_art_ids)}
	{* Связанные статьи *}
	{get_articles var='last_articles' limit=3 id=$rel_art_ids sort='date'}
{elseif !empty($category->id)}
	{* Статьи из той же категории *}
	{get_articles var='last_articles' category_id=$category->id limit=3 sort='rand'}
{else}
	{get_articles var='last_articles' limit=3 sort='rand'}
{/if}
{if !empty($last_articles)}
	<div class="mainproduct blog_also">Рекомендуем прочесть</div>
	<div class="blogposts">
	{include file='articlesline_body.tpl'}
	</div>
{/if}
