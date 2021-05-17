{* Канонический адрес страницы *}
{$canonical="/{$page->url}" scope=root}

{if $page->url == 'catalog' || $page->url == '404'}
	{* categories *}
	{if (empty($settings->purpose) || $page->url == 'catalog') && !empty($categories)}
		{function name=categories_treecat}
			<ul class="category_products separator">
				{foreach $categories as $c}
					{if $c->visible}
						<li class="product" onClick="window.location='/catalog/{$c->url}'">								
							<div class="image">
								{if $c->image}
									<img alt="{$c->name|escape}" title="{$c->name|escape}" src="{$config->categories_images_dir}{$c->image}" />
								{else}
									<svg class="nophoto"><use xlink:href='#folder' /></svg>
								{/if}
							</div>
							<div class="product_info">
								<h3>{if !empty($c->menu)}{$c->menu|escape}{else}{$c->name|escape}{/if}</h3>
							</div>
						</li>
					{/if}
				{/foreach}
			</ul>
		{/function}
		{categories_treecat categories=$categories}
	{elseif !empty($settings->purpose) && !empty($services_categories)}
		{function name=services_categories_tree2 level=1}
			<ul class="category_products separator">
				{foreach $services_categories as $ac2}
					{if $ac2->visible}
						<li class="product" onClick="window.location='/services/{$ac2->url}'">
							<div class="image">
								{if $ac2->image}
									<img alt="{$ac2->name|escape}" title="{$ac2->name|escape}" src="{$config->services_categories_images_dir}{$ac2->image}" />
								{else}
									<svg class="nophoto"><use xlink:href='#folder' /></svg>
								{/if}
							</div>
							<div class="product_info">
								<h3>{$ac2->menu|escape}</h3>
							</div>
						</li>
					{/if}
				{/foreach}
			</ul>
		{/function}
		{services_categories_tree2 services_categories=$services_categories}	
	{/if}
	{* categories end *}
{elseif $page->url == 'reviews-archive'}
	<div id="comments" class="response_archive" itemprop="description">
		<ul role="navigation" class="comment_list">
			{$comments_num = 0}
			
			{get_comments var=last_comments1 type='product'}
			{if $last_comments1}
				{foreach $last_comments1 as $comment}
					<li>
						<div class="comment_header">{$comment->name} <i>({$comment->date|date}, {$comment->date|time})</i>:</div>
						<div class="comment_about">о товаре <a href="products/{$comment->url}">{$comment->product|escape}</a>:</div>
						<div class="comment_body">{if !empty($settings->allow_comment_tags)}{$comment->text|escape|nl2br|bbcode}{else}{$comment->text|escape|nl2br}{/if}</div>
						{if $comment->otvet}
							<div class="comment_admint">Администрация:</div>
							<div class="comment_admin" style="margin-bottom: 5px;">
								{$comment->otvet}
							</div>
						{/if}
					</li>
					{$comments_num = $comments_num + 1}
				{/foreach}
	        {/if}

			{get_comments var=last_comments2 type='blog'}
			{if $last_comments2}
				{foreach $last_comments2 as $comment}
					<li>
						<div class="comment_header">{$comment->name} <i>({$comment->date|date}, {$comment->date|time})</i></div>
						<div class="comment_about">о записи <a href="blog/{$comment->url}">{$comment->product|escape}</a>:</div>
						<div class="comment_body">{if !empty($settings->allow_comment_tags)}{$comment->text|escape|nl2br|bbcode}{else}{$comment->text|escape|nl2br}{/if}</div>
						{if $comment->otvet}
							<div class="comment_admint">Администрация:</div>
							<div class="comment_admin" style="margin-bottom: 5px;">
								{$comment->otvet}
							</div>
						{/if}
					</li>
					{$comments_num = $comments_num + 1}
				{/foreach}
	        {/if}
		</ul>
		{if $comments_num > 10}	
			<input type='hidden' id='current_page' />
			<input type='hidden' id='show_per_page' />	
			<div id="page_navigation" class="pagination"></div>
		{/if}
	</div>
{elseif $page->url == 'brands'}
	<div class="brand-pg" itemprop="description">
        {get_brands var=all_brands}
        {if $all_brands}
            <ul class="category_products brands_list">
				{foreach name=brands item=b from=$all_brands}
					<li class="product" style="cursor:pointer;" onClick="window.location='/brands/{$b->url}'">
						<div class="image">
							{if $b->image}
								<img alt="{$b->name}" title="{$b->name}" src="{$config->brands_images_dir}{$b->image}" />
							{*{else}
								<svg class="nophoto"><use xlink:href='#folder' /></svg>*}
							{/if}
						</div>
						<div class="product_info">
							<h3 data-brand="{$b->id}">{$b->name}</h3>
						</div>
					</li>
				{/foreach}
            </ul>
        {/if}
	</div>	
{elseif $page->url == 'm-info'}
	{include file='minfo.tpl'}
{/if}

{if !empty($metadata_page->description) || !empty($page->body)}
	<div class="page-pg" itemprop="description">
		{if !empty($metadata_page->description)}{$metadata_page->description}{elseif !empty($page->body)}{$page->body}{/if}
	</div>
{/if}

