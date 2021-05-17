<!-- incl. blog_item -->
<div class="postimage shine" {if $post->text}onclick="window.location='/blog/{$post->url}'"{/if} 
style="{if $post->text}cursor:pointer;{/if} {if !empty($post->image)}background-image: url({$post->image->filename|resize:400:400:false:$config->resized_blog_images_dir});{/if}">
	{if empty($post->image)}
		<svg class="no_photo"><use xlink:href='#no_photo' /></svg>
	{/if}
	<h3 class="post_title">{if !empty($post->text)}<a data-post="{$post->id}" href="blog/{$post->url}" title="{$post->name|escape}">{$post->name|escape}</a>{else}{$post->name|escape}{/if}
	</h3>
</div>
<div class="postdate dateico">
	<div class="left">
		<svg><use xlink:href='#calendar' /></svg>
		<span>{$post->date|date}</span>
	</div>
	<div class="right">
		<svg class="comments_icon"><use xlink:href='#comments_count' /></svg>
		<span>{$post->comments_count}</span>
	</div>
	<div class="right">
		<svg><use xlink:href='#views' /></svg>
		<span><span class="views_title">Просмотров: </span>{$post->views}</span>
	</div>
</div>
{if !empty($post->annotation)}<div class="blog_annotation {if !empty($post->section)}has_category{/if}">{$post->annotation}</div>{/if}
{if !empty($post->section)}
	<div class="path">
		<svg><use xlink:href='#folder' /></svg>
		<a href="sections/{$post->section->url}" title="{$post->section->name|escape}">{$post->section->name|escape}</a>
	</div>
{/if}
<!-- incl. blog_item @-->