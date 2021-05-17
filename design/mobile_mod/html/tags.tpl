{* Канонический адрес страницы *}
{if empty($meta_title)}
	{$meta_title = "Хэштеги" scope=root}
{/if}

{if !empty($keyword)}
	{$canonical="/tags?keyword={$keyword|escape}" scope=root}
{else}
	{$canonical="/tags" scope=root}
	{$page_name="Хэштеги" scope=root}
{/if}

{if !empty($page->body)}
<div class="post-pg">{$page->body}</div>
{/if}

{if empty($keyword)}	
<div class="post-pg">
	{* tags *}
	{if !empty($tags)}
		<div class="nav_tags">
			{foreach $tags as $tag}
			<a href="tags?keyword={$tag->value|escape}" class="tag_item">
				<svg><use xlink:href='#tag' /></svg>
				<span>{$tag->value|escape}</span>
			</a>{*{if !$tag@last}, {/if}*}
			{/foreach}
		</div>
		<svg style="display:none;">
			<symbol id="tag" viewBox="0 0 24 24">
				<path fill="none" d="M0 0h24v24H0V0z"/><path d="M21.41 11.58l-9-9C12.05 2.22 11.55 2 11 2H4c-1.1 0-2 .9-2 2v7c0 .55.22 1.05.59 1.42l9 9c.36.36.86.58 1.41.58s1.05-.22 1.41-.59l7-7c.37-.36.59-.86.59-1.41s-.23-1.06-.59-1.42zM13 20.01L4 11V4h7v-.01l9 9-7 7.02z"/><circle cx="6.5" cy="6.5" r="1.5"/>
			</symbol>
		</svg>
	{/if}
	{* tags @ *}
</div>	
{else}
	{if !empty($posts)}
	{* Записи *}
	<ul id="blogposts" class="comment_list">
		{foreach $posts as $post}
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
					<div class="right">
						<svg><use xlink:href='#views' /></svg>
						<span>Просмотров: {$post->views}</span>
					</div>
				</div>
				{if !empty($post->annotation)}<div class="post-annotation">{$post->annotation|replace:"li>":"div>"}</div>{/if}
				{*{if !empty($post->text)}<p class="readmore"><a href="blog/{$post->url}">Далее ...</a></p>{/if}*}
				{if isset($post->section)}
				<div class="path">
					<svg><use xlink:href='#folder' /></svg>
					<a href="sections/{$post->section->url}" title="{$post->section->name|escape}">{$post->section->name|escape}</a>
				</div>
				{/if}
			</li>
		{/foreach}
	</ul>
	{* Записи end *}    
	{/if}
{/if}

