{* Вкладки *}
{capture name=tabs}
	{if in_array('users', $manager->permissions)}<li><a href="index.php?module=UsersAdmin">{$tr->buyers|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=GroupsAdmin">{$tr->users_groups|escape}</a></li>		
	{if in_array('mailer', $manager->permissions)}<li><a href="index.php?module=MailerAdmin">{$tr->mailer|escape}</a></li>{/if}
{/capture}

{* Title *}
{$meta_title = $tr->users_groups|escape scope=root}

{* Заголовок *}
<div id="header">
	<h1>{$tr->users_groups|escape}</h1> 
	<a class="add" href="index.php?module=GroupAdmin">{$tr->add|escape}</a>
</div>	


<!-- Основная часть -->
<div id="main_list">

	<form id="list_form" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
	<div id="list" class="groups">
		
		{foreach $groups as $group}
		<div class="row">
		 	<div class="checkbox cell">
				<input type="checkbox" name="check[]" value="{$group->id}"/>				
			</div>
			<div class="name cell" style="width: 270px;">
				<a href="index.php?module=GroupAdmin&id={$group->id}">{$group->name}</a>
			</div>
			<div class="group_discount cell">
				{$group->discount} %
			</div>
			<div class="icons cell" style="width:70px; min-width:70px;">
				<a class="delete" title="{$tr->delete|escape}" href="#"></a>
			</div>
			<div class="clear"></div>
		</div>
		{/foreach}
	</div>

	<div id="action" style="width: 500px;">
	<label id="check_all" class="dash_link">{$tr->choose_all|escape}</label>

	<span id=select>
	<select name="action">
		<option value="delete">{$tr->delete|escape}</option>
	</select>
	</span>

	<input id="apply_action" class="button_green" type="submit" value="{$tr->save|escape}">
	</div>


	</form>

</div>


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
		
	// Подтверждение удаления
	$("form").submit(function() {
		if($('#list input[type="checkbox"][name*="check"]:checked').length>0)
			if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
				return false;	
	});
	
});

</script>
{/literal}


