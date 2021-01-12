{capture name=tabs}
	{if in_array('pages', $manager->permissions)}
	{foreach from=$menus item=m}
		<li {if $m->id == $menu->id}class="active"{/if}><a style="font-size:14px;padding: 11px 10px 11px 10px;" href='index.php?module=PagesAdmin&menu_id={$m->id}'>{$m->name}</a></li>
	{/foreach}
	{/if}
{/capture}

{if !empty($page->id) && isset($page->name)}
	{$meta_title = $page->name scope=root}
{else}
	{$meta_title = $tr->new_post|escape scope=root}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

{* On document load *}
{literal}
<script>
$(function() {

	// Автозаполнение мета-тегов
	menu_item_name_touched = true;
	meta_title_touched = true;
	meta_keywords_touched = true;
	meta_description_touched = true;
	url_touched = true;
	
	if($('input[name="menu_item_name"]').val() == generate_menu_item_name() || $('input[name="name"]').val() == '')
		menu_item_name_touched = false;
	if($('input[name="meta_title"]').val() == generate_meta_title() || $('input[name="meta_title"]').val() == '')
		meta_title_touched = false;
	if($('input[name="meta_keywords"]').val() == generate_meta_keywords() || $('input[name="meta_keywords"]').val() == '')
		meta_keywords_touched = false;
	if($('textarea[name="meta_description"]').val() == generate_meta_description() || $('textarea[name="meta_description"]').val() == '')
		meta_description_touched = false;
	if($('input[name="url"]').val() == generate_url())
		url_touched = false;
		
	$('input[name="name"]').change(function() { menu_item_name_touched = true; });
	$('input[name="meta_title"]').change(function() { meta_title_touched = true; });
	$('input[name="meta_keywords"]').change(function() { meta_keywords_touched = true; });
	$('textarea[name="meta_description"]').change(function() { meta_description_touched = true; });
	$('input[name="url"]').change(function() { url_touched = true; });
	
	$('input[name="header"]').keyup(function() { set_meta(); });
});

function set_meta()
{
	if(!menu_item_name_touched)
		$('input[name="name"]').val(generate_menu_item_name());
	if(!meta_title_touched)
		$('input[name="meta_title"]').val(generate_meta_title());
	if(!meta_keywords_touched)
		$('input[name="meta_keywords"]').val(generate_meta_keywords());
	if(!meta_description_touched)
	{
		descr = $('textarea[name="meta_description"]');
		descr.val(generate_meta_description());
		descr.scrollTop(descr.outerHeight());
	}
	if(!url_touched)
		$('input[name="url"]').val(generate_url());
}

function generate_menu_item_name()
{
	name = $('input[name="header"]').val();
	return name;
}

function generate_meta_title()
{
	name = $('input[name="header"]').val();
	return name;
}

function generate_meta_keywords()
{
	name = $('input[name="header"]').val();
	return name;
}

function generate_meta_description()
{
	if( typeof tinymce != "undefined" )
	{
		return myCustomGetContent( "body" );
	}
	else
		return $('textarea[name=body]').val().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ").replace(/^\s+|\s+$/g, '').substr(0, 512);
}

function generate_url()
{
	url = $('input[name="header"]').val();
	url = url.replace(/[\s]+/gi, '-');
	url = translit(url);
	url = url.replace(/[^0-9a-z_\-]+/gi, '').toLowerCase();	
	return url;
}

function translit(str)
{
	var ru=("А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я").split("-")   
	var en=("A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch-'-'-Y-y-'-'-E-e-YU-yu-YA-ya").split("-")   
 	var res = '';
	for(var i=0, l=str.length; i<l; i++)
	{ 
		var s = str.charAt(i), n = ru.indexOf(s); 
		if(n >= 0) { res += en[n]; } 
		else { res += s; } 
    } 
    return res;  
}
</script>
{/literal}

<div id="onecolumn" class="pagepage">
	{if !empty($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success == 'added'}{$tr->added|escape}{elseif $message_success == 'updated'}{$tr->updated|escape}{/if}</span>
		<a class="link" target="_blank" href="../{$page->url}">{$tr->open_on_page|escape}</a>
		{if !empty($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
		<span class="share">		
			<a href="#" onClick='window.open("http://vkontakte.ru/share.php?url={$config->root_url|urlencode}/{$page->url|urlencode}&title={$page->name|urlencode}&description={$page->body|urlencode}&noparse=false","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/vk_icon.png" /></a>
			<a href="#" onClick='window.open("http://www.facebook.com/sharer.php?u={$config->root_url|urlencode}/{$page->url|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/facebook_icon.png" /></a>
			<a href="#" onClick='window.open("http://twitter.com/share?text={$page->name|urlencode}&url={$config->root_url|urlencode}/{$page->url|urlencode}&hashtags={$page->meta_keywords|replace:' ':''|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/twitter_icon.png" /></a>
		</span>
	
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span class="text">{if $message_error == 'url_exists'}{$tr->exists|escape}{/if}</span>
		<a class="button" href="">{$tr->return|escape}</a>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
		<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input placeholder="{$tr->enter_name|escape}" class="name" name=header type="text" value="{if !empty($page->header)}{$page->header|escape}{/if}" required/> 
			<input name=id type="hidden" value="{if !empty($page->id)}{$page->id|escape}{/if}"/> 
			<div class="checkbox">
				<input name=visible value='1' type="checkbox" id="active_checkbox" {if $page->visible}checked{/if}/> <label for="active_checkbox">{$tr->active|escape}</label>
			</div>
		</div> 
	
		<!-- Параметры страницы -->
		<div class="block">
			<ul>
				<li><label class=property>{$tr->name_menu_item|escape}</label><input name="name" class="fivecms_inp" type="text" value="{if !empty($page->name)}{$page->name|escape}{/if}" required/></li>
				<li>
					<label class=property>{$tr->menu_name|escape}</label>	
					<select name="menu_id">
					   	{foreach from=$menus item=m}
					        <option value='{$m->id}' {if $page->menu_id == $m->id}selected{/if}>{$m->name|escape}</option>
					    {/foreach}
					</select>		
				</li>
			</ul>
		</div>
		<!-- Параметры страницы (The End)-->
	
		<!-- Левая колонка свойств -->
		<div id="column_left">
				
			<!-- Параметры страницы -->
			<div class="block layer">
				<h2>{$tr->page_parameters}</h2>
				<ul>
					<li style="width: 100%;"><label style="width: 140px;" class=property>{$tr->url|escape} 
						<span class="helper">
							{if $menu->id != 18}
								(<a class="helperlink" href="#urlhelper">{$tr->reserve|escape}</a>)
							{else}
								(<a class="helperlink" href="#urlchange">?</a>)
								<svg class="locked" onClick="$(this).hide();$('.unlocked').show();$('input[name=url]').prop('readonly', false);" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M0 0h24v24H0z" fill="none"/><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/></svg>
								<svg class="unlocked" onClick="$(this).hide();$('.locked').show();$('input[name=url]').prop('readonly', true);" style="display:none;" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M0 0h24v24H0z" fill="none"/><path d="M12 17c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm6-9h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6h1.9c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm0 12H6V10h12v10z"/></svg>
							{/if}
						</span></label><div class="page_url" style="width: 5px;">/</div><input placeholder="{$tr->without_slash|escape}" {if $menu->id == 18 && !empty($page->url)}readonly{/if} style="width:394px;" name="url" class="page_url" type="text" value="{if !empty($page->url)}{$page->url|escape}{/if}" /></li>
					<li style="width: 100%;"><label style="width: 90px;" class=property>{$tr->meta_title|escape}</label><input maxlength="250" style="width: 450px;" id="text-count1" name="meta_title" class="fivecms_inp" type="text" value="{if !empty($page->meta_title)}{$page->meta_title|escape}{/if}" /><span style="margin-left: 5px;" id="count1"></span></li>
					<li style="width: 100%;"><label style="width: 90px;" class=property>{$tr->keywords|escape}</label><input maxlength="250" style="width: 450px;" id="text-count2" name="meta_keywords" class="fivecms_inp" type="text" value="{if !empty($page->meta_keywords)}{$page->meta_keywords|escape}{/if}" /><span style="margin-left: 5px;" id="count2"></span></li>
					<li style="width: 100%;"><label style="width: 90px;" class=property>{$tr->meta_description|escape}</label><textarea style="width: 450px; max-width:450px; min-width:450px; height: 50px;" maxlength="250" id="text-count3" name="meta_description" class="fivecms_inp"/>{if !empty($page->meta_description)}{$page->meta_description|escape}{/if}</textarea><span style="margin-left: 5px;" id="count3"></span></li>
				</ul>
			</div>
			<!-- Параметры страницы (The End)-->		
			<div style="display:none;">
				<div id="urlhelper" style="width:500px;">
					{$tr->reserve_help}
					<ul class="stars">
						<li>compare</li>
						<li>wishlist</li>
						<li>pages</li>
						<li>search</li>
						<li>price</li>
						<li>sitemap</li>
						<li>browsed</li>
						<li>cart</li>
						<li>order</li>
						<li>rss</li>
						<li>articles_rss</li>
						<li>sections</li>
						<li>tags</li>
					</ul>
				</div>
				<div id="urlchange" style="width:500px;">
					{$tr->change_help}
				</div>
			</div>
	
			<script type="text/javascript">
			{literal}
				$(function()
				{
				    $('#text-count3').keyup(function()
				    {
				        var curLength = $('#text-count3').val().length;
				        var remaning = curLength;
				        if (remaning < 0) remaning = 0;
				        $('#count3').html(remaning);
				    })
					$('#text-count1').keyup(function()
				    {
				        var curLength = $('#text-count1').val().length;
				        var remaning = curLength;
				        if (remaning < 0) remaning = 0;
				        $('#count1').html(remaning);
				    })
				});
			{/literal}
			</script>
				
		</div>
		<!-- Левая колонка свойств (The End)--> 
			
		<!-- Описание -->
		<div class="block layer">
			<h2>{$tr->page_text|escape} <span class="helper">(<a class="helperlink" href="#helper">{$tr->standart|escape}</a>)</span></h2>
			<textarea name="body"  class="editor_small">{if !empty($page->body)}{$page->body|escape}{/if}</textarea>
		</div>
		<!-- Описание (The End)-->
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Основная форма (The End) -->

</div>

{literal}<script type="text/javascript">(function (d, w, c) { (w[c] = w[c] || []).push(function() { try { w.yaCounter29801469 = new Ya.Metrika({id:29801469}); } catch(e) { } }); var n = d.getElementsByTagName("script")[0], s = d.createElement("script"), f = function () { n.parentNode.insertBefore(s, n); }; s.type = "text/javascript"; s.async = true; s.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//mc.yandex.ru/metrika/watch.js"; if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f, false); } else { f(); } })(document, window, "yandex_metrika_callbacks");</script><noscript><div><img src="//mc.yandex.ru/watch/29801469" style="position:absolute; left:-9999px;" alt="" /></div></noscript>{/literal}
