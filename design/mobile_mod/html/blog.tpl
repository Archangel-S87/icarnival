{if isset($smarty.server.HTTP_X_REQUESTED_WITH) && $smarty.server.HTTP_X_REQUESTED_WITH|strtolower == 'xmlhttprequest'}
    {$wrapper = '' scope=root}
    	
	<input class="refresh_title" type="hidden" value="{$meta_title|escape}{if !empty($current_page_num) && $current_page_num>1} - страница {$current_page_num}{/if}" />
{/if}

{if isset($keyword)}
	{$canonical="/blog?keyword={$keyword|escape}" scope=root}
{elseif isset($category)}
	{$canonical="/sections/{$category->url}{if $current_page_num>1}?page={$current_page_num}{/if}" scope=root}
{else}
	{$canonical="/blog{if $current_page_num>1}?page={$current_page_num}{/if}" scope=root}
{/if}

<input class="curr_page" type="hidden" data-url="{url page=$current_page_num}" value="{$current_page_num}" />
<input class="refresh_curr_page" type="hidden" data-url="{url page=$current_page_num}" value="{$current_page_num}" />
{if $current_page_num<$total_pages_num}<input class="refresh_next_page" type="hidden" data-url="{url page=$current_page_num+1}" value="{$current_page_num+1}" />{/if}
{if $current_page_num==2}<input class="refresh_prev_page" type="hidden" data-url="{url page=null}" value="{$current_page_num-1}" />{/if}
{if $current_page_num>2}<input class="refresh_prev_page" type="hidden" data-url="{url page=$current_page_num-1}" value="{$current_page_num-1}" />{/if}
<input class="total_pages" type="hidden" value="{$total_pages_num}" />

{if empty($category) && !empty($blog_categories)}
	<div class="brand-pg">
        <ul class="category_products brands_list">
        {foreach $blog_categories as $bc}
			{if $bc->visible}
			<li  class="product" style="cursor:pointer;" onClick="window.location='/sections/{$bc->url}'">
				<div class="image">
					{if $bc->image}
						<img alt="{$bc->name|escape}" title="{$bc->name|escape}" src="{$config->blog_categories_images_dir}{$bc->image}" />
					{else}
						<svg class="nophoto"><use xlink:href='#folder' /></svg>
					{/if}
				</div>
				
				<div class="product_info">
					<h3>{$bc->name|escape}</h3>
				</div>
			</li>
			{/if}
		{/foreach}
        </ul>
	</div>	
{/if}

{if !empty($page->body)}
	<div class="post-pg">
		{$page->body}
	</div>
{/if}

{if !empty($posts)}
	<div class="ajax_pagination">
		{*<div class="post-pg">
		{include file='pagination.tpl'}
		</div>*}
		
		{if $current_page_num >= 2}
			<div class="infinite_prev" style="display:none;">
				<div class="trigger_prev infinite_button">Загрузить пред. страницу</div>
			</div>
		{/if}
	
		<ul class="comment_list infinite_load" style="margin-top:0;">
			{foreach $posts as $post}
				{include file='blog_item.tpl'}
			{/foreach}
		</ul>   
		
		{*{include file='pagination.tpl'}*}
		{if $total_pages_num >1}
			<div class="infinite_pages infinite_button" style="display:none;margin:15px auto;">
				<div>Стр. {$current_page_num} из {$total_pages_num}</div>
			</div>
			<div class="infinite_trigger"></div>
		{/if}
	</div>
{else}
	<div class="post-pg">
		Публикаций не найдено
	</div>
{/if}


