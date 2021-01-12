{$wrapper = 'index.tpl' scope=root}

{* Канонический адрес страницы *}
{$canonical="" scope=root}

{include file='slides_mob.tpl'}

{* categories start *}
	{if $settings->purpose == 0}
		{function name=categories_treemain}
			{if $categories}
				<div class="maincatalog">Каталог</div>
				<ul class="category_products separator" style="margin-bottom:10px;margin-top:0;">
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
									<h3>{$c->name|escape}</h3>
								</div>
							</li>
						{/if}
					{/foreach}
					{if !empty($settings->show_brands)}
							<li class="product svg_brands" onClick="window.location='/brands'">
								<div class="image">
									<svg viewBox="0 0 24 24"><use xlink:href='#brands' /></svg>
								</div>
								<div class="product_info">
									<h3>Бренды</h3>
								</div>
							</li>
					{/if}
					{get_products var=discounted_products discounted=1 limit=3}
					{if !empty($discounted_products) && $discounted_products|count > 2}
							<li class="product svg_lowprice" onClick="window.location='/discounted'">
								<div class="image">
									<svg class="lowprice" viewBox="0 0 24 24"><use xlink:href='#lowprice' /></svg>
								</div>
								<div class="product_info">
									<h3>Скидки</h3>
								</div>
							</li>
					{/if}
					{get_products var=featured_products featured=1 limit=3}
					{if !empty($featured_products) && $featured_products|count > 2}
							<li class="product svg_hit" onClick="window.location='/hits'">
								<div class="image">
									<svg class="hit" viewBox="0 0 24 24"><use xlink:href='#hit' /></svg>
								</div>
								<div class="product_info">
									<h3>Лидеры продаж</h3>
								</div>
							</li>
					{/if}
					{get_products var=is_new_products is_new=1 limit=3}
					{if !empty($is_new_products) && $is_new_products|count > 2}
							<li class="product svg_new" onClick="window.location='/new'">
								<div class="image">
									<svg class="new" viewBox="0 0 24 24"><use xlink:href='#new' /></svg>
								</div>
								<div class="product_info">
									<h3>Новинки</h3>
								</div>
							</li>
					{/if}
				</ul>
			{/if}
		{/function}
		{categories_treemain categories=$categories}
	{elseif $settings->purpose == 1}
		{function name=services_categories_treemain level=1}
				{if $services_categories}
					<div class="maincatalog">Каталог</div>
					<ul class="category_products separator" style="margin-bottom:10px;margin-top:0px;">
						{foreach $services_categories as $ac2}
							{if $ac2->visible}
								<li class="product" onClick="window.location='/services/{$ac2->url}'">
									<div class="image">
									{if $ac2->image}
										<img alt="{$ac2->menu|escape}" title="{$ac2->menu|escape}" src="{$config->services_categories_images_dir}{$ac2->image}" />
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
				{/if}
		{/function}
		{services_categories_treemain services_categories=$services_categories}	
	{/if}
{* categories end *}

{* main text *}
{if $page->body}
	<div class="main-text">
		<div class="top cutouter" style="max-height:{$settings->cutmob|escape}px;">
			<div class="disappear"></div>
			<div class="cutinner">
			  	<h1>{$page->header|escape}</h1>
			  	{$page->body}
			</div>
		</div>
		<div class="top cutmore" style="display:none;">Развернуть...</div>
	</div>
{/if}
{* main text end *}

{if $settings->hideblog == 1}
	{$news=3}
	{include file='mblog.tpl'}
{/if}
