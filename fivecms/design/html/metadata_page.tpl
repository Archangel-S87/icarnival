{capture name=tabs}
	{if in_array('promo', $manager->permissions)}<li><a href="index.php?module=PromoAdmin">{$tr->seo|escape}</a></li>{/if}
    <li class="active"><a href="index.php?module=MetadataPagesAdmin">{$tr->md_redirect|escape}</a></li>
	{if in_array('promo', $manager->permissions)}<li><a href="index.php?module=LinksAdmin">{$tr->metadata_filter|escape}</a></li>{/if}
	{if in_array('promo', $manager->permissions)}<li><a href="index.php?module=RobotsAdmin">robots.txt</a></li>{/if}
{/capture}

{if isset($metadata_page->id)}
	{if $metadata_page->h1_title}
		{$meta_title = $metadata_page->h1_title scope=root}
	{elseif $metadata_page->meta_title}
		{$meta_title = $metadata_page->meta_title scope=root}
	{else}
		{$meta_title = $tr->md_redirect|escape scope=root}
	{/if}
{else}
	{$meta_title = $tr->new_post|escape scope=root}
{/if}

{include file='tinymce_init.tpl'}

{* On document load *}

<div id="onecolumn" class="pagepage">

	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span>{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success}{/if}</span>
		<a class="link" target="_blank" href="..{$metadata_page->url|escape}">{$tr->open_on_page|escape}</a>
		{if !empty($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span>{if $message_error=='url_exists'}{$tr->exists|escape}{else}{$message_error}{/if}</span>
		<a class="button" href="">{$tr->return|escape}</a>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	<!-- Основная форма -->
	    <form method=post id=product>
	        <input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input type="hidden" class="name" name=name type="text" value="{if isset($metadata_page->name)}{$metadata_page->name|escape}{/if}"/> 
			<input name=id type="hidden" value="{if isset($metadata_page->id)}{$metadata_page->id|escape}{/if}"/> 
		</div> 
		
		<!-- Левая колонка свойств -->
		<div id="column_left_all_width">
				
			<!-- Параметры страницы -->
			<div class="block widelayer">
				
				{if $settings->redirect == 1}
				<div class="redirecthelp">
					<div style="display:none;">
						<div id="redirhelp">
							{$tr->redir_help}
						</div>
					</div>
					<ul>
						<li style="width:100%;"><label style="margin-bottom:10px;" class=property>{$tr->redirect_from|escape} URL <a class="helperlink" href="#redirhelp">(?)</a></label>
							<p>{$tr->if_needed_301}</p>
							<input placeholder="{$tr->without_slash_end|escape}, {$tr->example|lower|escape}: /stores/kompyutery/nastolnye-pk" maxlength="255" name="redirect" class="fivecms_inp" type="text" value="{if isset($metadata_page->redirect)}{$metadata_page->redirect|escape}{/if}" /></li>
					</ul>
				</div>
				{/if}
				<h2>{$tr->page_parameters|escape}:</h2>
				<ul class="metablock">
					<li style="width:100%;"><label class=property>* {$tr->url|escape}</label><input required placeholder="{$tr->form_url_placeholder|escape} /dropshipping" name="url" class="fivecms_inp" type="text" value="{if isset($metadata_page->url)}{$metadata_page->url|escape}{/if}" /></li>
					<li style="width:100%;"><label class=property>{$tr->meta_title|escape}</label><input id="text-count1" maxlength="500" name="meta_title" class="fivecms_inp" type="text" value="{if isset($metadata_page->meta_title)}{$metadata_page->meta_title|escape}{/if}" /><span style="margin-left: 5px;" id="count1"></span></li>
					<li style="width:100%;"><label class=property>{$tr->keywords|escape}</label><input  maxlength="500" name="meta_keywords" class="fivecms_inp" type="text" value="{if isset($metadata_page->meta_keywords)}{$metadata_page->meta_keywords|escape}{/if}" /></li>
					<li style="width:100%;"><label class=property>{$tr->meta_description|escape}</label><textarea id="text-count3" style="width:400px;" maxlength="500" name="meta_description" class="fivecms_inp" />{if isset($metadata_page->meta_description)}{$metadata_page->meta_description|escape}{/if}</textarea><span style="margin-left: 5px;" id="count3"></span></li>
	                <li style="width:100%;"><label class=property>{$tr->name_h1|escape}</label><input maxlength="255" name="h1_title"  class="fivecms_inp" type="text" value="{if isset($metadata_page->h1_title)}{$metadata_page->h1_title|escape}{/if}" /></li>                       
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
			
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		</div>
		<!-- Левая колонка свойств (The End)--> 
		
		<!-- Описание -->
		<div class="block layer">
			<h2>{$tr->page_text|escape} <span class="helper">(<a class="helperlink" href="#helper">{$tr->standart|escape}</a>)</span></h2>
			<textarea name="description" class="editor_small">{if isset($metadata_page->description)}{$metadata_page->description|escape}{/if}</textarea>
		</div>
		<!-- Описание (The End)-->
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Основная форма (The End) -->

</div>
