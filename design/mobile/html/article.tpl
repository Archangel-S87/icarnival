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
			<a rel="gallery" href="{$image->filename|resize:800:600:w:$config->resized_articles_images_dir}" class="swipebox" title="{$post->name|escape}">
			<img alt="{$post->name|escape}" title="{$post->name|escape}" src="{$image->filename|resize:400:400:false:$config->resized_articles_images_dir}" /></a></div>
			</li>
		{/foreach}
	</ul>
{/if}
