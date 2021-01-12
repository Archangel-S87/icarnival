{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main}</a></li>{/if}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SetCatAdmin">{$tr->settings_cat}</a></li>{/if}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SetModAdmin">{$tr->settings_modules}</a></li>{/if}
	<li class="active"><a href="index.php?module=SocialAdmin">{$tr->social}</a></li>
{/capture}
 
{$meta_title = $tr->social scope=root}

<div id="onecolumn" class="triggerpage">

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
	
	{$tr->social_helper}
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
		<input type=hidden name="session_id" value="{$smarty.session.id}">
				
		<div style="display:table; margin: 20px 0 15px 20px;">
		    <div style="float:left;">
		      <ul>
		        <li style="margin-bottom:10px;"><label style="width:80px;display:inline-block;" class=property>Twitter</label><input style="margin:0 30px; width:500px;" name="twitter" class="fivecms_inp" type="text" value="{$settings->twitter|escape}" /></li>
		        <li style="margin-bottom:10px;"><label style="width:80px;display:inline-block;" class=property>Google+</label><input style="margin:0 30px; width:500px;" name="google" class="fivecms_inp" type="text" value="{$settings->google|escape}" /></li>
		        <li style="margin-bottom:10px;"><label style="width:80px;display:inline-block;" class=property>Facebook</label><input style="margin:0 30px; width:500px;" name="facebook" class="fivecms_inp" type="text" value="{$settings->facebook|escape}" /></li>
		        <li style="margin-bottom:10px;"><label style="width:80px;display:inline-block;" class=property>Youtube</label><input style="margin:0 30px; width:500px;" name="youtube" class="fivecms_inp" type="text" value="{$settings->youtube|escape}" /></li>
		        <li style="margin-bottom:10px;"><label style="width:80px;display:inline-block;" class=property>VKontakte</label><input style="margin:0 30px; width:500px;" name="vk" class="fivecms_inp" type="text" value="{$settings->vk|escape}" /></li>
		        <li style="margin-bottom:10px;"><label style="width:80px;display:inline-block;" class=property>Instagram</label><input style="margin:0 30px; width:500px;" name="insta" class="fivecms_inp" type="text" value="{$settings->insta|escape}" /></li>
				<li style="margin-bottom:10px;"><label style="width:80px;display:inline-block;" class=property>Viber</label><input style="margin:0 30px; width:500px;" name="viber" class="fivecms_inp" type="text" value="{$settings->viber|escape}" placeholder="{$tr->example} 71234567890"/></li>
				<li style="margin-bottom:10px;"><label style="width:80px;display:inline-block;" class=property>Whatsapp</label><input style="margin:0 30px; width:500px;" name="whatsapp" class="fivecms_inp" type="text" value="{$settings->whatsapp|escape}" placeholder="{$tr->example} 71234567890"/></li>
				<li style="margin-bottom:10px;"><label style="width:80px;display:inline-block;" class=property>Одноклассники</label><input style="margin:0 30px; width:500px;" name="odnoklassniki" class="fivecms_inp" type="text" value="{$settings->odnoklassniki|escape}" /></li>
				<li style="margin-bottom:10px;"><label style="width:80px;display:inline-block;" class=property>Telegram</label><input style="margin:0 30px; width:500px;" name="telegram" class="fivecms_inp" type="text" value="{$settings->telegram|escape}" /></li>
		      </ul>
		    </div> 
		
			<input style="float:left;" class="button_green button_save" type="submit" name="save" value="{$tr->save}" />
		</div>
	
	</form>
	<!-- Основная форма (The End) -->
</div>
