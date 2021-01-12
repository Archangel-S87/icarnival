{literal}
<link rel="stylesheet" media="screen" type="text/css" href="design/js/colorpicker/css/colorpicker.css" />
<script type="text/javascript" src="design/js/colorpicker/js/colorpicker.js"></script>
<script>

	$(function() {
		$("#color_icon, #color_link").click(function() { 
			nz_colorpick(this);
		});

	});

	function nz_colorpick(target) {
		$(function() {

			$(target).ColorPicker({
				color: $(target).next().val(),
				onShow: function (colpkr) {
					$(colpkr).fadeIn(500);
					return false;
				},
				onHide: function (colpkr) {
					$(colpkr).fadeOut(500);
					return false;
				},
				onChange: function (hsb, hex, rgb) {
					$(target).css('backgroundColor', '#' + hex);
					$(target).next().val(hex);
					$(target).next().ColorPickerHide();
				}
			});
		});
		return false;
	}
</script>
{/literal}


{capture name=tabs}
	<li class="active"><a href="index.php?module=MobthemeAdmin">{$tr->gamma_mob|escape}</a></li>
	{if in_array('slides', $manager->permissions)}<li><a href="index.php?module=SlidesmAdmin">{$tr->slider_mob|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobsetAdmin">{$tr->settings_mob|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobileTemplatesAdmin">{$tr->templates|escape} ({$tr->mob|escape})</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobileStylesAdmin">{$tr->styles_mob|escape}</a></li>{/if}
{/capture}
 
{$meta_title = $tr->gamma_mob_diz scope=root}

<div id="onecolumn" class="mobthemepage">

	{if isset($message_success) && $message_success == 'saved'}
		<div class="message message_success">
			<span class="text">{$tr->updated|escape}</span>
		</div>
	{/if}
	
	<div class="border_box" style="padding:10px;">
		<form method=post id=product enctype="multipart/form-data">
			<input type=hidden name="session_id" value="{$smarty.session.id}">
					
			<div class="block mobthemefields">
			<h2 style="color:#3667a7;text-transform:uppercase;">{$tr->mob_theme_intro} <svg style="vertical-align: middle;" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
				    <path d="M0 0h24v24H0z" fill="none"></path>
				    <path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z"></path>
				</svg></p>
			<p>**** {$tr->mob_theme_intro_two}</p>
				<ul>
					<li style="margin-top:10px;"><label class=property>colorPrimary <a class="helperlink zoom" href="./design/images/mtheme1.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->colorPrimary|escape};" class="order_label_big"></span>
						#<input id="color_input" name="colorPrimary" class="fivecms_inp" type="text" value="{$mobtheme->colorPrimary|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>colorPrimaryDark <a class="helperlink zoom" href="./design/images/mtheme1.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->colorPrimaryDark|escape};" class="order_label_big"></span>
						#<input id="color_input" name="colorPrimaryDark" class="fivecms_inp" type="text" value="{$mobtheme->colorPrimaryDark|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>colorSecondPrimary <a class="helperlink zoom" href="./design/images/mtheme1.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->colorSecondPrimary|escape};" class="order_label_big"></span>
						#<input id="color_input" name="colorSecondPrimary" class="fivecms_inp" type="text" value="{$mobtheme->colorSecondPrimary|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>leftMenuItem <a class="helperlink zoom" href="./design/images/mtheme1.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->leftMenuItem|escape};" class="order_label_big"></span>
						#<input id="color_input" name="leftMenuItem" class="fivecms_inp" type="text" value="{$mobtheme->leftMenuItem|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>logoText <a class="helperlink zoom" href="./design/images/mtheme1.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->logoText|escape};" class="order_label_big"></span>
						#<input id="color_input" name="logoText" class="fivecms_inp" type="text" value="{$mobtheme->logoText|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>logoPhone <a class="helperlink zoom" href="./design/images/mtheme1.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->logoPhone|escape};" class="order_label_big"></span>
						#<input id="color_input" name="logoPhone" class="fivecms_inp" type="text" value="{$mobtheme->logoPhone|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>leftMenuItemActive <a class="helperlink zoom" href="./design/images/mtheme2.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->leftMenuItemActive|escape};" class="order_label_big"></span>
						#<input id="color_input" name="leftMenuItemActive" class="fivecms_inp" type="text" value="{$mobtheme->leftMenuItemActive|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>leftMenuIconActive <a class="helperlink zoom" href="./design/images/mtheme2.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->leftMenuIconActive|escape};" class="order_label_big"></span>
						#<input id="color_input" name="leftMenuIconActive" class="fivecms_inp" type="text" value="{$mobtheme->leftMenuIconActive|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>backgroundAccent <a class="helperlink zoom" href="./design/images/mtheme2.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->backgroundAccent|escape};" class="order_label_big"></span>
						#<input id="color_input" name="backgroundAccent" class="fivecms_inp" type="text" value="{$mobtheme->backgroundAccent|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>textAccent <a class="helperlink zoom" href="./design/images/mtheme3.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->textAccent|escape};" class="order_label_big"></span>
						#<input id="color_input" name="textAccent" class="fivecms_inp" type="text" value="{$mobtheme->textAccent|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>colorMain <a class="helperlink zoom" href="./design/images/mtheme4.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->colorMain|escape};" class="order_label_big"></span>
						#<input id="color_input" name="colorMain" class="fivecms_inp" type="text" value="{$mobtheme->colorMain|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>badgeBackground <a class="helperlink zoom" href="./design/images/mtheme5.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->badgeBackground|escape};" class="order_label_big"></span>
						#<input id="color_input" name="badgeBackground" class="fivecms_inp" type="text" value="{$mobtheme->badgeBackground|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>badgeBorder <a class="helperlink zoom" href="./design/images/mtheme5.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->badgeBorder|escape};" class="order_label_big"></span>
						#<input id="color_input" name="badgeBorder" class="fivecms_inp" type="text" value="{$mobtheme->badgeBorder|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>badgeText <a class="helperlink zoom" href="./design/images/mtheme5.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->badgeText|escape};" class="order_label_big"></span>
						#<input id="color_input" name="badgeText" class="fivecms_inp" type="text" value="{$mobtheme->badgeText|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>aboutBackgroundText <a class="helperlink zoom" href="./design/images/mtheme6.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->aboutBackgroundText|escape};" class="order_label_big"></span>
						#<input id="color_input" name="aboutBackgroundText" class="fivecms_inp" type="text" value="{$mobtheme->aboutBackgroundText|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>aboutText3 <a class="helperlink zoom" href="./design/images/mtheme6.jpg">(?)</a>:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->aboutText3|escape};" class="order_label_big"></span>
						#<input id="color_input" name="aboutText3" class="fivecms_inp" type="text" value="{$mobtheme->aboutText3|escape}" />
					</li>
									
				</ul>
			</div>
			<input style="margin: 0 0 20px 0; float:left;" class="button_green button_save" type="submit" name="save" value="{$tr->save_main_colors|escape}" />
		</form>

		<form method=post id=product enctype="multipart/form-data">
			<input type=hidden name="session_id" value="{$smarty.session.id}">
					
			<div class="block mobthemefields" style="padding-top:15px;border-top: 2px dashed #bfbdbd;">
				{if isset($message_success) && $message_success == "savedadd"}
					<div style="margin-bottom:15px;" class="message message_success">
						<span class="text">{$tr->updated|escape}</span>
					</div>
				{/if}
				<h2 style="color:#3667a7;text-transform:uppercase;">{$tr->additional_colors|escape}:</h2>
				<ul>
					<li style="margin-top:10px;"><label class=property>{$tr->sliderbg|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->sliderbg|escape};" class="order_label_big"></span>
						#<input id="color_input" name="sliderbg" class="fivecms_inp" type="text" value="{$mobtheme->sliderbg|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->slidertext|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->slidertext|escape};" class="order_label_big"></span>
						#<input id="color_input" name="slidertext" class="fivecms_inp" type="text" value="{$mobtheme->slidertext|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->buybg|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->buybg|escape};" class="order_label_big"></span>
						#<input id="color_input" name="buybg" class="fivecms_inp" type="text" value="{$mobtheme->buybg|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->buytext|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->buytext|escape};" class="order_label_big"></span>
						#<input id="color_input" name="buytext" class="fivecms_inp" type="text" value="{$mobtheme->buytext|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->buybgactive|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->buybgactive|escape};" class="order_label_big"></span>
						#<input id="color_input" name="buybgactive" class="fivecms_inp" type="text" value="{$mobtheme->buybgactive|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->buytextactive|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->buytextactive|escape};" class="order_label_big"></span>
						#<input id="color_input" name="buytextactive" class="fivecms_inp" type="text" value="{$mobtheme->buytextactive|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->wishcomp|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->wishcomp|escape};" class="order_label_big"></span>
						#<input id="color_input" name="wishcomp" class="fivecms_inp" type="text" value="{$mobtheme->wishcomp|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->wishcompactive|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->wishcompactive|escape};" class="order_label_big"></span>
						#<input id="color_input" name="wishcompactive" class="fivecms_inp" type="text" value="{$mobtheme->wishcompactive|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->breadbg|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->breadbg|escape};" class="order_label_big"></span>
						#<input id="color_input" name="breadbg" class="fivecms_inp" type="text" value="{$mobtheme->breadbg|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->breadtext|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->breadtext|escape};" class="order_label_big"></span>
						#<input id="color_input" name="breadtext" class="fivecms_inp" type="text" value="{$mobtheme->breadtext|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->zagolovok|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->zagolovok|escape};" class="order_label_big"></span>
						#<input id="color_input" name="zagolovok" class="fivecms_inp" type="text" value="{$mobtheme->zagolovok|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->zagolovokbg|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->zagolovokbg|escape};" class="order_label_big"></span>
						#<input id="color_input" name="zagolovokbg" class="fivecms_inp" type="text" value="{$mobtheme->zagolovokbg|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->productborder|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->productborder|escape};" class="order_label_big"></span>
						#<input id="color_input" name="productborder" class="fivecms_inp" type="text" value="{$mobtheme->productborder|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->ballovbg|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->ballovbg|escape};" class="order_label_big"></span>
						#<input id="color_input" name="ballovbg" class="fivecms_inp" type="text" value="{$mobtheme->ballovbg|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->oneclickbg|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->oneclickbg|escape};" class="order_label_big"></span>
						#<input id="color_input" name="oneclickbg" class="fivecms_inp" type="text" value="{$mobtheme->oneclickbg|escape}" />
					</li>
					<li style="margin-top:10px;"><label class=property>{$tr->oneclicktext|escape}:</label>
						<span onclick="nz_colorpick(this)" id="color_icon" style="background-color:#{$mobtheme->oneclicktext|escape};" class="order_label_big"></span>
						#<input id="color_input" name="oneclicktext" class="fivecms_inp" type="text" value="{$mobtheme->oneclicktext|escape}" />
					</li>
	
				</ul>

			</div>
			<input style="margin: 0 0 20px 0; float:left;" class="button_green button_save" type="submit" name="saveadditional" value="{$tr->save_additional_colors|escape}" />
		</form>
		<!-- Main form | Основная форма (The End) -->
				
	</div>

	{include file='phonedesign.tpl'}

</div>