<!-- incl. mblog -->
<div class="page-pg">
	<h2 class="mainproduct blue">Новости</h2>
</div>	
{get_posts var=posts limit=$news}
{if !empty($posts)}
	<ul class="comment_list infinite_load" style="margin-top:0;">
		{foreach $posts as $post}
			<li>
				<h3 class="blog_title">{if !empty($post->text)}<a href="blog/{$post->url}" title="{$post->name|escape}">{$post->name|escape}</a>{else}{$post->name|escape}{/if}</h3>
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
			</li>
		{/foreach}
	</ul>   
	<div class="page-pg" style="margin-top:-5px;">
		<a class="blogmore" href="blog">Все записи...</a>
	</div>	
{else}
	<div class="page-pg">Публикаций не найдено</div>
{/if}
<!-- incl. mblog @-->