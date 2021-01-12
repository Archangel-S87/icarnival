{include file='tinymce_init.tpl'}
{capture name=tabs}
	<li class="active"><a href="index.php?module=TriggerAdmin">{$tr->trigger} "Retail Rocket"</a></li>
{/capture}
 
{$meta_title = $tr->trigger scope=root}

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
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
		<input type=hidden name="session_id" value="{$smarty.session.id}">
	
		<div style="display:table; margin: 20px 0 15px 20px;">
		    <div style="float:left;">
		      <ul>
		        <li><label class=property>id</label><input style="margin:0 30px; width:200px;" name="trigger_id" class="fivecms_inp" type="text" value="{$settings->trigger_id|escape}" /></li>
		      </ul>
		    </div> 
		
			<input style="float:left;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
		</div>
	
	</form>
	<!-- Основная форма (The End) -->
	
	<div style="margin:20px 0 0 20px;">
		<div class="bigbutton green" onclick="window.open('https://retailrocket.ru/pricing/?refer=592c75b99872e59738983465','_blank');">{$tr->more|capitalize} {$tr->about} Retail Rocket</div>
	</div>
	
</div>

