{* Вкладки *}
{capture name=tabs}
	<li><a href="index.php?module=BannersAdmin&do=groups">{$tr->banners_groups|escape}</a></li>
{/capture}

{* Title *}
{$meta_title = $tr->add|cat:' / '|cat:$tr->edit_group scope=root}

<div id="onecolumn">
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->

	<link href="design/css/banners.css" rel="stylesheet" type="text/css" />
	
	{if !empty($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span>{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success|escape}{/if}</span>
		{if !empty($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}

	{if !empty($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span>{if $message_error=='empty_name'}{$tr->enter_s_name|escape}{else}{$message_error|escape}{/if}</span>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if empty($message_success)}
	<form method=post enctype="multipart/form-data">
		<div class="cell group">
			<div class="banner_wrapper">
				<div class="group title"><a href="#">{if $action == 'add'}{$tr->add_group|escape}{else}{$tr->edit_group|escape} {if !empty($group->name)}"{$group->name}"{/if}{/if}</a></div>
				<form method="get">
					<input type=hidden name="session_id" value="{$smarty.session.id}">
					<div style="padding:10px 0;">
						<label for="group_name" class="property">{$tr->name|escape}:</label>&nbsp;&nbsp;&nbsp;<input type="text" style="width:300px;" value="{if !empty($group->name)}{$group->name}{/if}" name="name">
					</div>
					<div class="tip">
						<input type="submit" style="float:none;" value="{if $action == 'add'}{$tr->save|escape}{else}{$tr->edit|escape}"{/if}" id="submit" class="button_green green button_save">
					</div>
				</form>
			</div>
		</div>
	</form>
	{/if}
</div>
