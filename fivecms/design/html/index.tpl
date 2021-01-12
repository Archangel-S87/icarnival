<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<title>{$meta_title}</title>
<link href="/favicon.ico" rel="icon" type="image/x-icon"/>
<link href="/favicon.ico" rel="shortcut icon" type="image/x-icon"/>
<link href="design/css/style_min.css?v={filemtime("fivecms/design/css/style_min.css")}" rel="stylesheet" type="text/css" />
<script src="design/js/jquery/jquery.js"></script>
<script src="design/js/jquery/jquery.form.js"></script>
<script src="design/js/jquery/jquery-ui.min.js"></script>
<link rel="stylesheet" type="text/css" href="design/js/jquery/jquery-ui.css" media="screen" />
<script type="text/javascript" src="/js/jquery/jquery.fancybox-1.3.4.pack.js"></script>

<meta name="viewport" content="width=1024">

<style>
@font-face {
 font-family: 'PT Sans Narrow';
 font-style: normal;
 font-weight: 400;
 src: local('PT Sans Narrow'), local('PTSans-Narrow'), url(design/images/UyYrYy3ltEffJV9QueSi4V77J2WsOmgW1CJPQ9ZetJo.woff) format('woff');
}
@font-face {
 font-family: 'PT Sans Narrow';
 font-style: normal;
 font-weight: 700;
 src: local('PT Sans Narrow Bold'), local('PTSans-NarrowBold'), url(design/images/Q_pTky3Sc3ubRibGToTAYg-RYH0DQDesBR18_67DZ4Y.woff) format('woff');
}
</style>

{* Order notify *}
{if $settings->b8manage == '1'}
<link href="/js/notify/toastr.min.css" rel="stylesheet" type="text/css" />
<script src="/js/notify/toastr.min.js"  type="text/javascript"></script>
<script src="/js/notify/buzz.min.js"></script>
<script src="/js/notify/jsplayer.js?v=1"></script>	
<script type="text/javascript" src="/js/notify/jquery.faviconNotify.js"></script>
{/if}
{* Order notify end *}
</head>
<body class="module-{$mod|lower}">

<a id="helpicon" href="#helpermain" class='helperlink admin_bookmark'>?</a>
<a href='index.php?module=SettingsAdmin' class='admin_lang admin_bookmark' title="{$tr->lng_title|escape}">{$admin_lang}</a>
<a href='{$config->root_url}' class='admin_bookmark'>{$tr->go_to_site|escape}</a>
<div class="mainwrapper">
<!-- Page --> 
	<div id="main">
		{include file='mcatalog.tpl'}
				
		<div class="contentblock">
			<!-- Tab menu -->
			<ul id="tab_menu">
				{$smarty.capture.tabs}
			</ul>
			<!-- Tab menu (The End)-->
			
			<!-- Main part of page -->
			<div id="middle">
				{$content}
			</div>
			<!-- Main part of page (The End) --> 
			 
			<!-- Footer / Подвал сайта -->
			<div id="footer">
			<a href='http://5cms.ru/' target="_blank">5CMS</a> v21-4-1.280120
			&nbsp; &nbsp; &nbsp; {$tr->entered_as|escape} {$manager->login}.
			{if !empty($license->valid)}
				{$tr->license_valid|escape} {if $license->expiration != '*'}<span class="expirable">{$tr->to|escape} {$license->expiration|date_format:"%d.%m.%Y"}</span>{/if} {if $license->domain}{$tr->for_domain|escape} {$license->domain}{/if}.
				<a href='index.php?module=LicenseAdmin'>{$tr->license_management|escape}</a>.
			{else}
				{$tr->license_invalid|escape}. <a href='index.php?module=LicenseAdmin'>{$tr->license_management|escape}</a>.
			{/if}
			
			<a href='{$config->root_url}?logout' id="logout">{$tr->logout|escape}</a>
			</div>
			<!-- Footer / Подвал сайта (The End)--> 
		</div>
		
	</div>
	<!-- Page / Вся страница (The End)--> 

</div>

<script type="text/javascript">
{literal}
	function hideShow(el){
	$(el).toggleClass('show').siblings('div#hideCont').fadeToggle('normal');
	$('#main_menu').toggleClass('notrounded');
	return false;
	};
	
	$(".helperlink").fancybox({ 'hideOnContentClick' : false, scrolling:'no' });
{/literal}
</script>

<div style="display:none;">{include file='help_text.tpl'}{include file='help.tpl'}</div>

{if $settings->b8manage == '1'}

 <script type="text/javascript">
 {literal}
	// New orders notify start

	toastr.options.newestOnTop = true;
	toastr.options.closeButton = true;
	toastr.options.progressBar = false;
	toastr.options.extendedTimeOut = 10000;
	toastr.options.timeOut = 0;
	toastr.options.preventDuplicates = true;
	
	function time() {
		return parseInt(new Date().getTime()/1000)
	}
	
	var start_time = time(), 				// стартовое время, его будем отправлять
		count_div = $("#count_new_orders"), // объект, где располагается счетчик заказов
		count_time = 0;						// будем запоминать сколько заказов пришло	
	
	function getNewOrdersCount()  
	{  		
		$.ajax({
			type: 'POST',
			url: 'ajax/get_new_orders_count.php',
			data: {'utime': start_time},
			success: function(data){

				if (!data)
					return false;
				
				if (data.count_new > 0) {
					count_div.show().find("span").html(data.count_new);
					$.faviconNotify('/favicon.ico', data.count_new, 'br');
	
					toastr.info('<a href="index.php?module=OrdersAdmin&status=0" class="go_new_order">{/literal}{$tr->go_to_new_orders|escape} </a>', '{$tr->is_new_orders|escape}');{literal}
					$.jsPlayer.play("notice");
	
					//count_div.find("label").css("visibility","visible");
				} else {
					count_div.hide(); 
					//count_div.find("label").css("visibility","hidden");
					$.faviconNotify('/favicon.ico');
				}			
	
			},
			dataType: 'json'
		});
	}  
	
	$(document).ready(function(){  	
		//Устанавливаем счетчик новых заказов в фавикон
		var fav_count = parseInt(count_div.find("span").html());
		if (fav_count)
			$.faviconNotify('/favicon.ico', fav_count, 'br');
	
		// Как только документ загружен, начинаем по таймеру запрашивать информацию о новых заказах
		setInterval('getNewOrdersCount()',20000);  
	});  
 
 // New orders notify end
 {/literal}
 </script>
{/if}

<svg style="display:none;">
	<symbol id="delete_button" fill="#f44343" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
		<path d="M0 0h24v24H0z" fill="none"/>
		<path d="M14.59 8L12 10.59 9.41 8 8 9.41 10.59 12 8 14.59 9.41 16 12 13.41 14.59 16 16 14.59 13.41 12 16 9.41 14.59 8zM12 2C6.47 2 2 6.47 2 12s4.47 10 10 10 10-4.47 10-10S17.53 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/>
	</symbol>
</svg>

{if empty($settings->theme)}
<div class="db_err_overlay">
	<div class="db_err_wrapper">
		<div class="db_err_inner">
			<p class="db_err_title">{$tr->db_err_title|escape}</p>
			<p>{$tr->db_err_text}</p>
			<div class="button_green" onClick="document.location.reload();">{$tr->reload_page|escape}</div>
		</div>
	</div>
</div>
{/if}

</body>
</html>

{literal}
<script>
	$(function() {

		if($.browser.opera)
			$("#logout").hide();
	
		$("#logout").click( function(event) {
			event.preventDefault();

			if($.browser.msie)
			{
				try{document.execCommand("ClearAuthenticationCache");}
				catch (exception){} 
				window.location.href='/';
			}
			else
			{
				$.ajax({
					url: $(this).attr('href'),
					username: '',
					password: '',
					complete: function () {
						window.location.href='/';
					},
					beforeSend : function(req) {
						req.setRequestHeader('Authorization', 'Basic');
					}
				});
			}
		});

	});

	$("a.zoom").fancybox({ 'hideOnContentClick' : true });
</script>
{/literal}

