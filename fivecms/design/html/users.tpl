{* Вкладки *}
{capture name=tabs}
	<li class="active"><a href="index.php?module=UsersAdmin">{$tr->buyers|escape}</a></li>
	{if in_array('groups', $manager->permissions)}<li><a href="index.php?module=GroupsAdmin">{$tr->users_groups|escape}</a></li>{/if}
	{if in_array('mailer', $manager->permissions)}<li><a href="index.php?module=MailerAdmin">{$tr->mailer|escape}</a></li>{/if}
{/capture}

{* Title *}
{$meta_title=$tr->buyers scope=root}


{* Заголовок *}
<div class="headerseparator" style="margin-bottom:10px;">
	<div id="header">
		{if !empty($keyword) && !empty($users_count)}
		<h1>{$tr->found|escape} {$tr->found_buyers|lower}: {$users_count}</h1>
		{elseif !empty($users_count)}
		<h1>{$tr->found_buyers}: {$users_count}</h1> 	
		{else}
		<h1>{$tr->no_content|escape}</h1> 	
		{/if}
		
		{if !empty($users_count)}
		<form class="bigicon" method="post" action="{url module=ExportUsersAdmin}" target="_blank">
			<input type="hidden" name="session_id" value="{$smarty.session.id}">
			<input type="image" src="./design/images/export_excel.png" name="export" style="border:0;" title="{$tr->buyers_export}">
		</form>
		{/if}
		
	</div>
	{* Поиск *}
	{if !empty($users) || !empty($keyword)}
	<form method="get">
	<div id="search">
		<input type="hidden" name="module" value='UsersAdmin'>
		<input class="search" type="text" name="keyword" value="{if !empty($keyword)}{$keyword|escape}{/if}" />
		<input class="search_button" type="submit" value=""/>
	</div>
	</form>
	{/if}
</div>

{if !empty($users)}
<!-- Основная часть -->
<div id="main_list" class="userspage">

	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->

	<div id="sort_links" style='display:block;'>
	<!-- Ссылки для сортировки -->
	{$tr->sort_by}:
	{if $sort!='name'}<a href="{url sort=name}">{$tr->person_name|lower}</a>{else}{$tr->person_name|lower}{/if} | 
	{if $sort!='date'}<a href="{url sort=date}">{$tr->date|lower}</a>{else}{$tr->date|lower}{/if} | 
	{if $sort!='balance'}<a href="{url sort=balance}">{$tr->points|lower}</a>{else}{$tr->points|lower}{/if} | 
	{if $sort!='views'}<a href="{url sort=views}">{$tr->ref_visits|lower}</a>{else}{$tr->ref_visits|lower}{/if} | 
	{if $sort!='group'}<a href="{url sort=group}">{$tr->group|lower}</a>{else}{$tr->group|lower}{/if}
	<!-- Ссылки для сортировки (The End) -->
	</div>

	<form id="form_list" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
	
		<div id="list">	
			{foreach $users as $user}
			<div class="{if !$user->enabled}invisible{/if} row">
		 		<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$user->id}"/>				
				</div>
				<div class="user_name cell">
					<a href="index.php?module=UserAdmin&id={$user->id}">{$user->name|escape}</a>{if $user->ref_views} <span class="cursor_help" title="{$tr->ref_visits}">[{$user->ref_views}]</span>{/if}{if !empty($user->balance) && $user->balance != 0} <span class="cursor_help" title="{$tr->points}">({$user->balance|round} {$currency->sign})</span>{/if}	
				</div>
				<div class="user_email cell">
					<a href="mailto:{$user->name|escape}<{$user->email|escape}>">{$user->email|escape}</a>	
				</div>
				<div class="user_group cell">
					{if !empty($user->tdiscount)}{$tr->enablediscounts5} ({$user->tdiscount}%){/if} {if !empty($groups[$user->group_id]->name)}{$groups[$user->group_id]->name}{/if}{if !empty($user->discount)} ({$user->discount}%){/if}
				</div>
				<div class="icons cell">
					<a class="enable" title="{$tr->active|escape}" href="#"></a>
					<a class="delete" title="{$tr->delete|escape}" href="#"></a>
				</div>
				<div class="clear"></div>
			</div>
			{/foreach}
		</div>
	
		<div id="action">
		<label id="check_all" class="dash_link">{$tr->choose_all|escape}</label>
	
		<span id=select>
		<select name="action">
			<option value="disable">{$tr->make_invisible|escape}</option>
			<option value="enable">{$tr->make_visible|escape}</option>
			<option value="delete">{$tr->delete|escape}</option>
		</select>
		</span>
	
		<input id="apply_action" class="button_green" type="submit" value="{$tr->save|escape}">
		</div>

	</form>

	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->

</div>
{/if}

 <!-- Меню -->
<div id="right_menu">
	<ul>
		<li {if empty($group->id)}class="selected"{/if}><a href='index.php?module=UsersAdmin'>{$tr->all} {$tr->groups}</a></li>
	</ul>
	<!-- Группы -->
	{if $groups}
	<ul>
		{foreach $groups as $g}
		<li {if !empty($group->id) && $group->id == $g->id}class="selected"{/if}><a href="index.php?module=UsersAdmin&group_id={$g->id}">{$g->name}</a></li>
		{/foreach}
	</ul>
	{/if}
	<!-- Группы (The End)-->
		
</div>
<!-- Меню  (The End) -->


{literal}
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
		$(this).closest(".row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Скрыт/Видим
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'user', 'id': id, 'values': {'enabled': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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
		if($('#list input[type="checkbox"][name*="check"]:checked').length>0)
			if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_deletion|escape}{literal}'))
				return false;	
	});
});

</script>
{/literal}
