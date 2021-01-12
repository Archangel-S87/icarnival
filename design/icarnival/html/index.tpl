<!DOCTYPE html>
<html dir="ltr" prefix="og: http://ogp.me/ns#" lang="ru">
<head>
	<base href="{$config->root_url}/"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
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
	
    <link rel="stylesheet" href="design/{$settings->theme|escape}/css/libs.css">
    <link rel="stylesheet" href="design/{$settings->theme|escape}/css/style.css">
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,600,700,900&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Pacifico&amp;display=swap" rel="stylesheet">

	<!--canonical-->{if isset($canonical)}<link rel="canonical" href="{$config->root_url}{$canonical}"/>{/if}<!--/canonical-->
	{if !empty($current_page_num) && $current_page_num==2}<link rel="prev" href="{$config->root_url}{url page=null}">{/if}
	{if !empty($current_page_num) && $current_page_num>2}<link rel="prev" href="{$config->root_url}{url page=$current_page_num-1}">{/if}
	{if !empty($current_page_num) && $current_page_num<$total_pages_num}<link rel="next" href="{$config->root_url}{url page=$current_page_num+1}">{/if}
	{if !empty($current_page_num) && $current_page_num > 1}<meta name=robots content="index,follow">{/if}
	
	<link href="design/{$settings->theme|escape}/images/favicon.ico" rel="icon" type="image/x-icon"/>
	<link href="design/{$settings->theme|escape}/images/favicon.ico" rel="shortcut icon" type="image/x-icon"/>

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

   <!-- Header-->
    <header class="site-header">
      <div class="container">
        <div class="site-header__top">
          <div class="site-header__top-row row align-items-center">
            <div class="col-4 hidden--md hidden--sm">
              <div class="logo"><a href="./">
                  <image class="img--responsive" src="design/{$settings->theme|escape}/images/logo.png" alt="Ай Карнавал"></image></a></div>
            </div>
            <div class="col-lg-4 col-6 hidden--md hidden--sm">
              <div class="form__mix" id="search">
				  <form action="products">     
              <input class="form__input form__input--square newsearch" type="text" name="keyword" value="{if !empty($keyword)}{$keyword|escape}{/if}" autocomplete="off" placeholder="Введите название или артикул">
              <button class="form__mix-icon" type="submit"><i class="icon-search"></i></button>
              </form>               
              </div>
            </div>
            <div class="col-md-4 col-sm-3 col-2 visible--md visible--sm"><a class="jsMobileBarToggle mobile-bar__toggle" href="javascript:void(0);"><i class="icon-list-menu"></i></a></div>
            <div class="col-md-4 col-6 visible--md visible--sm">
              <div class="logo"><a href="./">
                  <image class="img--responsive" src="design/{$settings->theme|escape}/images/logo.png" alt="Ай Карнавал"></image></a></div>
            </div>
            <div class="col-lg-4 col-md-2 col-sm-3 col-4">
              <div class="row row--x-indent-10 justify-content-end align-items-center">
                <div class="col-item hidden--md hidden--sm visible--lg"><a class="action-btn" href="account.html"><i class="icon-login"></i></a></div>
                <div class="col-item visible--md visible--sm hidden--lg"><a class="action-btn jsSearchBtn" href="javascript:void(0);"><i class="icon-search"></i></a></div>
                <div class="col-item" id="cart_informer">
                {include file='cart_informer.tpl'}
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="float-search jsSearchContent">
          <div class="float-search__row row align-items-center no-gutters">
            <div class="form__mix col">
				  <form action="products">     
              <input class="form__input form__input--square newsearch" type="text" name="keyword" value="{if !empty($keyword)}{$keyword|escape}{/if}" autocomplete="off" placeholder="Введите название или артикул">
              <button class="form__mix-icon" type="submit"><i class="icon-search"></i></button>
              </form> 
            </div>
          </div>
        </div>
        <div class="mobile-bar jsMobileBarContent">
          <div class="align--right"><a class="link--dark row align-items-center no-gutters justify-content-end" href=""><small><b>Войти в кабинет</b></small><i class="margin--left-5 icon-login"></i></a></div>
          <ul class="list--unstyled mobile-bar__menu">
				{get_pages var="menu_top" menu_id="1"}
				{if $menu_top}
						{foreach $menu_top as $p}
							<li {if $page && $page->id == $p->id}class="is--active"{/if}>
								<a data-page="{$p->id}" href="{$p->url}" title="{$p->name|escape}">{$p->name|escape}</a>
							</li>
						{/foreach}
				{/if}
          </ul>
        </div>
        <nav class="site-menu hidden--md hidden--sm">
          <ul class="list--unstyled">
            <li><a href="./">Главная</a></li>
            <li class="site-menu__catalog"><a class="jsCatalogMenu" href="products"><i class="icon-list"></i>Каталог</a>
							{function name=categories_tree_top level=1}
							<ul{if $level == 1} class="site-menu__dropdown-list"{/if}>
								{foreach $categories as $c}
									{if $c->visible}
									<li>
										<a title="{$c->name|escape}" href="catalog/{$c->url}">
											{$c->name|escape}
											{if !empty($c->subcategories)}
											{if $mobile}</a><div class="site-menu__slide-icon jsCatalogMenuTogglebtn"><i class="icon-down-arrow"></i></div>
											{else}<span class="icon-right-chevron"></span></a>
											{/if}
										{else}</a>{/if}
										{if !empty($c->subcategories)}
											{categories_tree_top categories=$c->subcategories level=$level+1}
										{/if}
									</li>
									{/if}
								{/foreach}
							</ul>
							{/function}
							{categories_tree_top categories=$categories}
            </li>
				{get_pages var="menu_top" menu_id="1"}
				{if $menu_top}
						{foreach $menu_top as $p}
							<li {if $page && $page->id == $p->id}class="is--active"{/if}>
								<a data-page="{$p->id}" href="{$p->url}" title="{$p->name|escape}">{$p->name|escape}</a>
							</li>
						{/foreach}
				{/if}
          </ul>
        </nav>
        <nav class="site-menu visible--md visible--sm hidden--lg">
          <ul class="list--unstyled">
            <li class="site-menu__catalog"><a class="jsCatalogMenu" href="javascript:void(0);"><i class="icon-list"></i>Каталог</a>
              {categories_tree_top categories=$categories mobile=1}              
            </li>
            {* if $menu_top}
						{foreach $menu_top as $p}
							<li {if $page && $page->id == $p->id}class="is--active"{/if}>
								<a data-page="{$p->id}" href="{$p->url}" title="{$p->name|escape}">{$p->name|escape}</a>
							</li>
						{/foreach}
				{/if*}
          </ul>
        </nav>
      </div>
    </header>
    <!-- Контент-->
    <main class="site-main">
      <div class="container">
        {if $module == 'MainView'}
        {$content}
        {else}
        <div class="section">
        <div class="row">
        <div class="col-lg-3">
        {include file='filter.tpl'}
        </div>
        <div class="col-lg-9">
        {$content}
        </div>
        </div>
        </div>
        {/if}
      </div>
    </main>
    <!-- Footer-->
    <footer class="site-footer align--md-center">
      <div class="container"> 
        <div class="site-footer__top">
          <div class="row align-items-center justify-content-between">
            <div class="col-md-4">
              <ul class="list--unstyled">
                <li><a href="">+7 (495) 204 29 40 </a></li>
                <li><a href="">+7 (903) 740 99 00</a></li>
                <li><a href="">+7 (499) 350 22 06</a></li>
              </ul>
            </div>
            <div class="col-md-4 align--center margin--y-md-20">
              <div class="logo"><a href="index.html">
                  <image class="img--responsive" src="design/{$settings->theme|escape}/images/logo-white.png" alt="Ай Карнавал"></image></a></div>
            </div>
            <div class="col-md-4 align--right align--md-center">
              <ul class="list--unstyled">
                <li>Филиал в Санкт-Петербурге:</li>
                <li><a href="">+7 (812) 603 71 09</a></li>
                <li><a href="">info@icarnival.ru</a></li>
              </ul>
            </div>
          </div>
        </div>
        <div class="site-footer__bottom"> 
          <div class="row align-items-center">
            <div class="col-md-3">
              <ul class="list--unstyled site-footer__list-social list-social row no-gutters">
                <li><a href=""><i class="icon-youtube"></i></a></li>
                <li><a href=""><i class="icon-instagram"></i></a></li>
                <li><a href=""><i class="icon-twitter"></i></a></li>
                <li><a href=""><i class="icon-vk"></i></a></li>
                <li><a href=""><i class="icon-facebook"></i></a></li>
                <li><a href=""><i class="icon-odnoklassniki"></i></a></li>
              </ul>
            </div>
            <div class="col-md-6 align--center"><small>
                 © 2012-2019 ICARNIVAL.RU - интернет-магазин карнавальных костюмов и аксессуаров.<br>Все права защищены.</small></div>
            <div class="col-3 hidden--sm hidden--md">
              <div class="row row--x-indent-5 justify-content-end">
                <div class="col-item"><img src="design/{$settings->theme|escape}/images/rights/3.png" alt=""></div>
                <div class="col-item"><img src="design/{$settings->theme|escape}/images/rights/2.png" alt=""></div>
                <div class="col-item"><img src="design/{$settings->theme|escape}/images/rights/1.png" alt=""></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </footer>
    <div class="blockout"></div>
    <div class="modal" id="ex1">
      <div class="modal__content" id="product_ajax">

      </div>
    </div>
    <!-- Scripts-->
    	{if $settings->popup_cart == 1}
		<script>var popup_cart = true;</script>
		{/if}
    <script src="design/{$settings->theme|escape}/js/libs.js"></script>
    <!-- Add fancyBox main JS and CSS files -->
	{*<script type="text/javascript" src="design/{$settings->theme|escape}/js/fancybox/jquery.fancybox.js?v=2.1.4"></script>
	<link rel="stylesheet" type="text/css" href="design/{$settings->theme|escape}/js/fancybox/jquery.fancybox.css?v=2.1.4" media="screen" />*}
	<script type="text/javascript" src="design/{$settings->theme|escape}/plugins/fancybox3/jquery.fancybox.js"></script>
	<link rel="stylesheet" href="design/{$settings->theme|escape}/plugins/fancybox3/jquery.fancybox.css" type="text/css" media="screen" />
	<script type="text/javascript" src="js/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    <script src="design/{$settings->theme|escape}/js/common.js"></script>
    	<script>

		$(function() {
			$(".zoom").fancybox({ 'hideOnContentClick' : true });
			//$("a.zoom").fancybox();
			//$(".zoom1").fancybox({ 'hideOnContentClick' : false, speedIn : 10, speedOut : 10, changeSpeed : 10});
		});
	</script>
		{*  price slider  *}
		{if $minCost<$maxCost}
			<script>
			$(function() {
	(function singleProductThumbSlider (){

		var stepsSlider = document.getElementById('steps-slider');
		var input0 = document.getElementById('minCurr');
		var input1 = document.getElementById('maxCurr');
		var inputs = [input0, input1];

		noUiSlider.create(stepsSlider, {
		    start: [{$minCurr}, {$maxCurr}],
		    connect: true,
		    step: 1,
		    range: {
		        'min': {$minCost},
		        'max': {$maxCost}
		    }
		});

		stepsSlider.noUiSlider.on('update', function (values, handle) {
		    inputs[handle].value = values[handle];
		    //inputs[handle].val(values[handle]).trigger('change');
		    
		});
		stepsSlider.noUiSlider.on('end', function (values, handle) {
		    $('#cfeatures form').submit();
		    
		});

	})();

});			
			</script>
			{/if}	
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
	{if !empty($settings->consultant)}
		<script id="rhlpscrtg" type="text/javascript" charset="utf-8" async="async" 
			src="https://web.redhelper.ru/service/main.js?c={$settings->consultant|escape}">
		</script> 
	{/if}
	{* OnlineChat end *}
	{if !empty($settings->script_footer)}{$settings->script_footer}{/if}
		<svg style="display:none;"> <symbol id="arrow" viewBox="0 0 24 24"> <path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"/> <path d="M0-.25h24v24H0z" fill="none"/> </symbol> <symbol id="uncheckedconf" viewBox="0 0 24 24"> <path d="M19 5v14H5V5h14m0-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/> <path d="M0 0h24v24H0z" fill="none"/> </symbol> <symbol id="checkedconf" viewBox="0 0 24 24"> <path d="M0 0h24v24H0z" fill="none"/> <path d="M19 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.11 0 2-.9 2-2V5c0-1.1-.89-2-2-2zm-9 14l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/> </symbol> <symbol id="antibotchecked" viewBox="0 0 24 24"> <path fill="none" d="M0 0h24v24H0z"/> <path d="M9 16.2L4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4L9 16.2z"/> </symbol> <symbol id="no_photo" viewBox="0 0 24 24"> <circle cx="12" cy="12" r="3.2"></circle> <path d="M9 2L7.17 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2h-3.17L15 2H9zm3 15c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5z"></path> <path d="M0 0h24v24H0z" fill="none"></path> </symbol> <symbol id="calendar" viewBox="0 0 24 24"> <path d="M9 11H7v2h2v-2zm4 0h-2v2h2v-2zm4 0h-2v2h2v-2zm2-7h-1V2h-2v2H8V2H6v2H5c-1.11 0-1.99.9-1.99 2L3 20c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 16H5V9h14v11z"/> <path d="M0 0h24v24H0z" fill="none"/> </symbol> <symbol id="folder" viewBox="0 0 24 24"> <path d="M10 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z"/><path d="M0 0h24v24H0z" fill="none"/> </symbol> <symbol id="views" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0V0z"/><path d="M16.24 7.75c-1.17-1.17-2.7-1.76-4.24-1.76v6l-4.24 4.24c2.34 2.34 6.14 2.34 8.49 0 2.34-2.34 2.34-6.14-.01-8.48zM12 1.99c-5.52 0-10 4.48-10 10s4.48 10 10 10 10-4.48 10-10-4.48-10-10-10zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8z"/> </symbol> <symbol id="comments_count" viewBox="0 0 24 24"> <path d="M9,22A1,1 0 0,1 8,21V18H4A2,2 0 0,1 2,16V4C2,2.89 2.9,2 4,2H20A2,2 0 0,1 22,4V16A2,2 0 0,1 20,18H13.9L10.2,21.71C10,21.9 9.75,22 9.5,22V22H9M10,16V19.08L13.08,16H20V4H4V16H10M17,11H15V9H17V11M13,11H11V9H13V11M9,11H7V9H9V11Z" /> </symbol> <symbol id="arrow-rounded-left-7x11" viewBox="0 0 7 11"><path d="M6.7.3c-.4-.4-.9-.4-1.3 0L0 5.5l5.4 5.2c.4.4.9.3 1.3 0 .4-.4.4-1 0-1.3l-4-3.9 4-3.9c.4-.4.4-1 0-1.3z"></path> </symbol> <symbol id="arrow-rounded-right-7x11" viewBox="0 0 7 11"><path d="M.3 10.7c.4.4.9.4 1.3 0L7 5.5 1.6.3C1.2-.1.7 0 .3.3c-.4.4-.4 1 0 1.3l4 3.9-4 3.9c-.4.4-.4 1 0 1.3z"></path> </symbol>
				<symbol id="activec" viewBox='0 0 24 24'> <path d='M12 6v3l4-4-4-4v3c-4.42 0-8 3.58-8 8 0 1.57.46 3.03 1.24 4.26L6.7 14.8c-.45-.83-.7-1.79-.7-2.8 0-3.31 2.69-6 6-6zm6.76 1.74L17.3 9.2c.44.84.7 1.79.7 2.8 0 3.31-2.69 6-6 6v-3l-4 4 4 4v-3c4.42 0 8-3.58 8-8 0-1.57-.46-3.03-1.24-4.26z'/> <path d='M0 0h24v24H0z' fill='none'/> </symbol> <symbol id="basec" viewBox="0 0 24 24"> <path d="M19 8l-4 4h3c0 3.31-2.69 6-6 6-1.01 0-1.97-.25-2.8-.7l-1.46 1.46C8.97 19.54 10.43 20 12 20c4.42 0 8-3.58 8-8h3l-4-4zM6 12c0-3.31 2.69-6 6-6 1.01 0 1.97.25 2.8.7l1.46-1.46C15.03 4.46 13.57 4 12 4c-4.42 0-8 3.58-8 8H1l4 4 4-4H6z"/> <path d="M0 0h24v24H0z" fill="none"/> </symbol> <symbol id="activew" viewBox='0 0 24 24'> <path d='M0 0h24v24H0z' fill='none'/> <path d='M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z'/> </symbol> <symbol id="basew" viewBox='0 0 24 24'> <path d='M0 0h24v24H0z' fill='none'/> <path d='M16.5 3c-1.74 0-3.41.81-4.5 2.09C10.91 3.81 9.24 3 7.5 3 4.42 3 2 5.42 2 8.5c0 3.78 3.4 6.86 8.55 11.54L12 21.35l1.45-1.32C18.6 15.36 22 12.28 22 8.5 22 5.42 19.58 3 16.5 3zm-4.4 15.55l-.1.1-.1-.1C7.14 14.24 4 11.39 4 8.5 4 6.5 5.5 5 7.5 5c1.54 0 3.04.99 3.57 2.36h1.87C13.46 5.99 14.96 5 16.5 5c2 0 3.5 1.5 3.5 3.5 0 2.89-3.14 5.74-7.9 10.05z'/> </symbol>
				
	</svg>	
</body>
</html>
