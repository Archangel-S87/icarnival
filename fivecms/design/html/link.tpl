{capture name=tabs}
	<li><a href="index.php?module=PromoAdmin">{$tr->seo|escape}</a></li>
    {if in_array('promo', $manager->permissions)}<li><a href="index.php?module=MetadataPagesAdmin">{$tr->md_redirect|escape}</a></li>
	<li class="active"><a href="index.php?module=LinksAdmin">{$tr->metadata_filter|escape}</a></li>{/if}
	{if in_array('promo', $manager->permissions)}<li><a href="index.php?module=RobotsAdmin">robots.txt</a></li>{/if}
{/capture}

{if !empty($link->id)}
	{if !empty($link->name)}
		{$meta_title = $link->name scope=root}
	{else}
		{$meta_title = '' scope=root}
	{/if}
{else}
	{$meta_title = $tr->new_post|escape scope=root}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

<div id="onecolumn" class="pagepage">

	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success == 'added'}{$tr->added|escape}{elseif $message_success == 'updated'}{$tr->updated|escape}{/if}</span>
		<a class="link" target="_blank" href="../pages/{$link->url}">{$tr->open_on_page|escape}</a>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
		
		<span class="share">		
			<a href="#" onClick='window.open("http://vkontakte.ru/share.php?url={$config->root_url|urlencode}/{$link->url|urlencode}&title={$link->name|urlencode}&description={$link->body|urlencode}&noparse=false","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/vk_icon.png" /></a>
			<a href="#" onClick='window.open("http://www.facebook.com/sharer.php?u={$config->root_url|urlencode}/{$link->url|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/facebook_icon.png" /></a>
			<a href="#" onClick='window.open("http://twitter.com/share?text={$link->name|urlencode}&url={$config->root_url|urlencode}/{$link->url|urlencode}&hashtags={$link->meta_keywords|replace:' ':''|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/twitter_icon.png" /></a>
		</span>
		
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span class="text">{if $message_error == 'url_exists'}{$tr->exists|escape}{/if}</span>
		<a class="button" href="">{$tr->return|escape}я</a>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
		<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<p style="font-weight:700;margin-bottom:6px;">{$tr->link_url|escape}</p>
			<input style="font-size:15px;" placeholder="{$tr->example|escape}: catalog/telefony?3%5B%5D=Android" class="name" name="src_url" type="text" value="{if !empty($link->src_url)}{$link->src_url|escape}{/if}" required /> 
			<input name=id type="hidden" value="{if !empty($link->id)}{$link->id|escape}{/if}"/> 
			<div class="checkbox">
				<input name=visible value='1' type="checkbox" id="active_checkbox" {if $link->visible}checked{/if}/> <label for="active_checkbox">{$tr->active|escape}</label>
			</div>
		</div> 
	
		<!-- Параметры страницы -->
		<div class="block">
			<ul>
				<li><label class=property>{$tr->name_menu_item|escape}</label><input name="name" class="fivecms_inp" type="text" value="{if !empty($link->name)}{$link->name|escape}{/if}" required /></li>
			</ul>
		</div>
		<!-- Параметры страницы (The End)-->
	
		<!-- Левая колонка свойств товара -->
		<div id="column_left_all_width">
				
			<!-- Параметры страницы -->
			<div class="block widelayer">
				<h2 style="margin-bottom:14px;">{$tr->page_parameters|escape}:</h2>
				<ul>
					<li style="width:100%;"><label style="width:50px;" class=property>{$tr->url|escape}</label><div style="display: inline-block;vertical-align: middle;height: 24px;margin-right:6px;" class="link_url">/pages/</div><input placeholder="{$tr->example|escape}: somepage" style="width:414px;" name="url" class="link_url" type="text" value="{if !empty($link->url)}{$link->url|escape}{/if}" required /></li>
					<li style="width:100%;"><label style="width:150px;" class=property>{$tr->meta_title|escape}</label><input id="text-count1" name="meta_title" class="fivecms_inp" type="text" value="{if !empty($link->meta_title)}{$link->meta_title|escape}{/if}" /><span style="margin-left: 5px;" id="count1"></span></li>
					<li style="width:100%;"><label style="width:150px;" class=property>{$tr->keywords|escape}</label><input name="meta_keywords" class="fivecms_inp" type="text" value="{if !empty($link->meta_keywords)}{$link->meta_keywords|escape}{/if}" /></li>
					<li style="width:100%;"><label style="width:150px;"class=property>{$tr->meta_description|escape}</label><textarea id="text-count3" style="width:400px;" maxlength="500" name="meta_description" class="fivecms_inp"/>{if !empty($link->meta_description)}{$link->meta_description|escape}{/if}</textarea><span style="margin-left: 5px;" id="count3"></span></li>
					<li style="width:100%;"><label style="width:150px;" class=property>{$tr->name_h1|escape}</label><input name="h1" class="fivecms_inp" type="text" value="{if !empty($link->h1)}{$link->h1|escape}{/if}" /></li>
				</ul>
			</div>
			<!-- Параметры страницы (The End)-->		
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
		<!-- Левая колонка свойств товара (The End)--> 
	
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />

		<div class="block layer">
			<h2>{$tr->description|escape} <span class="helper">(<a class="helperlink" href="#helper">{$tr->standart|escape}</a>)</span></h2>
			<textarea name="description"  class="editor_small">{if !empty($link->description)}{$link->description}{/if}</textarea>
			<h2 style="margin-top:15px;">{$tr->description_seo|escape}</h2>
			<textarea name="seo"  class="editor_small">{if !empty($link->seo)}{$link->seo}{/if}</textarea>
		</div>
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Основная форма (The End) -->

</div>