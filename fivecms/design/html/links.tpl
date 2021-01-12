{* Вкладки *}
{capture name=tabs}
	<li><a href="index.php?module=PromoAdmin">{$tr->seo|escape}</a></li>
    {if in_array('promo', $manager->permissions)}<li><a href="index.php?module=MetadataPagesAdmin">{$tr->md_redirect|escape}</a></li>
	<li class="active"><a href="index.php?module=LinksAdmin">{$tr->metadata_filter|escape}</a></li>{/if}
	{if in_array('promo', $manager->permissions)}<li><a href="index.php?module=RobotsAdmin">robots.txt</a></li>{/if}
{/capture}

{* Title *}
{$meta_title = $tr->metadata_filter|escape scope=root}

{* Заголовок *}
<div id="header">
	<h1>{$tr->metadata_filter|escape}</h1>
	<a class="add" href="{url module=LinkAdmin}">{$tr->add|escape}</a>
</div>

<div id="onecolumn">
	{$tr->links_help}
</div>

{if $links}
<div id="main_list" style="width:730px;">
 
	<form id="list_form" method="post">
		<input type="hidden" name="session_id" value="{$smarty.session.id}">
		<div id="list">		
			{foreach $links as $link}
			<div class="{if !$link->visible}invisible{/if} row">
				<input type="hidden" name="positions[{$link->id}]" value="{$link->position}">
				<div class="move cell"><div class="move_zone"></div></div>
		 		<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$link->id}" />				
				</div>
				<div class="name cell">
					<a href="{url module=LinkAdmin id=$link->id return=$smarty.server.REQUEST_URI}">{$link->name|escape}</a> 
					(/pages/{$link->url})
				</div>
				<div class="icons cell">
					<a class="preview" title="{$tr->open_on_page|escape}" href="../pages/{$link->url}" target="_blank"></a>
					<a class="enable" title="{$tr->active|escape}" href="#"></a>
					<a class="delete" title="{$tr->delete|escape}" href="#"></a>
				</div>
				<div class="clear"></div>
			</div>
			{/foreach}
		</div>
	
		<div id="action">
		<label id="check_all" class="dash_link">{$tr->choose_all|escape}</label>
	
		<span id="select">
		<select name="action">
			<option value="enable">{$tr->make_visible|escape}</option>
			<option value="disable">{$tr->make_invisible|escape}</option>
			<option value="delete">{$tr->delete|escape}</option>
		</select>
		</span>
	
		<input id="apply_action" class="button_green" type="submit" value="{$tr->save|escape}">
	
		</div>
	</form>	
	
	<!-- Pagination | Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Pagination | Листалка страниц (The End) -->
	
</div>
{else}
	{$tr->no_content|escape}
{/if}

{* On document load *}
{literal}
<script>
$(function() {

	// Сортировка списка
	$("#list").sortable({
		items:             ".row",
		tolerance:         "pointer",
		handle:            ".move_zone",
		scrollSensitivity: 40,
		opacity:           0.7, 
		forcePlaceholderSize: true,
		axis: 'y',
		
		helper: function(event, ui){		
			if($('input[type="checkbox"][name*="check"]:checked').size()<1) return ui;
			var helper = $('<div/>');
			$('input[type="checkbox"][name*="check"]:checked').each(function(){
				var item = $(this).closest('.row');
				helper.height(helper.height()+item.innerHeight());
				if(item[0]!=ui[0]) {
					helper.append(item.clone());
					$(this).closest('.row').remove();
				}
				else {
					helper.append(ui.clone());
					item.find('input[type="checkbox"][name*="check"]').attr('checked', false);
				}
			});
			return helper;			
		},	
 		start: function(event, ui) {
  			if(ui.helper.children('.row').size()>0)
				$('.ui-sortable-placeholder').height(ui.helper.height());
		},
		beforeStop:function(event, ui){
			if(ui.helper.children('.row').size()>0){
				ui.helper.children('.row').each(function(){
					$(this).insertBefore(ui.item);
				});
				ui.item.remove();
			}
		},
		update:function(event, ui)
		{
			$("#list_form input[name*='check']").attr('checked', false);
			$("#list_form").ajaxSubmit(function() {
				colorize();
			});
		}
	});

 
	// Раскраска строк
	function colorize()
	{
		$(".row:even").addClass('even');
		$(".row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();
 

	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Удалить 
	$("a.delete").click(function() {
		$('#list_form input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest(".row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	

	// Показать
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'link', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				icon.removeClass('loading_icon');
				if(state)
					line.removeClass('invisible');
				else
					line.addClass('invisible');				
			},
			dataType: 'json'
		});	
		return false;	
	});


	$("form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
			return false;	
	});
});
</script>
{/literal}
