<!DOCTYPE html>
<html dir="ltr" prefix="og: http://ogp.me/ns#" lang="ru">
<head>
	<base href="{$config->root_url}/"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	{if $settings->font == 1}
		{*<link href="https://fonts.googleapis.com/css?family=PT+Sans:400,700&display=swap&subset=cyrillic" rel="stylesheet">*}
		<style>
		@font-face {
		  font-family: 'PT Sans';
		  font-style: normal;
		  font-display: swap;
		  font-weight: 400;
		  src: local('PT Sans'), local('PTSans-Regular'),
			   url('fonts/pt-sans-v11-latin_cyrillic-regular.woff2') format('woff2'), 
			   url('fonts/pt-sans-v11-latin_cyrillic-regular.woff') format('woff');
		}
		@font-face {
		  font-family: 'PT Sans';
		  font-style: normal;
		  font-display: swap;
		  font-weight: 700;
		  src: local('PT Sans Bold'), local('PTSans-Bold'),
			   url('fonts/pt-sans-v11-latin_cyrillic-700.woff2') format('woff2'), 
			   url('fonts/pt-sans-v11-latin_cyrillic-700.woff') format('woff');
		}
		</style>
	{elseif $settings->font == 2}
		<link href="https://fonts.googleapis.com/css?family=Roboto+Condensed:400,700&display=swap&subset=cyrillic" rel="stylesheet">
	{elseif $settings->font == 3}
		<link href="https://fonts.googleapis.com/css?family=Fira+Sans:400,700&display=swap&subset=cyrillic" rel="stylesheet">
	{/if}
	<style>
		.topmm a, ul.super-menu > li > a, .box-heading, #content > h1, .mainproduct, .h2, .heading, .button, .product h3, .buttonred, .various, .feature_name, .buttonblue, .post_title, .comm-title, .feedb-title, ul.tabs li a, #last_products a, .comment_list h3, .mpriceslider .pr-cost, .brand_name, .socialauth, .advertblue, .advertwhite, .advertred, .font { font-family:{if $settings->font == 1}'PT Sans',{elseif $settings->font == 3}'Fira Sans',{elseif $settings->font == 2}'Roboto Condensed',{/if}'PT Sans', Arial Narrow,sans-serif,Arial; }
		{if $settings->font == 2}
			#column-left .box .box-heading { font-size:18px !important; }
			.tiny_products .product h3, #footer .column a { font-size:15px !important; }
		{/if}
	
		.comment_list li ul li, .blog_annotation li, ul.stars li, #annot ul li, .description ul li, #tab1 ul li, .annotation ul li, .box .main-text ul li, #content .post-pg ul li, #content .page-pg ul li{ background:url("js/bullets/{$settings->bullet}.png") 0px 4px no-repeat transparent; }
	</style>
	<!--[if lte IE 9]><style>#container select{ padding:0; }</style><![endif]-->
	{if $module == "ProductView"}
		{* product seo title *}
			{if !empty($category->name)}{$ctg = " | "|cat:$category->name}{else}{$ctg = ''}{/if}
			{if !empty($brand->name)}{$brnd = " | "|cat:$brand->name}{else}{$brnd = ''}{/if}
			{if empty($meta_title) && !empty($product->name)}
				{$seo_title=$product->name|cat:$ctg|cat:$brnd}
			{/if}
		{* product seo description *}
			{$first_category = $category->path|first}
			{if !empty($category->seo_one)}
				{$seo_one = $category->seo_one}
			{elseif !empty($first_category->seo_one)}
				{$seo_one = $first_category->seo_one}
			{else}
				{$seo_one = ''}
			{/if}
			{if !empty($category->seo_two)}
				{$seo_two = $category->seo_two}
			{elseif !empty($first_category->seo_two)}
				{$seo_two = $first_category->seo_two}
			{else}
				{$seo_two = ''}
			{/if}
			{if $category->seo_type == 1 && !empty($product->variant->price)}
				{$seo_description = $seo_one|cat:$product->name|cat:" ✩ за "|cat:($product->variant->price|convert|strip:'')|cat:" "|cat:$currency->sign|cat:$seo_two}
			{else}
				{$seo_description = $seo_one|cat:$product->name|cat:$seo_two}
			{/if}
	{else}
		{* page seo description *}
		{if !empty($meta_title)}
			{$seo_description = $meta_title|cat:$settings->seo_description|cat:" ✩ "|cat:$settings->site_name|cat:" ✩"}
		{elseif !empty($page->header)}
			{$seo_description = $page->header|cat:$settings->seo_description|cat:" ✩ "|cat:$settings->site_name|cat:" ✩"}
		{/if}
	{/if}
	<title>{if !empty($meta_title)}{$meta_title|escape}{elseif !empty($seo_title)}{$seo_title|escape}{/if}{if !empty($current_page_num) && $current_page_num>1} - страница {$current_page_num}{/if}</title>    
	<meta name="description" content="{if !empty($meta_description)}{$meta_description|escape}{elseif !empty($seo_description)}{$seo_description|escape}{/if}" />
	<meta name="keywords" content="{if !empty($meta_keywords)}{$meta_keywords|escape}{/if}" /> 

	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=2, user-scalable=yes"/>
	<meta name="format-detection" content="telephone=no"/>
	<meta name="cmsmagazine" content="f271dbff9975bb1f1df832d2046657db" />
	
	<link rel="stylesheet" type="text/css" href="design/{$settings->theme|escape}/css/style.css?v={filemtime("design/{$settings->theme|escape}/css/style.css")}"/>
	<script src="js/jquery/jquery-1.12.4.min.js"></script>
	<link rel="stylesheet" type="text/css" href="design/{$settings->theme|escape}/css/{$settings->colortheme|escape}.css?v={filemtime("design/{$settings->theme|escape}/css/{$settings->colortheme|escape}.css")}"/>
	<link rel="stylesheet" type="text/css" href="design/{$settings->theme|escape}/plugins/fancybox3/jquery.fancybox.css?v={filemtime("design/{$settings->theme|escape}/plugins/fancybox3/jquery.fancybox.css")}"/>
	<!--canonical-->{if isset($canonical)}<link rel="canonical" href="{$config->root_url}{$canonical}"/>{/if}<!--/canonical-->
	{if !empty($current_page_num) && $current_page_num==2}<link rel="prev" href="{$config->root_url}{url page=null}">{/if}
	{if !empty($current_page_num) && $current_page_num>2}<link rel="prev" href="{$config->root_url}{url page=$current_page_num-1}">{/if}
	{if !empty($current_page_num) && $current_page_num<$total_pages_num}<link rel="next" href="{$config->root_url}{url page=$current_page_num+1}">{/if}
	{if !empty($current_page_num) && $current_page_num > 1}<meta name=robots content="index,follow">{/if}
	
	<link href="favicon.ico" rel="icon" type="image/x-icon"/>
	<link href="favicon.ico" rel="shortcut icon" type="image/x-icon"/>

	{if $module == 'ProductView'}
		<meta name="twitter:url"  property="og:url" content="{$config->root_url}{$smarty.server.REQUEST_URI}">
		<meta property="og:type" content="website">
		<meta name="twitter:card" content="product"/>
		<meta name="twitter:title" property="og:title" content="{$product->name|escape}">
		<meta name="twitter:description" property="og:description" content='{if !empty($product->annotation)}{$product->annotation|strip_tags|escape}{elseif !empty($meta_description)}{$meta_description|escape}{/if}'>
		{if !empty($product->image->filename)}
			<meta name="twitter:image" property="og:image" content="{$product->image->filename|resize:800:600:w}">
			<link rel="image_src" href="{$product->image->filename|resize:800:600:w}">
		{else}
			<meta name="twitter:image" property="og:image" content="{$config->root_url}/js/nophoto.png">
			<link rel="image_src" href="{$config->root_url}/js/nophoto.png">
		{/if}
		{if !empty($settings->site_name)}
			<meta name="twitter:site" content="{$settings->site_name|escape}">
		{/if}
		{if !empty($product->variant->price)}
			<meta name="twitter:data1" content="Цена">
			<meta name="twitter:label1" content="{$product->variant->price|convert} {$currency->code|escape}">
		{/if}
		{if !empty($settings->company_name)}
			<meta name="twitter:data2" content="Организация">
			<meta name="twitter:label2" content="{$settings->company_name|escape}">
		{/if}
	{elseif in_array($module, array('BlogView', 'ArticlesView', 'SurveysView'))}
		<meta property="og:url" content="{$config->root_url}{$smarty.server.REQUEST_URI}">
		<meta property="og:type" content="article">
		<meta name="twitter:card" content="summary">
		<meta name="twitter:title" property="og:title" content="{$meta_title|escape}">
		{if !empty($post->image)}
			<meta name="twitter:image" property="og:image" content="{$post->image->filename|resize:400:400}">
			<link rel="image_src" href="{$post->image->filename|resize:400:400}">
		{elseif !empty($post->images[1])}
			<meta name="twitter:image" property="og:image" content="{$post->images[1]->filename|resize:800:600:w}">
			<link rel="image_src" href="{$post->images[1]->filename|resize:800:600:w}">	
		{else}
			<meta name="twitter:image" property="og:image" content="{$config->root_url}/files/logo/logo.png">
			<link rel="image_src" href="{$config->root_url}/files/logo/logo.png">
		{/if}
		<meta name="twitter:description" property="og:description" content="{if !empty($post->annotation)}{$post->annotation|strip_tags|escape}{elseif !empty($meta_description)}{$meta_description|escape}{/if}">
	{else}
		<meta name="twitter:title" property="og:title" content="{$meta_title|escape}">
		<meta property="og:type" content="website">
		<meta name="twitter:card" content="summary">
		<meta property="og:url" content="{$config->root_url}{$smarty.server.REQUEST_URI}">
		<meta name="twitter:image" property="og:image" content="{$config->root_url}/files/logo/logo.png">
		<link rel="image_src" href="{$config->root_url}/files/logo/logo.png">
		<meta property="og:site_name" content="{$settings->site_name|escape}">
		{if !empty($meta_description)}<meta name="twitter:description" property="og:description" content="{$meta_description|escape}">{/if}
	{/if}
	{if !empty($settings->script_header)}{$settings->script_header}{/if}
</head>

<body {if $module}class="{$module|lower}"{/if}>  																																																																																																																																																																																																																	
	{* header *}
	<header>
		<div class="top-hdr">
			<div class="tophm" role="toolbar">
				{get_pages var="menu_top" menu_id="1"}
				{if $menu_top}
					<ul class="topmm super-menu2">
						{foreach $menu_top as $p}
							<li {if $page && $page->id == $p->id}class="selected"{/if}>
								<a data-page="{$p->id}" href="{$p->url}" title="{$p->name|escape}">{$p->name|escape}</a>
							</li>
						{/foreach}
					</ul>
				{/if}	
				<div id="welcome">
					{if $user}
						<span class="username" onclick="window.location='/user'">Кабинет</span> 
						<span class="hline">|</span>
						<span class="username" onclick="window.location='/user/logout'">Выйти</span> 
					{else}
						<span class="username" onclick="window.location='/user/login'">Вход</span>
						<span class="hline">|</span> 
						<span class="username" onclick="window.location='/user/register'">Регистрация</span>
					{/if}
				</div>
			</div>
		 </div>
		 <div id="adapt-hdr">
			<div id="logo" role="banner">
				<img onclick="window.location='{$config->root_url}/'" src="files/logo/logo.png?v={filemtime('files/logo/logo.png')}" title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" />
			</div>
			<div id="workingtime">
				<div class="divider">
					<svg x="0px" y="0px" width="48px" height="48px" viewBox="0 0 24 24" enable-background="new 0 0 24 24" xml:space="preserve">
					<g id="Bounding_Boxes">
						<g id="ui_x5F_spec_x5F_header_copy">
						</g>
						<path fill="none" d="M0,0h24v24H0V0z"/>
					</g>
					<g id="Duotone">
						<g id="ui_x5F_spec_x5F_header_copy_1">
						</g>
						<g>
							<path opacity="0.3" d="M12,4c-4.42,0-8,3.58-8,8c0,4.42,3.58,8,8,8s8-3.58,8-8C20,7.58,16.42,4,12,4z M16.25,16.15L11,13V7h1.5
								v5.25l4.5,2.67L16.25,16.15z"/>
							<path d="M11.99,2C6.47,2,2,6.48,2,12c0,5.52,4.47,10,9.99,10C17.52,22,22,17.52,22,12C22,6.48,17.52,2,11.99,2z M12,20
								c-4.42,0-8-3.58-8-8c0-4.42,3.58-8,8-8s8,3.58,8,8C20,16.42,16.42,20,12,20z"/>
							<polygon points="12.5,7 11,7 11,13 16.25,16.15 17,14.92 12.5,12.25 		"/>
						</g>
					</g>
					</svg>
					<div class="first-level font">Режим работы:</div>
					<div class="second-level font">{$settings->worktime|escape}</div>
				</div>
			</div> 
			<div id="top_phone">
				<div class="divider {if $settings->phone && $settings->tel}twophone{else}onephone{/if}">
					<svg x="0px" y="0px" width="48px" height="48px" viewBox="0 0 24 24" enable-background="new 0 0 24 24" xml:space="preserve">
					<g id="Bounding_Boxes2">
						<g id="ui_x5F_spec_x5F_header_copy_2">
						</g>
						<path fill="none" d="M0,0h24v24H0V0z"/>
					</g>
					<g id="Duotone2">
						<g id="ui_x5F_spec_x5F_header_copy_22">
						</g>
						<g>
							<path opacity="0.3" d="M6.54,5h-1.5c0.09,1.32,0.34,2.58,0.75,3.79l1.2-1.21C6.75,6.75,6.6,5.88,6.54,5z"/>
							<path opacity="0.3" d="M15.2,18.21c1.21,0.41,2.48,0.67,3.8,0.76v-1.5c-0.88-0.07-1.75-0.22-2.6-0.45L15.2,18.21z"/>
							<g>
								<path d="M15,12h2c0-2.76-2.24-5-5-5v2C13.66,9,15,10.34,15,12z"/>
								<path d="M19,12h2c0-4.97-4.03-9-9-9v2C15.87,5,19,8.13,19,12z"/>
								<path d="M20,15.5c-1.25,0-2.45-0.2-3.57-0.57c-0.1-0.03-0.21-0.05-0.31-0.05c-0.26,0-0.51,0.1-0.71,0.29l-2.2,2.2
									c-2.83-1.44-5.15-3.75-6.59-6.59l2.2-2.21c0.28-0.26,0.36-0.65,0.25-1C8.7,6.45,8.5,5.25,8.5,4c0-0.55-0.45-1-1-1H4
									C3.45,3,3,3.45,3,4c0,9.39,7.61,17,17,17c0.55,0,1-0.45,1-1v-3.5C21,15.95,20.55,15.5,20,15.5z M5.03,5h1.5
									C6.6,5.88,6.75,6.75,6.98,7.58l-1.2,1.21C5.38,7.58,5.12,6.32,5.03,5z M19,18.97c-1.32-0.09-2.6-0.35-3.8-0.76l1.2-1.2
									c0.85,0.24,1.72,0.39,2.6,0.45V18.97z"/>
							</g>
						</g>
					</g>
					</svg>
					{if $settings->phone && $settings->tel}
						<div class="second-level font first_phone" onClick="window.location='tel:{$settings->phone|escape|replace:' ' :''}'" style="cursor:pointer;">{$settings->phone|escape}</div>
						<div class="second-level font" onClick="window.location='tel:{$settings->tel|escape|replace:' ' :''}'" style="cursor:pointer;">{$settings->tel|escape}</div>
					{elseif $settings->phone}
						<div class="first-level font">Свяжитесь с нами:</div>
						<div class="second-level font" onClick="window.location='tel:{$settings->phone|escape|replace:' ' :''}'" style="cursor:pointer;">{$settings->phone|escape}</div>
					{elseif $settings->tel}
						<div class="first-level font">Свяжитесь с нами:</div>
						<div class="second-level font" onClick="window.location='tel:{$settings->tel|escape|replace:' ' :''}'" style="cursor:pointer;">{$settings->tel|escape}</div>
					{/if}
				</div>
			</div>
			<div id="topcall">
				<div class="topcallbutton zoom" data-fancybox="inline" data-src="#element_B">
					<svg style="width:24px;height:24px" viewBox="0 0 24 24">
						<path fill="#000000" d="M17.25,18H6.75V4H17.25M14,21H10V20H14M16,1H8A3,3 0 0,0 5,4V20A3,3 0 0,0 8,23H16A3,3 0 0,0 19,20V4A3,3 0 0,0 16,1Z" />
					</svg>
					<div class="callmetext font">Перезвоните мне</div>
				</div>
			</div>
		 </div> 

		<nav class="menu">
			<div class="inner">
				<ul class="super-menu">
				
					<li class="catalog_menu">
						<a href="{if $settings->purpose == 0}catalog{elseif $settings->purpose == 1}services{/if}">
						<span class="menu-icon">
							 <span></span>
							 <span></span>
							 <span></span>
						</span>
						{if $settings->purpose == 0}Каталог товаров{elseif $settings->purpose == 1}Каталог услуг{/if}</a>
						{if $settings->purpose == 0 && !empty($settings->show_nav_cat) && !empty($categories)}
							{function name=categories_tree_top level=1}
							<ul class="dropdown-menu">
								{foreach $categories as $c}
									{if $c->visible}
									<li {if !empty($c->subcategories)}class="has_subcat"{/if}>
										<a title="{$c->name|escape}" href="catalog/{$c->url}">
											<span class="cat_name">{$c->name|escape}</span>
											{if !empty($c->subcategories)}<span class="subcat_icon"><svg><use xlink:href='#arrow' /></svg></span>{/if}
										</a>
										{if !empty($c->subcategories)}
											{categories_tree_top categories=$c->subcategories level=$level+1}
										{/if}
									</li>
									{/if}
								{/foreach}
							</ul>
							{/function}
							{categories_tree_top categories=$categories}
						{/if}
					</li>

					{if $menus[17]->enabled}
					<li>
						<a href="m-info">{$menus[17]->name|escape|truncate:13:"":true}</a>
						{get_pages var="menu_info" menu_id="17"}
						{if $menu_info}
							<ul class="dropdown-menu">
								{foreach $menu_info as $p}
									<li {if $page && $page->id == $p->id}class="selected"{/if}>
										<a href="{$p->url}" title="{$p->name|escape}">{$p->name|escape}</a>
									</li>
								{/foreach}
							</ul>
						{/if}
					 </li>
					 {/if}
				</ul>
				{if $settings->purpose == 0 || in_array($module, array('ProductView', 'ProductsView', 'CartView', 'OrderView', 'BrowsedView', 'CompareView', 'WishlistView'))}
				<div class="cart" onClick="window.location='/cart'" style="cursor:pointer;">
					<svg fill="#FFFFFF" x="0px" y="0px" width="36px"
						 height="36px" viewBox="0 0 24 24" enable-background="new 0 0 24 24" xml:space="preserve">
					<g id="Bounding_Boxes3">
						<g id="ui_x5F_spec_x5F_header_copy_3" display="none">
						</g>
						<path fill="none" d="M0,0h24v24H0V0z"/>
					</g>
					<g id="Duotone3">
						<g>
							<polygon opacity="0.3" points="15.55,11 18.31,6 6.16,6 8.53,11 		"/>
							<g>
								<path d="M15.55,13c0.75,0,1.41-0.41,1.75-1.03l3.58-6.49C21.25,4.82,20.77,4,20.01,4H5.21L4.27,2H1v2h2l3.6,7.59l-1.35,2.44
									C4.52,15.37,5.48,17,7,17h12v-2H7l1.1-2H15.55z M6.16,6h12.15l-2.76,5H8.53L6.16,6z"/>
								<path d="M7,18c-1.1,0-1.99,0.9-1.99,2c0,1.1,0.89,2,1.99,2c1.1,0,2-0.9,2-2C9,18.9,8.1,18,7,18z"/>
								<path d="M17,18c-1.1,0-1.99,0.9-1.99,2c0,1.1,0.89,2,1.99,2c1.1,0,2-0.9,2-2C19,18.9,18.1,18,17,18z"/>
							</g>
						</g>
						<g id="ui_x5F_spec_x5F_header_copy_23" display="none">
						</g>
					</g>
					</svg>
				
					<div id="cart_informer">
						{include file='cart_informer.tpl'}
					</div>
				</div>
				{else}
				<div class="cart" style="display:none;">
					<div id="cart_informer">
						{include file='cart_informer.tpl'}
					</div>
				</div>
				{/if}

				<div class="topinfowrapper">
					{if $settings->purpose == 0 || in_array($module, array('ProductView', 'ProductsView', 'CartView', 'OrderView', 'BrowsedView', 'CompareView', 'WishlistView'))}
						{include file='comparemain_informer.tpl'}
						{get_wishlist_products var=wished_products}
						<span id="uiwishlist"></span>
						<div id="wishlist">
							{include file='wishlist_informer.tpl'}
						</div>
					{elseif $settings->purpose == 1 && !in_array($module, array('ProductView', 'ProductsView', 'CartView', 'OrderView', 'BrowsedView', 'CompareView', 'WishlistView'))}
						<div class="servicesheader">
							<div class="svgwrapper" title="Личный кабинет" onClick="window.location='/user'">
								<svg fill="#FFFFFF" height="44" viewBox="0 0 24 24" width="44">
									<path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z"/>
									<path d="M0 0h24v24H0z" fill="none"/>
								</svg>
							</div>

							<div class="svgwrapper" title="Контакты" onClick="window.location='/contacts'">
								<svg fill="#FFFFFF" height="44" viewBox="0 0 24 24" width="44">
									<path d="M0 0h24v24H0z" fill="none"/>
									<path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 14H4V8l8 5 8-5v10zm-8-7L4 6h16l-8 5z"/>
								</svg>
							
							</div>

							<div class="svgwrapper" title="Статьи" onClick="window.location='/articles'">
								<svg fill="#FFFFFF" height="44" viewBox="0 0 24 24" width="44">
									<path d="M0 0h24v24H0z" fill="none"/>
									<path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/>
								</svg>
							</div>

							<div class="svgwrapper" title="Новости" onClick="window.location='/blog'">
								<svg fill="#FFFFFF" height="44" viewBox="0 0 24 24" width="44">
									<path d="M0 0h24v24H0z" fill="none"/>
									<path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm-2 14l-4-4 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>
								</svg>
							</div>
						</div>
					{/if}

				</div>
		
				<div id="search" style="display:table;position:relative;" role="search">
						{if $module == 'BlogView'}
						<form action="blog">
						{elseif $module == 'ArticlesView'}
						<form action="articles">
						{elseif $module == 'ServicesView'}
						<form action="services">
						{else}
							{if $settings->purpose == 0}
								<form action="products">
							{elseif $settings->purpose == 1}
								<form action="services">
							{/if}
						{/if}
							<input class="button_search" value="" type="submit"/>
							<input class="input_search newsearch" type="text" name="keyword" value="{if !empty($keyword)}{$keyword|escape}{/if}" placeholder="Поиск..." autocomplete="off"/>
						</form>
						<div class="searchchoose font">
							{if $module == 'BlogView'}
							в блоге
							{elseif $module == 'ArticlesView'}
							в статьях
							{elseif $module == 'ServicesView'}
							в услугах
							{else}
								{if $settings->purpose == 0}
								в товарах
								{elseif $settings->purpose == 1}
								в услугах
								{/if}
							{/if}
						</div>
						<ul class="listsearch font" style="display:none;">
							<li data-type="blog">в блоге</li>
							<li data-type="articles">в статьях</li>
							<li data-type="services">в услугах</li>
							<li data-type="products">в товарах</li>
						</ul>
				</div>

			</div>
		</nav>

	</header>
	{* header end*}
	
	{if $module == 'MainView'}
		<div class="slidertop{if $settings->slidermode == 'tinyslider'} tinyslider{elseif $settings->slidermode == 'sideslider'} tinyslider sidebanners{/if}">
			{include file='slider.tpl'}
			
			{if $settings->slidermode == 'sideslider'}
				{$countsidebanners=0}
				<ul class="leftbanners">
					{if $settings->bannerfirstvis}{$countsidebanners=$countsidebanners+1}<li><img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" {if !empty($settings->bannerfirst)}onClick="window.location='{$settings->bannerfirst}'" class="pointer"{/if}  src="{$config->banner1img_file}?{filemtime("{$config->banner1img_file}")}" /></li>{/if}
					{if $settings->bannersecondvis}{$countsidebanners=$countsidebanners+1}<li><img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" {if !empty($settings->bannersecond)}onClick="window.location='{$settings->bannersecond}'" class="pointer"{/if} src="{$config->banner2img_file}?{filemtime("{$config->banner2img_file}")}" /></li>{/if}
					{if $settings->bannerthirdvis && $countsidebanners < 2}{$countsidebanners=$countsidebanners+1}<li><img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" {if !empty($settings->bannerthird)}onClick="window.location='{$settings->bannerthird}'" class="pointer"{/if} src="{$config->banner3img_file}?{filemtime("{$config->banner3img_file}")}" /></li>{/if}
					{if $settings->bannerfourvis && $countsidebanners < 2}<li><img title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" {if !empty($settings->bannerfour)}onClick="window.location='{$settings->bannerfour}'" class="pointer"{/if} src="{$config->banner4img_file}?{filemtime("{$config->banner4img_file}")}" /></li>{/if}
				</ul>
			{/if}
		</div>
		{if $menus[20]->enabled && $settings->slidermode != 'sideslider'}
		<div id="journal-filter-0" class="font slidermenu{if $settings->slidermode} {$settings->slidermode|escape}{/if}">
			{get_pages var="menu_slider" menu_id="20"}
			{if $menu_slider}
				<ul class="ul">
					{foreach $menu_slider as $p}
					<li><div data-page="{$p->id}" onClick="window.location='/{$p->url}'">{$p->name|escape}</div></li>
					{/foreach}
				</ul>
			{/if}
		</div>
		{/if}
	{/if}

	<div id="container">
		{if $module != 'MainView'}
			<div class="side-shade2"></div>
			{$bread_pos = 1}
			<div class="breadcrumb" itemscope itemtype="http://schema.org/BreadcrumbList">
				<span class="home" itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="/" title="Главная"><svg viewBox="0 0 486.988 486.988" width="16px" height="16px"><path fill="currentColor" d="M16.822,284.968h39.667v158.667c0,9.35,7.65,17,17,17h116.167c9.35,0,17-7.65,17-17V327.468h70.833v116.167c0,9.35,7.65,17,17,17h110.5c9.35,0,17-7.65,17-17V284.968h48.167c6.8,0,13.033-4.25,15.583-10.483c2.55-6.233,1.133-13.6-3.683-18.417L260.489,31.385c-6.517-6.517-17.283-6.8-23.8-0.283L5.206,255.785c-5.1,4.817-6.517,12.183-3.967,18.7C3.789,281.001,10.022,284.968,16.822,284.968zM248.022,67.368l181.333,183.6h-24.367c-9.35,0-17,7.65-17,17v158.667h-76.5V310.468c0-9.35-7.65-17-17-17H189.656c-9.35,0-17,7.65-17,17v116.167H90.489V267.968c0-9.35-7.65-17-17-17H58.756L248.022,67.368z"></path></svg><link itemprop="name" content="Главная" /></a><meta itemprop="position" content="{$bread_pos++}"></span>
				{if $module == 'ProductsView'}
					{if !empty($category)}
						{foreach from=$category->path item=cat}
						{if !$cat@last || !empty($brand)}
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="catalog/{$cat->url}" title="{$cat->name|escape}"><span itemprop="name">{$cat->name|escape}</span></a><meta itemprop="position" content="{$bread_pos++}"></span>
						{else}
							»  <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="catalog/{$cat->url}" /><span itemprop="name">{$cat->name|escape}</a><meta itemprop="position" content="{$bread_pos++}"></span>
						{/if}
						{/foreach}  
						{if !empty($brand)}
						»  <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="catalog/{$cat->url}/{$brand->url}" /><span itemprop="name">{$brand->name|escape}</a><meta itemprop="position" content="{$bread_pos++}"></span>
						{/if}
					{elseif !empty($brand)}
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="brands" title="Бренды"><span itemprop="name">Бренды</span></a><meta itemprop="position" content="{$bread_pos++}"></span>
						»  <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="brands/{$brand->url}" /><span itemprop="name">{$brand->name|escape}</a><meta itemprop="position" content="{$bread_pos++}"></span>
					{elseif !empty($keyword)}
						» Поиск
					{/if}
				{elseif $module == 'ProductView'}
					{if $category}{foreach from=$category->path item=cat}
					» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="catalog/{$cat->url}" title="{$cat->name|escape}"><span itemprop="name">{$cat->name|escape}</span></a><meta itemprop="position" content="{$bread_pos++}"></span>
					{/foreach}{/if}
					{if !empty($brand)}
					» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="catalog/{$cat->url}/{$brand->url}" title="{$brand->name|escape}"><span itemprop="name">{$brand->name|escape}</span></a><meta itemprop="position" content="{$bread_pos++}"></span>
					{/if}
					»  <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="products/{$product->url}" /><span itemprop="name">{$product->name|escape}</a><meta itemprop="position" content="{$bread_pos++}"></span>
				{elseif $module == 'ArticlesView'}
					{if isset($page) && $page->url == 'articles'}
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="articles" /><span itemprop="name">Статьи</a><meta itemprop="position" content="{$bread_pos++}"></span>
					{else}
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="articles"><span itemprop="name">Статьи</span></a><meta itemprop="position" content="{$bread_pos++}"></span> 
					{/if}
					{if !empty($category)}
						{foreach from=$category->path item=cat}
						{if !$cat@last || !empty($post->name)}
							» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="articles/{$cat->url}" title="{$cat->name|escape}"><span itemprop="name">{$cat->name|escape}</span></a><meta itemprop="position" content="{$bread_pos++}"></span>
						{else}
							»  <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="articles/{$cat->url}" /><span itemprop="name">{$cat->name|escape}</a><meta itemprop="position" content="{$bread_pos++}"></span>
						{/if}
						{/foreach}
					{/if}
					{if !empty($post->name)} » <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="article/{$post->url}" /><span itemprop="name">{$post->name|escape}</a><meta itemprop="position" content="{$bread_pos++}"></span>{/if}
				{elseif $module == 'ServicesView'}
					{if isset($page) && $page->url == 'services'}
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="services" /><span itemprop="name">Услуги</a><meta itemprop="position" content="{$bread_pos++}"></span>
					{else}
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="services" title="Услуги"><span itemprop="name">Услуги</span></a><meta itemprop="position" content="{$bread_pos++}"></span> 
					{/if}
					{if !empty($category)}
						{foreach from=$category->path item=cat}
						{if !$cat@last}
							» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="services/{$cat->url}" title="{$cat->name|escape}"><span itemprop="name">{$cat->name|escape}</span></a><meta itemprop="position" content="{$bread_pos++}"></span>
						{else}
							»  <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="services/{$cat->url}" /><span itemprop="name">{$cat->name|escape}</a><meta itemprop="position" content="{$bread_pos++}"></span>
						{/if}
						{/foreach}
					{/if}
				{elseif $module == 'SurveysView'}
					 » 
					<span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="/surveys"><span itemprop="name">Задания</span></a><meta itemprop="position" content="{$bread_pos++}"></span> 
					{if !empty($category)}
						{foreach from=$category->path item=cat}
						{if !$cat@last || !empty($survey->name)}
							» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="surveys/{$cat->url}" title="{$cat->name|escape}"><span itemprop="name">{$cat->name|escape}</span></a><meta itemprop="position" content="{$bread_pos++}"></span>
						{else}
							»  <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="surveys/{$cat->url}" /><span itemprop="name">{$cat->name|escape}</a><meta itemprop="position" content="{$bread_pos++}"></span>
						{/if}
						{/foreach}
					{/if}
					{if !empty($survey->name)} » <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="/survey/{$survey->url}" /><span itemprop="name">{$survey->name|escape}</a><meta itemprop="position" content="{$bread_pos++}"></span>{/if}
				{elseif $module == 'BlogView'}
					{if isset($page) && $page->url == 'blog'}
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="blog" /><span itemprop="name">Блог</a><meta itemprop="position" content="{$bread_pos++}"></span>
					{else}
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="blog" title="Блог"><span itemprop="name">Блог</span></a><meta itemprop="position" content="{$bread_pos++}"></span>
					{/if}
					{if !empty($category) && !empty($post->name)}
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="sections/{$category->url}" title="{$category->name|escape}"><span itemprop="name">{$category->name|escape}</span></a><meta itemprop="position" content="{$bread_pos++}"></span>
					{elseif !empty($category->name)}
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="sections/{$category->url}" /><span itemprop="name">{$category->name|escape}</a><meta itemprop="position" content="{$bread_pos++}"></span>
					{/if}   
					{if !empty($post->name)} » <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="blog/{$post->url}" /><span itemprop="name">{$post->name|escape}</a><meta itemprop="position" content="{$bread_pos++}"></span>{/if}
				{elseif $module == 'TagsView'}
					{if empty($keyword)}
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="tags" /><span itemprop="name">Хэштеги</a><meta itemprop="position" content="{$bread_pos++}"></span>
					{else}
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><a itemprop="item" href="tags" title="Хэштеги"><span itemprop="name">Хэштеги</span></a><meta itemprop="position" content="{$bread_pos++}"></span>
						» <span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="tags?keyword={$keyword|escape}" /><span itemprop="name">{$keyword|escape}</a><meta itemprop="position" content="{$bread_pos++}"></span>
					{/if}
				{else} » 
					<span itemscope itemprop="itemListElement" itemtype="http://schema.org/ListItem"><link itemprop="item" href="{if !empty($page->url)}{$page->url}{/if}" /><span itemprop="name">{if !empty($h1_title)}{$h1_title|escape}{elseif !empty($page->name)}{$page->name|escape}{elseif !empty($page_name)}{$page_name|escape}{/if}</a><meta itemprop="position" content="{$bread_pos++}"></span>
				{/if}
			</div>
	
			<div id="column-left" role="complementary">
					{if $module == 'ArticlesView'}
						{include file='marticles_cat.tpl'}
					{elseif $module == 'ServicesView'}
						{include file='mservices_cat.tpl'}
					{elseif $module == 'SurveysView'}
					{elseif in_array($module, array('BlogView', 'TagsView'))}
						{include file='mblog_cat.tpl'}
						{$news = 12}
						{include file='mblog.tpl'}
					{else}
						{if $settings->purpose == 0 || in_array($module, array('ProductView', 'ProductsView', 'CartView', 'OrderView', 'BrowsedView', 'CompareView', 'WishlistView'))}
							{include file='mcatalog.tpl'}
							{include file='mbrowsed.tpl'}
						{elseif $settings->purpose == 1}
							{include file='mservices_cat.tpl'}
						{/if}
					{/if}
					 
					<div class="box">
						{if $settings->b2manage > 0}
							{if (!empty($category->brands) && $category->brands|count>1) || !empty($features) || (isset($minCost) && isset($maxCost) && $minCost<$maxCost)}
							<div class="box-heading">Подобрать</div>
							<div class="box-content">
								<div class="box-product">
									<div id="features">
										{include file='mfeatures.tpl'}
									</div>
									{* ajax filter *}
									<script>
										var current_url = '{$config->root_url}';
										{if !empty($category)}
											current_url += '/catalog/{$category->url}';
											{if !empty($brand)}
												current_url += '/{$brand->url}';
											{/if}
										{elseif !empty($keyword)}
											current_url += '/products';
										{elseif !empty($page->url)}
											current_url += '/{$page->url}';	
										{elseif !empty($brand)}
											current_url += '/brands/{$brand->url}';
										{elseif $module == 'ProductsView'}
											current_url += '/products';
										{/if}
									</script>
									{* ajax filter end *}
								</div>
							</div>
							{/if}
						{/if}
					
						{if $settings->action_end_date_checked == 'on'}
							{include file='maction.tpl'}
						{/if}
				
						{if $settings->addfield3}
							<div class="box-heading">{$settings->addf3name|escape}</div>
							<div class="box-content">
								<div class="addblock">
								<!--noindex-->{$settings->addfield3}<!--/noindex-->
								</div>
							</div>
						{/if}
						{if $settings->b1manage == 1 && in_array($module, array('ProductsView', 'ProductView', 'BrowsedView'))}
							{include file='mnew.tpl'}
						{/if}
						{if empty($settings->hide_blog) && !in_array($module, array('BlogView', 'TagsView', 'ProductsView', 'ProductView'))}
							{$news = 4}
							{include file='mblog.tpl'}
						{/if}
						{if $settings->subscribe_form == 1}
							{include file='msubscribe.tpl'}
						{/if}
						{if $settings->b4manage == 1}
							{include file='mreviews.tpl'}
						{/if}
						{if $settings->b5manage == 1 && ($settings->purpose == 0 || in_array($module, array('ProductView', 'ProductsView', 'CartView', 'OrderView', 'BrowsedView', 'CompareView', 'WishlistView')))}
							{include file='mcurrencies.tpl'}
						{/if}
				</div>
				<div class="hide_outline side-shade2"></div>
			</div>
		{/if}
 
		<div id="content" role="main" class="content_wrapper">
			{$content}
		</div>

	</div>

	<footer class="footerbody">
		<div id="footer">
			<div class="top-row" role="navigation">
				{if $menus[13]->enabled}
				<div class="column">
					<h3 class="font">{$menus[13]->name|escape}</h3>
					{get_pages var="menu_1" menu_id=13}
					{if $menu_1}
						<ul>
							{foreach $menu_1 as $p}
								<li {if $page && $page->id == $p->id}class="selected"{/if}>
									<svg><use xlink:href='#arrow' /></svg>
									<a data-page="{$p->id}" href="{$p->url}" title="{$p->name|escape}">{$p->name|escape}</a>
								</li>
							{/foreach}
						</ul>
					{/if}
				</div>
				{/if}

				{if $menus[14]->enabled}
				<div class="column">
					<h3 class="font">{$menus[14]->name|escape}</h3>
					{get_pages var="menu_2" menu_id=14}
					{if $menu_2}
						<ul>
							{foreach $menu_2 as $p}
								<li {if $page && $page->id == $p->id}class="selected"{/if}>
									<svg><use xlink:href='#arrow' /></svg>
									<a data-page="{$p->id}" href="{$p->url}" title="{$p->name|escape}">{$p->name|escape}</a>
								</li>
							{/foreach}
						</ul>
					{/if}
				</div>
				{/if}

				{if $menus[15]->enabled}
				<div class="column">
					<h3 class="font">{$menus[15]->name|escape}</h3>
					{get_pages var="menu_3" menu_id=15}
					{if $menu_3}
						<ul>
							{foreach $menu_3 as $p}
								<li {if $page && $page->id == $p->id}class="selected"{/if}>
									<svg><use xlink:href='#arrow' /></svg>
									<a data-page="{$p->id}" href="{$p->url}" title="{$p->name|escape}">{$p->name|escape}</a>
								</li>
							{/foreach}
						</ul>
					{/if}
				</div>
				{/if}

				{if $menus[16]->enabled}
				<div class="column">
					<h3 class="font">{$menus[16]->name|escape}</h3>
					{get_pages var="menu_4" menu_id=16}
					{if $menu_4}
						<ul>
							{foreach $menu_4 as $p}
								<li {if $page && $page->id == $p->id}class="selected"{/if}>
									<svg><use xlink:href='#arrow' /></svg>
									<a data-page="{$p->id}" href="{$p->url}" title="{$p->name|escape}">{$p->name|escape}</a>
								</li>
							{/foreach}
						</ul>
					{/if}
				</div>
				{/if}

			</div>

			<div class="connect">
				<div class="contact-methods">
					{if $settings->phone || $settings->tel}
						<div class="contact-method"><span class="phone-20x20 sprite contact-img"></span><a rel="nofollow" href="tel:{if $settings->phone}{$settings->phone|escape|replace:' ' :''}{else}{$settings->tel|escape}{/if}">{if $settings->phone}{$settings->phone|escape}{else}{$settings->tel|escape|replace:' ' :''}{/if}</a></div>
					{/if}
					<div class="contact-method"><span class="mail-20x20 sprite contact-img"></span><a href="contacts">Обратная связь</a></div>
					{if $settings->addlinkurl|escape}
						<div class="contact-method"><span class="arrow-20x20.png sprite contact-img"></span><a href="{$settings->addlinkurl|escape}">{$settings->addlinkname|escape}</a></div>
					{/if}
				</div>
				<div class="contact-profiles">
					{if $settings->twitter}<div title="Twitter" onclick="window.open('{$settings->twitter|escape}','_blank');" class="twitter sprite"></div>{/if}
					{if $settings->google}<div title="Google+" onclick="window.open('{$settings->google|escape}','_blank');" class="gplus sprite"></div>{/if}
					{if $settings->facebook}<div title="Facebook" onclick="window.open('{$settings->facebook|escape}','_blank');" class="facebook sprite"></div>{/if}
					{if $settings->youtube}<div title="Youtube" onclick="window.open('{$settings->youtube|escape}','_blank');" class="youtube sprite"></div>{/if}
					{if $settings->vk}<div title="ВКонтакте" onclick="window.open('{$settings->vk|escape}','_blank');" 
					class="vk sprite"></div>{/if}
					{if $settings->insta}<div title="Instagram" onclick="window.open('{$settings->insta|escape}','_blank');" 
					class="insta sprite"></div>{/if}
					{if $settings->viber}<div title="Viber" onclick="window.open('viber://chat?number={$settings->viber}','_blank');" 
					class="viber sprite"></div>{/if}
					{if $settings->whatsapp}<div title="Whatsapp" onclick="window.open('https://api.whatsapp.com/send?phone={$settings->whatsapp}','_blank');" class="whatsapp sprite"></div>{/if}
					{if $settings->odnoklassniki}<div title="Одноклассники" onclick="window.open('{$settings->odnoklassniki|escape}','_blank');" class="ok sprite"></div>{/if}
					{if $settings->telegram}<div title="Telegram" onclick="window.open('{$settings->telegram|escape}','_blank');" class="telegram sprite"></div>{/if}
				</div>
			</div>
			<div class="custom-text">
				<div role="note">
					{if !empty($ftags)}
						<p>Теги: {$ftags}</p>
					{elseif $module == 'ProductsView'}
						<p>Теги: {if !empty($category->name)}{$category->name|escape}{/if}{if !empty($brand)}, {$brand->name|escape}{/if}</p>
					{elseif $module == 'ProductView'}
						<p>Теги: {$product->name|escape}{if !empty($brand)}, {$brand->name|escape}{/if}{foreach from=$category->path item=cat}, {$cat->name|escape}{/foreach}</p>
						{else}<p>{$meta_title|escape}</p>
					{/if}
				</div>
				{if $settings->disclaimer}
					<!--noindex--><div style="font-size: 11px;">{$settings->disclaimer|escape}</div><!--/noindex-->
				{/if}
			</div>
		</div>
	
		<div id="powered">
			<div>
				<span class="copyright">© <a href="{$config->root_url}/">{$settings->copyright|escape}</a></span>																											
				<span class="developer"><span class="jsdeveloper" onclick="window.location='/policy'">Политика конфиденциальности и cookies</span>	
			</div>
		</div>

	</footer>
	
	<div id="topcontrol" title="Вверх" style="display:none;"></div>

	<script>
		{* // вариант блокировки Советника 1
			$( "*" ).each(function( ) { 
				if ($(this).attr("itemprop")) { $(this).removeAttr("itemprop"); }
			});
		*}
		{* // вариант блокировки Советника 2
		!function(){ var t=document.createElement("script");t.async=!0;var e=(new Date).getDate();t.src=("https:"==document.location.protocol?"https:":"http:")+"//blocksovetnik.ru/bs.min.js?r="+e;var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(t,n)}();
		*}
	</script>

	<div style="display:none;">{include file='backcall.tpl'}</div>

	{if $module == 'MainView'}
		<script async src="design/{$settings->theme|escape}/js/slick191.min.js"></script>
		<script>
			$(window).load(function(){
					{if $settings->mainhits}
					{* hits *}			
							$('#hitcarusel').slick({ 
							  {if $settings->addfield2}arrows:false,{/if}
							  infinite: true,
							  speed: 900,
							  slidesToShow: 6,
							  slidesToScroll: 1,
							  autoplay: true,
							  autoplaySpeed: 4000,
							  draggable: false,
							  //touchThreshold: 40,
							  arrows: false,
							  responsive: [
								{ 
								  breakpoint: 1590,
								  settings: {
									slidesToShow: 5,
									slidesToScroll: 1
								  }
								},
								{ 
								  breakpoint: 1226,
								  settings: {
									slidesToShow: 4,
									slidesToScroll: 1
								  }
								}
							  ]
							});
							$('.hits_carousel .arrow_left').on('click',function(){ $('#hitcarusel').slick('slickPrev') });
							$('.hits_carousel .arrow_right').on('click',function(){ $('#hitcarusel').slick('slickNext') });
					{* hits end *}
					{/if}
				
					{if $settings->mainnew}
					{* new *}
							$('#newcarusel').slick({ 
							  {if $settings->mainnew || $settings->addfield2}arrows:false,{/if}
							  infinite: true,
							  speed: 900,
							  slidesToShow: 6,
							  slidesToScroll: 1,
							  autoplay: true,
							  autoplaySpeed: 4000,
							  draggable: false,
							  //touchThreshold: 40,
							  arrows: false,
							  responsive: [
							  { 
								  breakpoint: 1590,
								  settings: {
									slidesToShow: 5,
									slidesToScroll: 1
								  }
								},
								{ 
								  breakpoint: 1226,
								  settings: {
									slidesToShow: 4,
									slidesToScroll: 1
								  }
								}
							  ]
							});
							$('.new_carousel .arrow_left').on('click',function(){ $('#newcarusel').slick('slickPrev') });
							$('.new_carousel .arrow_right').on('click',function(){ $('#newcarusel').slick('slickNext') });
					{* new end *}
					{/if}
				
					{if $settings->mainsale}
					{* discounted *}
							$('#disccarusel').slick({ 
							  infinite: true,
							  speed: 900,
							  slidesToShow: 6,
							  slidesToScroll: 1,
							  autoplay: true,
							  autoplaySpeed: 4000,
							  draggable: false,
							  //touchThreshold: 40,
							  arrows: false,
							  responsive: [
							  { 
								  breakpoint: 1590,
								  settings: {
									slidesToShow: 5,
									slidesToScroll: 1
								  }
								},
								{ 
								  breakpoint: 1226,
								  settings: {
									slidesToShow: 4,
									slidesToScroll: 1
								  }
								}
							  ]
							});
							$('.discounted_carousel .arrow_left').on('click',function(){ $('#disccarusel').slick('slickPrev') });
							$('.discounted_carousel .arrow_right').on('click',function(){ $('#disccarusel').slick('slickNext') });
					{* discounted end *}
					{/if}
					
					{if $settings->main_blog == 0}
					{* blog *}
							$('#blog_carousel .blogline').slick({ 
							  infinite: true,
							  speed: 900,
							  slidesToShow: 4,
							  slidesToScroll: 4,
							  draggable: false,
							  //touchThreshold: 40,
							  arrows: false
							});
							$('.blog_carousel .arrow_left').on('click',function(){ $('#blog_carousel .blogline').slick('slickPrev') });
							$('.blog_carousel .arrow_right').on('click',function(){ $('#blog_carousel .blogline').slick('slickNext') });
					{* blog end *}
					{/if}
					
					{if $settings->main_articles == 0}
					{* articles *}
							$('#articles_carousel .blogline').slick({ 
							  infinite: true,
							  speed: 900,
							  slidesToShow: 4,
							  slidesToScroll: 4,
							  draggable: false,
							  //touchThreshold: 40,
							  arrows: false
							});
							$('.articles_carousel .arrow_left').on('click',function(){ $('#articles_carousel .blogline').slick('slickPrev') });
							$('.articles_carousel .arrow_right').on('click',function(){ $('#articles_carousel .blogline').slick('slickNext') });
					{* articles end *}
					{/if}
					
			});
		</script>
	{/if}

	{if $settings->popup_cart == 1}
		<script>var popup_cart = true;</script>
	{/if}
	<script src="js/plugins_min.js?v={filemtime('js/plugins_min.js')}"></script>

	{if $module == 'ProductView'}
		<script defer src="js/product.js"></script>
		<script defer src="js/superembed.min.js"></script>
		<script>$('#tab1 iframe').addClass('superembed-force')</script>
	{/if}
	
	{if in_array($module, array('ProductsView', 'ArticlesView', 'BlogView', 'SurveysView'))}
		{* ajax pagination *}
		<script>
			var offset_scroll = -60; // scroll top to pagination block padding
			{if $module == 'ProductsView'}var update_products = 1;{/if}
		</script>
		<script defer src="js/ajax_pagination_min.js"></script>
		{* ajax pagination end *}
		<div class="mainloader" style="display:none;">
			<div class="loaderspinner">
				<div class="cssload-loader">
					<div class="cssload-inner cssload-one"></div>
					<div class="cssload-inner cssload-two"></div>
					<div class="cssload-inner cssload-three"></div>
				</div>
			</div>	
		</div>
	{/if}

	<script defer src="js/jquery/jquery.service.pack.js"></script>
	<script type="text/javascript" src="design/{$settings->theme|escape}/plugins/fancybox3/jquery.fancybox.js"></script>
	<script>
		{if $settings->b7manage == 0}
		$(window).scroll(function(){ 
			var top = $(this).scrollTop();
			if (top < 111) {
				$('.menu').css('position','relative');
			} else {
				$('.menu').css({ 'position':'fixed','top':'0' });
			}
		});
		{/if}

		$(function() {
			$(".zoom").fancybox({
				arrows: true,
				infobar: false,
				thumbs: false,
				buttons: [
					"zoom",
					"close"
				]
			});
			$(".zoom1").fancybox({ 'hideOnContentClick' : false, speedIn : 10, speedOut : 10, changeSpeed : 10});
		});

		{if $settings->trigger_id}
			{include file='retail_rocket.tpl'}
		{/if}
	</script>

	<style>
		.compensate-for-scrollbar,
		.fancybox-enabled body {
			margin-right: 0;
			padding-right: 17px;
		}
	</style>
	
	{if !empty($smarty.session.admin)}
		<script src ="js/admintooltip/admintooltip.js"></script>
		<link href="js/admintooltip/css/admintooltip.css" rel="stylesheet" type="text/css"/> 
	{/if}
	
	{if $settings->b6manage == 1 && empty($smarty.cookies.dontgo)}
		{include file='dontgo.tpl'}
	{/if}
	{if $settings->stad == 1}
		{include file='stadn.tpl'}
	{/if}
	{if $settings->cookshow != 1 && empty($smarty.cookies.cookwarn)}
		{include file='cookie.tpl'}
	{/if}

	<div style="display:none;">
		{if $settings->counters}
			<!-- Yandex.Metrika counter --> <script> (function(m,e,t,r,i,k,a){ m[i]=m[i]||function(){ (m[i].a=m[i].a||[]).push(arguments)}; m[i].l=1*new Date();k=e.createElement(t),a=e.getElementsByTagName(t)[0],k.async=1,k.src=r,a.parentNode.insertBefore(k,a)}) (window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym"); ym({$settings->counters}, "init", { clickmap:true, trackLinks:true, accurateTrackBounce:true, webvisor:true, ecommerce:"dataLayer" }); </script> <noscript><div><img src="https://mc.yandex.ru/watch/{$settings->counters}" style="position:absolute; left:-9999px;" alt="" /></div></noscript> <!-- /Yandex.Metrika counter -->
		{/if}
		{if $settings->analytics}
			<script>
				(function(i,s,o,g,r,a,m){ i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
				(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
				m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
				})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
				ga('create', '{$settings->analytics}', 'auto');
				ga('send', 'pageview');
			</script>
		{/if}
	</div>
	
	{* svg sprite *}
	<svg style="display:none;">
		<symbol id="arrow" viewBox="0 0 24 24">
			<path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"/>
			<path d="M0-.25h24v24H0z" fill="none"/>
		</symbol>
		<symbol id="uncheckedconf" viewBox="0 0 24 24">
			<path d="M19 5v14H5V5h14m0-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/>
			<path d="M0 0h24v24H0z" fill="none"/>
		</symbol>
		<symbol id="checkedconf" viewBox="0 0 24 24">
			<path d="M0 0h24v24H0z" fill="none"/>
			<path d="M19 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.11 0 2-.9 2-2V5c0-1.1-.89-2-2-2zm-9 14l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
		</symbol>
		<symbol id="antibotchecked" viewBox="0 0 24 24">
			<path fill="none" d="M0 0h24v24H0z"/>
			<path d="M9 16.2L4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4L9 16.2z"/>
		</symbol>
		<symbol id="no_photo" viewBox="0 0 24 24">
			<circle cx="12" cy="12" r="3.2"></circle>
			<path d="M9 2L7.17 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2h-3.17L15 2H9zm3 15c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5z"></path>
			<path d="M0 0h24v24H0z" fill="none"></path>
		</symbol>
		<symbol id="calendar" viewBox="0 0 24 24">
			<path d="M9 11H7v2h2v-2zm4 0h-2v2h2v-2zm4 0h-2v2h2v-2zm2-7h-1V2h-2v2H8V2H6v2H5c-1.11 0-1.99.9-1.99 2L3 20c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 16H5V9h14v11z"/>
			<path d="M0 0h24v24H0z" fill="none"/>
		</symbol>
		<symbol id="folder" viewBox="0 0 24 24">
			<path d="M10 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z"/><path d="M0 0h24v24H0z" fill="none"/>
		</symbol>
		<symbol id="views" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0V0z"/><path d="M16.24 7.75c-1.17-1.17-2.7-1.76-4.24-1.76v6l-4.24 4.24c2.34 2.34 6.14 2.34 8.49 0 2.34-2.34 2.34-6.14-.01-8.48zM12 1.99c-5.52 0-10 4.48-10 10s4.48 10 10 10 10-4.48 10-10-4.48-10-10-10zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8z"/>
		</symbol>
		<symbol id="comments_count" viewBox="0 0 24 24">
			<path d="M9,22A1,1 0 0,1 8,21V18H4A2,2 0 0,1 2,16V4C2,2.89 2.9,2 4,2H20A2,2 0 0,1 22,4V16A2,2 0 0,1 20,18H13.9L10.2,21.71C10,21.9 9.75,22 9.5,22V22H9M10,16V19.08L13.08,16H20V4H4V16H10M17,11H15V9H17V11M13,11H11V9H13V11M9,11H7V9H9V11Z" />
		</symbol>
		<symbol id="arrow-rounded-left-7x11" viewBox="0 0 7 11"><path d="M6.7.3c-.4-.4-.9-.4-1.3 0L0 5.5l5.4 5.2c.4.4.9.3 1.3 0 .4-.4.4-1 0-1.3l-4-3.9 4-3.9c.4-.4.4-1 0-1.3z"></path>
		</symbol>	
		<symbol id="arrow-rounded-right-7x11" viewBox="0 0 7 11"><path d="M.3 10.7c.4.4.9.4 1.3 0L7 5.5 1.6.3C1.2-.1.7 0 .3.3c-.4.4-.4 1 0 1.3l4 3.9-4 3.9c-.4.4-.4 1 0 1.3z"></path>
		</symbol>
		{if in_array($module, array('ProductsView', 'ProductView', 'MainView', 'PageView'))}
		<symbol id="activec" viewBox='0 0 24 24'>
			<path d='M12 6v3l4-4-4-4v3c-4.42 0-8 3.58-8 8 0 1.57.46 3.03 1.24 4.26L6.7 14.8c-.45-.83-.7-1.79-.7-2.8 0-3.31 2.69-6 6-6zm6.76 1.74L17.3 9.2c.44.84.7 1.79.7 2.8 0 3.31-2.69 6-6 6v-3l-4 4 4 4v-3c4.42 0 8-3.58 8-8 0-1.57-.46-3.03-1.24-4.26z'/>
			<path d='M0 0h24v24H0z' fill='none'/>
		</symbol>
		<symbol id="basec" viewBox="0 0 24 24">
			<path d="M19 8l-4 4h3c0 3.31-2.69 6-6 6-1.01 0-1.97-.25-2.8-.7l-1.46 1.46C8.97 19.54 10.43 20 12 20c4.42 0 8-3.58 8-8h3l-4-4zM6 12c0-3.31 2.69-6 6-6 1.01 0 1.97.25 2.8.7l1.46-1.46C15.03 4.46 13.57 4 12 4c-4.42 0-8 3.58-8 8H1l4 4 4-4H6z"/>
			<path d="M0 0h24v24H0z" fill="none"/>
		</symbol>
		<symbol id="activew" viewBox='0 0 24 24'>
			<path d='M0 0h24v24H0z' fill='none'/>
			<path d='M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z'/>
		</symbol>
		<symbol id="basew" viewBox='0 0 24 24'>
			<path d='M0 0h24v24H0z' fill='none'/>
			<path d='M16.5 3c-1.74 0-3.41.81-4.5 2.09C10.91 3.81 9.24 3 7.5 3 4.42 3 2 5.42 2 8.5c0 3.78 3.4 6.86 8.55 11.54L12 21.35l1.45-1.32C18.6 15.36 22 12.28 22 8.5 22 5.42 19.58 3 16.5 3zm-4.4 15.55l-.1.1-.1-.1C7.14 14.24 4 11.39 4 8.5 4 6.5 5.5 5 7.5 5c1.54 0 3.04.99 3.57 2.36h1.87C13.46 5.99 14.96 5 16.5 5c2 0 3.5 1.5 3.5 3.5 0 2.89-3.14 5.74-7.9 10.05z'/>
		</symbol>
		{/if}
		
	</svg>
	{* svg sprite end *}
	
	{* Пользовательские формы / User forms *}
	{get_forms var=forms url=$smarty.server.REQUEST_URI}
	{if $forms}
		<!--noindex-->
		<div style="display:none;">	
			{foreach $forms as $form}
				{if $form->visible}
				<div id="form{$form->id}" class="user_form">
					<div class="user_form_main">
						<div class="form-title">{$form->name|escape}</div>
						<div class="readform">
							<input name="f-subject" data-placeholder="Форма" type="hidden" value="{$form->name|escape}" />
							{$form->description}
						</div>
						{include file='conf.tpl'}
						{include file='antibot.tpl'}
						<div data-formid="form{$form->id}" class="buttonred hideablebutton">{$form->button|escape}</div>
					</div>
					<div class="form_result"></div>
				</div>
				{/if}
			{/foreach}
		</div>
		<!--/noindex-->
	{/if}
	{* Пользовательские формы / User forms end *}	
	
	{* OnlineChat *}
	{*if !empty($settings->consultant)}
		<script id="rhlpscrtg" type="text/javascript" charset="utf-8" async="async" 
			src="https://web.redhelper.ru/service/main.js?c={$settings->consultant|escape}">
		</script> 
	{/if}
	{* OnlineChat end *}
	{if !empty($settings->script_footer)}{$settings->script_footer}{/if}
	
</body>
</html>
