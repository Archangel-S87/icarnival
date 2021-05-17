<!-- incl. blogline_body -->
<ul class="blogline">
{foreach $last_posts as $post}
	<li class="blogitem_wrapper">
		<div class="postimage shine" {if $post->text}onclick="window.location='/blog/{$post->url}'"{/if}
			style="{if $post->text}cursor:pointer;{/if} {if !empty($post->images)}background-image: url({$post->images[0]->filename|resize:400:400:false:$config->resized_blog_images_dir});{/if}">
			{if empty($post->images)}
				<svg class="no_photo"><use xlink:href='#no_photo' /></svg>
			{/if}
			<h3 class="post_title">
				{if !empty($post->text)}
				<a data-post="{$post->id}" href="blog/{$post->url}" title="{$post->name|escape}">{$post->name|escape|truncate:80:"...":true}</a>
				{else}{$post->name|escape|truncate:80:"...":true}{/if}
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
			{if !empty($settings->allow_views)}
			<div class="right">
				<svg><use xlink:href='#views' /></svg>
				<span><span class="views_title">Просмотров: </span>{$post->views}</span>
			</div>
			{/if}
		</div>
		{if !empty($post->annotation)}<div class="blog_annotation {if !empty($post->section)}has_category{/if}" {if !empty($post->text)}style="cursor:pointer;" onclick="window.location='/blog/{$post->url}'"{/if}>{$post->annotation}</div>{/if}
		{if !empty($post->section)}
			<div class="path">
				<svg><use xlink:href='#folder' /></svg>
				<a href="sections/{$post->section->url}" title="{$post->section->name|escape}">{$post->section->name|escape}</a>
			</div>
		{/if}
	</li>
{/foreach}
</ul>
<!-- incl. blogline_body @ -->
