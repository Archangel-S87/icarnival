{* Вкладки *}
{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main|escape}</a></li>{/if}
	{if in_array('currency', $manager->permissions)}<li><a href="index.php?module=CurrencyAdmin">{$tr->currencies|escape}</a></li>{/if}
	{if in_array('delivery', $manager->permissions)}<li><a href="index.php?module=DeliveriesAdmin">{$tr->delivery|escape}</a></li>{/if}
	{if in_array('payment', $manager->permissions)}<li><a href="index.php?module=PaymentMethodsAdmin">{$tr->payment|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=ManagersAdmin">{$tr->managers|escape}</a></li>
	{if in_array('discountgroup', $manager->permissions)}<li><a href="index.php?module=DiscountGroupAdmin">{$tr->discounts|escape}</a></li>{/if}
{/capture}
{* Title *}
{$meta_title=$tr->managers|escape scope=root}


{* Заголовок *}
<div id="header">
	<h1>{$tr->managers|escape}</h1> 	
	<a class="add" href="index.php?module=ManagerAdmin">{$tr->add|escape}</a>
</div>

{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">
	{if $message_error=='not_writable'}{$tr->set_permissions|escape} /fivecms/.passwd
	{else}{$message_error|escape}{/if}
	</span>
	<a class="button" href="">{$tr->return|escape}</a>
</div>
<!-- Системное сообщение (The End)-->
{/if}


{if $managers}
<!-- Основная часть -->
<div id="main_list" class="managerspage">
	<form id="form_list" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
	
		<div id="list">	
			{foreach $managers as $m}
			<div class="row">
		 		<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$m->login|escape}" {if $manager->login == $m->login}disabled{/if}/>
				</div>
				<div class="user_name cell">
					<a href="index.php?module=ManagerAdmin&login={$m->login|urlencode}">{$m->login|escape}</a>
				</div>
				<div class="icons cell">
					{if $manager->login != $m->login}
					<a class="delete" title="{$tr->delete|escape}" href="#"></a>
					{/if}
				</div>
				<div class="clear"></div>
			</div>
			{/foreach}
		</div>
	
		<div id="action">
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
{/if}

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
		$('#list input[type="checkbox"][name*="check"]:not(:disabled)').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:disabled):not(:checked)').length>0);
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
			if($('select[name="action"]').val()=='delete' && !confirm('{$tr->confirm_delete|escape}'))
				return false;	
	});
});
</script>
