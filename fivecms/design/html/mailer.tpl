{* Вкладки *}
{capture name=tabs}
	{if in_array('users', $manager->permissions)}<li><a href="index.php?module=UsersAdmin">{$tr->buyers|escape}</a></li>{/if}
	{if in_array('groups', $manager->permissions)}<li><a href="index.php?module=GroupsAdmin">{$tr->users_groups|escape}</a></li>{/if}
    <li class="active"><a href="index.php?module=MailerAdmin">{$tr->local_mailer|escape}</a></li>
    {if in_array('maillist', $manager->permissions)}<li><a href="index.php?module=MailListAdmin">{$tr->subscribers_list|escape}</a></li>{/if}
{/capture}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

{* Title *}
{$meta_title=$tr->local_mailer|escape scope=root}
		
<div id="onecolumn">
	{if isset($message_success)}
	<!-- Системное сообщение -->
		<div class="message message_success">
			<span class="text">
			{if $message_success == 1}
				{$tr->added_to_send|escape} {$tr->found_posts|escape}: {$count_added}
			{elseif $message_success == 2}
				{if $count_added == 0}{$tr->mailing_list_cleared|escape}{else}{$tr->try_later|escape}{/if}
			{elseif $message_success == 'updated'}
				{$tr->updated}
			{else}
				{$message_success}
			{/if}
			</span>
		</div>
	<!-- Системное сообщение (The End)-->	
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span class="text">{if $message_error == 'clear_error'}{$tr->error}: {$message_error}{/if}</span>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}

	<form id="product" method="post">
	    <div class="block">
	        <h2>{$tr->settings|escape}</h2>
	        <ul class="subscribe_settings">
				<li style="max-width:800px;width:750px;"><label>{$tr->reply_to|escape}: </label><input style="width:385px;" maxlength="255" type="text" name="mails_from" value="{if $settings->mails_from}{$settings->mails_from}{else}{$settings->notify_from_email}{/if}"/></li>
				<li style="max-width:900px;width:750px;border-top:1px dashed #cccccc;padding-top:10px;"><a href="index.php?module=MailTemplatesAdmin&file=email_header.tpl" target="_blank">{$tr->email_header_edit|escape}</a></li>
				<li style="max-width:900px;width:750px;margin:10px 0;"><label>{$tr->email_geetings|escape}</label><input style="width:400px;" maxlength="510" type="text" name="mails_hello" value="{$settings->mails_hello}"/></li>
				<li style="max-width:900px;width:750px;margin:10px 0;"><label>{$tr->email_noname|escape}</label><input style="width:295px;" maxlength="510" type="text" name="mails_hello_noname" value="{$settings->mails_hello_noname}"/></li>
				<li style="max-width:900px;width:750px;border-bottom:1px dashed #cccccc;padding-bottom:10px;"><a href="index.php?module=MailTemplatesAdmin&file=email_footer.tpl" target="_blank">{$tr->email_footer_edit|escape}</a></li>
	            <li><label>{$tr->emails_limit|escape}: </label><input max="10" step="1" maxlength="2" style="width:40px;" type="number" name="mails_round" value="{if $settings->mails_round > 10}10{else}{$settings->mails_round}{/if}"/></li>
	            <li style="max-width:800px;width:750px;"><label>{$tr->emails_pause|escape}: </label><input min="6" step="1" maxlength="2" style="width:40px;" type="number" name="mails_pause" value="{if $settings->mails_pause < 6}6{else}{$settings->mails_pause}{/if}"/><div style="margin-left:30px; display: inline-block;">{$tr->total_about|escape} {86400/$settings->mails_pause} {$tr->emails_day|escape}</div></li>
	            <li><label>{$tr->email_form|escape}: </label>
					<select name="subscribe_form" class="fivecms_inp" style="width: 110px;">
						<option value='0' {if $settings->subscribe_form == '0'}selected{/if}>{$tr->hide|escape}</option>
						<option value='1' {if $settings->subscribe_form == '1'}selected{/if}>{$tr->show|escape}</option>
					</select>
				</li>
				<li><label>{$tr->auto_subscribe|escape}: </label>
					<select name="auto_subscribe" class="fivecms_inp" style="width:60px;min-width:60px;">
						<option value='0' {if $settings->auto_subscribe == '0'}selected{/if}>{$tr->no|escape}</option>
						<option value='1' {if $settings->auto_subscribe == '1'}selected{/if}>{$tr->yes|escape}</option>
					</select>
				</li>
	        </ul>
	    </div>
		<a class="bigbutton" style="float:left;margin:0 20px 0 0;" href="index.php?module=SmtpAdmin">{$tr->check_smtp|escape}</a>
		
		<p style="margin-top:10px;float:left;" class="helper"><a class="helperlink" href="#helper_cron">{$tr->how_mailing|escape}</a></p>
		<div style="display:none;">
			<div id="helper_cron" style="width:600px;padding:5px;">
				{$tr->mailing_help}
			</div>
		</div>
		
	    <div id="action" style="display:table;">
	        <input id="apply_action" class="button_green" type="submit" name="settings" value="{$tr->save_settings|escape}"/>
	    </div>

	<div style="display:table; width:100%; border-top:2px dashed #b7b4b4;height:2px; margin: 20px 0;"></div>

	{if $count_total>0}
		<div style="display:table;clear:both;width:100%;border-bottom:2px dashed #b7b4b4;margin-bottom:20px;padding-bottom:5px;">
			<div style="display:table;float:left;font-weight:700; background-color: #d6ddff; padding:9px 15px; border-radius:6px; border:1px dashed #6d6ea0;margin-bottom:15px;margin-right:50px;">{$tr->mailing_list_total|escape}: {$count_total}</div>
			<div onclick="$('#predelete').hide();$('.postdelete').show();" id="predelete" style="float:left;background-color:#505050;" class="button_green" >{$tr->mailing_list_clear|escape}</div>
			<input style="display:none;float:left;background-color:#ff0202;" id="apply_action" class="button_green postdelete" type="submit" name="delete_mailing" value="{$tr->confirm_delete|escape}"/>
		</div>
	{/if}

	    <input type="hidden" name="session_id" value="{$smarty.session.id}"/>
	    <h2>{$tr->email_subject|escape}</h2>
	    <div id="name">
		<input class="name" name=title type="text" value=""/> 
	    </div>
	    <div class="block">		
		<h2>{$tr->email_body|escape}</h2>
		<textarea name="body" class="editor_large" style="height:300px;"></textarea>
	    </div>
	    <div id="action">
	        <input id="apply_action" class="button_green" type="submit" name="mass_mailing" value="{$tr->to_mailing_list|escape}"/>
	    </div>

	</form>
</div>

