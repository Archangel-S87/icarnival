{* Вкладки *}
{capture name=tabs}
	{if in_array('users', $manager->permissions)}<li><a href="index.php?module=UsersAdmin">{$tr->buyers|escape}</a></li>{/if}
	{if in_array('groups', $manager->permissions)}<li><a href="index.php?module=GroupsAdmin">{$tr->users_groups|escape}</a></li>{/if}
    {if in_array('mailer', $manager->permissions)}<li><a href="index.php?module=MailerAdmin">{$tr->local_mailer|escape}</a></li>{/if}
    <li class="active"><a href="index.php?module=MailListAdmin">{$tr->subscribers_list|escape}</a></li>
{/capture}

{* Title *}
{$meta_title=$tr->subscribers_list|escape scope=root}
		
{* Заголовок *}
<div class="headerseparator" style="margin-bottom:10px;">
	<div id="header">
		{if $mails_count}
			<h1 style="text-transform: capitalize">{$tr->found_posts|escape}: {$mails_count}</h1>
		{else}
			<h1>{$tr->no_content|escape}</h1>
		{/if}
		<a class="add" href="index.php?module=MailuserAdmin">{$tr->add_subscriber|escape}</a>
		<a class="add" href="index.php?module=ImportSubscribersAdmin">{$tr->subscribers_import|escape}</a>
		<a class="add" style="background: #ffffff url(design/images/excel_small.png) no-repeat 10px 6px;" href="index.php?module=ExportSubscribersAdmin">{$tr->subscribers_export|escape}</a>
	</div>
	{* Поиск *}
	{if $maillist || !empty($keyword)}
	<form method="get">
	<div id="search">
		<input type="hidden" name="module" value='MailListAdmin'>
		<input class="search" type="text" name="keyword" value="{$keyword|escape}" />
		<input class="search_button" type="submit" value=""/>
	</div>
	</form>
	{/if}
</div>	

{if $maillist}
<div id="main_list">
	
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
	
	<div id="sort_links" style='display:block;'>
	<!-- Ссылки для сортировки -->
	Упорядочить по 
	{if $sort!='name'}<a href="{url sort=name}">имени</a>{else}имени{/if} | 
	{if $sort!='date'}<a href="{url sort=date}">дате</a>{else}дате{/if}
	<!-- Ссылки для сортировки (The End) -->
	</div>

	<form id="form_list" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
	
		<div id="list" class="maillist">
			{foreach $maillist as $mail}
			<div class="{if !$mail->active}invisible{/if} row">
		 		<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$mail->id}"/>				
				</div>
				<div class="coupon_name cell">			 	
	 				<a href="index.php?module=MailuserAdmin&id={$mail->id}">{if $mail->name}{$mail->name}{else}{$tr->no_name|escape}{/if}</a>
				</div>
				<div class="coupon_discount cell">			 	
	 				{$mail->email}
				</div>
				<div class="coupon_details cell" style="width:152px;">			 	
	 				<div class="detail">
		 				{if $mail->created}{$mail->created}{/if}
	 				</div>
				</div>
				<div class="icons cell" >
					<span>
						<a class="enable"    title="Активен"                 href="#"></a>
						<a class="delete"    title="Удалить"                 href="#"></a>
					</span>
				</div>
				<div class="name cell" style='white-space:nowrap;'>
					
				</div>
				<div class="clear"></div>
			</div>
			{/foreach}
		</div>
		
	
		<div id="action">
		<label id="check_all" class="dash_link">{$tr->choose_all|escape}</label>
	
		<span id="select">
		<select name="action">
            <option value="enable">{$tr->make_active|escape}</option>
			<option value="disable">{$tr->make_disabled|escape}</option>
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

{* On document load *}
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
		$('#list input[type="checkbox"][name*="check"]:not(:disabled)').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:disabled):not(:checked)').length>0);
	});	
	
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest("div.row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'subscriber', 'id': id, 'values': {'active': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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