{capture name=tabs}
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=ImportAdmin">{$tr->import_csv|escape}</a></li>{/if}
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=ImportYmlAdmin">{$tr->import_xml|escape}</a></li>{/if}
	{if in_array('export', $manager->permissions)}<li><a href="index.php?module=ExportAdmin">{$tr->export_csv|escape}</a></li>{/if}
	{if in_array('backup', $manager->permissions)}<li><a href="index.php?module=BackupAdmin">{$tr->backup|escape}</a></li>{/if}
	{if in_array('multichanges', $manager->permissions)}<li><a href="index.php?module=MultichangesAdmin">{$tr->packet|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=OnecAdmin">1C</a></li>
{/capture}
{$meta_title='1C' scope=root}

{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span>
	{$message_error}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

{if isset($message_success)}
<!-- Системное сообщение -->
<div class="message message_success">
	<span>
	{$message_success}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}
 
<div class="onecsettings">
	<div class="block">	
		<form method="post" id="settings" enctype="multipart/form-data">
			<input type="hidden" name="session_id" value="{$smarty.session.id}">
				
					<h2>Настройки обмена данными с 1C или другими сервисами по CommerceML (CML)</h2>
					<div style="display:table;margin-bottom:15px;padding:5px;border:1px dashed #dadada;background-color:#f4f4f4;border-radius:5px;">
						<h3 style="margin-bottom:10px;">АДРЕС:</h3>
						<ul class="stars">
						<li>Модуль для старых версий 1С: <strong>{$config->root_url}/fivecms/cml/1c_exchange.php</strong></li>
						<li>Модуль для новых версий 1С: <strong>{$config->root_url}/fivecms/cml/1c_exchange2.php</strong></li>
						</ul>
					</div>
					<ul>
						<li><label class=property>Название параметра товара, передаваемого как бренд</label>
							<select name="onebrand" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->onebrand == '0'}selected{/if}>Свойства->Производитель</option>
								<option value='1' {if $settings->onebrand == '1'}selected{/if}>Товар->Изготовитель или Свойства->Изготовитель</option>
							</select>
						</li>
						<li><label class=property>Бренд передается в явном виде *</label>
							<select name="onegetbrand" class="fivecms_inp" style="width: 100px;">
								<option value='1' {if $settings->onegetbrand == '1'}selected{/if}>нет</option>
								<option value='0' {if $settings->onegetbrand == '0'}selected{/if}>да</option>
							</select>
							<p style="max-width:600px;margin:6px 0 10px;padding-bottom:10px;font-style:italic;font-size:13px;border-bottom:1px dashed #dadada;">* Если при импорте вместо названия бренда получаете его ID, то нужно выбрать "Нет"</p>
						</li>
						<li><label class=property>В мета-заголовок товара/категории/бренда подставлять его название</label>
							<select name="onemetatitle" class="fivecms_inp" style="width: 100px;vertical-align:top;">
								<option value='0' {if $settings->onemetatitle == '0'}selected{/if}>нет</option>
								<option value='1' {if $settings->onemetatitle == '1'}selected{/if}>да</option>
							</select>
						</li>
						<li><label class=property>В названии товара использовать тег</label>
							<select name="oneprodname" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->oneprodname == '0'}selected{/if}>Товар->Наименование</option>
								<option value='1' {if $settings->oneprodname == '1'}selected{/if}>ЗначенияРеквизитов->Полное наименование</option>
							</select>
						</li>
						<li><label class=property>В кратком описании товара использовать тег</label>
							<select name="oneprodannot" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->oneprodannot == '0'}selected{/if}>Не использовать</option>
								<option value='1' {if $settings->oneprodannot == '1'}selected{/if}>ЗначенияРеквизитов->Полное наименование</option>
								<option value='1' {if $settings->oneprodannot == '2'}selected{/if}>Товар->Описание</option>
							</select>
						</li>
						<li><label class=property>В полном описании товара использовать тег</label>
							<select name="oneprodbody" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->oneprodbody == '0'}selected{/if}>Товар->Описание</option>
								<option value='1' {if $settings->oneprodbody == '1'}selected{/if}>ЗначенияРеквизитов->Полное наименование</option>
								<option value='1' {if $settings->oneprodbody == '2'}selected{/if}>ЗначенияРеквизитов->ОписаниеВФорматеHTML</option>
							</select>
						</li>
						<li style="display:none;"><label class=property>Название параметра заказа, используемого как телефон</label>
							<select name="onephone" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->onephone == '0'}selected{/if}>Телефон рабочий</option>
								<option value='1' {if $settings->onephone == '1'}selected{/if}>Телефон (МС и старые версии 1С)</option>
							</select>
						</li>
						<li style="display:none;"><label class=property>Название параметра заказа, используемого как Email</label>
							<select name="oneemail" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->oneemail == '0'}selected{/if}>Электронная почта</option>
								<option value='1' {if $settings->oneemail == '1'}selected{/if}>Почта (МС и старые версии 1С)</option>
							</select>
						</li>
						<li><label class=property>Обновлять при импорте</label>
							<select name="oneprodupdate" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->oneprodupdate == '0'}selected{/if}>товар целиком</option>
								<option value='1' {if $settings->oneprodupdate == '1'}selected{/if}>только варианты товара</option>
							</select>
						</li>
						<li><label class=property>Удалять при каждом обмене временные файлы</label>
							<select name="oneunlink" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->oneunlink == '0'}selected{/if}>нет</option>
								<option value='1' {if $settings->oneunlink == '1'}selected{/if}>да</option>
							</select>
						</li>
						<li><label class=property>Импортировать единицы измерения **</label>
							<select name="oneunits" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->oneunits == '0'}selected{/if}>нет</option>
								<option value='1' {if $settings->oneunits == '1'}selected{/if}>да</option>
							</select>
							<p style="max-width:600px;margin:6px 0 10px;padding-bottom:10px;font-style:italic;font-size:13px;border-bottom:1px dashed #dadada;">** В 1С у единицы измерения должно быть указано "НаименованиеКраткое" и в файле выгрузки import.xml для единицы измерения должно присутствовать "Ид". А также единицы измерения должны совпадать с используемыми на сайте (см. <a class="bluelink" href="index.php?module=SetCatAdmin">"Индивидуальные единицы измерения товаров"</a>).</p>
						</li>
						<li><label class=property>Пересчитывать цены в базовую валюту</label>
							<select name="onecurrency" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->onecurrency == '0'}selected{/if}>нет</option>
								<option value='1' {if $settings->onecurrency == '1'}selected{/if}>да</option>
							</select>
						</li>
						<li><label style="width:420px;" class=property>Обрабатывать "ХарактеристикиТовара" "Размер" и "Цвет" ****</label>
							<select name="onesizecol" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->onesizecol == '0'}selected{/if}>нет</option>
								<option value='1' {if $settings->onesizecol == '1'}selected{/if}>да</option>
							</select>
							<p style="max-width:600px;margin:6px 0 10px;padding-bottom:10px;font-style:italic;font-size:13px;border-bottom:1px dashed #dadada;">**** Если выбрано "нет", то "Размер" и "Цвет" будут просто объединены в название варианта товара.</p>
						</li>
						
						<li><label class="property" style="margin-right:10px;">Дата последнего переданного в 1С заказа (более ранние заказы не будут выгружаться)</label>
						<input style="min-width:195px;" name="last_1c_orders_export_date" class="fivecms_inp" type="text" value="{$settings->last_1c_orders_export_date|escape}" placeholder="напр.: 2020-04-27 16:39:46" />
						</li>
					</ul>
					
					<h2 style="margin-top:15px;">Соответствие <a class="bluelink" href="http://5cms.ru/blog/labels" target="_blank">статусов заказа</a> CMS статусам в 1С</h2>
					<ul>
						<li>
							<label class="property" style="width:90px;">Новый</label>
							<input style="max-width:58px;width:58px;" name="one_status0" class="fivecms_inp" type="text" value="{$settings->one_status0|escape}" placeholder="напр.: C" />
						</li>
						<li>
							<label class="property" style="width:90px;">В обработке</label>
							<input style="max-width:58px;width:58px;" name="one_status4" class="fivecms_inp" type="text" value="{$settings->one_status4|escape}" placeholder="напр.: C" />
						</li>
						<li>
							<label class="property" style="width:90px;">Принят</label>
							<input style="max-width:58px;width:58px;" name="one_status1" class="fivecms_inp" type="text" value="{$settings->one_status1|escape}" placeholder="напр.: N" />
						</li>
						<li>
							<label class="property" style="width:90px;">Выполнен</label>
							<input style="max-width:58px;width:58px;" name="one_status2" class="fivecms_inp" type="text" value="{$settings->one_status2|escape}" placeholder="напр.: F" />
						</li>
						<li>
							<label class="property" style="width:90px;">Удален</label>
							<input style="max-width:58px;width:58px;" name="one_status3" class="fivecms_inp" type="text" value="{$settings->one_status3|escape}" placeholder="напр.: X" />
						</li>
					</ul>
					
					<div style="display:table;margin:15px 0 10px 0;padding:7px;border:1px dashed #dadada;background-color:#f4f4f4;border-radius:5px;">
						<p style="font-weight:700;margin-bottom:10px;">Для модуля старых версий 1С:</p>
						<ul>
							<li><label class=property>Выгружать в заказах ИД товаров в виде</label>
								<select name="oneid" class="fivecms_inp" style="width: 100px;">
									<option value='0' {if $settings->oneid == '0'}selected{/if}>ИД_товара#ИД_варианта_товара</option>
									<option value='1' {if $settings->oneid == '1'}selected{/if}>ИД_варианта_товара</option>
								</select>
								<p style="max-width:600px;margin:6px 0 10px;padding-bottom:10px;font-style:italic;font-size:13px;border-bottom:1px dashed #dadada;">Если при выгрузке с сайта заказов создаются дубли товаров, то выбрать "ИД_варианта_товара"
								</p>
							</li>
							<li><label class=property>Вариант загрузки изображений из 1С ***</label>
								<select name="oneimages" class="fivecms_inp">
									<option value='0' {if $settings->oneimages == '0'}selected{/if}>стандартный</option>
									<option value='1' {if $settings->oneimages == '1'}selected{/if}>локальный</option>
								</select>
								<p style="max-width:600px;margin:6px 0 10px;padding-bottom:10px;font-style:italic;font-size:13px;border-bottom:1px dashed #dadada;">*** Если выбран вариант "локальный", то необходимо выгрузить картинки из 1С локально и затем через файловый менеджер на хостинге или FTP-клиент их залить (обратите внимание, <strong>не должно быть подпапок</strong> у изображений) в папку /files/originals</p>
							</li>
							
							<li><label style="width:450px;" class=property>Варианты/модификации товаров находятся в файле offers.xml</label>
								<select name="onevariants" class="fivecms_inp" style="width: 100px;">
									<option value='0' {if $settings->onevariants == '0'}selected{/if}>да</option>
									<option value='1' {if $settings->onevariants == '1'}selected{/if}>нет</option>
								</select>
								<p style="max-width:600px;margin:6px 0 10px;font-style:italic;font-size:13px;">Если после импорта вы видите пустые варианты товаров, то выберите "да"</p>
								<p style="max-width:600px;margin:6px 0 0px;font-style:italic;font-size:13px;">Если в папке /fivecms/cml/temp/ (или среди выгружаемых из 1С файлов) вы видите только два .xml файла import и offers, то выберите "да"</p>
							</li>
							
						</ul>
					</div>

			<input style="margin-top:15px;" class="button_green" type="submit" name="settings" value="Применить" />
		</form>
	</div>		
	<div class="border_box" style="display:table; width:400px;clear:both; "></div>
	<a class="bigbutton" href="http://5cms.ru/blog/1s" target="_blank">Инструкция по настройке 1C</a>
	<div class="border_box" style="display:table; width:400px;clear:both; margin-top: 15px; border-top: 2px dashed #bdbdbd; padding-top:20px;height:2px;"></div>
	<div id="delete_all_products" class="block" style="padding-top: 10px;margin-bottom:40px;">
		<span onClick="$('.quest').hide();$('.confirm').show();" class="button_green quest">Удалить все товары?</span>
		<div class="confirm" style="display:none;">
			<div style="display:table;background-color:#5a5858;margin-bottom:20px;" class="button_green delete_ajax">Подвердить удаление всех товаров и их фото!</div>
			
			<div style="display:table;background-color:#5a5858;" class="button_green delete_ajax_noimage">Подвердить удаление всех товаров без удаления фото!</div>
			
			<div style="display:none;margin-top:15px;" class="message message_error">
				<span>Что-то пошло не так. Попробуйте еще раз.</span>
			</div>
			<div style="display:none;" class="message message_success">
				<span>Товары успешно удалены.</span>
			</div>
		</div>
	</div>	
	
</div>

{literal}
<style>
.confirm .message{display:table;}
.started{animation-name: blink;
    animation-timing-function: linear;
    animation-duration: 1s;
    animation-iteration-count: infinite;}
@keyframes blink {50% {opacity:0.65;}}    
</style>
<script>
$('.delete_ajax').click(function() {
	$('.confirm .message_error').hide();
	$('.delete_ajax').addClass('started');
	$.ajax({
		type: "GET",
		url: "ajax/delete_products.php",
		dataType: 'json', 
		statusCode: { 
			404: function(){ 
			  $('.confirm .message_error').show();
			},
			403: function(){ // access
			  $('.confirm .message_error').show();
			},
			500: function(){ 
			  $('.confirm .message_error').show();
			},
			504: function(){ // timeout
			  $('.confirm .message_error').show();
			}
		  },
		success: function(result){
			if(result == 'delete_success'){
				$('.delete_ajax').hide();
				$('.delete_ajax_noimage').hide();
				$('.confirm .message_success').show();
			} else {
				$('.confirm .message_error').show();
			}
		}
	});
    return false;
});
$('.delete_ajax_noimage').click(function() {
	$('.confirm .message_error').hide();
	$('.delete_ajax_noimage').addClass('started');
	$.ajax({
		type: "GET",
		url: "ajax/delete_products_noimage.php",
		dataType: 'json', 
		statusCode: { 
			404: function(){ 
			  $('.confirm .message_error').show();
			},
			403: function(){ // access
			  $('.confirm .message_error').show();
			},
			500: function(){ 
			  $('.confirm .message_error').show();
			},
			504: function(){ // timeout
			  $('.confirm .message_error').show();
			}
		  },
		success: function(result){
			if(result == 'delete_success'){
				$('.delete_ajax_noimage').hide();
				$('.delete_ajax').hide();
				$('.confirm .message_success').show();
			} else {
				$('.confirm .message_error').show();
			}
		}
	});
    return false;
});
</script>
{/literal}
