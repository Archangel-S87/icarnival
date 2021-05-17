<li>
	<h3 class="blog_title">{if !empty($post->text)}<a data-article="{$post->id}" href="article/{$post->url}" title="{$post->name|escape}">{$post->name|escape}</a>{else}{$post->name|escape}{/if}</h3>
	<div class="postdate dateico">
		<div class="left">
			<svg><use xlink:href='#calendar' /></svg>
			<span>{$post->date|date}</span>
		</div>
		{if !empty($settings->allow_views)}
		<div class="right">
			<svg><use xlink:href='#views' /></svg>
			<span>Просмотров: {$post->views}</span>
		</div>
		{/if}
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