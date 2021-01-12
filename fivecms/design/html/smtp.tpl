{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main|escape}</a></li>{/if}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SetCatAdmin">{$tr->settings_cat|escape}</a></li>{/if}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SetModAdmin">{$tr->settings_modules|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=SmtpAdmin">SMTP</a></li>
{/capture}
 
{$meta_title = "SMTP" scope=root}

<div id="onecolumn" class="promopage">

	{if isset($message_success)}
		<!-- Системное сообщение -->
		<div class="message message_success">
			<span class="text">{if $message_success == 'saved'}{$tr->updated|escape}{/if}</span>
			{if isset($smarty.get.return)}
			<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
			{/if}
		</div>
		<!-- Системное сообщение (The End)-->
	{/if}
	
	<div class="border_box" style="padding:10px;">
		<form method=post id=product enctype="multipart/form-data">
			<input type=hidden name="session_id" value="{$smarty.session.id}">
					
			<div class="block promofields">
					
				<div id="managestad" class="block">
					<h2>{$tr->email_settings}</h2>
					<div class="block layer">
						<h2>{$tr->notifications}</h2>
						<ul>
							<li><label class=property>{$tr->order_email}</label><input name="order_email" class="fivecms_inp" type="text" value="{$settings->order_email|escape}" /></li>
							<li><label class=property>{$tr->comment_email}</label><input name="comment_email" class="fivecms_inp" type="text" value="{$settings->comment_email|escape}" /></li>
							<li><label class=property>{$tr->notify_from_email}</label><input name="notify_from_email" class="fivecms_inp" type="text" value="{$settings->notify_from_email|escape}" /></li>
						</ul>
						{$tr->notify_helper}
					</div>

					<h2>{$tr->mail_templates}</h2>
					<ul style="margin-bottom:20px;">
						<li><a href="index.php?module=MailTemplatesAdmin&file=email_header.tpl" target="_blank">{$tr->email_header_edit}</a></li>
						<li><a href="index.php?module=MailTemplatesAdmin&file=email_footer.tpl" target="_blank">{$tr->email_footer_edit}</a></li>
					</ul>
				
					<h2>SMTP {$tr->settings}</h2>
					<ul>
						<li style="margin-top:15px;"><label class=property>{$tr->use} SMTP </label>
							<select name="smtp_enable" class="fivecms_inp" style="width: 60px;">
								<option value='0' {if $settings->smtp_enable == '0'}selected{/if}>{$tr->no}</option>
								<option value='1' {if $settings->smtp_enable == '1'}selected{/if}>{$tr->yes}</option>
							</select>
						</li>
						<li>
							<label class=property>SMTP server (host)</label>
							<input name="smtp_host" class="fivecms_inp" type="text" value="{$settings->smtp_host|escape}" placeholder="напр. smtp.host.ru"/>
						</li>
						<li>
							<label class=property>Port</label>
							<input name="smtp_port" class="fivecms_inp" type="text" value="{$settings->smtp_port|escape}" placeholder="напр. 2525"/>
						</li>
						<li>
							<label class=property>User</label>
							<input name="smtp_user" class="fivecms_inp" type="text" value="{$settings->smtp_user|escape}" placeholder="напр. mail@site.ru"/>
						</li>
						<li>
							<label class=property>{$tr->password}</label>
							<input name="smtp_password" class="fivecms_inp" type="text" value="{$settings->smtp_password|escape}" />
						</li>
						<li style="margin-top:10px;"><label class=property>SSL|TLS</label>
							<select name="smtp_ssl" class="fivecms_inp" style="width: 120px;">
								<option value='0' {if $settings->smtp_ssl == '0'}selected{/if}>{$tr->no}</option>
								<option value='1' {if $settings->smtp_ssl == '1'}selected{/if}>SSL</option>
								<option value='2' {if $settings->smtp_ssl == '2'}selected{/if}>TLS</option>
							</select>
						</li>
						
					</ul>
				</div>
			</div>
			<span class="button_green green smtp" style="display:table;margin:10px 0;padding: 7px 12px;">{$tr->check_connection}</span>
			<div class="smtp_status"></div>
			<div class="smtp_trace"></div>
			
			<input style="margin: 15px 0 20px 0; float:left;" class="button_green button_save" type="submit" name="save" value="{$tr->save}" />
		</form>
		<!-- Основная форма (The End) -->

		<div style="display:table;clear:both;width:100%;margin-top:10px;border-top:1px dashed #dadada;padding-top:15px;">
			<h2 style="text-transform:uppercase;margin-bottom:15px;">{$tr->smtp_samples}:</h2>
			<p><a class="bluelink" style="font-weight:700;" href="http://5cms.ru/blog/smtp-mail">{$tr->more|capitalize}...</a></p>
		</div>
	</div>

</div>

<script>
    $(document).on('click', '.smtp', function() { 
        $('.smtp_status').fadeOut(100);
        var host = $('input[name="smtp_host"]').val(),
            port   = $('input[name="smtp_port"]').val(),
            user   = $('input[name="smtp_user"]').val(),
            password   = $('input[name="smtp_password"]').val();
            ssl   = $('select[name="smtp_ssl"]').val();
        $.ajax({
            url: 'ajax/test_smtp.php',
            type: 'POST',
            data: { 
                host: host,
                port: port,
                user: user,
                password: password,
                ssl: ssl
            },
            success: function (data) { 
                $('.smtp_status').text(data.message);
                if (data.status == true) { 
                    $('.smtp_trace').text('').closest('.fn_row').addClass('hidden');
                    $('.smtp_status').removeClass('message_error').addClass('message_success');
                } else { 
                    $('.smtp_trace').html(data.trace).closest('.fn_row').removeClass('hidden');
                    $('.smtp_status').removeClass('message_success').addClass('message_error');
                }
                $('.smtp_status').fadeIn(500);
            }
        });
    });
</script>
{literal}
<style>
.smtp_status.message_error, .smtp_status.message_success{padding:10px;font-weight:700;display:table !important;margin-bottom:10px;}
</style>
{/literal}