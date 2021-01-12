{capture name=tabs}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobthemeAdmin">{$tr->gamma_mob|escape}</a></li>{/if}
	{if in_array('slides', $manager->permissions)}<li><a href="index.php?module=SlidesmAdmin">{$tr->slider_mob|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=MobsetAdmin">{$tr->settings_mob|escape}</a></li>
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobileTemplatesAdmin">{$tr->templates|escape} ({$tr->mob|escape})</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobileStylesAdmin">{$tr->styles_mob|escape}</a></li>{/if}
{/capture}
 
{$meta_title = $tr->settings_mob scope=root}

<div id="onecolumn" class="mobthemepage">

	{if isset($message_success) && $message_success == 'saved'}
		<div class="message message_success">
			<span class="text">{$tr->updated|escape}</span>
		</div>
		<script>
			//setTimeout(function(){ $('.message').fadeOut('fast') },5000); 
		</script>
	{/if}
	
	<div class="border_box" style="padding:10px;">
		<h2>{$tr->settings_mob|escape}:</h2>
		<form method=post id=product enctype="multipart/form-data">
			<input type=hidden name="session_id" value="{$smarty.session.id}" />
			
			<ul style="display:table;" class="mob_settings">
				<li>
					<label class="property" style="margin-right: 20px;">
						{$tr->hide_comments|escape}
					</label>
					<select name="hidecomment" class="fivecms_inp">
						<option value='0' {if $settings->hidecomment == '0'}selected{/if}>{$tr->no|escape}</option>
						<option value='1' {if $settings->hidecomment == '1'}selected{/if}>{$tr->yes|escape}</option>
					</select>
				</li>
				<li>
					<label class="property" style="margin-right: 20px;">
						{$tr->hide_bottom_menu|escape}
					</label>
					<select name="hidereview" class="fivecms_inp">
						<option value='0' {if $settings->hidereview == '0'}selected{/if}>{$tr->no|escape}</option>
						<option value='1' {if $settings->hidereview == '1'}selected{/if}>{$tr->yes|escape}</option>
					</select>
				</li>
				
				<li>
					<label class="property" style="margin-right: 20px;">
						{$tr->show_blog_main|escape}
					</label>
					<select name="hideblog" class="fivecms_inp">
						<option value='0' {if $settings->hideblog == '0'}selected{/if}>{$tr->no|escape}</option>
						<option value='1' {if $settings->hideblog == '1'}selected{/if}>{$tr->yes|escape}</option>
					</select>
				</li>
				
				<li><label style="max-width:500px; margin-right:10px;" class="property">{$tr->cut_height|escape}</label><input min="100" step="1" style="width: 55px;" name="cutmob" class="fivecms_inp" type="number" value="{$settings->cutmob|escape}" /> px</li>
				
				<li>
					<label class="property" style="margin-right: 20px;">
						{$tr->show_cart_wishcomp|escape}
					</label>
					<select name="show_cart_wishcomp" class="fivecms_inp">
						<option value='0' {if $settings->show_cart_wishcomp == '0'}selected{/if}>{$tr->no|escape}</option>
						<option value='1' {if $settings->show_cart_wishcomp == '1'}selected{/if}>{$tr->yes|escape}</option>
					</select>
				</li>
				
				<li><label class="property" style="margin-right: 20px;">{$tr->mob_products_num|escape}</label><input style="max-width: 50px;" name="mob_products_num" class="fivecms_inp" min="0" step="1" type="number" value="{$settings->mob_products_num|escape}" /></li>
				
				<li><label class="property" style="margin-right:20px;font-weight:700;">{$tr->mob_discount|escape}</label><input style="max-width: 40px;" name="mob_discount" class="fivecms_inp" min="0" step="1" type="number" value="{$settings->mob_discount|escape}" /> %</li>
				
			</ul>
						
			<input style="margin: 20px 0 20px 0; float:left;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
		</form>

	</div>
</div>

<style>
.mob_settings li { margin-bottom: 10px; }
.mob_settings select { min-width:initial; }
</style>
