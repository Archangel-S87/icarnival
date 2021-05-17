<li>
	<h3 class="blog_title">{if !empty($post->text)}<a data-post="{$post->id}" href="blog/{$post->url}" title="{$post->name|escape}">{$post->name|escape}</a>{else}{$post->name|escape}{/if}</h3>
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
			<span>Просмотров: {$post->views}</span>
		</div>
		{/if}
	</div>
	{if !empty($post->annotation)}<div class="post-annotation">{$post->annotation|replace:"li>":"div>"}</div>{/if}
	{*{if !empty($post->text)}<p class="readmore"><a href="blog/{$post->url}">Далее ...</a></p>{/if}*}
	{if !empty($post->section)}
		<div class="path">
			<svg><use xlink:href='#folder' /></svg>
			<a href="sections/{$post->section->url}" title="{$post->section->name|escape}">{$post->section->name|escape}</a>
		</div>
	{/if}
</li>