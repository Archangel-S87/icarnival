{literal}
<link rel="stylesheet" media="screen" type="text/css" href="design/js/colorpicker/css/colorpicker.css" />
<script type="text/javascript" src="design/js/colorpicker/js/colorpicker.js"></script>
<script>
$(function() {
	$('#color_icon, #color_link').ColorPicker({
		color: $('#color_input').val(),
		onShow: function (colpkr) {
			$(colpkr).fadeIn(500);
			return false;
		},
		onHide: function (colpkr) {
			$(colpkr).fadeOut(500);
			return false;
		},
		onChange: function (hsb, hex, rgb) {
			$('#color_icon').css('backgroundColor', '#' + hex);
			$('#color_input').val(hex);
			$('#color_input').ColorPickerHide();
		}
	});
});
</script>
{/literal}

{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main}</a></li>{/if}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SetCatAdmin">{$tr->settings_cat}</a></li>{/if}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SetModAdmin">{$tr->settings_modules}</a></li>{/if}
	<li class="active"><a href="index.php?module=StadAdmin">{$tr->stad}</a></li>
{/capture}
 
{$meta_title = $tr->stad scope=root}

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
					<h2>{$tr->widget} "{$tr->stad}"</h2>
					<ul>
						<li style="margin-top:15px;"><label class=property>{$tr->widget}</label>
							<select name="stad" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->stad == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
								<option value='1' {if $settings->stad == '1'}selected{/if}>{$tr->show|lower|escape}</option>
							</select>
						</li>
						<li style="margin-top:10px;"><label class=property>{$tr->gender}</label>
							<select name="b13manage" class="fivecms_inp" style="width: 60px;">
								<option value='0' {if $settings->b13manage == '0'}selected{/if}>{$tr->male_sh}</option>
								<option value='1' {if $settings->b13manage == '1'}selected{/if}>{$tr->female_sh}</option>
								<option value='2' {if $settings->b13manage == '2'}selected{/if}>{$tr->male_female_sh}</option>
							</select>
						</li>
						<li style="margin-top:10px;"><label class=property>{$tr->bg_color}:</label>
							<span id="color_icon" style="background-color:{$settings->stadcolor};" class="order_label_big"></span>
							<input id="color_input" name="hexstadcolor" class="fivecms_inp" type="hidden" />
							<input style="max-width:160px;" name="stadcolor" class="fivecms_inp" type="text" value="{$settings->stadcolor|escape}" />
						</li>
						<li style="margin-top:10px;"><label class=property>{$tr->interval_show} (>15):</label><input style="max-width:40px;" name="stadtime" class="fivecms_inp" type="number" value="{$settings->stadtime}" placeholder="25" /> {$tr->seconds_sh}</li>
						<li style="margin-top:10px;"><label class=property>{$tr->city}:</label>
							<select name="b14manage" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->b14manage == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
								<option value='1' {if $settings->b14manage == '1'}selected{/if}>{$tr->show|lower|escape}</option>
							</select>
						</li>
						
						<li class="layer" style="margin-top:15px;"><label class=property>{$tr->text_type}</label>
							<select name="b11manage" class="fivecms_inp" style="width: 140px;">
								<option value='0' {if $settings->b11manage == '0'}selected{/if}>{$tr->order_for_amount}</option>
								<option value='1' {if $settings->b11manage == '1'}selected{/if}>{$tr->purchased_product}</option>
							</select>
						</li>
						<li style="margin-top:15px;"><label class=property>{$tr->purchases_type}</label>
							<select name="b12manage" class="fivecms_inp" style="width: 170px;">
								<option value='0' {if $settings->b12manage == '0'}selected{/if}>{$tr->hits|lower}</option>
								<option value='1' {if $settings->b12manage == '1'}selected{/if}>{$tr->with_old_price|lower}</option>
								<option value='2' {if $settings->b12manage == '2'}selected{/if}>{$tr->novelties|lower}</option>
							</select>
						</li>
						<li style="margin-top:15px;"><label class=property>{$tr->interval_order_amount}:</label> {$tr->from} <input style="max-width:60px;width:60px;" name="stadfrom" class="fivecms_inp" type="number" value="{$settings->stadfrom}" placeholder="1000" />  {$tr->to} <input style="max-width:60px;width:60px;" name="stadto" class="fivecms_inp" type="number" value="{$settings->stadto}" placeholder="10000" /> {$currency->sign}</li>
						<li style="margin-top:15px;"><label class=property>{$tr->round_order_amount}</label>
							<select name="stad_round" class="fivecms_inp" style="width: 100px;">
								<option value='1' {if $settings->stad_round == '1'}selected{/if}>{$tr->to_integer}</option>
								<option value='100' {if $settings->stad_round == '100'}selected{/if}>{$tr->to_hundreds}</option>
								<option value='1000' {if $settings->stad_round == '1000'}selected{/if}>{$tr->to_thousands}</option>
							</select>
						</li>
					</ul>

				</div>

			</div>
			<input style="margin: 10px 0 20px 0; float:left;" class="button_green button_save" type="submit" name="save" value="{$tr->save}" />
		</form>
		<!-- Основная форма (The End) -->

		<!-- demo -->
		<div id="stadn" style="background-color:{$settings->stadcolor}">
			<div class="stad-left"><img src="/design/{$settings->theme|escape}/images/stad.png" /></div>
			<div class="stad-right">
				<div class="stad-title">
					{if $settings->b11manage == 0}
						Новый заказ на сайте
					{elseif $settings->b11manage == 1}
						Новая покупка на сайте
					{/if}
				</div>
				<div class="stad-body"><span class="stad-name">Игорь</span> {if $settings->b14manage == 1}из <span class="stad-city">Москвы</span>{/if} только что 
					{if $settings->b11manage == 0}
						оформил<span class="w-end"></span> заказ на <span class="stad-sum">{3981|convert}</span> {$currency->sign}
					{elseif $settings->b11manage == 1}
						заказал<span class="w-end"></span> <span class="stad-prod"><a href="/products/samsung-s7070-diva">Samsung S7070 Diva</a></span>
					{/if}
				</div>		
			</div>
		</div>
		{literal}
		<style>
		#stadn{position:fixed;right:20px;top:170px;z-index:100;width:290px;display:table;color:#ffffff;padding:10px;border-radius:10px;-moz-border-radius:10px;-webkit-border-radius:10px;box-shadow: 0px 0px 3px rgba(76, 76, 76, 0.3), 3px 3px 10px rgba(105, 103, 103, 0.2);}
		.stad-left{display:table-cell;width:60px;vertical-align:middle;}
		.stad-left img {width:50px;}
		.stad-right{display:table-cell;vertical-align:top;}
		.stad-title{font-weight:700;font-size:14px;margin-bottom:4px;}
		.stad-body{font-size:13px;line-height:17px;}
		.stad-body a {color:#ffffff;}
		.stad-body a:hover {color:#ffffff;}
		</style>
		{/literal}
		<!-- demo end-->

	</div>

</div>

