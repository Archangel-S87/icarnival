{capture name=tabs}
		<li class="active"><a href="index.php?module=LicenseAdmin">{$tr->license|escape}</a></li>
{/capture}
{$meta_title = $tr->license|escape scope=root}
<form method=post id=product enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">

	<div id="column_left" style="width:500px;">
		<div class=block>
			{if !empty($license->valid) && empty($valid)}	
			<div style="font-size:16px;font-weight:700;margin-bottom:15px;">{$tr->license|escape} {if $license->expiration != '*'}{$tr->to|escape} <span style="color:#0091d3;">{$license->expiration|date_format:"%d.%m.%Y"}</span><br />{/if} {if $license->domain}{$tr->for_domain|escape} <span style="color:#0091d3;">{$license->domain|escape}</span>{/if}</div>
			{else}
			<h2 style='color:red;'>{$tr->license_invalid|escape}</h2>
			{/if}
			<textarea name=license style='width:420px; height:100px;'>{$config->license|escape}</textarea>
		</div>
		<div class=block>	
			<input class="button_green button_save" style="float:left;" type="submit" name="" value="{$tr->save|escape}" />
		</div>
	</div>
	{if empty($license->valid)}	
	<div id="column_left" style="width:500px;">
		<div class="block" style="text-align:justify;">
			{$tr->license_warning}
		</div>
	</div>
	{/if}

	<div id="column_right" style="display:table;float:none;">
		<div class=block>
		<h2>{$tr->license_agreement_title|escape}</h2>
		<textarea style='width:420px; height:450px;'>{$tr->license_agreement_text}</textarea>
		</div>
	</div>		
</form>
