{include file='tinymce_init.tpl'}
{capture name=tabs}
	<li class="active"><a href="index.php?module=SettingsAdmin">{$tr->settings_main}</a></li>
	{if in_array('currency', $manager->permissions)}<li><a href="index.php?module=CurrencyAdmin">{$tr->currencies}</a></li>{/if}
	{if in_array('delivery', $manager->permissions)}<li><a href="index.php?module=DeliveriesAdmin">{$tr->delivery}</a></li>{/if}
	{if in_array('payment', $manager->permissions)}<li><a href="index.php?module=PaymentMethodsAdmin">{$tr->payment}</a></li>{/if}
	{if in_array('managers', $manager->permissions)}<li><a href="index.php?module=ManagersAdmin">{$tr->managers}</a></li>{/if}
	{if in_array('discountgroup', $manager->permissions)}<li><a href="index.php?module=DiscountGroupAdmin">{$tr->discounts}</a></li>{/if}
{/capture}
 
{$meta_title = $tr->settings_main scope=root}

<div id="onecolumn" class="settingspage">

	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success == 'saved'}{$tr->updated|escape}{elseif $message_success == 'db_cleared'}{$tr->cart_db_cleared}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span class="text">{if $message_error == 'watermark_is_not_writable'}{$tr->set_permissions} {$config->watermark_file}{/if}</span>
		<a class="button" href="">{$tr->return|escape}</a>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
				
	<div id="main_list" style="max-width:82%;">
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
		<input type=hidden name="session_id" value="{$smarty.session.id}">
		
		<div class="block" id="lang">
			
			<ul style="display:inline-block;vertical-align:middle;margin:5px 20px 0 0;">
				<li><label class="property" style="font-size:17px;font-weight:700;width:190px;">{$tr->lng_title}</label>
					<select name="lang" class="fivecms_inp" style="text-transform:uppercase;">
						{foreach $languages as $l}
						<option value='{$l}' {if $admin_lang == $l}selected{/if}>{$l}</option>
						{/foreach}
					</select>
				</li>
			</ul>
			
	        <input id="apply_action" class="button_green green" type="submit" name="lang_save" value="{$tr->change_lang}" />

		</div>
		
		<!-- Параметры -->
		<div class="block">
				<div class="addsettings">
					<a class="bigbutton" href="index.php?module=SetCatAdmin">{$tr->settings_cat}</a>
					<a class="bigbutton" href="index.php?module=SetModAdmin">{$tr->settings_modules}</a>
					<a class="bigbutton" href="index.php?module=SmtpAdmin">{$tr->smtp}</a>
				</div>

				<ul>
					<li><label class=property>{$tr->site_name}</label><input name="site_name" class="fivecms_inp" type="text" value="{$settings->site_name|escape}" /></li>
					<li><label class=property>{$tr->company_name}</label><input name="company_name" class="fivecms_inp" type="text" value="{$settings->company_name|escape}" /></li>
					<li><label class=property>{$tr->date_format}</label><input readonly name="date_format" class="fivecms_inp" type="text" value="{$settings->date_format|escape}" /></li>
					<li><label class=property>Email {$tr->admin_pass_remind}</label><input name="admin_email" class="fivecms_inp" type="text" value="{$settings->admin_email|escape}" /></li>
					
					<li><label class=property>{$tr->copyright}</label><input placeholder="напр: site.ru" name="copyright" class="fivecms_inp" type="text" value="{$settings->copyright|escape}" /></li>
				<div style="padding: 10px 10px 0px 10px; margin-bottom: 10px; border: 1px dashed #dadada;">
					<h3 style="margin-bottom:10px;">{$tr->additional_link|upper}:</h3>
					<li><label class=property>{$tr->name}</label><input name="addlinkname" class="fivecms_inp" type="text" value="{$settings->addlinkname|escape}" /></li>
					<li><label class=property>Url</label><input name="addlinkurl" class="fivecms_inp" type="text" value="{$settings->addlinkurl|escape}" /></li>
				</div>
				<div style="padding: 10px 10px 0px 10px; margin-bottom: 10px; border: 1px dashed #dadada;">
					<li><label class=property>{$tr->first_phone}</label><input name="phone" class="fivecms_inp" type="text" value="{$settings->phone|escape}" /></li>
					<li><label class=property>{$tr->second_phone}</label><input name="tel" class="fivecms_inp" type="text" value="{$settings->tel|escape}" /></li>
				</div>
					
					<li><label class=property>{$tr->worktime}</label><input name="worktime" class="fivecms_inp" type="text" value="{$settings->worktime|escape}" /></li>
					
				</ul>
				<input style="margin-top: 20px;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
		</div>
		
		<!-- Параметры (The End)-->
		<div class="block layer" id="sitesells">
					<ul>
					
						<li style="overflow:visible;max-width:100%;"><label style="width:150px !important;" class=property>{$tr->carts_stored_in}</label>
							<select name="cart_storage" class="fivecms_inp" style="width: 380px;margin-bottom:10px;">
								<option value='0' {if $settings->cart_storage == '0'}selected{/if}>{$tr->cookies_stored}</option>
								<option value='1' {if $settings->cart_storage == '1'}selected{/if}>{$tr->sessions_stored}</option>
								<option value='2' {if $settings->cart_storage == '2'}selected{/if}>{$tr->db_stored}</option>
							</select>
							{if $settings->cart_storage == '2'}
							<div style="display:table;margin:0 0 10px 0;float:right;">
								<span onClick="$('.quest').hide();$('.confirm').show();" class="button_green quest small_button green">{$tr->delete_carts_db}?</span>
								<input style="display:none; background-color:#5a5858;" class="button_green small_button confirm" type="submit" name="clear_db" value="{$tr->press_confirm}!" />
							</div>	
							{/if}
						</li>
						
						<li><label class=property>{$tr->website_selling}</label>
							<select name="purpose" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->purpose == '0'}selected{/if}>{$tr->products}</option>
								<option value='1' {if $settings->purpose == '1'}selected{/if}>{$tr->services}</option>
							</select>
						</li>
						
						<li><label class=property>{$tr->headers_font}</label>
							<select name="font" class="fivecms_inp" style="width: 170px;">
								<option value='1' {if $settings->font == '1'}selected{/if}>PT Sans</option>
								<option value='2' {if $settings->font == '2'}selected{/if}>Roboto Condensed</option>
								<option value='3' {if $settings->font == '3'}selected{/if}>Fira Sans</option>
							</select>
						</li>
						
						<li><label class=property>{$tr->img_for_li} <img id="selmimg" src="" /></label>
							<select id="selm" name="bullet" class="fivecms_inp" style="min-width: 70px;width:70px;">
								<option data-path="/js/bullets/1.png" value='1' {if $settings->bullet == '1'}selected{/if}>1 тип</option>
								<option data-path="/js/bullets/2.png" value='2' {if $settings->bullet == '2'}selected{/if}>2 тип</option>
								<option data-path="/js/bullets/3.png" value='3' {if $settings->bullet == '3'}selected{/if}>3 тип</option>
								<option data-path="/js/bullets/4.png" value='4' {if $settings->bullet == '4'}selected{/if}>4 тип</option>
								<option data-path="/js/bullets/5.png" value='5' {if $settings->bullet == '5'}selected{/if}>5 тип</option>
								<option data-path="/js/bullets/6.png" value='6' {if $settings->bullet == '6'}selected{/if}>6 тип</option>
								<option data-path="/js/bullets/7.png" value='7' {if $settings->bullet == '7'}selected{/if}>7 тип</option>
								<option data-path="/js/bullets/8.png" value='8' {if $settings->bullet == '8'}selected{/if}>8 тип</option>
								<option data-path="/js/bullets/9.png" value='9' {if $settings->bullet == '9'}selected{/if}>9 тип</option>
								<option data-path="/js/bullets/10.png" value='10' {if $settings->bullet == '10'}selected{/if}>10 тип</option>
								<option data-path="/js/bullets/11.png" value='11' {if $settings->bullet == '11'}selected{/if}>11 тип</option>
								<option data-path="/js/bullets/12.png" value='12' {if $settings->bullet == '12'}selected{/if}>12 тип</option>
								<option data-path="/js/bullets/13.png" value='13' {if $settings->bullet == '13'}selected{/if}>13 тип</option>
								<option data-path="/js/bullets/14.png" value='14' {if $settings->bullet == '14'}selected{/if}>14 тип</option>
								<option data-path="/js/bullets/15.png" value='15' {if $settings->bullet == '15'}selected{/if}>15 тип</option>
								<option data-path="/js/bullets/16.png" value='16' {if $settings->bullet == '16'}selected{/if}>16 тип</option>
								<option data-path="/js/bullets/17.png" value='17' {if $settings->bullet == '17'}selected{/if}>17 тип</option>
								<option data-path="/js/bullets/18.png" value='18' {if $settings->bullet == '18'}selected{/if}>18 тип</option>
								<option data-path="/js/bullets/19.png" value='19' {if $settings->bullet == '19'}selected{/if}>19 тип</option>
								<option data-path="/js/bullets/20.png" value='20' {if $settings->bullet == '20'}selected{/if}>20 тип</option>
							</select>
							<script>{literal}
							$('#selmimg').attr('src', $('#selm option:selected').attr('data-path'));
							$(document).ready(function(){
								$('#selm').change(function(){
									$('#selmimg').attr('src', $('#selm option:selected').attr('data-path'));
								});
							});{/literal}
							</script>
						</li>
						
					</ul>
		</div>
	
	
			<!-- Параметры -->
			<div id="watermark" class="block layer">
				<h2>{$tr->product_images}</h2>
				<ul>
					<li><label class=property>{$tr->quality} ({$tr->max} 100)</label><input style="width: 40px;" name="images_quality" class="fivecms_inp" type="number" max="100" min="1" value="{if $settings->images_quality > 0}{$settings->images_quality|escape}{else}100{/if}" /> %</li>
				
					<li><label class=property>{$tr->watermark} <span style="font-size:13px;">(.png {$tr->on_transp_background}, {$tr->max} 800x600px)</span></label>
					<input name="watermark_file" class="fivecms_inp" type="file" />
	
					<img style='display:block; padding:10px 0 10px 0; max-width:300px;max-height:300px;' src="{$config->root_url}/{$config->watermark_file}?{math equation='rand(10,10000)'}">
					</li>
					<li><label class=property>{$tr->hor_pos} ({$tr->watermark|lower})</label><input style="width: 40px;" name="watermark_offset_x" class="fivecms_inp" type="number" max="100" min="0" value="{$settings->watermark_offset_x|escape}" /> %</li>
					<li><label class=property>{$tr->vert_pos} ({$tr->watermark|lower})</label><input style="width: 40px;" name="watermark_offset_y" class="fivecms_inp" type="number" max="100" min="0" value="{$settings->watermark_offset_y|escape}" /> %</li>
					<li><label class=property>{$tr->transp} ({$tr->watermark|lower})</label><input style="width: 40px;" name="watermark_transparency" class="fivecms_inp" type="number" max="100" min="0" value="{$settings->watermark_transparency|escape}" /> %</li>
					<li><label class=property>{$tr->sharpness}</label><input style="width: 40px;" name="images_sharpen" class="fivecms_inp" type="number" max="100" min="1" value="{$settings->images_sharpen|escape}" /> %</li>
				</ul>
			</div>
			<!-- Параметры (The End)-->
	
			<div id="logo" class="block layer">
				<h2>{$tr->logo}</h2>
				<ul style="display: block; width: 500px; float: left; margin-bottom: 0;">
					<li style="width: 500px;">
						<label style="margin-bottom:10px;width:500px !important;" class=property>{$tr->upload} {$tr->file|lower} (.png {$tr->on_transp_background} {$tr->max} 340x186px)</label>
						<input name="logoimg_file" class="fivecms_inp" type="file" />
						<img style='display:block;max-width:100%;max-height:79px;border:0px solid #d0d0d0; margin:10px 0 10px 0;' src="{$config->root_url}/{$config->logoimg_file}?{math equation='rand(10,10000)'}">
					</li>
				</ul>
			</div>

			<div id="favicon" class="block layer">
				<h2>Favicon.ico</h2>
				<ul style="display: block; width: 500px; float: left; margin-bottom: 0;">
					<li style="width: 500px;">
						<label style="margin-bottom:10px;width:500px !important;" class=property>{$tr->upload} {$tr->file|lower} favicon.ico (<strong>{$tr->size|lower} 16x16px</strong>)</label>
						<input name="faviconimg_file" class="fivecms_inp" type="file" />
						<img style='display:block; border:0px solid #d0d0d0; margin:10px 0 10px 0;' src="{$config->root_url}/{$config->faviconimg_file}?{math equation='rand(10,10000)'}">
					</li>
				</ul>
			</div>
	
			<input style="margin-top: 20px;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />

		<!-- Параметры -->
		<div class="block layer">
			<h2>ТОРГ-12</h2>
			<ul>
				<li><label class=property>Грузоотправитель</label><textarea name="consignor">{$settings->consignor|escape}</textarea></li>
				<li><label class=property>Поставщик</label><textarea name="supplier">{$settings->supplier|escape}</textarea></li>
				<li>
					<label class=property>Доставка в накладной</label>
					<input name="torg12_delivery" type="checkbox" {if $settings->torg12_delivery eq 'true'}checked{/if} value="true" />
				</li>
				
			</ul>
		</div>
		<!-- Параметры (The End)-->
	
			<div id="disclaimer" class="block layer">
				<h2>{$tr->disclaimer}</h2>
				<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more}</a>
				<div id="hideCont">
					<textarea style="width:96%;height:80px;margin: 15px 0;" name="disclaimer">{$settings->disclaimer}</textarea>
				</div>
			</div>
			
			<div id="sms" class="block layer">
				<h2>SMS</h2>
				<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more}</a>
				<div id="hideCont">
					<p style="margin-top: 10px;font-weight:700;font-size:15px;">* {$tr->register_on_website} <a href="http://cmssend.sms.ru/" target=_blank>CMSSEND.SMS.RU</a></p>
					<ul>
						<li><label style="min-width:400px;" class=property>API ID</label><input placeholder="00000000-0000-0000-0000-0000000000" name="apiid" class="fivecms_inp" type="text" value="{$settings->apiid}" /></li>
						<li><label style="min-width:400px;" class="property" style="width: 190px; margin-right: 10px;">{$tr->sms_name}</label><input placeholder="79811234567" name="apifrom" class="fivecms_inp" type="text" value="{$settings->apifrom}" /></li>
						<li><label style="min-width:400px;" class="property" style="width: 190px; margin-right: 10px;">{$tr->sms_phone}</label><input placeholder="79811234567" name="smsadmin" class="fivecms_inp" type="text" value="{$settings->smsadmin}" /></li>
					</ul>
					
					<ul>
						<li><label style="min-width:400px;" class=property>{$tr->sms_send}</label>
							<select name="allowsms" class="fivecms_inp" style="width: 40px;">
								<option value='0' {if $settings->allowsms == '0'}selected{/if}>{$tr->no}</option>
								<option value='1' {if $settings->allowsms == '1'}selected{/if}>{$tr->yes}</option>
							</select>
						</li>

						<li><label style="min-width:400px;" class=property>{$tr->sms_order}</label>
							<select name="statussms" class="fivecms_inp" style="width: 40px;">
								<option value='0' {if $settings->statussms == '0'}selected{/if}>{$tr->no}</option>
								<option value='1' {if $settings->statussms == '1'}selected{/if}>{$tr->yes}</option>
							</select>
						</li>
					</ul>
					
				</div>
			</div>
	
			<div id="rekvizites" class="block layer">
				<h2>{$tr->bank_details}</h2>
				<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more}</a>
				<div id="hideCont">
					<p style="margin-top: 10px;">{$tr->bank_print}</p>
					<textarea style='width:96%;height:200px;margin: 15px 0;' name="rekvizites">{$settings->rekvizites}</textarea>
				</div>
			</div>
			
			<div id="maintenance" class="block layer">
				<h2>{$tr->offline_template} ({$tr->template} offline.tpl)</h2>
				<select name="site_disabled" class="simpla_inp">
				  	<option value='0' {if $settings->site_disabled == 0}selected{/if}>{$tr->no}</option>
					<option value='1' {if $settings->site_disabled == 1}selected{/if}>{$tr->yes}</option>
				</select>
			</div>
	
			<input class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
				
		<!-- Левая колонка свойств товара (The End)--> 
		
	</form>
	<!-- Основная форма (The End) -->
	
	</div>

</div>

{literal}
<script>
$(function() {
	$('#change_password_form').hide();
	$('#change_password').click(function() {
		$('#change_password_form').show();
	});
});
</script>
{/literal}
