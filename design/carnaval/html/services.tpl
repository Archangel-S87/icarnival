{if !empty($category->url)}
	{$canonical="/services/{$category->url}{if !empty($current_page_num) && $current_page_num>1}?page={$current_page_num}{/if}" scope=root}
{elseif !empty($keyword)}
	{$canonical="/services?keyword={$keyword|escape}" scope=root}
{else}
	{$canonical="/services{if !empty($current_page_num) && $current_page_num>1}?page={$current_page_num}{/if}" scope=root}
{/if}

{if !empty($keyword)}
	{$meta_title = $keyword scope=root}
	{$meta_description = $keyword scope=root}
	{$meta_keywords = $keyword scope=root}
	<h1>Результаты поиска по: "{$keyword}"</h1>
	{if $serviceskey}
		<ul class="relcontent tiny_products parentscat" style="margin-bottom: 0px !important;">
			{foreach $serviceskey as $key}
					<li class="product" onClick="window.location='/services/{$key->url}'" style="cursor:pointer;">
						<div class="image">
							{if $key->image}
								<img src="{$config->services_categories_images_dir}{$key->image}" alt="{$key->menu}" title="{$key->menu}" />
							{else}
								<svg class="nophoto"><use xlink:href='#folder' /></svg>
							{/if}
						</div>
						<div class="product_info">
							<h3 class="product_title"><a href="services/{$key->url}" title="{$key->menu}">{$key->menu}</a></h3>
						</div>
					</li>
			{/foreach}
		</ul>
	{else}
		<div class="page-pg">
			Услуг не найдено
		</div>
	{/if}
{else}
	{* Заголовок страницы *}
	{if $page}
		{$meta_title = $page->meta_title|escape scope=root}
		{$meta_description = $page->meta_description|escape scope=root}
		{$meta_keywords = $page->meta_keywords|escape scope=root}
		<h1 data-page="{$page->id}">{$page->name|escape}</h1>
	{elseif $category->name}
		<h1 data-servicescategory="{$category->id}">{$category->name|escape}</h1>
	{else}
		<h1>Услуги</h1>
		{$meta_title = "Услуги" scope=root}
		{$meta_description = "Услуги" scope=root}
		{$meta_keywords = "Услуги" scope=root}
		{$nopage = 1}
	{/if}

	{* subcat start *}
	{if (isset($page->url) && $page->url == 'services') || (isset($nopage) && $nopage == 1)}
		{function name=services_categories_tree2 level=1}
			{if !empty($services_categories)}
				<ul class="relcontent tiny_products parentscat" style="margin-bottom: 0px !important;">
					{foreach $services_categories as $ac2}
						{if $ac2->visible}
							<li class="product" onClick="window.location='/services/{$ac2->url}'" style="cursor:pointer;">
								<div class="image">
									{if !empty($ac2->image)}
										<img src="{$config->services_categories_images_dir}{$ac2->image}" alt="{$ac2->name}" title="{$ac2->name}" />
									{else}
										<svg class="nophoto"><use xlink:href='#folder' /></svg>
									{/if}
								</div>
								<div class="product_info">
										<h3 class="product_title"><a data-servicescategory="{$ac2->id}" href="services/{$ac2->url}" title="{$ac2->name}">{$ac2->menu}</a></h3>
								</div>
							</li>
						{/if}
					{/foreach}
				</ul>
			{/if}
		{/function}
		{services_categories_tree2 services_categories=$services_categories}
	{elseif !empty($category->subcategories)}
		<ul class="relcontent tiny_products parentscat" style="margin-bottom: 0px !important;">
			{foreach name=cats from=$category->subcategories item=c}
				{if $c->visible}
					<li class="product" onClick="window.location='/services/{$c->url}'" style="cursor:pointer;">
						<div class="image">
							{if !empty($c->image)}
								<img src="{$config->services_categories_images_dir}{$c->image}" alt="{$c->name}" title="{$c->name}" />
							{else}
								<svg class="nophoto"><use xlink:href='#folder' /></svg>
							{/if}
						</div>
						<div class="product_info">
							<h3 class="product_title"><a data-servicescategory="{$c->id}" href="services/{$c->url}" title="{$c->name}">{$c->menu}</a></h3>
						</div>
					</li>
				{/if}
			{/foreach}
		</ul>
	{/if}
	{* subcat end *}

	{if !empty($category->description) || !empty($page->body)}
		<div {if !empty($service->images)}class="postcontent"{/if} itemscope itemtype="http://schema.org/Article">
				<meta content="{$meta_title|escape}" itemprop="name">
				<meta content="{$config->root_url}" itemprop="author" />
				{if isset($category->last_modify)}
				<meta content="{$category->last_modify|date_format:'c'}" itemprop="datePublished" />
				<meta content="{$category->last_modify|date_format:'c'}" itemprop="dateModified" />
				{/if}
				<meta content="{$meta_title|escape}" itemprop="headline" />
				{$seo_description = $meta_title|cat:$settings->seo_description|cat:" ✩ "|cat:$settings->site_name|cat:" ✩"}
				<meta content="{if !empty($meta_description)}{$meta_description|escape}{elseif !empty($seo_description)}{$seo_description|escape}{/if}" itemprop="description" />
				<meta content="" itemscope itemprop="mainEntityOfPage" itemType="https://schema.org/WebPage" itemid="{$config->root_url}/services{if !empty($category->url)}/{$category->url}{/if}" /> 
			
				<div style="display:none;" itemprop="publisher" itemscope itemtype="https://schema.org/Organization">
					<div itemprop="logo" itemscope itemtype="https://schema.org/ImageObject">
						<img itemprop="url" src="{$config->root_url}/files/logo/logo.png" alt="{$settings->company_name|escape}" />
						<meta itemprop="image" content="{$config->root_url}/files/logo/logo.png" />
					</div>
					<meta itemprop="name" content="{$settings->company_name|escape}" />
					<meta itemprop="address" content="{$config->root_url}" />
					<meta itemprop="telephone" content="{$settings->phone|escape}" />
				</div>

				<div class="page-pg" itemprop="articleBody" role="article">
					{if !empty($page->body)}
						{$page->body}
					{elseif !empty($category->description)}
						{$category->description}
					{/if}
					<div style="display:none;" itemprop="image" itemscope itemtype="https://schema.org/ImageObject">
						{if !empty($service->images[1])}
							<img itemprop="url contentUrl" src="{$service->images[1]->filename|resize:1024:768:w:$config->resized_services_images_dir}" alt="{$meta_title|escape}"/>
							<meta itemprop="image" content="{$service->images[1]->filename|resize:1024:768:w:$config->resized_services_images_dir}" />
							<meta itemprop="width" content="100%" />
							<meta itemprop="height" content="100%" />
						{elseif !empty($category->image)}
							<img itemprop="url contentUrl" src="{$config->services_categories_images_dir}{$category->image}" alt="{$meta_title|escape}"/>
							<meta itemprop="image" content="{$config->services_categories_images_dir}{$category->image}" />
							<meta itemprop="width" content="100%" />
							<meta itemprop="height" content="100%" />
						{else}
							<img itemprop="url" src="{$config->root_url}/files/logo/logo.png" alt="{$meta_title|escape}"/>
							<meta itemprop="image" content="{$config->root_url}/files/logo/logo.png" />
							<meta itemprop="width" content="100%" />
							<meta itemprop="height" content="100%" />
						{/if}
					</div>
				</div>
		</div>
	{/if}

	{if !empty($service->images)}
		<ul id="gallerypic" class="tiny_products">
			{foreach $service->images as $i=>$image}
					<li class="product">
						<div class="image">
							<a rel="nofollow" data-rel="gallery" href="{$image->filename|resize:1024:768:w:$config->resized_services_images_dir}" class="zoom" title="{$category->name|escape}">
								<img src="{$image->filename|resize:400:400:false:$config->resized_services_images_dir}" alt="{$category->name|escape}" />
							</a>
						</div>
					</li>
			{/foreach}
		</ul>
	{/if}
	<!--noindex-->
	{$settings->advertservice}
	<!--/noindex-->

{/if}
