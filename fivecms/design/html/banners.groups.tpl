{* Вкладки *}
{capture name=tabs}
	<li class="active"><a href="index.php?module=BannersAdmin&do=groups">{$tr->banners_groups|escape}</a></li>
{/capture}

{* Title *}
{$meta_title = $tr->banners_groups|escape scope=root}

<link href="design/css/banners.css" rel="stylesheet" type="text/css" />
	
	<div id="header" style="margin-bottom:0;">
		{if empty($function)}
			<a class="add" href="{url module=BannersAdmin do=groups action=add return=$smarty.server.REQUEST_URI}">{$tr->add_group|escape}</a>
		{/if}
	</div>
	{$tr->banners_instruction}
	
	{* Основная форма | Main Form *}
	{if !empty($groups)}
	<form id="list_form" method="post">
		<input type="hidden" name="session_id" value="{$smarty.session.id}">
	
		<div id="list" style="display:table;">
		{foreach $groups as $group}
			<div class="row">
				<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$group->id}"/>
				</div>
				
				<div class="cell group">
						<div class="banner_wrapper" style="cursor:pointer;" onclick="javascript:location.href='{url module=BannersAdmin do=banners group=$group->id return=$smarty.server.REQUEST_URI}';">
							<div class="group title">
								<a href="{url module=BannersAdmin do=banners group=$group->id return=$smarty.server.REQUEST_URI}">{$group->name|escape}</a>
								<span>{$tr->get_banners_group|escape} <span style="margin;0;padding:0;color:#000000">{literal}{get_banners group={/literal}{$group->id}}...</span></span>
							</div>
							{if !empty($group->banner->image)}
							<div class="banner">
								<img src="/{$config->banners_images_dir}{$group->banner->image}" alt="">
							</div>
							{/if}
							<div class="tip">
									{if !$group->banner_count}<span style="color:#b61919">{/if}{$tr->banners_in_group|escape}: {$group->banner_count}{if !$group->banner_count}</span>{/if}<br>
									{*{if $group->banner}
									{$img_url=$config->root_url|cat:'/'|cat:$config->banners_images_dir|cat:$group->banner->image}{assign var="info" value=$img_url|getimagesize}
										размер изображений баннеров:{$info.0} х {$info.1}px
									{/if}*}
							</div>
						</div>
				</div>
				<div class="icons cell">
					<a class="edit" title="{$tr->edit|escape}" href="{url module=BannersAdmin do=groups action=edit id=$group->id return=$smarty.server.REQUEST_URI}"></a>
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
$(".helper_banner").fancybox({ 'hideOnContentClick' : false, scrolling:'no' });
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

	// Удалить группу
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Подтверждение удаления
	$("form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete}{literal}'))
			return false;	
	});
});

</script>
{/literal}