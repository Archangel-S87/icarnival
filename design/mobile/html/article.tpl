{* Канонический адрес страницы *}
{$canonical="/article/{$post->url}" scope=root}
<div class="post-pg">
	{if !empty($category)}
	<div class="path bottom_line">
		<svg><use xlink:href='#folder' /></svg>
		<span><a href="articles/{$category->url}" title="{$category->name|escape}">{$category->name|escape}</a></span>
	</div>
	{/if}
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
	<div class="post_text">{$post->text}</div>
</div>

{if !empty($post->images)}
	<ul id="gallerypic" class="tiny_products">
		{foreach $post->images|cut as $i=>$image}
			<li class="product"><div class="image">
			<a rel="gallery" href="{$image->filename|resize:1024:768:w:$config->resized_articles_images_dir}" class="swipebox" title="{$post->name|escape}">
			<img alt="{$post->name|escape}" title="{$post->name|escape}" src="{$image->filename|resize:400:400:false:$config->resized_articles_images_dir}" /></a></div>
			</li>
		{/foreach}
	</ul>
{/if}

{* related products *}
{if !empty($rel_prod_ids)}
	{get_products var=related_products id=$rel_prod_ids}
	{if !empty($related_products)}
		<div class="mainproduct blue noradius">Связанные товары</div>
		<ul class="tiny_products">
			{foreach $related_products as $product}
				{include file='products_item.tpl'}
			{/foreach}
		</ul>
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
	<div class="mainproduct blog_also noradius">Рекомендуем прочесть</div>
	<ul class="comment_list">
		{foreach $last_articles as $post}
			{include file='articles_item.tpl'}
		{/foreach}
	</ul>
{/if}