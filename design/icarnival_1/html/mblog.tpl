<!-- incl. mblog -->
{get_posts var=last_posts limit=$news}
{if !empty($last_posts)}
	<div class="box mblog">
		<div class="box-heading">Последние <a href="blog" class="bloglink" title="Новости">новости</a></div>
		<div class="box-content">
				<div id="blog_menu" class="m_blog">
					<ul>
						{foreach $last_posts as $post}
							{if $post->name}
								<li class="dateico {if !empty($post->images) && (!in_array($module, array('BlogView', 'TagsView')))}has_image{/if}">
									{if !empty($post->images) && (!in_array($module, array('BlogView', 'TagsView')))}
									<div class="b_image shine" {if $post->text}onclick="window.location='/blog/{$post->url}'"{/if}
										style="{if $post->text}cursor:pointer;{/if} ">
										<img alt="{$post->name|escape}" title="{$post->name|escape}" src="{$post->images[0]->filename|resize:400:400:false:$config->resized_blog_images_dir}" />
									</div>
									{/if}
									<a data-post="{$post->id}" class="post_title" href="blog/{$post->url}" title="{$post->name|escape}">{$post->name|escape}</a>
									<div class="postdate">
										<div class="left">
											<svg><use xlink:href='#calendar' /></svg>
											<span>{$post->date|date}</span>
										</div>
										{if !in_array($module, array('BlogView', 'TagsView'))}
										<div class="right">
											<svg class="comments_icon"><use xlink:href='#comments_count' /></svg>
											<span>{$post->comments_count}</span>
										</div>
										<div class="right">
											<svg><use xlink:href='#views' /></svg>
											<span>{$post->views}</span>
										</div>
										{/if}
									</div>
									{*<div class="blog_annotation" data-post="{$post->id}">{$post->annotation}</div>*}
								</li>
							{/if}
						{/foreach}
					</ul>
					<p class="blogreadmore"><a title="Архив новостей" href="blog">Архив новостей ...</a></p>
				</div>
		</div>
	</div>
{/if}
<!-- incl. mblog @ -->