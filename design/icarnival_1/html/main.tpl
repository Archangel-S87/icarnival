{$wrapper = 'index.tpl' scope=root}

{* Канонический адрес страницы *}
{$canonical="" scope=root}

<link rel="stylesheet" type="text/css" href="design/{$settings->theme|escape}/css/main.css?v={filemtime("design/{$settings->theme|escape}/css/main.css")}"/>

{if $settings->addfield2 && $settings->slidermode != 'sideslider'}
	<div class="marketing-boxes">
		<ul>
			{if $settings->bannerfirstvis}<li><img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" {if !empty($settings->bannerfirst)}onClick="window.location='{$settings->bannerfirst}'" class="pointer"{/if} src="{$config->banner1img_file}?{filemtime("{$config->banner1img_file}")}" /></li>{/if}
			{if $settings->bannersecondvis}<li><img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" {if !empty($settings->bannersecond)}onClick="window.location='{$settings->bannersecond}'" class="pointer"{/if} src="{$config->banner2img_file}?{filemtime("{$config->banner2img_file}")}" /></li>{/if}
			{if $settings->bannerthirdvis}<li><img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" {if !empty($settings->bannerthird)}onClick="window.location='{$settings->bannerthird}'" class="pointer"{/if} src="{$config->banner3img_file}?{filemtime("{$config->banner3img_file}")}" /></li>{/if}
			{if $settings->bannerfourvis}<li><img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" {if !empty($settings->bannerfour)}onClick="window.location='{$settings->bannerfour}'" class="pointer"{/if} src="{$config->banner4img_file}?{filemtime("{$config->banner4img_file}")}" /></li>{/if}
		</ul>
	</div>
{/if}

{foreach from=$settings->position_carousel key=$carousel item=$i}
	{if $settings->mainhits && $carousel == 'mainhits'}
		{* hits *}
		{* available sort (or remove): position, name, date, views, rating, rand *}
		{get_products var=featured_products featured=1 sort=rand limit=12}
		{if !empty($featured_products)}
			{if $settings->addfield2}
				<div class="mainproduct block-header hits_carousel">
					<div class="block-header__title">Лидеры продаж / бестселлеры</div>
					<div class="block-header__divider"></div>
					<div class="block-header__arrows-list">
						<button class="block-header__arrow arrow_left" type="button">
							<svg><use xlink:href='#arrow-rounded-left-7x11' /></svg>
						</button>
						<button class="block-header__arrow arrow_right" type="button">
							<svg><use xlink:href='#arrow-rounded-right-7x11' /></svg>
						</button>
					</div>
				</div>
			{/if}
			<div id="hitcarusel" class="tiny_products hoverable owl-carousel">
				{foreach $featured_products as $product}
					<div class="product_wrap" style="display:none;">
						{include file='products_item.tpl'}
					</div>
				{/foreach}
			</div>
		{/if}
		{* hits end *}
	{/if}

	{if $settings->mainnew && $carousel == 'mainnew'}
		{* new *}
		{* available sort (or remove): position, name, date, views, rating, rand *}
		{get_products var=is_new_products is_new=1 sort=rand limit=12}
		{if !empty($is_new_products)}
			{if $settings->mainnew || $settings->addfield2}
				<div class="mainproduct block-header new_carousel">
					<div class="block-header__title">Новинки в магазине</div>
					<div class="block-header__divider"></div>
					<div class="block-header__arrows-list">
						<button class="block-header__arrow arrow_left" type="button">
							<svg><use xlink:href='#arrow-rounded-left-7x11' /></svg>
						</button>
						<button class="block-header__arrow arrow_right" type="button">
							<svg><use xlink:href='#arrow-rounded-right-7x11' /></svg>
						</button>
					</div>
				</div>
			{/if}
			<div id="newcarusel" class="tiny_products hoverable owl-carousel">
				{foreach $is_new_products as $product}
					<div class="product_wrap" style="display:none;">
						{include file='products_item.tpl'}
					</div>
				{/foreach}
			</div>
		{/if}
		{* new end *}
	{/if}

	{if $settings->mainsale && $carousel == 'mainsale'}
		{* discounted *}
		{* available sort (or remove): position, name, date, views, rating, rand *}
		{get_products var=discounted_products discounted=1 sort=rand limit=12}
		{if !empty($discounted_products)}
			<div class="mainproduct block-header discounted_carousel">
				<div class="block-header__title">Снижена цена</div>
				<div class="block-header__divider"></div>
				<div class="block-header__arrows-list">
					<button class="block-header__arrow arrow_left" type="button">
						<svg><use xlink:href='#arrow-rounded-left-7x11' /></svg>
					</button>
					<button class="block-header__arrow arrow_right" type="button">
						<svg><use xlink:href='#arrow-rounded-right-7x11' /></svg>
					</button>
				</div>
			</div>
			<div id="disccarusel" class="tiny_products hoverable owl-carousel">
				{foreach $discounted_products as $product}
					<div class="product_wrap" style="display:none;">
						{include file='products_item.tpl'}
					</div>
				{/foreach}
			</div>
		{/if}
		{* discounted end *}
	{/if}
{/foreach}

{if !empty($settings->widebannervis)}
	{$widebanner_img=$config->threebanners_images_dir|cat:$settings->widebanner_file|escape}
	<div class="box widebanner">
		<img {if !empty($settings->widebanner)}onClick="window.location='{$settings->widebanner}'" class="pointer"{/if} title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" src="{$widebanner_img}?{filemtime("{$widebanner_img}")}">
	</div>
{/if}

{if $settings->main_blog == 0}
	{get_posts var=last_posts limit=12}
	{if !empty($last_posts)}
	<div class="full_width">
		<div class="mainproduct hide block-header blog_carousel">
			<div class="block-header__title">Последние <a href="blog" title="новости" class="bloglink">новости</a></div>
			<div class="block-header__divider"></div>
			{if $last_posts|count > 4}
			<div class="block-header__arrows-list">
				<button class="block-header__arrow arrow_left" type="button">
					<svg><use xlink:href='#arrow-rounded-left-7x11' /></svg>
				</button>
				<button class="block-header__arrow arrow_right" type="button">
					<svg><use xlink:href='#arrow-rounded-right-7x11' /></svg>
				</button>
			</div>
			{/if}
		</div>
		<div id="blog_carousel">
			{include file='blogline_body.tpl'}
		</div>
	</div>
	{/if}
{/if}

{if $settings->bbanners == 1}
	<div class="marketing-boxes bottom-banners">
		<ul>
			{if $settings->bbannerfirstvis}<li><img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" {if $settings->bbannerfirst}onClick="window.location='{$settings->bbannerfirst}'" class="pointer"{/if} src="{$config->bbanner1img_file}?{filemtime("{$config->bbanner1img_file}")}" /></li>{/if}
			{if $settings->bbannersecondvis}<li><img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" {if $settings->bbannersecond}onClick="window.location='{$settings->bbannersecond}'" class="pointer"{/if} src="{$config->bbanner2img_file}?{filemtime("{$config->bbanner2img_file}")}" /></li>{/if}
			{if $settings->bbannerthirdvis}<li><img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" {if $settings->bbannerthird}onClick="window.location='{$settings->bbannerthird}'" class="pointer"{/if} src="{$config->bbanner3img_file}?{filemtime("{$config->bbanner3img_file}")}" /></li>{/if}
			{if $settings->bbannerfourvis}<li><img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" {if $settings->bbannerfour}onClick="window.location='{$settings->bbannerfour}'" class="pointer"{/if} src="{$config->bbanner4img_file}?{filemtime("{$config->bbanner4img_file}")}" /></li>{/if}
		</ul>
	</div>
{/if}

{if $settings->main_articles == 0}
	{get_articles var=last_articles sort=position limit=12}
	{if !empty($last_articles)}
	<div class="full_width">
		<div class="mainproduct hide block-header articles_carousel">
			<div class="block-header__title">Обзоры <a href="articles" title="Статьи" class="bloglink">и статьи</a></div>
			<div class="block-header__divider"></div>
			{if $last_articles|count > 4}
			<div class="block-header__arrows-list">
				<button class="block-header__arrow arrow_left" type="button">
					<svg><use xlink:href='#arrow-rounded-left-7x11' /></svg>
				</button>
				<button class="block-header__arrow arrow_right" type="button">
					<svg><use xlink:href='#arrow-rounded-right-7x11' /></svg>
				</button>
			</div>
			{/if}
		</div>
		<div id="articles_carousel">
			{include file='articlesline_body.tpl'}
		</div>
	</div>
	{/if}
{/if}

{if $page->body}
	<div class="box page_body">
		<section itemscope itemtype="http://schema.org/Article">
			<meta content="{$meta_title|escape}" itemprop="name" />
			<meta content="{$config->root_url}" itemprop="author" />
			<meta content="{$page->last_modify|date_format:'c'}" itemprop="datePublished" />
			<meta content="{$page->last_modify|date_format:'c'}" itemprop="dateModified" />
			<meta content="{$meta_title|escape}" itemprop="headline" />
			{$seo_description = $meta_title|cat:$settings->seo_description|cat:" ✩ "|cat:$settings->site_name|cat:" ✩"}
			<meta content="{if !empty($meta_description)}{$meta_description|escape}{elseif !empty($seo_description)}{$seo_description|escape}{/if}" itemprop="description" />
			<meta content="" itemscope itemprop="mainEntityOfPage" itemType="https://schema.org/WebPage" itemid="{$config->root_url}" /> 
			<div style="display:none;" itemprop="publisher" itemscope itemtype="https://schema.org/Organization">
			    <div itemprop="logo" itemscope itemtype="https://schema.org/ImageObject">
			        <img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" itemprop="url" src="{$config->root_url}/files/logo/logo.png" />
					<meta itemprop="image" content="{$config->root_url}/files/logo/logo.png" />
			    </div>
				<meta itemprop="name" content="{$config->root_url}" />
				<meta itemprop="address" content="{$config->root_url}" />
				<meta itemprop="telephone" content="{$settings->phone|escape}" />
			</div>
			<div class="main-text" itemprop="articleBody">
				<h1 data-page="{$page->id}">{$page->header|escape}</h1>
				{$page->body}
				<div style="display:none;" itemprop="image" itemscope itemtype="https://schema.org/ImageObject">
					{$img_url=$config->root_url|cat:'/files/logo/logo.png'}
					<img itemprop="url contentUrl" src="{$img_url}" title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}"/>
					<meta itemprop="image" content="{$img_url}" />
					{assign var="info" value=$img_url|getimagesize}
					<meta itemprop="width" content="{$info.0}" />
					<meta itemprop="height" content="{$info.1}" />
				</div>
			</div>
		</section>
	</div>
{/if}

