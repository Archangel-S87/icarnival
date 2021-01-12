{capture name=tabs}
	{if in_array('users', $manager->permissions)}<li><a href="index.php?module=UsersAdmin">{$tr->buyers|escape}</a></li>{/if}
	{if in_array('groups', $manager->permissions)}<li><a href="index.php?module=GroupsAdmin">{$tr->users_groups|escape}</a></li>{/if}
    {if in_array('mailer', $manager->permissions)}<li><a href="index.php?module=MailerAdmin">{$tr->local_mailer|escape}</a></li>{/if}
    <li class="active"><a href="index.php?module=MailListAdmin">{$tr->subscribers_list|escape}</a></li>	
{/capture}

<div id="onecolumn">

	{if !empty($send->id)}
		{$meta_title = $tr->subscriber|escape scope=root}
	{else}
		{$meta_title = $tr->new_subscriber|escape scope=root}
	{/if}
	<form method=post id=product>
	<h1>{$tr->subscriber|escape}</h1>
				<div class="checkbox" style="width: 100px;float:right">
					<input name="active" value='1' type="checkbox" id="active" {if !empty($send->active)}checked{/if}/> <label for="active">{$tr->enabled|escape}</label>
				</div>
	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span>{if $message_success=='updated'}{$tr->updated|escape}{elseif $message_success=="added"}{$tr->added|escape}{else}{$message_success|escape}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span>{if $message_error=='login_exists'}{$tr->login_exists|escape}
		{elseif $message_error=='empty_name'}{$tr->empty_name|escape}
		{elseif $message_error=='empty_email'}{$tr->empty_email|escape}
		{else}{$message_error|escape}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	<!-- Основная форма -->
		
			<div style="display:table; padding: 0px 0 30px; clear: both; width:500px;">
				<input type=hidden name="session_id" value="{$smarty.session.id}">
				<h2 style="margin:10px 0;">{$tr->person_name|escape}</h2>
				<input class="name" name=name type="text" value="{if !empty($send->name)}{$send->name|escape}{/if}"/> 
				<input name=id type="hidden" value="{if !empty($send->id)}{$send->id|escape}{/if}"/> 
				<h2 style="margin:10px 0;">Email</h2>	
				<input class="name" name=email type="text" value="{if !empty($send->email)}{$send->email|escape}{/if}"/> 	
				<div id="action" style="margin-top:25px;">
					<input id="apply_action" class="button_green" type="submit" name="user_send" value="Сохранить">
				</div>
			</div>
		</form>
	<!-- Основная форма (The End) -->

</div>
