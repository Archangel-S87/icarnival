{* Вкладки *}
{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main|escape}</a></li>{/if}
	{if in_array('currency', $manager->permissions)}<li><a href="index.php?module=CurrencyAdmin">{$tr->currencies|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=DeliveriesAdmin">{$tr->delivery|escape}</a></li>
	{if in_array('payment', $manager->permissions)}<li><a href="index.php?module=PaymentMethodsAdmin">{$tr->payment|escape}</a></li>{/if}
	{if in_array('managers', $manager->permissions)}<li><a href="index.php?module=ManagersAdmin">{$tr->managers|escape}</a></li>{/if}
	{if in_array('discountgroup', $manager->permissions)}<li><a href="index.php?module=DiscountGroupAdmin">{$tr->discounts|escape}</a></li>{/if}
{/capture}

{if !empty($delivery->name)}
	{$meta_title = $delivery->name scope=root}
{else}
	{$meta_title = $tr->new_post scope=root}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

{* On document load *}
{literal}
<script src="design/js/jquery/jquery-ui.min.js"></script>

<script>
$(function() {

$('select[name=module]').change(function(){
	$('div#module_settings').hide();
	$('div#module_settings[module='+$(this).val()+']').show();
	});
});

</script>
{/literal}

<div id="onecolumn" class="deliverypage">
	
	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success == 'added'}{$tr->added|escape}{elseif $message_success == 'updated'}{$tr->updated|escape}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span class="text">{$message_error}</span>
		<a class="button" href="">{$tr->return|escape}</a>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input placeholder="{$tr->enter_s_name|escape}" class="name" name=name type="text" value="{if !empty($delivery->name)}{$delivery->name|escape}{/if}" required /> 
			<input name=id type="hidden" value="{$delivery->id}"/> 
			<div class="checkbox">
				<input name=enabled value='1' type="checkbox" id="active_checkbox" {if !empty($delivery->enabled)}checked{/if}/> <label for="active_checkbox">{$tr->active|escape}</label>
			</div>
		</div> 
	
		<!-- Левая колонка -->
		<div id="column_left">
		
			<ul class="widget_choose" style="margin-bottom:20px;{if $delivery->id == 3 || $delivery->id == 4 || $delivery->id == 114 || $delivery->id == 121}display:none;{/if}">
				<li><label class=property style="font-weight:700;font-size:16px; margin-right:10px;">Используется виджет доставки:</label>
					<select name="widget" class="fivecms_inp" style="width: 50px;" onChange="Selected(this)">
						<option value='0' {if !empty($delivery->widget) && $delivery->widget == '0'}selected{/if}>Нет</option>
						<option value='1' {if !empty($delivery->widget) && $delivery->widget == '1'}selected{/if}>Да</option>
					</select>
				</li>
			</ul>
			<script>
				function Selected(a) {
					var label = a.value;
					if (label==0) {
						$('.nowidget').show();
						$('.widget').hide();
					}
					if (label==1) {
						$('.nowidget').hide();
						$('.widget').show();
						$('input[type=submit]').click();
						$('.widget_choose option[value=0]').attr('selected', 'selected');
					}
				}
			</script>
			<!-- Параметры страницы -->
			<div class="block layer nowidget" {if !empty($delivery->widget) && $delivery->widget == 1}style="display:none;"{/if}>
				<h2>{$tr->delivery_price|escape}:</h2>
				<ul {if $delivery->id == 3 || $delivery->id == 4 || $delivery->id == 114 || $delivery->id == 121}style="display:none;"{/if}>
					<li><label class=property>{$tr->fixed|escape}</label><input style="width:100px;" name="price" class="fivecms_small_inp" type="text" value="{if !empty($delivery->price)}{$delivery->price}{/if}" /> {$currency->sign}</li>
					<li><label class=property>+ {$tr->per_kg|escape} более 3-х</label><input style="width:100px;" name="price2" class="fivecms_small_inp" type="text" value="{if !empty($delivery->price2)}{$delivery->price2}{/if}" /> {$currency->sign}</li>
				</ul>
			</div>	
			<div class="block layer">
				<ul>
					<li><label class=property>{$tr->free_from|escape}</label><input style="width:100px;" name="free_from" class="fivecms_small_inp" type="text" value="{if !empty($delivery->free_from)}{$delivery->free_from}{/if}" /> {$currency->sign}</li>
					<li><label class=property for="separate_payment">{$tr->separate_payment|escape} <br /><span style="font-weight:400;font-size:12px;">({$tr->about_separate|escape})</span></label><input id="separate_payment" name="separate_payment" type="checkbox" value="1" {if !empty($delivery->separate_payment)}checked{/if} /></li>
					<li><label class=property>Доплнительная стоимость</label><input style="width:100px;" name="additional_cost" class="fivecms_small_inp" type="text" value="{if !empty($delivery->additional_cost)}{$delivery->additional_cost}{/if}" /> {$currency->sign}</li>
				</ul>
			</div>
			<!-- Параметры страницы (The End)-->
	
		</div>
		<!-- Левая колонка (The End)--> 
		
		<!-- Левая колонка -->
		<div id="column_right">
			<div class="block layer">
			<h2>{$tr->available_payments|escape}</h2>
			<ul>
			{foreach $payment_methods as $payment_method}
				<li>
					<input type=checkbox name="delivery_payments[]" id="payment_{$payment_method->id}" value='{$payment_method->id}' {if in_array($payment_method->id, $delivery_payments)}checked{/if}> <label for="payment_{$payment_method->id}">{$payment_method->name}</label><br>
				</li>
			{/foreach}
			</ul>		
			</div>
		</div>
		<!-- Левая колонка (The End)--> 
		
		{if $delivery->id == 121}
		<div class="block layer widget" id="boxberry">
			<ul>
				<li>Для начала работы необходимо зарегистрироваться на сайте <a href="https://account.boxberry.ru/" target="_blank">Boxberry</a></li>
				<li><label class="property">Ключ интеграции <span style="font-weight:400;">(в <a href="https://account.boxberry.ru/client/infoblock/index?tab=api&api=settings#" target="_blank">Интеграция > Настройка виджетов</a>)</span></label><input placeholder="Напр.: gfgiLAIqtr8qn4kciPkUmw==" name="option1" class="fivecms_inp" type="text" value="{if !empty($delivery->option1)}{$delivery->option1|escape}{/if}" /></li>
				<li><label class="property">Город по умолчанию (custom_city)*</label><input placeholder="Напр.: Санкт-Петербург" name="option2" class="fivecms_inp" type="text" value="{if !empty($delivery->option2)}{$delivery->option2|escape}{/if}" /></li>
				<li>* Если задан параметр custom_city, откроется карта региона переданного города.</li>
				<li><label class="property">Код пункта приема посылок - задает пункт, куда ваш ИМ сдает посылки (targetstart)**</label><input name="option3" class="fivecms_inp" type="text" value="{if !empty($delivery->option3)}{$delivery->option3|escape}{/if}" /></li>
				<li>** Если параметр (targetstart) не задан, то по умолчанию расчет будет производиться от пункта приема, который указан в настройках базового тарифа</li>
				<li><label class="property">Заказ отправляется на условиях:</label>
					<select name="option4" class="fivecms_inp" style="width: 100px;">
						<option value='0' {if isset($delivery->option4) && $delivery->option4 == '0'}selected{/if}>По предоплате</option>
						<option value='1' {if isset($delivery->option4) && $delivery->option4 == '1'}selected{/if}>Наложенным платежом</option>
					</select>
				</li>
			</ul>		
		</div>
		{elseif $delivery->id == 114}
		<div class="block layer widget" id="cdek">
			<ul>
				<li>Для начала работы необходимо зарегистрироваться на сайте <a href="https://www.cdek.ru/clients/reglament.html" target="_blank">СДЭК  и заключить с ними договор</a></li>
				<li><label class="property">Город по умолчанию (defaultCity)*</label><input placeholder="Напр.: Санкт-Петербург" name="option1" class="fivecms_inp" type="text" value="{if !empty($delivery->option1)}{$delivery->option1|escape}{/if}" /></li>
				<li>* Если не задан параметр defaultCity, то местоположение клиента будет определяться автоматически.</li>
				<li><label class="property">Из какого города будет идти доставка (cityFrom)</label><input placeholder="Напр.: Москва" name="option2" class="fivecms_inp" type="text" value="{if !empty($delivery->option2)}{$delivery->option2|escape}{/if}" /></li>
				<li><label class="property">Страна, для которой показывать список ПВЗ (country)</label><input placeholder="Напр.: Россия" name="option3" class="fivecms_inp" type="text" value="{if !empty($delivery->option3)}{$delivery->option3|escape}{/if}" /></li>
				<li><label class="property">API-ключ Яндекс.Карт <a class="bluelink" href="https://5cms.ru/blog/yandex-maps-api" target="_blank">(как получить?)</a></label><input placeholder="Напр.: 2e19g7d5-d897-7b59-2ab6-8427cdbf43a1" name="option4" class="fivecms_inp" type="text" value="{if !empty($delivery->option4)}{$delivery->option4|escape}{/if}" /></li>
				{*<li><label class="property">Стоимость доставки, если сервер СДЭК недоступен</label><input name="option5" class="fivecms_inp" type="number" min="0" step="1" style="width:50px;" value="{if !empty($delivery->option5)}{$delivery->option5|escape}{/if}" /> {$currency->sign|escape}</li>*}
				<li>** полученные при регистрации (аккаунт к интеграции и ключ), а также выбранные тарифы необходимо указать в файле /service.php в корневой директории (правится через файловый менеджер)</li>
			</ul>		
		</div>
		{elseif $delivery->id == 4}
		<div class="block layer widget" id="cdek">
			<p style="margin-bottom:15px;"><a class="bluelink" href="http://5cms.ru/blog/postrf" target="_blank">{$tr->instruction|capitalize}</a></p>
			<ul>
				<li><label class="property">ID виджета *</label><input placeholder="Напр.: 6935" name="option1" class="fivecms_inp" type="text" value="{if !empty($delivery->option1)}{$delivery->option1|escape}{/if}" /></li>
			</ul>		
		</div>
		{elseif $delivery->id == 3}
		<div class="block layer widget" id="shiptor">
			<p style="margin-bottom:15px;"><a class="bluelink" href="http://5cms.ru/blog/shiptor" target="_blank">{$tr->instruction|capitalize}</a></p>
			<ul>
				<li><label class="property" style="margin-right:10px;"><a href="https://shiptor.ru/help/integration/e-shop-widgets/calculation-widget-settings#article_7" target="_blank">КЛАДР код</a> города отправки (если Москва, то ничего не указывать)</label><input placeholder="напр.: 7800000000000" name="option1" class="fivecms_inp" type="text" value="{if !empty($delivery->option1)}{$delivery->option1|escape}{/if}" /></li>
				<li><label class="property" style="margin-right:10px;">Публичный ключ API Shiptor</label><input name="option2" class="fivecms_inp" type="text" value="{if !empty($delivery->option2)}{$delivery->option2|escape}{/if}" /></li>
				<p style="margin-bottom:10px;">* скопировать в ЛК Шиптора в Настройки > API > API токен для https://api.shiptor.ru/public/v1</p>
				<li><label class="property" style="margin-right:10px;">Наложенным платежом:</label>
					<select name="option3" class="fivecms_inp" style="width: 100px;">
						<option value="0" {if isset($delivery->option3) && $delivery->option3 == '0'}selected{/if}>Нет</option>
						<option value="1" {if isset($delivery->option3) && $delivery->option3 == '1'}selected{/if}>Да</option>
					</select>
				</li>
				<li><label class="property" style="margin-right:10px;">API-ключ Яндекс.Карт (<a  href="http://5cms.ru/blog/yandex-maps-api" target="_blank">получить</a>)</label><input name="option5" class="fivecms_inp" type="text" value="{if !empty($delivery->option5)}{$delivery->option5|escape}{/if}" /></li>
				<li><label class="property" style="margin-right:10px;">Транспортные компании (если не указано, то все доступные)</label><input placeholder="напр.: shiptor_today,dpd_auto" name="option4" class="fivecms_inp" type="text" value="{if !empty($delivery->option4)}{$delivery->option4|escape}{/if}" /></li>
			</ul>		
		</div>
		{elseif $delivery->id == 122}

		<script src="design/js/autocomplete/jquery.autocomplete.js"></script>

		<div class="block layer widget" id="postcalc">
			<ul>
				<li>Для начала работы необходимо зарегистрироваться на сайте <a href="https://https://www.postcalc.ru/" target="_blank">Тарифы Почты России и EMS и заключить с ними договор</a></li>
				<li>
					<label for="from" class="property" style="width: 350px;">Шестизначный индекс или местоположение EMS (название региона или центр региона)</label>
					<input id="from" placeholder="Напр.: Москва или 101700" name="option1[default_from]" class="fivecms_inp" type="text" value="{$delivery->option1['default_from']}" />
				</li>
				<li>
					<label class="property" style="width: 350px;">Скрыть адрес отправления</label>
					<select name="option1[hide_from]">
						<option value="0" {if isset($delivery->option1['hide_from']) && $delivery->option1['hide_from'] == 0}selected{/if}>Нет</option>
						<option value="1" {if isset($delivery->option1['hide_from']) && $delivery->option1['hide_from'] == 1}selected{/if}>Да</option>
					</select>
				</li>
				<li>
					<label for="from" class="property" style="width: 350px;">Округление вверх стоимости доставки</label>
					<select name="option1[r]">
						<option value="0.01" {if isset($delivery->option1['r']) && $delivery->option1['r'] == 0.01}selected{/if}>До копеек</option>
						<option value="1" {if isset($delivery->option1['r']) && $delivery->option1['r'] == 1}selected{/if}>До рублей</option>
					</select>
				</li>
				<li>
					<label class="property" style="width: 350px;">Запрашивать расчёты для отправлений (Для выбора нескольких значений используйте Ctrl или Shift + click)</label>
					<select name="option1[p][]" multiple style="height: 200px;">
						{foreach from=$postcalc->parcels key=$label item=$items}
							<optgroup label="{$label}">
								{foreach from=$items key=$key item=$value}
									<option value="{$key}" {if isset($delivery->option1['p']) && in_array($key, $delivery->option1['p'])}selected{/if}>{$value|escape}</option>
								{/foreach}
							</optgroup>
						{/foreach}
					</select>
				</li>
				<li>
					<label class="property" style="width: 350px;">Коробка Почты России (пока только для отправления ЕКОМ)</label>
					<select name="option1[bo]">
						<option value=""></option>
						{foreach from=$postcalc->boxes key=$key item=$value}
							<option value="{$key}" {if isset($delivery->option1['bo']) && $delivery->option1['bo'] == $key}selected{/if}>{$value}</option>
						{/foreach}
					</select>
				</li>
				<li>
					<label class="property" style="width: 350px;">Опции и доп. услуги (Для выбора нескольких значений используйте Ctrl или Shift + click)</label>
					<select name="option1[sv][]" multiple style="height: 200px;">
						{foreach from=$postcalc->services key=$key item=$value}
							<option value="{$key}" {if isset($delivery->option1['sv']) && in_array($key, $delivery->option1['sv'])}selected{/if}>{$value|escape}</option>
						{/foreach}
					</select>
				</li>
			</ul>
			<script>
				$(document).ready(function($) {
					$("input#from").autocomplete({
						serviceUrl:'/Postcalc/AjaxPostcalc.php',
						params: {
							delivery_id: '{$delivery->id}',
							action: 'autocomplete'
						},
						minChars: 0,
						noCache: false,
						onSelect: function (suggestion) {
							$(this).val(suggestion.value);
							console.log(this);
							return suggestion.index;
						},
						formatResult: function (suggestions) {
							console.log(suggestions);
							return suggestions.value;
						}
					});
				});
			</script>
		</div>
		{else}
			<input name="option1" type="hidden" value="" />
			<input name="option2" type="hidden" value="" />
			<input name="option3" type="hidden" value="" />
			<input name="option4" type="hidden" value="" />
			<input name="option5" type="hidden" value="" />
		{/if}
		
		<!-- Описание -->
		<div class="block layer">
			<h2>{$tr->description|escape}</h2>
			<textarea name="description" class="editor_small">{if !empty($delivery->description)}{$delivery->description|escape}{/if}</textarea>
		</div>
		<!-- Описание (The End)-->
		
		<div class="block layer widget" {if !empty($delivery->widget) && $delivery->widget == 1}{else}style="display:none;"{/if}>
			{$tr->widget_instruction}
			{if !empty($delivery->id)}<p style="font-size:16px;font-weight:700;margin-bottom:15px;color:#7080ca;">Ваш_id: {$delivery->id}</p>{/if}
			<h2>Код виджета</h2>
			<textarea name="code" style="width:100%;height:400px;">{if !empty($delivery->code)}{$delivery->code}{/if}</textarea>
		</div>
		
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Основная форма (The End) -->

</div>
{literal}
<style>
.widget .fivecms_inp{margin-left:10px;}
.widget li{width:100% !important;}
#shiptor label{width:242px!important;}
#cdek label{width:330px!important;}
#boxberry label{width:350px!important;}
#boxberry .fivecms_inp{width:250px!important}
</style>
{/literal}
