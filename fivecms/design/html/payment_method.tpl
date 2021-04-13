{* Вкладки *}
{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main|escape}</a></li>{/if}
	{if in_array('currency', $manager->permissions)}<li><a href="index.php?module=CurrencyAdmin">{$tr->currencies|escape}</a></li>{/if}
	{if in_array('delivery', $manager->permissions)}<li><a href="index.php?module=DeliveriesAdmin">{$tr->delivery|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=PaymentMethodsAdmin">{$tr->payment|escape}</a></li>
	{if in_array('managers', $manager->permissions)}<li><a href="index.php?module=ManagersAdmin">{$tr->managers|escape}</a></li>{/if}
	{if in_array('discountgroup', $manager->permissions)}<li><a href="index.php?module=DiscountGroupAdmin">{$tr->discounts|escape}</a></li>{/if}
{/capture}

{if $payment_method->id}
	{$meta_title = $payment_method->name scope=root}
{else}
	{$meta_title = $tr->new_post|escape scope=root}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

{* On document load *}
{literal}
<script>
$(function() {
	$('div#module_settings').filter(':hidden').find("input, select, textarea").attr("disabled", true);

	$('select[name=module]').change(function(){
		$('div#module_settings').hide().find("input, select, textarea").attr("disabled", true);
		$('div#module_settings[module='+$(this).val()+']').show().find("input, select, textarea").attr("disabled", false);
	});
	$(document).ready(function() {
		$('div#module_settings').hide().find("input, select, textarea").attr("disabled", true);
		$('div#module_settings[module='+$('select[name=module]').val()+']').show().find("input, select, textarea").attr("disabled", false);
	});
	
});
</script>
{/literal}

{$rand=rand(100,10000)}

<div id="onecolumn" class="paymentpage">

	<!-- Системное сообщение -->
	{if isset($message_success)}
		<div class="message message_success">
			<span class="text">{$message_success}</span>
			{if isset($smarty.get.return)}
			<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
			{/if}
		</div>
	{/if}

	{if isset($message_error)}
		<div class="message message_error">
			<span class="text">{if $message_success == 'added'}{$tr->added|escape}{elseif $message_success == 'updated'}{$tr->updated|escape}{/if}</span>
			<a class="button" href="">{$tr->return|escape}</a>
		</div>
	{elseif isset($message_error)}
		<div class="message message_error">
			<span class="text">{if $message_error == 'image_is_not_writable'}{$tr->upload_error|escape}{/if}</span>
			{if isset($smarty.get.return)}
			<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
			{/if}
		</div>
	{/if}
	<!-- Системное сообщение (The End)-->
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input placeholder="{$tr->enter_s_name|escape}" class="name" name=name type="text" value="{if !empty($payment_method->name)}{$payment_method->name|escape}{/if}" required /> 
			<input name=id type="hidden" value="{$payment_method->id}"/> 
			<div class="checkbox">
				<input name=enabled value='1' type="checkbox" id="active_checkbox" {if !empty($payment_method->enabled)}checked{/if}/> <label for="active_checkbox">{$tr->active|escape}</label>
			</div>
		</div> 
	
		<div id="product_categories">
			<select name="module">
	            <option value='null'>{$tr->manual_processing|escape}</option>
	       		{foreach $payment_modules as $payment_module}
	            	<option value='{$payment_module@key|escape}' {if !empty($payment_method->module) && $payment_method->module == $payment_module@key}selected{/if} >{$payment_module->name|escape}</option>
	        	{/foreach}
			</select>
		</div>
		
		<div id="product_brand">
			<label>{$tr->currency|escape}</label>
			<div>
			<select name="currency_id">
				{foreach $currencies as $currency}
	            <option value='{$currency->id}' {if !empty($payment_method->currency_id) && $currency->id==$payment_method->currency_id}selected{/if}>{$currency->name|escape}</option>
	            {/foreach}
			</select>
			</div>
		</div>

		<div style="display:table;clear:both;margin-bottom:20px;" class="payments_settings helper"><a style="" href="#payments_settings" class="helperlink">{$tr->payment_helper|escape}</a></div>
		<div style="display:none;">
			<div id="payments_settings" style="width:700px;">
				<ul class="stars">
					{$tr->payment_help}
					<li>
						<a href="https://5cms.ru/blog/yandex-kassa" target="_blank"><strong>ЮKassa (2.0.1):</strong></a> 
						<p style="margin:10px 0 5px 0;font-weight:700;">!Обязательно наличие HTTPS</p>
						<p>При необходимости в "Параметры для платежей" в "Адрес для уведомлений" укажите:</p>
						<p>{$config->root_url}/payment/YooMoneyApi/callback.php?action=notify</p>
						<p style="margin:10px 0 5px 0;">Важно! В тестовом режиме не использовать реальный кошелек, а нужно использовать !только тестовую карту:</p>
						<p>1111 1111 1111 1026</p>
						<p>12/20 000</p>
					</li>
					<li>
						<a class="zoom" href="/payment/Robokassa/example.png"><strong>Робокасса</strong></a>
						<p style="margin:10px 0 5px 0;">Вам также может пригодится следующая информация:</p>
						<p>Success URL - {$config->root_url}/order/</p>
						<p>Fail URL - {$config->root_url}/order/</p>
						<p>Result URL - {$config->root_url}/payment/Robokassa/callback.php</p>
					</li>
					<li>
						<a href="http://5cms.ru/blog/tinkoff" target="_blank"><strong>Tinkoff</strong></a>
					</li>
					<li>
						<a class="zoom" href="/payment/Webmoney/example.png"><strong>Webmoney</strong></a>
						<p style="margin:10px 0 5px 0;">Вам также может пригодится следующая информация:</p>
						<p>Result URL - {$config->root_url}/payment/Webmoney/callback.php</p>
					</li>
					<li><strong>Paypal:</strong> укажите "Merchant email" и выберите в "mode" - "Real payments"</li>
				</ul>
			</div>
		</div>
		
		<!-- Левая колонка свойств -->
		<div id="column_left">
		
	   		{foreach $payment_modules as $payment_module}
	        	<div class="block layer" {if !empty($payment_method->module) && $payment_module@key == $payment_method->module}{* todo *}{else}style='display:none;'{/if} id=module_settings module='{$payment_module@key}'>
				<h2>{$payment_module->name}</h2>
				{* Параметры модуля оплаты *}
				<ul>
				{foreach $payment_module->settings as $setting}
					{$variable_name = $setting->variable}
					{if !empty($setting->options) && $setting->options|@count>1}
					<li><label class=property>{$setting->name}</label>
					<select name="payment_settings[{$setting->variable}]">
						{foreach $setting->options as $option}
						<option value='{$option->value}' {if $option->value==$payment_settings[$setting->variable]}selected{/if}>{$option->name|escape}</option>
						{/foreach}
					</select>
					</li>
					{elseif !empty($setting->options) && $setting->options|@count==1}
					{$option = $setting->options|@first}
					<li><label class="property" for="{$setting->variable}">{$setting->name|escape}</label><input name="payment_settings[{$setting->variable}]" class="fivecms_inp" type="checkbox" value="{if !empty($option->value)}{$option->value|escape}{/if}" {if $option->value==$payment_settings[$setting->variable]}checked{/if} id="{$setting->variable}" /> <label for="{$setting->variable}">{$option->name}</label></li>
					{else}
					<li><label class="property" for="{$setting->variable}">{$setting->name|escape}</label><input name="payment_settings[{$setting->variable}]" class="fivecms_inp" type="text" value="{if !empty($payment_settings[$setting->variable])}{$payment_settings[$setting->variable]|escape}{/if}" id="{$setting->variable}"/></li>
					{/if}
				{/foreach}
				</ul>
				{* END Параметры модуля оплаты *}
	        	
	        	</div>
	        {/foreach}
	        	
	        {if (!empty($payment_method->module) && $payment_method->module == 'ReceiptUr') || empty($payment_method->module)}	
				<div class="block layer" style="margin-top: 15px;" id="module_settings" module='ReceiptUr'>
					<div class="threebannerstitle">Печать (рекомендуется размер 300х300 px)</div>
					<ul style="display: block; width: 600px; float: left; margin-bottom: 0;">
						<li style="width: 600px;"><label class=property>Загрузить файл (.png)</label>
							<input name="printimg_file" class="fivecms_inp" type="file" />
							{$img_url=$config->root_url|cat:'/payment/ReceiptUr/print.png'|cat:'?'|cat:$rand}
							{if file_exists('payment/ReceiptUr/print.png')}
								{assign var="info" value=$img_url|getimagesize}
								{if !empty($info.0) && $info.0 > 0}	
									<img style="max-width:200px;margin:10px 0;" src="{$config->root_url}/payment/ReceiptUr/print.png?{$rand}" />
									<div class="tip">
										{$info.0}x{$info.1}px
									</div>
								{/if}
							{/if}	
						</li>
					</ul>
				</div>

				<div class="block layer" id="module_settings" module='ReceiptUr'>
					<div class="threebannerstitle">Подпись директора (рекомендуется размер 300х300 px)</div>
				
					<ul style="display: block; width: 600px; float: left; margin-bottom: 0;">
						<li style="width: 600px;"><label class=property>Загрузить файл (.png)</label>
							<input name="signimg_file" class="fivecms_inp" type="file" />
							{$img_url=$config->root_url|cat:'/payment/ReceiptUr/sign.png'|cat:'?'|cat:$rand}
							{if file_exists('payment/ReceiptUr/sign.png')}
								{assign var="info" value=$img_url|getimagesize}
								{if !empty($info.0)}
									<img style="max-width:200px;margin:10px 0;" src="{$config->root_url}/payment/ReceiptUr/sign.png?{$rand}" />
									<div class="tip">
										{$info.0}x{$info.1}px
									</div>
								{/if}
							{/if}
						</li>
					</ul>
				</div>
				<div class="block layer" id=module_settings module='ReceiptUr'>
					<div class="threebannerstitle">Подпись главбуха (рекомендуется размер 300х300 px)</div>
				
					<ul style="display: block; width: 600px; float: left; margin-bottom: 0;">
						<li style="width: 600px;"><label class=property>Загрузить файл (.png)</label>
							<input name="buhimg_file" class="fivecms_inp" type="file" />
							{$img_url=$config->root_url|cat:'/payment/ReceiptUr/buh.png'|cat:'?'|cat:$rand}
							{if file_exists('payment/ReceiptUr/buh.png')}
								{assign var="info" value=$img_url|getimagesize}
								{if !empty($info.0)}
									<img style="max-width:200px;margin:10px 0;" src="{$config->root_url}/payment/ReceiptUr/buh.png?{$rand}" />
									<div class="tip">
										{$info.0}x{$info.1}px
									</div>
								{/if}
							{/if}
						</li>
					</ul>
				</div>
	        {/if}	
	        	
	    	<div class="block layer" {if isset($payment_method->module) && $payment_method->module != ''}style='display:none;'{/if} id=module_settings module='null'></div>
	
		</div>
		<!-- Левая колонка свойств (The End)--> 
		
		<!-- Правая колонка -->
		<div id="column_right">
			<div class="block layer">
			<h2>{$tr->delivery_variants|escape}</h2>
			<ul>
			{foreach $deliveries as $delivery}
				<li>
				<input type=checkbox name="payment_deliveries[]" id="delivery_{$delivery->id}" value='{$delivery->id}' {if in_array($delivery->id, $payment_deliveries)}checked{/if}> <label for="delivery_{$delivery->id}">{$delivery->name}</label><br>
				</li>
			{/foreach}
			</ul>		
			</div>
		</div>
		<!-- Правая колонка (The End)--> 
		
		<!-- Описание -->
		<div class="block layer">
			<h2>{$tr->description|escape}</h2>
			<textarea name="description" class="editor_small">{if !empty($payment_method->description)}{$payment_method->description|escape}{/if}</textarea>
		</div>
		<!-- Описание (The End)-->
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Основная форма (The End) -->

</div>
