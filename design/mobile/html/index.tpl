<!DOCTYPE html>
<html dir="ltr" lang="ru" prefix="og: http://ogp.me/ns#">
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
	<base href="{$config->root_url}/"/>
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
	
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=yes"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>

	<!--canonical-->{if isset($canonical)}<link rel="canonical" href="{$config->root_url}{$canonical}"/>{/if}<!--/canonical-->
	{if !empty($current_page_num) && $current_page_num==2}<link rel="prev" href="{$config->root_url}{url page=null}">{/if}
	{if !empty($current_page_num) && $current_page_num>2}<link rel="prev" href="{$config->root_url}{url page=$current_page_num-1}">{/if}
	{if !empty($current_page_num) && $current_page_num<$total_pages_num}<link rel="next" href="{$config->root_url}{url page=$current_page_num+1}">{/if}
	{if !empty($current_page_num) && $current_page_num > 1}<meta name=robots content="index,follow">{/if}
	
	<meta name="theme-color" content="#{$mobtheme->colorPrimaryDark}"/>
	<style>
		#menutop{ background-color: #{$mobtheme->colorPrimary}; }
		#catalogtopbody svg{ fill: #{$mobtheme->colorSecondPrimary}; }
		#catalogtopbody a{ color:#{$mobtheme->leftMenuItem}; }
		#catalogtopbody .selected a, #catalogtopbody .filter-active, #catalogtopbody li:hover a{ color:#{$mobtheme->leftMenuItemActive}; }
		#catalogtopbody .activeli svg, #catalogtopbody li:hover svg { fill:#{$mobtheme->leftMenuIconActive}; }
		#catalogtopbody .activeli, #catalogtopbody li:hover { background-color:#{$mobtheme->backgroundAccent}; }
		#catalog svg, #cart_informer svg, #searchblock svg{ fill:#{$mobtheme->colorMain}; }
		#menutoptitle{ color:#{$mobtheme->colorMain}; }
		.badge{ background-color:#{$mobtheme->badgeBackground};border-color:#{$mobtheme->badgeBorder};color:#{$mobtheme->badgeText};}
		.maincatalog { background-color:#{$mobtheme->sliderbg|escape};color:#{$mobtheme->slidertext|escape}; }
		#content .pagination .selected, .pagination .butpag.selected, .pagination .butpag.selected:hover, .htabs a, .buttonred, #content a.buttonred, #content .logreg { background-color:#{$mobtheme->buybg|escape};color:#{$mobtheme->buytext|escape}; }
		.pagination .selected { border-color: #{$mobtheme->buybg|escape} !important; }
		.buttonred:hover, #content .logreg:hover { background-color:#{$mobtheme->buybgactive|escape};color:#{$mobtheme->buytextactive|escape}; }
		.addcompare svg, .towish svg, .purchase-remove svg, .wish-remove svg, #comparebody .delete svg, .minfo .nophoto { fill: #{$mobtheme->wishcomp|escape}; }
		.gocompare svg, .inwish svg, .purchase-remove svg:active, .wish-remove svg:active, #comparebody .delete svg:active { fill: #{$mobtheme->wishcompactive|escape}; }
		.breadcrumb { background-color:#{$mobtheme->breadbg|escape};color:#{$mobtheme->breadtext|escape}; }
		.upl-trigger-prev, a.titlecomp, .product h3, #content a, .cutmore, .blogmore, .purchasestitle a, .pagination .butpag { color: #{$mobtheme->zagolovok|escape}; }
		.tiny_products .product, .category_products .product { background-color:#{$mobtheme->zagolovokbg|escape};border: 1px solid #{$mobtheme->productborder|escape}; }
		.bonus { background-color:#{$mobtheme->ballovbg|escape}; }
		.various, .comment_form .button, #logininput, .register_form .button, .login_form .button, .feedback_form .button, .cart_form .button, #orderform .button, .checkout_button { background-color:#{$mobtheme->oneclickbg|escape} !important;color:#{$mobtheme->oneclicktext|escape} !important; }
		{if empty($mobile_app)}
			#container { z-index: 97;position: relative;top:50px;max-width:1024px;margin: 0 auto; }
			.breadcrumb { position:relative;z-index:9;top:50px; }
			#body .hidefeaturesbtn { top:90px; }
		{/if}
	</style>
	<link rel="stylesheet" type="text/css" href="design/mobile/css/style.css?v={filemtime('design/mobile/css/style.css')}"/>
	{if $module == 'SurveysView'}
		<link rel="stylesheet" type="text/css" href="design/mobile/css/survey.css?v={filemtime("design/mobile/css/survey.css")}"/>
	{/if}
	<link href="favicon.ico" rel="icon"          type="image/x-icon"/>
	<link href="favicon.ico" rel="shortcut icon" type="image/x-icon"/>
	<link href="favicon.ico" rel="apple-touch-icon">
	<meta name="format-detection" content="telephone=no">
	
	{* social *}
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
	{* social end *}
	{if !empty($settings->script_header)}{$settings->script_header}{/if}
	<script src="js/jquery/jquery-1.12.4.min.js"></script>
</head>

<body id="body" {if in_array($module, array('MainView', 'ProductsView', 'WishlistView')) || (!empty($page->url) && $page->url == 'catalog')}class="nonwhitebg"{/if}>

	{if empty($mobile_app)}
		{include file='toolbar.tpl'}
	{/if}

	{if $module != 'MainView'}
	
	<h1 id="uphere" class="breadcrumb {if $module == 'SurveysView' && empty($user->id)}blured{/if}">
		<!--h1-->
		{if !empty($h1_title)}
			{$h1_title|escape}
		{else}
			{if !empty($keyword)}Поиск по "{$keyword|escape}"
			{elseif !empty($page->header)}{$page->header|escape}
			{elseif !empty($page_name)}{$page_name|escape}
			{elseif !empty($page->name)}{$page->name|escape}
			{else}
				{if in_array($module, array('BlogView', 'ArticlesView', 'ServicesView'))}
					{if !empty($post->name)}{$post->name|escape}
					{elseif !empty($category->name)}{$category->name|escape}
					{/if}
				{elseif $module=='SurveysView'}
					{if !empty($survey->name)}{$survey->name|escape}
					{elseif !empty($category->name)}{$category->name|escape}
					{/if}
				{elseif $module=='ProductsView'}
					{if !empty($category->name)}{$category->name|escape}{/if} 
					{if !empty($brand->name)}{$brand->name|escape}{/if} 
				{elseif $module=='ProductView'}
					{if !empty($product->name)}{$product->name|escape}{/if}
				{/if}
			{/if}
		{/if}
		<!--/h1-->
	</h1>
	{/if}

	<div id="container" {if $module == 'SurveysView' && empty($user->id)}class="blured"{/if}>
		<div id="content" {if $module}class="{$module|lower}"{/if}>
			{$content}
		</div>
	</div>
	{if $module == 'CartView'}
		<script src="androidcore/baloon/js/baloon.js" type="text/javascript"></script>
	{/if}
	<script type="text/javascript" src="androidcore/core2.js?v={filemtime('androidcore/core2.js')}"></script>
	<script>
		$(function() {
			$(".zoom").fancybox({ 'hideOnContentClick' : true });
		});
		// .image_half_width open in modal
		$("img.image-half-width, .image-half-width img").click(function(){
			$.fancybox({ 'href' : $(this).attr('src') , 'hideOnContentClick' : true });
		})
	</script>

	{if $module == 'MainView'}
		<script type="text/javascript">
			$(window).load(function() { 
				var element = document.getElementById('slider');
				window.mySwipe = new Swipe(element, {
				  startSlide: 0,
				  auto: 5000,
				  draggable: true,
				  autoRestart: true,
				  continuous: true,
				  disableScroll: false,
				  stopPropagation: false,
				  callback: function(index, element) { $('.dot').removeClass('active');$('#'+index).addClass('active'); },
				  transitionEnd: function(index, element) {}
				});
			});
		</script>
		<script type="text/javascript">
			// убирание под кат
			heightt=$('.top .cutinner').height();	
			if(heightt<{$settings->cutmob}){
				$('.top.cutouter').addClass('fullheight');
				$('.top .disappear').hide();
			} else {
				$('.top.cutmore').show();
			}
			$('.cutmore').click(function() { 
				$(this).toggleText('Развернуть...', 'Свернуть...');
				$(this).prev().toggleClass('fullheight');
				$(this).prev().find('.disappear').toggle();
				if ($(this).prev().find('.disappear').is(':visible')) {
					destination = $(this).prev().offset().top;
					$('html, body').animate( { scrollTop: destination }, 0 );
				}
			});
			// убирание под кат end
		</script>
	{/if}

	{if in_array($module, array('BlogView', 'FeedbackView', 'LoginView', 'RegisterView', 'UserView', 'ProductView'))}
		<script defer src="androidcore/baloon/js/baloon.js" type="text/javascript"></script>
	{/if}

	{if $module == 'ProductsView'}
		{*<script type="text/javascript" src="androidcore/lazyload.js"></script>
		<script>
			{literal}
				$(document).ready(function () {
					$(window).load(function() {$('img.lazy').lazyload();});
				});
			{/literal}
		</script>*}

		<script src="androidcore/priceslider.js" type="text/javascript"></script>
		{if !empty($keyword) || (!empty($category->brands) && $category->brands|count>1) || !empty($features) || (isset($minCost) && isset($maxCost) && $minCost<$maxCost)}
			<div class="hidefeaturesbtn" onclick="hideFeatures(this);return false;">
				<svg viewBox="0 0 24 24">
    				<path d="M3,2H21V2H21V4H20.92L14,10.92V22.91L10,18.91V10.91L3.09,4H3V2Z" />
				</svg>
			</div>
		{/if}
		<script type="text/javascript">
			// cfeatures
			function hideFeatures(el){
				$('.hidefeaturesbtn').toggleClass('show');
				$('#features').toggleClass('show');
				$('html').removeClass('fullheight');
				$('.page-pg, .category_products, #start, .ajax_pagination').show();

				if ($(".hidefeaturesbtn").is('.show')) {
					$('html').addClass('fullheight');
					$('.page-pg, .category_products, #start, .ajax_pagination').hide();
				}
				return false;
			};		
			// убирание под кат
			heightb=$('.bottom .cutinner').height();	
			if(heightb<{$settings->cutmob}){
				$('.bottom.cutouter').addClass('fullheight');
				$('.bottom .disappear').hide();
			} else {
				$('.bottom.cutmore').show();
			}
			heightt=$('.top .cutinner').height();	
			if(heightt<{$settings->cutmob}){
				$('.top.cutouter').addClass('fullheight');
			} else {
				$('.top.cutmore').show();
				$('.top .disappear').show();
			}
			$(document).on('click', '.cutmore', function () { 
				$(this).toggleText('Развернуть...', 'Свернуть...');
				$(this).prev().toggleClass('fullheight');
				$(this).prev().find('.disappear').toggle();
				if ($(this).prev().find('.disappear').is(':visible')) {
					destination = $(this).prev().offset().top;
					$('html, body').animate( { scrollTop: destination }, 0 );
				}
			});
			// убирание под кат end
		</script>
	{/if}
	
	{if in_array($module, array('ProductsView', 'ArticlesView', 'BlogView', 'SurveysView')) && !empty($total_pages_num) && $total_pages_num > 1 }
		{* infinite ajax pagination *}
			<script type="text/javascript">
				$('.infinite_prev').show();
				var offset = 800; // start next page
				var scroll_timeout = 100; // window scroll throttle setTimeout
				{if $module == 'ProductsView'}var update_products = 1;{/if}
			</script>
			<script type="text/javascript" src="androidcore/infinite_ajax.js"></script>
		{* infinite ajax pagination end *}
	{/if}
	
	{if $module == 'ProductView'}
		<script type="text/javascript" src="androidcore/product.js"></script>
		<script src="js/rating/project.js"></script>
		<script type="text/javascript">
			$(function() { 
				$('.testRater').rater({ postHref: 'ajax/rating.php' }); 
			});
		</script>
		<script>
		// Amount change
		$(window).load(function() {
			stock=parseInt($('select[name=variant]').find('option:selected').attr('v_stock'));
			if( !$.isNumeric(stock) ){ stock = {$settings->max_order_amount|escape}; }
			$('.variants .amount').attr('data-max',stock);
		});
		$('select[name=variant]').change(function(){
			stock=parseInt($(this).find('option:selected').attr('v_stock'));
			if( !$.isNumeric(stock) ) 
				stock = {$settings->max_order_amount|escape};
			$('.variants .amount').attr('data-max',stock);
			oldamount = parseInt($('.variants .amount').val());
			if(oldamount > stock) 
				$('.variants .amount').val(stock);
		});

		$(document).ready(function() { 
			$('.minus').click(function () { 
				var $input = $(this).parent().find('.amount');
		
				var count = parseInt($input.val()) - 1;
				count = count < 1 ? 1 : count;
				if( !$.isNumeric(count) ){ count = 1; }
		
				maxamount = parseInt($('#amount .amount').attr('data-max'));
				if( !$.isNumeric(maxamount) ){ maxamount = {$settings->max_order_amount|escape}; $('#amount .amount').attr('data-max',maxamount);}
				if(count < maxamount)
					$input.val(count);
				else
					$input.val(maxamount);
		
				$input.change();
				return false;
			});
			$('.plus').click(function () { 
				var $input = $(this).parent().find('.amount');
				oldamount = parseInt($input.val());
				if( !$.isNumeric(oldamount) ){ oldamount = 1; }
		
				maxamount = parseInt($('#amount .amount').attr('data-max'));
				if( !$.isNumeric(maxamount) ){ maxamount = {$settings->max_order_amount|escape}; $('#amount .amount').attr('data-max',maxamount);}
		
				if(oldamount < maxamount)
					$input.val(oldamount + 1);
				else
					$input.val(maxamount);
				$input.change();
				return false;
			});
		});
		</script>
		<script>
			$(function() {
				$(".various").fancybox({
					'hideOnContentClick' : false,
					'hideOnOverlayClick' : false,
					'onComplete': function() { $('body').css('overflow','hidden');},
					'onClosed': function() { $('body').css('overflow','visible');}
                });
			});
		</script>
		<script defer type="text/javascript" src="js/superembed.min.js"></script>
		<script type="text/javascript">$('#tab1 iframe').addClass('superembed-force')</script>
	{/if}
	
	{if in_array($module, array('ArticlesView', 'BlogView', 'ServicesView')) && (!empty($post->images) || !empty($service->images))}
		{*<script src="js/swipebox/ios-orientationchange-fix.js"></script>*}
		<script src="js/swipebox/jquery.swipebox.min.js"></script>
		<link type="text/css" rel="stylesheet" href="js/swipebox/swipebox.css"/>
		<script>
		$(function() { 
			$(".swipebox").swipebox({ hideBarsDelay : 0 });
		});
		</script>
	{/if}

	<div class="mainloader" style="display:none;">
	    <div class="loaderspinner">
			<div class="cssload-loader">
				<div class="cssload-inner cssload-one"></div>
				<div class="cssload-inner cssload-two"></div>
				<div class="cssload-inner cssload-three"></div>
			</div>
	    </div>	
	</div>
	
	{* user forms *}
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
							<input name="f-subject" placeholder="Форма" type="hidden" value="{$form->name|escape}" />
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
	{* user forms end *}	

	{* Поддержка свайпа *}
	<script src="design/mobile/js/custom.js" type="text/javascript"></script>
	{if !empty($mobile_app)}
		{* Android *}
		{*<script type="text/javascript">
				try { 
					Phone.sendPhone("+7 (123) 4567-891");
				} catch(e) {};
		</script>*}
		<script type="text/javascript">
			try { 
				Search.sendSearch("{if $module == 'BlogView'}blog{elseif $module == 'ArticlesView'}articles{elseif $module == 'ServicesView'}services{else}{if $settings->purpose == 0}products{elseif $settings->purpose == 1}services{/if}{/if}");
			} catch(e) {};
		</script>
		{* Android @ *}
		{* Android & iOS *}
		<div id="cart_informer" style="display:none;">
			{include file='cart_informer.tpl'}
		</div>
		{* Android & iOS @*}
		{* iOS *}
		<script>
			try { 
				{*window.webkit.messageHandlers.phone.postMessage("{if $settings->phone}{$settings->phone|escape}{elseif $settings->tel}{$settings->tel|escape}{/if}");*}
				window.webkit.messageHandlers.search.postMessage("{if $module == 'BlogView'}blog{elseif $module == 'ArticlesView'}articles{elseif $module == 'ServicesView'}services{elseif $settings->purpose == 0}products{elseif $settings->purpose == 1}services{/if}");
			} catch(e) {};
		</script>
		{* iOS @ *}
	{else}
		<script>
			$(window).load(function() { 
			var swipem = new MobiSwipe("body");
			swipem.direction = swipem.HORIZONTAL;
			swipem.onswipeleft = function() {
				if ( $('#catalog').hasClass('showcat') ) {
					hideShowOverlay(this);
				}
				return!1};
			});
		</script>
	{/if}
	{if $uagent == 'ios'}
	<script>
		// Загружаем пред. страницу
		$(window).load(function() { 
			var swipem = new MobiSwipe("body");
			swipem.direction = swipem.HORIZONTAL;
			swipem.AXIS_THRESHOLD = 20; // угол отклонения
			swipem.GESTURE_DELTA = 100; // сдвиг до срабатывания
			swipem.onswiperight = function() {
				window.history.back();
				return!1};
		});
	</script>
	{/if}
	
	<div style="display:none;">
		{if $settings->counters}
			<!-- Yandex.Metrika counter --> <script type="text/javascript" > (function(m,e,t,r,i,k,a){ m[i]=m[i]||function(){ (m[i].a=m[i].a||[]).push(arguments)}; m[i].l=1*new Date();k=e.createElement(t),a=e.getElementsByTagName(t)[0],k.async=1,k.src=r,a.parentNode.insertBefore(k,a)}) (window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym"); ym({$settings->counters}, "init", { clickmap:true, trackLinks:true, accurateTrackBounce:true, webvisor:true, ecommerce:"dataLayer" }); </script> <noscript><div><img src="https://mc.yandex.ru/watch/{$settings->counters}" style="position:absolute; left:-9999px;" alt="" /></div></noscript> <!-- /Yandex.Metrika counter -->
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
	<script type="text/javascript">
	{literal}
		document.addEventListener('touchstart', function(e) {
			document.addEventListener('touchend', function(e) {
			});
		});
		$(function() {
			$("img, .pagination a, .category_products .product, a, .button, button").click(function() {
				$(this).addClass("active");
			})
		});
		$(document).ready(function () {
			$(window).load(function() { 
				$('a').removeAttr('target'); 
			});
		});
	{/literal}
	</script>
	<style>
		.comment_list li ul li, ul.stars li, #annot ul li, .description ul li, .annotation ul li, .box .main-text ul li, #content .blog-pg ul li, #content .post-pg ul li, #content .page-pg ul li, .post-annotation ul div { background:url("js/bullets/{$settings->bullet}.png") 0px 8px no-repeat transparent; }
	</style>
	
	{* svg sprite *}
	<svg style="display:none;">
		<symbol id="arrow_tool" viewBox="0 0 24 24">
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
		<symbol id="folder" viewBox="0 0 24 24">
			<path d="M10 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z"/><path d="M0 0h24v24H0z" fill="none"/>
		</symbol>
		<symbol id="hit" viewBox="0 0 24 24">
			<path d="M16.23,18L12,15.45L7.77,18L8.89,13.19L5.16,9.96L10.08,9.54L12,5L13.92,9.53L18.84,9.95L15.11,13.18L16.23,18M12,2C6.47,2 2,6.5 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2Z" />
		</symbol>
		<symbol id="new" viewBox="0 0 24 24">
			<path d="M20,4C21.11,4 22,4.89 22,6V18C22,19.11 21.11,20 20,20H4C2.89,20 2,19.11 2,18V6C2,4.89 2.89,4 4,4H20M8.5,15V9H7.25V12.5L4.75,9H3.5V15H4.75V11.5L7.3,15H8.5M13.5,10.26V9H9.5V15H13.5V13.75H11V12.64H13.5V11.38H11V10.26H13.5M20.5,14V9H19.25V13.5H18.13V10H16.88V13.5H15.75V9H14.5V14A1,1 0 0,0 15.5,15H19.5A1,1 0 0,0 20.5,14Z" />
		</symbol>
		<symbol id="lowprice" viewBox="0 0 24 24">
			<path d="M18.65,2.85L19.26,6.71L22.77,8.5L21,12L22.78,15.5L19.24,17.29L18.63,21.15L14.74,20.54L11.97,23.3L9.19,20.5L5.33,21.14L4.71,17.25L1.22,15.47L3,11.97L1.23,8.5L4.74,6.69L5.35,2.86L9.22,3.5L12,0.69L14.77,3.46L18.65,2.85M9.5,7A1.5,1.5 0 0,0 8,8.5A1.5,1.5 0 0,0 9.5,10A1.5,1.5 0 0,0 11,8.5A1.5,1.5 0 0,0 9.5,7M14.5,14A1.5,1.5 0 0,0 13,15.5A1.5,1.5 0 0,0 14.5,17A1.5,1.5 0 0,0 16,15.5A1.5,1.5 0 0,0 14.5,14M8.41,17L17,8.41L15.59,7L7,15.59L8.41,17Z" />
		</symbol>
		<symbol id="brands" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0V0z"/><path opacity=".3" d="M12 11h2v2h-2v2h2v2h-2v2h8V9h-8v2zm4 0h2v2h-2v-2zm0 4h2v2h-2v-2z"/><path d="M16 15h2v2h-2zm0-4h2v2h-2zm6-4H12V3H2v18h20V7zM6 19H4v-2h2v2zm0-4H4v-2h2v2zm0-4H4V9h2v2zm0-4H4V5h2v2zm4 12H8v-2h2v2zm0-4H8v-2h2v2zm0-4H8V9h2v2zm0-4H8V5h2v2zm10 12h-8v-2h2v-2h-2v-2h2v-2h-2V9h8v10z"/>
		</symbol>
		{if in_array($module, array('BlogView', 'ArticlesView', 'TagsView', 'MainView'))}
		<symbol id="calendar" viewBox="0 0 24 24">
			<path d="M9 11H7v2h2v-2zm4 0h-2v2h2v-2zm4 0h-2v2h2v-2zm2-7h-1V2h-2v2H8V2H6v2H5c-1.11 0-1.99.9-1.99 2L3 20c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 16H5V9h14v11z"/>
			<path d="M0 0h24v24H0z" fill="none"/>
		</symbol>
		<symbol id="views" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0V0z"/><path d="M16.24 7.75c-1.17-1.17-2.7-1.76-4.24-1.76v6l-4.24 4.24c2.34 2.34 6.14 2.34 8.49 0 2.34-2.34 2.34-6.14-.01-8.48zM12 1.99c-5.52 0-10 4.48-10 10s4.48 10 10 10 10-4.48 10-10-4.48-10-10-10zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8z"/>
		</symbol>
		<symbol id="comments_count" viewBox="0 0 24 24">
			<path d="M9,22A1,1 0 0,1 8,21V18H4A2,2 0 0,1 2,16V4C2,2.89 2.9,2 4,2H20A2,2 0 0,1 22,4V16A2,2 0 0,1 20,18H13.9L10.2,21.71C10,21.9 9.75,22 9.5,22V22H9M10,16V19.08L13.08,16H20V4H4V16H10M17,11H15V9H17V11M13,11H11V9H13V11M9,11H7V9H9V11Z" />
		</symbol>
		{/if}
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
	
	{* Ссылка на моб. приложение
	{if empty($mobile_app) && empty($smarty.cookies.appadv)}
		{include file='installapp.tpl'}
	{/if} *}

	{if !empty($settings->script_footer)}{$settings->script_footer}{/if}
	
	{* OnlineChat *}
	{if !empty($settings->consultant)}
		<script id="rhlpscrtg" type="text/javascript" charset="utf-8" async="async" 
			src="https://web.redhelper.ru/service/main.js?c={$settings->consultant|escape}">
		</script> 
	{/if}
	{* OnlineChat end *}
	
</body>
</html>
