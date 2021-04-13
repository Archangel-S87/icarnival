{* Tabs| Вкладки *}
{capture name=tabs}
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=ImportAdmin">{$tr->import_csv|escape}</a></li>{/if}
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=ImportYmlAdmin">{$tr->import_xml|escape}</a></li>{/if}
	{if in_array('export', $manager->permissions)}<li><a href="index.php?module=ExportAdmin">{$tr->export_csv|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=BackupAdmin">{$tr->backup|escape}</a></li>	
	{if in_array('multichanges', $manager->permissions)}<li><a href="index.php?module=MultichangesAdmin">{$tr->packet|escape}</a></li>{/if}	
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=OnecAdmin">1C</a></li>{/if}
{/capture}

{$meta_title = $tr->backup scope=root}
{* Больше данного кол-ва товаров выводим предупреждение *}
{$limit_prods_backup = 10000}

{* Title | Заголовок *}
<div id="header">
	<h1>{$tr->backup|escape}</h1>
	{if isset($message_error) && $message_error == 'no_permission'}
		{* todo *}
	{else}
		<span class="fast_add" href="">{$tr->make_db_backup|escape}</span>
		<span class="products_add backupstyle" href="">{$tr->make_products_backup|escape}</span>
		<span class="prices_add backupstyle" href="">{$tr->make_prices_backup|escape}</span>
		<span class="orders_add backupstyle" href="">{$tr->make_orders_backup|escape}</span>
		<span class="settings_add backupstyle" href="">{$tr->make_settings_backup|escape}</span>
		<span class="texts_add backupstyle" href="">{$tr->make_texts_backup|escape}</span>
		<span class="users_add backupstyle" href="">{$tr->make_users_backup|escape}</span>
	{/if}
	<form id="hidden" method="post">
		<input type="hidden" name="session_id" value="{$smarty.session.id}">
		<input type="hidden" name="action" value="">
		<input type="hidden" name="name" value="">
	</form>
</div>	

{if isset($message_success)}
<!-- System message | Системное сообщение -->
<div class="message message_success">
	<span class="text">{if $message_success == 'created'}{$tr->backup_created|escape}{elseif $message_success == 'restored'}{$tr->backup_restored|escape}{elseif $message_success == 'uploaded'}{$tr->file_uploaded|escape}{/if}</span>
	{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
	{/if}
</div>
<!-- System message | Системное сообщение (The End)-->
{/if}

{if isset($message_error)}
<!-- System message | Системное сообщение -->
<div class="message message_error">
	<span class="text">
	{if $message_error == 'no_permission'}
		{$tr->no_permission|escape} {$backup_files_dir}
	{elseif $message_error == 'upload_error'}
		{$tr->upload_error|escape}
	{else}
		{$message_error}
	{/if}
	</span>
</div>
<!-- System message | Системное сообщение (The End)-->
{/if}

{if $prod_count >= $limit_prods_backup}
<!-- System message | Системное сообщение -->
<div class="message message_error">
	<span class="text">
	[{$tr->total}: {$prod_count}] {$tr->limit_prods_backup}
	</span>
</div>
<!-- System message | Системное сообщение (The End)-->
{/if}

{if $backups}
<div id="main_list">

	<form id="list_form" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">

		<div id="list">			
			{foreach $backups as $backup}
			<div class="row">
				{if isset($message_error) && $message_error != 'no_permission'}
					{* todo *}
				{else}
					<div class="checkbox cell">
						<input type="checkbox" name="check[]" value="{$backup->name}"/>				
					</div>
				{/if}
				<div class="name cell">
	 				<a href="files/backup/{$backup->name}">{$backup->name}</a>
					({if $backup->size>1024*1024}{($backup->size/1024/1024)|round:2} МБ{else}{($backup->size/1024)|round:2} КБ{/if})
				</div>
				<div class="icons cell">
					{if isset($message_error) && $message_error != 'no_permission'}
						{* todo *}
					{else}
						<a class="delete" title="{$tr->delete|escape}" href="#"></a>
					{/if}
		 		</div>
				<div class="icons cell">
					<a class="restore" title="{$tr->restore_backup|escape}" href="#"></a>
				</div>
		 		<div class="clear"></div>
			</div>
			{/foreach}
		</div>
		
		{if isset($message_error) && $message_error != 'no_permission'}
			{* todo *}
		{else}
			<div id="action">
				<label id="check_all" class="dash_link">{$tr->choose_all|escape}</label>
	
				<span id="select">
					<select name="action">
						<option value="delete">{$tr->delete|escape}</option>
					</select>
				</span>
	
				<input id="apply_action" class="button_green" type="submit" value="{$tr->save|escape}">
			</div>
		{/if}
	</form>
</div>
{/if}

<div class="block" style="display:inline-block;margin:30px 0;">	
	<h2>{$tr->upload_backup_file|escape}:</h2>
	<form method=post id=product enctype="multipart/form-data">
		<input type=hidden name="session_id" value="{$smarty.session.id}">
		<input name="file" class="import_file" type="file" />
		<input class="button_green" type="submit" name="" value="{$tr->upload|escape}" />
		<p>
			({$tr->max_file_size|escape} &mdash; {if $config->max_upload_filesize>1024*1024}{$config->max_upload_filesize/1024/1024|round:'2'} Mb{else}{$config->max_upload_filesize/1024|round:'2'} Kb{/if})
		</p>
	</form>
</div>	


{literal}
<script>
$(function() {

	// Colorise list items | Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Colorize on load | Раскрасить строки сразу
	colorize();
	
	// Choose all | Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Delete | Удалить 
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest(".row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});

	// Restore | Восстановить 
	$("a.restore").click(function() {
		file = $(this).closest(".row").find('[name*="check"]').val();
		$('form#hidden input[name="action"]').val('restore');
		$('form#hidden input[name="name"]').val(file);
		$('form#hidden').submit();
		return false;
	});

	$(".fast_add").click(function() {
	    $('form#hidden input[name="action"]').val('fast_create');
	    $('form#hidden').submit();
	    return false;
	});

	$(".settings_add").click(function() {
	    $('form#hidden input[name="action"]').val('settings');
	    $('form#hidden').submit();
	    return false;
	});
	
	$(".texts_add").click(function() {
	    $('form#hidden input[name="action"]').val('texts');
	    $('form#hidden').submit();
	    return false;
	});
	
	$(".users_add").click(function() {
	    $('form#hidden input[name="action"]').val('users');
	    $('form#hidden').submit();
	    return false;
	});
	
	$(".prices_add").click(function() {
	    $('form#hidden input[name="action"]').val('prices');
	    $('form#hidden').submit();
	    return false;
	});
	
	$(".orders_add").click(function() {
	    $('form#hidden input[name="action"]').val('orders');
	    $('form#hidden').submit();
	    return false;
	});
	
	$(".products_add").click(function() {
	    $('form#hidden input[name="action"]').val('products');
	    $('form#hidden').submit();
	    return false;
	});

	// Create backup | Создать бекап 
	$("a.add").click(function() {
		$('form#hidden input[name="action"]').val('create');
		$('form#hidden').submit();
		return false;
	});

	$("form#hidden").submit(function() {
		if($('input[name="action"]').val()=='restore' && !confirm('{/literal}{$tr->confirm_restore|escape}{literal}'))
			return false;	
	});
	
	$("form#list_form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
			return false;	
	});
	
});

</script>
{/literal}
