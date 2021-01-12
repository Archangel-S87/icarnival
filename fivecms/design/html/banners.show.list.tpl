{* Вкладки *}
{capture name=tabs}
	<li><a href="index.php?module=BannersAdmin&do=groups">{$tr->banners_groups|escape}</a></li>
	{if !empty($banners_group)}<li class="active"><a href="index.php?module=BannersAdmin&do=banners&group={$banners_group->id}">{$tr->group|escape} » {$banners_group->name}</a></li>{/if}
{/capture}

	{* Title *}
	{$meta_title= $tr->group|escape|cat:' » '|cat:$banners_group->name|cat:' « Управление баннерами сайта' scope=root}

	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
	
	{* Заголовок *}
	<div id="header">
		{if empty($function)}
			<a class="add" href="{url module=BannersAdmin action=add return=$smarty.server.REQUEST_URI}">{$tr->add_banner|escape}</a><br/><br/><br/>
		{/if}
		{if $banners_count}
				<h1 style="text-transform:capitalize;">{$tr->found_posts|escape}: {$banners_count}</h1>
		{else}
			<h1>{$tr->no_content|escape}</h1>
		{/if}
	</div>
	
	<link href="design/css/banners.css" rel="stylesheet" type="text/css" />
	
	{* Основная форма *}
	{if !empty($banners)}
	<form id="list_form" method="post">
		<input type="hidden" name="session_id" value="{$smarty.session.id}">
	
		<div id="list" style="display:table;">
		{foreach $banners as $banner}
		<div class="{if !$banner->visible}invisible{/if} row">
			<input type="hidden" name="positions[{$banner->id}]" value="{$banner->position}">
			<div class="move cell"><div class="move_zone"></div></div>
	 		<div class="checkbox cell">
				<input type="checkbox" name="check[]" value="{$banner->id}"/>
			</div>
			
			<div class="cell banner">
				<div class="banner_wrapper" style="cursor:pointer;" onclick="javascript:location.href='{url module=BannersAdmin action=edit id=$banner->id return=$smarty.server.REQUEST_URI}';">
					<div class="title">
						<a href="{url module=BannersAdmin action=edit id=$banner->id return=$smarty.server.REQUEST_URI}">
						{$banner->name|escape}
						</a>
					</div>
					<div class="banner">
						{if $banner->image}
						<img src="/{$banners_images_dir}{$banner->image}" alt="">
						{/if}
					</div>
					{if $banner->image}
					<div class="tip">
						{$tr->image_size|escape}: {$img_url=$config->root_url|cat:'/'|cat:$config->banners_images_dir|cat:$banner->image}
						{assign var="info" value=$img_url|getimagesize}
						{$info.0} x {$info.1}px<br />
						{$tr->link|escape}: <a href="{$banner->url}" title="">{$banner->url}</a>
						{if $banner->show_all_pages}<br/><span style="font-family:Arial;font-weight:bold;color:green;">{$tr->show_on|escape} {$tr->all_site_pages}</span>
						{else}<br />
							{if $banner->pages_count}{$tr->pages|escape}: {$banner->pages_count} | {/if}
							{if $banner->categories_count}{$tr->categories|escape}: {$banner->categories_count} | {/if}
							{if $banner->brands_count}{$tr->brands|escape}: {$banner->brands_count}{/if}
							{if !$banner->pages_count && !$banner->categories_count && !$banner->brands_count}<br/><span style="font-family:Arial;font-weight:bold;color:red">{$tr->dont_show|escape}</span>{/if}
						{/if}
					</div>
					{/if}
				</div>
			</div>
			<div class="icons cell">
				<a class="enable" title="{if $banner->visible == 1}{$tr->enabled|escape}{else}{$tr->disabled|escape}{/if}" href="#"></a>
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
		</div>
		<input style="float:left;margin-top:10px;" id="apply_action" class="button_green" type="submit" value="{$tr->save|escape}">	
	</form>
	{/if}
	
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
	
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
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();

	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Удалить товар
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Показать баннер
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest("div.row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'banner', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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

	// Подтверждение удаления
	$("form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete}{literal}'))
			return false;	
	});
});

</script>
{/literal}