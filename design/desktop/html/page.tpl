{* Канонический адрес страницы *}
{$canonical="/{$page->url}" scope=root}

<h1 data-page="{$page->id}">{if !empty($h1_title)}{$h1_title|escape}{else}{$page->header|escape}{/if}</h1>

<div itemscope itemtype="http://schema.org/Article">
	<meta content="{$meta_title|escape}" itemprop="name">
	<meta content="{$config->root_url}" itemprop="author" />
	<meta content="{$page->last_modify|date_format:'c'}" itemprop="datePublished" />
	<meta content="{$page->last_modify|date_format:'c'}" itemprop="dateModified" />
	<meta content="{$meta_title|escape}" itemprop="headline" />
	{$seo_description = $meta_title|cat:$settings->seo_description|cat:" ✩ "|cat:$settings->site_name|cat:" ✩"}
	<meta content="{if !empty($meta_description)}{$meta_description|escape}{elseif !empty($seo_description)}{$seo_description|escape}{/if}" itemprop="description" />
	<meta content="" itemscope itemprop="mainEntityOfPage" itemType="https://schema.org/WebPage" itemid="{$config->root_url}/{$page->url}" /> 
	<div style="display:none;" itemprop="image" itemscope itemtype="https://schema.org/ImageObject">
		{$img_url=$config->root_url|cat:'/files/logo/logo.png'}
		<img itemprop="url contentUrl" src="{$img_url}" alt="{$meta_title|escape}" title="{$meta_title|escape}"/>
		<meta itemprop="image" content="{$img_url}" />
		{assign var="info" value=$img_url|getimagesize}
		<meta itemprop="width" content="{$info.0}" />
		<meta itemprop="height" content="{$info.1}" />
	</div>
	<div style="display:none;" itemprop="publisher" itemscope itemtype="https://schema.org/Organization">
		<div itemprop="logo" itemscope itemtype="https://schema.org/ImageObject">
			<img itemprop="url" src="{$config->root_url}/files/logo/logo.png" alt="{$settings->company_name|escape}" title="{$settings->company_name|escape}" />
			<meta itemprop="image" content="{$config->root_url}/files/logo/logo.png" />
		</div>
		<meta itemprop="name" content="{$settings->company_name|escape}" />
		<meta itemprop="address" content="{$config->root_url}" />
		<meta itemprop="telephone" content="{$settings->phone|escape}" />
	</div>

	{if $page->url == 'reviews-archive'}
		{* Страница "Все отзывы" *}
		<div class="response_archive" itemprop="articleBody">
			<ul role="navigation" class="comment_list">
			{$comments_num = 0}
			
			{get_comments var=last_comments1 type='product'}
			{if !empty($last_comments1)}
				{foreach $last_comments1 as $comment}
					<li>
						<p><b>{$comment->name}</b> о товаре <a href="products/{$comment->url}">{$comment->product}</a>:
						&laquo;{$comment->text|escape|nl2br}&raquo;</p>
						{if $comment->otvet}
							<div class="comment_admint">Администрация:</div>
							<div class="comment_admin" style="margin-bottom: 12px;">
								{$comment->otvet}
							</div>
						{/if}
					</li>
					{$comments_num = $comments_num + 1}
				{/foreach}
	        {/if}

			{get_comments var=last_comments2 type='blog'}
			{if !empty($last_comments2)}
				{foreach $last_comments2 as $comment}
					<li>
						<p><b>{$comment->name}</b> о записи <a href="blog/{$comment->url}">{$comment->product}</a>:
						&laquo;{$comment->text|escape|nl2br}&raquo;</p>
						{if $comment->otvet}
							<div class="comment_admint">Администрация:</div>
							<div class="comment_admin" style="margin-bottom: 12px;">
								{$comment->otvet}
							</div>
						{/if}
					</li>
					{$comments_num = $comments_num + 1}
				{/foreach}
	        {/if}
			</ul>
			{$comments_on_page = 5}
			{if $comments_num > $comments_on_page}	
				<script type="text/javascript" src="js/pagination/pagination.js"></script>
				<script>var show_per_page = {$comments_on_page};</script> 
				<input type='hidden' id='current_page' />
				<input type='hidden' id='show_per_page' />	
				<div id="page_navigation" class="pagination"></div>
			{/if}
		</div>
	{elseif $page->url == 'm-info'}
		{* Страница "Информация" *}
		<div class="page-pg" itemprop="articleBody">
			{if !empty($page->body)}
				{$page->body}
			{/if}
			{get_pages var="pag" menu_id=17}
			{if $pag}
				<ul>
					{foreach $pag as $p}
						<li {if $page && $page->id == $p->id}class="selected"{/if}>
							<a class="bluelink" data-page="{$p->id}" href="{$p->url}" title="{$p->name|escape}">{$p->name|escape}</a>
						</li>
					{/foreach}
				</ul>
			{/if}
		</div>
		<!--noindex-->
		{$settings->advertpage}
		<!--/noindex-->
	{elseif $page->url == 'catalog' || $page->url == '404'}
		{* Страница "Разделы" или 404 *}
		{if !empty($page->body)}
		<div class="page-pg" itemprop="articleBody">
			{$page->body}
		</div>
		{/if}
		
		{if (empty($settings->purpose) || $page->url == 'catalog') && !empty($categories)}
			{function name=categories_treecat}
				<ul class="relcontent tiny_products parentscat">
					{foreach $categories as $c}
						{if $c->visible}
							<li class="product" style="cursor:pointer;" onClick="window.location='/catalog/{$c->url}'">
								<div class="image">										
									{if $c->image}
										<img alt="{$c->name|escape}" title="{$c->name|escape}" src="{$config->categories_images_dir}{$c->image}" />
									{else}
										<svg class="nophoto"><use xlink:href='#folder' /></svg>
									{/if}
								</div>
								<div class="product_info">
									<h3 class="product_title" data-category="{$c->id}">{if !empty($c->menu)}{$c->menu|escape}{else}{$c->name|escape}{/if}</h3>
								</div>
							</li>
						{/if}
					{/foreach}
				</ul>
			{/function}
			{categories_treecat categories=$categories}
		{elseif !empty($settings->purpose) && !empty($services_categories)}
			{function name=services_categories_tree2 level=1}
				<ul class="relcontent tiny_products parentscat" style="margin-bottom: 20px !important;">
					{foreach $services_categories as $ac2}
						{if $ac2->visible}
							<li class="product" onClick="window.location='/services/{$ac2->url}'" style="cursor:pointer;">
								<div class="image">
									{if $ac2->image}
										<img src="{$config->services_categories_images_dir}{$ac2->image}" alt="{$ac2->name}" title="{$ac2->name}" />
									{else}
										<svg class="nophoto"><use xlink:href='#folder' /></svg>
									{/if}
								</div>
								<div class="product_info">
									<h3 class="product_title" data-servicescategory="{$ac2->id}">{$ac2->menu}</h3>
								</div>
							</li>
						{/if}
					{/foreach}
				</ul>
			{/function}
			{services_categories_tree2 services_categories=$services_categories}
			{if !empty($settings->widebannervis)}
				{$widebanner_img=$config->threebanners_images_dir|cat:$settings->widebanner_file|escape}
				<div class="box widebanner">
					<img {if !empty($settings->widebanner)}onClick="window.location='{$settings->widebanner}'" class="pointer"{/if} alt="{$meta_title|escape}" title="{$meta_title|escape}" src="{$widebanner_img}?{filemtime("{$widebanner_img}")}">
				</div>
			{/if}
		{/if}

	{elseif $page->url == 'brands'}
		{* Страница брендов *}
		{if !empty($page->body)}
			<div class="page-pg" itemprop="articleBody">
				{$page->body}
			</div>
		{/if}
		<div class="brand-pg" itemprop="articleBody">
            {get_brands var=all_brands}
            {if $all_brands}
                <ul class="relcontent tiny_products parentscat brands_list">
					{foreach name=brands item=b from=$all_brands}
						<li class="product" style="cursor:pointer;" onClick="window.location='/brands/{$b->url}'">
							<div class="image">
								{if $b->image}
									<img alt="{$b->name}" title="{$b->name}" src="{$config->brands_images_dir}{$b->image}" />
								{else}
									<div class="nophoto">{$b->name}</div>
								{/if}
							</div>
							<div class="product_info">
								<h3 class="product_title" data-brand="{$b->id}">{$b->name}</h3>
							</div>
						</li>
					{/foreach}
                </ul>
            {/if}
		</div>
	{else}
		{* Обычная страница *}
		<div class="page-pg" itemprop="articleBody">
			{if !empty($metadata_page->description)}{$metadata_page->description}{elseif !empty($page->body)}{$page->body}{/if}
		</div>
		<!--noindex-->
		{$settings->advertpage}
		<!--/noindex-->
	{/if}

	{* Карусели *}
	{if $page->url == 'catalog' || ($page->url == '404' && $settings->purpose == 0)}
		<script async src="design/{$settings->theme|escape}/js/slick191.min.js"></script>
		{* Лидеры продаж *}
		{* available sort (or remove): position, name, date, rating, rand *}
		{get_products var=featured_products featured=1 sort=rand limit=12}
		{if !empty($featured_products)}
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
			<div id="hitcarusel" class="tiny_products hoverable owl-carousel">
				{foreach $featured_products as $product}
					<div class="product_wrap" style="display:none;">
						{include file='products_item.tpl'}
					</div>
				{/foreach}
			</div>
		
			{literal}
			<script>
			$(window).load(function() {
				$('#hitcarusel').slick({
				  arrows:false,
				  dots: false,
				  infinite: true,
				  speed: 900,
				  slidesToShow: 4,
				  slidesToScroll: 1,
				  autoplay: true,
				  autoplaySpeed: 4000,
				  draggable: false,
				  //touchThreshold: 40,
				  responsive: [
				    {
				      breakpoint: 1331,
				      settings: {
				        slidesToShow: 3,
				        slidesToScroll: 1
				      }
				    }
				  ]
				});
				$('.hits_carousel .arrow_left').on('click',function(){ $('#hitcarusel').slick('slickPrev') });
				$('.hits_carousel .arrow_right').on('click',function(){ $('#hitcarusel').slick('slickNext') });
			});
			</script>
			{/literal}
		{/if}
		{* Лидеры продаж @ *}
		
		{if !empty($settings->widebannervis)}
			{$widebanner_img=$config->threebanners_images_dir|cat:$settings->widebanner_file|escape}
			<div class="box widebanner">
				<img {if !empty($settings->widebanner)}onClick="window.location='{$settings->widebanner}'" class="pointer"{/if} alt="{$meta_title|escape}" title="{$meta_title|escape}" src="{$widebanner_img}?{filemtime("{$widebanner_img}")}">
			</div>
		{/if}
		
		{* Новинки *}
		{* available sort (or remove): position, name, date, rating, rand *}
		{get_products var=is_new_products is_new=1 sort=rand limit=12}
		{if !empty($is_new_products)}
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
			<div id="newcarusel" class="tiny_products hoverable owl-carousel">
				{foreach $is_new_products as $product}
					<div class="product_wrap" style="display:none;">
						{include file='products_item.tpl'}
					</div>
				{/foreach}
			</div>

			{literal}
			<script>
			$(window).load(function() {
				$('#newcarusel').slick({
				  arrows:false,
				  dots: false,
				  infinite: true,
				  speed: 900,
				  slidesToShow: 4,
				  slidesToScroll: 1,
				  autoplay: true,
				  autoplaySpeed: 4000,
				  draggable: false,
				  //touchThreshold: 40,
				  responsive: [
				    {
				      breakpoint: 1331,
				      settings: {
				        slidesToShow: 3,
				        slidesToScroll: 1
				      }
				    }
				  ]
				});
				$('.new_carousel .arrow_left').on('click',function(){ $('#newcarusel').slick('slickPrev') });
				$('.new_carousel .arrow_right').on('click',function(){ $('#newcarusel').slick('slickNext') });
			});
			</script>
			{/literal}
		{/if}
		{* Новинки @ *}
	{/if}
	{* Карусели @ *}

</div>

