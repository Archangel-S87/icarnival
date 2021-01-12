<!-- incl. articlesline_body @ -->
<ul class="blogline">
{foreach $last_articles as $post}
	<li class="blogitem_wrapper">
		<div class="postimage shine" {if $post->text}onclick="window.location='/article/{$post->url}'"{/if}
			style="{if $post->text}cursor:pointer;{/if} {if !empty($post->images)}background-image: url({$post->images[0]->filename|resize:400:400:false:$config->resized_articles_images_dir});{/if}">
			{if empty($post->images)}
				<svg class="no_photo"><use xlink:href='#no_photo' /></svg>
			{/if}
			<h3 class="post_title">
				{if !empty($post->text)}
					<a data-article="{$post->id}" href="article/{$post->url}" title="{$post->name|escape}">{$post->name|escape|truncate:80:"...":true}</a>
				{else}{$post->name|escape|truncate:80:"...":true}{/if}
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
		{if !empty($post->annotation)}<div class="blog_annotation {if !empty($post->categories)}has_category{/if}" {if !empty($post->text)}style="cursor:pointer;" onclick="window.location='/article/{$post->url}'"{/if}>{$post->annotation}</div>{/if}
		{if !empty($post->categories)}
			{$category = $post->categories[0]}
			<div class="path">
				<svg><use xlink:href='#folder' /></svg>
				<a href="articles/{$category->url}" title="{$category->name|escape}">{$category->name|escape}</a>
			</div>
		{/if}
	</li>
{/foreach}
</ul>
<!-- incl. articlesline_body @ -->
