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

	{if $serviceskey}
		<ul class="category_products separator">
			{foreach $serviceskey as $key}
					<li class="product" onClick="window.location='services/{$key->url}'" style="cursor:pointer;">
						<div class="image">
							{if $key->image}
								<img src="{$config->services_categories_images_dir}{$key->image}" alt="{$key->menu}" title="{$key->menu}" />
							{else}
								<svg class="nophoto"><use xlink:href='#folder' /></svg>
							{/if}
						</div>
						<div class="product_info">
							<h3>{$key->menu}</h3>
						</div>
					</li>
			{/foreach}
		</ul>
	{else}
		<div class="blog-pg">
			Услуг не найдено
		</div>
	{/if}
{else}
	{if $page}
		{$meta_title = $page->meta_title|escape scope=root}
		{$meta_description = $page->meta_description|escape scope=root}
		{$meta_keywords = $page->meta_keywords|escape scope=root}
	{/if}

	{if $page && $page->url == 'services'}
		{* subcat start *}
			{function name=services_categories_tree2 level=1}
				{if $services_categories}
					<ul class="category_products separator">
						{foreach $services_categories as $ac2}
							{if $ac2->visible}
								<li class="product" onClick="window.location='services/{$ac2->url}'">
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
			{services_categories_tree2 services_categories=$services_categories}
		{* subcat end *}
	{/if}	

	{if !empty($category->subcategories)}
			<ul class="category_products separator">
				{foreach name=cats from=$category->subcategories item=c}
					{if $c->visible}
						<li class="product" onClick="window.location='services/{$c->url}'">
							<div class="image">
							{if $c->image}
								<img alt="{$c->menu|escape}" title="{$c->menu|escape}" src="{$config->services_categories_images_dir}{$c->image}" />
							{else}
								<svg class="nophoto"><use xlink:href='#no_photo' /></svg>
							{/if}
							</div>
							<div class="product_info">
								<h3>{$c->menu|escape}</h3>
							</div>
						</li>
					{/if}
				{/foreach}
			</ul>
	{/if}

	{if !empty($page->body) || !empty($category->description)}
			<div class="blog-pg">	
				{if !empty($page->body)}{$page->body}{/if}
				{if !empty($category->description)}{$category->description}{/if}
			</div>
	{/if}

	{if !empty($service->images)}
		<ul id="gallerypic" class="tiny_products">	
			{foreach $service->images as $i=>$image}
				<li class="product"><div class="image">
				<a rel="gallery" href="{$image->filename|resize:800:600:w:$config->resized_services_images_dir}" class="swipebox" title="{$category->name|escape}">
				<img alt="{$category->name|escape}" title="{$category->name|escape}" src="{$image->filename|resize:400:400:false:$config->resized_services_images_dir}" /></a></div>
				</li>
			{/foreach}
		</ul>
	{/if}

{/if}
