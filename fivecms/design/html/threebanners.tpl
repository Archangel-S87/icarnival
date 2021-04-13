{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main}</a></li>{/if}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SetCatAdmin">{$tr->settings_cat}</a></li>{/if}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SetModAdmin">{$tr->settings_modules}</a></li>{/if}
	<li class="active"><a href="index.php?module=ThreeBannersAdmin">{$tr->banners} {$tr->on_main_page}</a></li>
{/capture}
 
{$meta_title = "{$tr->banners} {$tr->on_main_page}" scope=root}

<div id="onecolumn" class="triggerpage threebanners">

	<!-- Системное сообщение -->
	{if isset($message_error)}
		<div class="message message_error">
			{if $message_error == 'banner_is_not_writable'}
				<span class="text">{$tr->write_error}</span>
			{elseif $message_error == 'not_allowed_extention'}
				<span class="text">{$tr->supported_formats}: .png</span>
			{/if}
			{if isset($smarty.get.return)}
				<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
			{/if}
		</div>
	{elseif isset($message_success)}
		<div class="message message_success">
			<span class="text">{if $message_success == 'saved'}{$tr->updated|escape}{/if}</span>
			{if isset($smarty.get.return)}
				<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
			{/if}
		</div>
	{/if}
	<!-- Системное сообщение (The End)-->
	{$rand=rand(10,1000000)}
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
		<input type=hidden name="session_id" value="{$smarty.session.id}">
				
		<div class="bannerslist" style="display:table; margin: 20px 0 15px 20px;">
		    
		    <ul id="slider_banners">
				<li>
					<label style="width:360px;font-weight:700;font-size:17px; margin-right:20px;" class="property">
						{$tr->banners} {if $settings->slidermode == 'sideslider'}{$tr->right_of_slider}{else}{$tr->under_slider_menu}{/if}
					</label>
					<select name="addfield2" class="fivecms_inp" style="width: 100px;{if $settings->slidermode == 'sideslider'}display:none;{/if}">
						<option value='0' {if $settings->addfield2 == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
						<option value='1' {if $settings->addfield2 == '1'}selected{/if}>{$tr->show|lower|escape}</option>
					</select>
				</li>
			</ul>
		    
			{if $settings->slidermode == 'sideslider'}
				<p style="margin:20px 0 10px 0;">{$tr->sideslider_help}</p>
			{else}
				<p style="margin:20px 0 20px 0;">{$tr->non_sideslider_help}</p>
			{/if}
			
			<div id="firstbanner" class="block layer" style="margin-top: 15px;">
				<div class="threebannerstitle">{$tr->banner} #1</div>
				<label title="{$tr->active}" class="switch switch-default ">
                    <input class="switch-input fn_ajax_action" name="bannerfirstvis" value="1" type="checkbox" {if $settings->bannerfirstvis}checked=""{/if}>
                    <span class="switch-label"></span>
                    <span class="switch-handle"></span>
                </label>
				<ul style="display: block; width: 600px; float: left; margin-bottom: 0;">
					<li><label class="property" style="max-width:70px;">{$tr->link}:</label>
						<input placeholder="{$tr->example}: /test" name="bannerfirst" class="fivecms_inp" type="text" value="{$settings->bannerfirst|escape}" />
					</li>
					<li style="width: 600px;"><label class=property>{$tr->upload} {$tr->file|lower} (.png)</label>
						<input name="banner1img_file" class="fivecms_inp" type="file" />
						{$img_url=$config->root_url|cat:'/'|cat:$config->banner1img_file|cat:'?'|cat:$rand}
						{if file_exists($config->banner1img_file)}
							{assign var="info" value=$img_url|getimagesize}
							{if !empty($info.0) && $info.0 > 0}	
								<img src="{$config->root_url}/{$config->banner1img_file}?{$rand}" />
								<div class="tip">
									{$tr->size}: {$info.0}px x {$info.1}px
								</div>
							{/if}
						{/if}	
					</li>
				</ul>
			</div>

			<div id="secondbanner" class="block layer">
				<div class="threebannerstitle">{$tr->banner} #2</div>
				
				<label title="{$tr->active}" class="switch switch-default ">
                    <input class="switch-input fn_ajax_action" name="bannersecondvis" value="1" type="checkbox" {if $settings->bannersecondvis}checked=""{/if}>
                    <span class="switch-label"></span>
                    <span class="switch-handle"></span>
                </label>
				
				<ul style="display: block; width: 600px; float: left; margin-bottom: 0;">
					<li><label class="property" style="max-width:70px;">{$tr->link}:</label>
						<input placeholder="{$tr->example}: /test" name="bannersecond" class="fivecms_inp" type="text" value="{$settings->bannersecond|escape}" />
					</li>
					<li style="width: 600px;"><label class=property>{$tr->upload} {$tr->file|lower} (.png)</label>
						<input name="banner2img_file" class="fivecms_inp" type="file" />
						{$img_url=$config->root_url|cat:'/'|cat:$config->banner2img_file|cat:'?'|cat:$rand}
						{if file_exists($config->banner2img_file)}
							{assign var="info" value=$img_url|getimagesize}
							{if !empty($info.0)}
								<img src="{$config->root_url}/{$config->banner2img_file}?{$rand}" />
								<div class="tip">
									{$tr->size}: {$info.0}px x {$info.1}px
								</div>
							{/if}
						{/if}
					</li>
				</ul>
			</div>

			<div id="thirdbanner" class="block layer">
				<div class="threebannerstitle">{$tr->banner} #3</div>
				
				<label title="{$tr->active}" class="switch switch-default ">
                    <input class="switch-input fn_ajax_action" name="bannerthirdvis" value="1" type="checkbox" {if $settings->bannerthirdvis}checked=""{/if}>
                    <span class="switch-label"></span>
                    <span class="switch-handle"></span>
                </label>
				
				<ul style="display: block; width: 600px; float: left; margin-bottom: 0;">
					<li><label class="property" style="max-width:70px;">{$tr->link}:</label>
						<input placeholder="{$tr->example}: /test" name="bannerthird" class="fivecms_inp" type="text" value="{$settings->bannerthird|escape}" />
					</li>
					<li style="width: 600px;"><label class=property>{$tr->upload} {$tr->file|lower} (.png)</label>
						<input name="banner3img_file" class="fivecms_inp" type="file" />
						{$img_url=$config->root_url|cat:'/'|cat:$config->banner3img_file|cat:'?'|cat:$rand}
						{if file_exists($config->banner3img_file)}
							{assign var="info" value=$img_url|getimagesize}
							{if !empty($info.0)}
								<img src="{$config->root_url}/{$config->banner3img_file}?{$rand}" />
								<div class="tip">
									{$tr->size}: {$info.0}px x {$info.1}px
								</div>
							{/if}
						{/if}
					</li>
				</ul>
			</div>

			<div id="fourbanner" class="block layer">
				<div class="threebannerstitle">{$tr->banner} #4</div>
				
				<label title="{$tr->active}" class="switch switch-default ">
                    <input class="switch-input fn_ajax_action" name="bannerfourvis" value="1" type="checkbox" {if $settings->bannerfourvis}checked=""{/if}>
                    <span class="switch-label"></span>
                    <span class="switch-handle"></span>
                </label>
				
				<ul style="display: block; width: 600px; float: left; margin-bottom: 0;">
					<li><label class="property" style="max-width:70px;">{$tr->link}:</label>
						<input placeholder="{$tr->example}: /test" name="bannerfour" class="fivecms_inp" type="text" value="{$settings->bannerfour|escape}" />
					</li>
					<li style="width: 600px;"><label class=property>{$tr->upload} {$tr->file|lower} (.png)</label>
						<input name="banner4img_file" class="fivecms_inp" type="file" />
						{$img_url=$config->root_url|cat:'/'|cat:$config->banner4img_file|cat:'?'|cat:$rand}
						{if file_exists($config->banner4img_file)}
							{assign var="info" value=$img_url|getimagesize}
							{if !empty($info.0)}
								<img src="{$config->root_url}/{$config->banner4img_file}?{$rand}" />
								<div class="tip">
									{$tr->size}: {$info.0}px x {$info.1}px
								</div>
							{/if}
						{/if}
					</li>
				</ul>
			</div>
			
			
			<input style="margin-top:15px; float:left;clear:both;" class="button_green button_save" type="submit" name="save" value="{$tr->save}" />
			
			<ul id="bottom_banners" class="block layer" style="margin-top: 15px;">
				<li>
					<label style="width:360px;font-weight:700;font-size:17px; margin-right:20px;" class="property">
						{$tr->banners} {$tr->under_blog}
					</label>
					<select name="bbanners" class="fivecms_inp" style="width: 100px;">
						<option value='0' {if $settings->bbanners == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
						<option value='1' {if $settings->bbanners == '1'}selected{/if}>{$tr->show|lower|escape}</option>
					</select>
				</li>
			</ul>
			
			<p style="margin:20px 0 20px 0;">{$tr->non_sideslider_help}</p>
			
			<div id="firstbbanner" class="block layer" style="margin-top: 15px;">
				<div class="threebannerstitle">{$tr->banner} #1</div>
				<label title="{$tr->active}" class="switch switch-default ">
                    <input class="switch-input fn_ajax_action" name="bbannerfirstvis" value="1" type="checkbox" {if $settings->bbannerfirstvis}checked=""{/if}>
                    <span class="switch-label"></span>
                    <span class="switch-handle"></span>
                </label>
				<ul style="display: block; width: 600px; float: left; margin-bottom: 0;">
					<li><label class="property" style="max-width:70px;">{$tr->link}:</label>
						<input placeholder="{$tr->example}: /test" name="bbannerfirst" class="fivecms_inp" type="text" value="{$settings->bbannerfirst|escape}" />
					</li>
					<li style="width: 600px;"><label class=property>{$tr->upload} {$tr->file|lower} (.png)</label>
						<input name="bbanner1img_file" class="fivecms_inp" type="file" />
						{$img_url=$config->root_url|cat:'/'|cat:$config->bbanner1img_file|cat:'?'|cat:$rand}
						{if file_exists($config->bbanner1img_file)}
							{assign var="info" value=$img_url|getimagesize}
							{if !empty($info.0)}
							<img src="{$config->root_url}/{$config->bbanner1img_file}?{$rand}" />
								<div class="tip">
									{$tr->size}: {$info.0}px x {$info.1}px
								</div>
							{/if}
						{/if}
					</li>
				</ul>
			</div>

			<div id="secondbbanner" class="block layer">
				<div class="threebannerstitle">{$tr->banner} #2</div>
				
				<label title="{$tr->active}" class="switch switch-default ">
                    <input class="switch-input fn_ajax_action" name="bbannersecondvis" value="1" type="checkbox" {if $settings->bbannersecondvis}checked=""{/if}>
                    <span class="switch-label"></span>
                    <span class="switch-handle"></span>
                </label>
				
				<ul style="display: block; width: 600px; float: left; margin-bottom: 0;">
					<li><label class="property" style="max-width:70px;">{$tr->link}:</label>
						<input placeholder="{$tr->example}: /test" name="bbannersecond" class="fivecms_inp" type="text" value="{$settings->bbannersecond|escape}" />
					</li>
					<li style="width: 600px;"><label class=property>{$tr->upload} {$tr->file|lower} (.png)</label>
						<input name="bbanner2img_file" class="fivecms_inp" type="file" />
						{$img_url=$config->root_url|cat:'/'|cat:$config->bbanner2img_file|cat:'?'|cat:$rand}
						{if file_exists($config->bbanner2img_file)}
							{assign var="info" value=$img_url|getimagesize}
							{if !empty($info.0)}
							<img src="{$config->root_url}/{$config->bbanner2img_file}?{$rand}" />
								<div class="tip">
									{$tr->size}: {$info.0}px x {$info.1}px
								</div>
							{/if}
						{/if}
					</li>
				</ul>
			</div>

			<div id="thirdbbanner" class="block layer">
				<div class="threebannerstitle">{$tr->banner} #3</div>
				
				<label title="{$tr->active}" class="switch switch-default ">
                    <input class="switch-input fn_ajax_action" name="bbannerthirdvis" value="1" type="checkbox" {if $settings->bbannerthirdvis}checked=""{/if}>
                    <span class="switch-label"></span>
                    <span class="switch-handle"></span>
                </label>
				
				<ul style="display: block; width: 600px; float: left; margin-bottom: 0;">
					<li><label class="property" style="max-width:70px;">{$tr->link}:</label>
						<input placeholder="{$tr->example}: /test" name="bbannerthird" class="fivecms_inp" type="text" value="{$settings->bbannerthird|escape}" />
					</li>
					<li style="width: 600px;"><label class=property>{$tr->upload} {$tr->file|lower} (.png)</label>
						<input name="bbanner3img_file" class="fivecms_inp" type="file" />
						{$img_url=$config->root_url|cat:'/'|cat:$config->bbanner3img_file|cat:'?'|cat:$rand}
						{if file_exists($config->bbanner3img_file)}
							{assign var="info" value=$img_url|getimagesize}
							{if !empty($info.0)}						
							<img src="{$config->root_url}/{$config->bbanner3img_file}?{$rand}" />
								<div class="tip">
									{$tr->size}: {$info.0}px x {$info.1}px
								</div>
							{/if}
						{/if}
					</li>
				</ul>
			</div>

			<div id="fourbbanner" class="block layer">
				<div class="threebannerstitle">{$tr->banner} #4</div>
				
				<label title="{$tr->active}" class="switch switch-default ">
                    <input class="switch-input fn_ajax_action" name="bbannerfourvis" value="1" type="checkbox" {if $settings->bbannerfourvis}checked=""{/if}>
                    <span class="switch-label"></span>
                    <span class="switch-handle"></span>
                </label>
				
				<ul style="display: block; width: 600px; float: left; margin-bottom: 0;">
					<li><label class="property" style="max-width:70px;">{$tr->link}:</label>
						<input placeholder="{$tr->example}: /test" name="bbannerfour" class="fivecms_inp" type="text" value="{$settings->bbannerfour|escape}" />
					</li>
					<li style="width: 600px;"><label class=property>{$tr->upload} {$tr->file|lower} (.png)</label>
						<input name="bbanner4img_file" class="fivecms_inp" type="file" />
						{$img_url=$config->root_url|cat:'/'|cat:$config->bbanner4img_file|cat:'?'|cat:$rand}
						{if file_exists($config->bbanner4img_file)}
							{assign var="info" value=$img_url|getimagesize}
							{if !empty($info.0)}						
							<img src="{$config->root_url}/{$config->bbanner4img_file}?{$rand}" />
								<div class="tip">
									{$tr->size}: {$info.0}px x {$info.1}px
								</div>
							{/if}
						{/if}	
					</li>
				</ul>
			</div>

			<input style="margin-top:15px; float:left;clear:both;" class="button_green button_save" type="submit" name="save" value="{$tr->save}" />
		</div>
	
	</form>
	<!-- Основная форма (The End) -->
	
</div>
<script>
{literal}
	// Показать
	$(".switch-input").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".switch-input");
		var name        = line.attr('name');
		var state       = line.is(':checked')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'post',
			url: 'ajax/update_object.php',
			data: {'object': 'settings', 'name': name, 'values': state, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				icon.removeClass('loading_icon');
			},
			dataType: 'json'
		});	
		return true;	
	});
{/literal}
</script>	