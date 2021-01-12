{capture name=tabs}
	{if in_array('promo', $manager->permissions)}<li><a href="index.php?module=PromoAdmin">{$tr->seo|escape}</a></li>{/if}
    <li class="active"><a href="index.php?module=MetadataPagesAdmin">{$tr->md_redirect|escape}</a></li>
	{if in_array('promo', $manager->permissions)}<li><a href="index.php?module=LinksAdmin">{$tr->metadata_filter|escape}</a></li>{/if}
	{if in_array('promo', $manager->permissions)}<li><a href="index.php?module=RobotsAdmin">robots.txt</a></li>{/if}
{/capture}

{* Meta-Title *}
{$meta_title=$tr->md_redirect|escape scope=root}

{* Header *}
<div id="header">
	<h1>{$tr->md_redirect|escape}</h1> 
	<a class="add" href="{url module=MetadataPageAdmin return=$smarty.server.REQUEST_URI}">{$tr->add|escape}</a>
</div>	

<div id="onecolumn">
	{$tr->md_help}
</div>

<div id="main_list" class="lines">

	<form id="list_form" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
		<ul style="margin-bottom:15px;">
			<li><label style="font-weight:700;margin-right:10px;" class="property">{$tr->allow_redirect|escape}</label>
				<select name="redirect" class="fivecms_inp" style="width: 60px;">
					<option value='0' {if $settings->redirect == '0'}selected{/if}>{$tr->no|escape}</option>
					<option value='1' {if $settings->redirect == '1'}selected{/if}>{$tr->yes|escape}</option>
				</select>
			</li>
		</ul>
		{if $metadata_pages}
			<div id="list" class="lines">	
				{foreach $metadata_pages as $metadata_page}
				<div class="row">
			 		<div class="checkbox cell">
						<input type="checkbox" name="check[]" value="{$metadata_page->id}" />				
					</div>
					<div class="name cell">
						<a href="{url module=MetadataPageAdmin id=$metadata_page->id return=$smarty.server.REQUEST_URI}">
						{if $metadata_page->h1_title}
							{$metadata_page->h1_title|escape}
						{elseif $metadata_page->meta_title}
							{$metadata_page->meta_title|escape}
						{else}
							{$tr->no_title|escape}
						{/if}
						</a>  ({$metadata_page->url|escape}) 	 			
						{if $metadata_page->redirect}<p style="margin-top:5px;">{$tr->redirect_from|escape}: <a href="{$metadata_page->redirect|escape}" target="_blank">{$metadata_page->redirect|escape}</a></p>{/if}
					</div>
					<div class="icons cell">
						<a class="preview" title="{$tr->open_on_page|escape}" href="..{$metadata_page->url}" target="_blank"></a>				
						<a class="delete"  title="{$tr->delete|escape}" href="#"></a>
					</div>
					<div class="clear"></div>
				</div>
				{/foreach}
			</div>
		{/if}
		<div id="action">
			{if $metadata_pages}
				<label id="check_all" class="dash_link">{$tr->choose_all|escape}</label>
				<span id="select">
					<select name="action">
						<option value="delete">{$tr->delete|escape}</option>
					</select>
				</span>
			{/if}
			<input id="apply_action" class="button_green" type="submit" value="{$tr->save|escape}">
		</div>
		
	</form>
</div>

<script>
$(function() {

	// Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();	
	
	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Удалить
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Подтверждение удаления
	$("form").submit(function() {
		if($('#list input[type="checkbox"][name*="check"]:checked').length>0)
			if($('select[name="action"]').val()=='delete' && !confirm('{$tr->confirm_delete}'))
				return false;	
	});
 	
});
</script>
