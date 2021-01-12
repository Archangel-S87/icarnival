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
	<div class="block" style="padding-top: 20px;">	
		<form method="post" id="settings" enctype="multipart/form-data">
			<input type="hidden" name="session_id" value="{$smarty.session.id}">
				
					<h2>Настройки обмена данными с 1C</h2>
					<p style="margin-bottom:20px;">! Первый пункт в выпадающем списке наиболее вероятное значение для свежих версий 1С</p>
					<ul>
						<li><label class=property>Название параметра товара, передаваемого как бренд</label>
							<select name="onebrand" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->onebrand == '0'}selected{/if}>Производитель</option>
								<option value='1' {if $settings->onebrand == '1'}selected{/if}>Изготовитель (старые версии 1С)</option>
							</select>
						</li>
						<li style="display:none;"><label class=property>Отдаем success после last_1c_orders_export_date </label>
							<select name="onesuccess" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->onesuccess == '0'}selected{/if}>нет</option>
								<option value='1' {if $settings->onesuccess == '1'}selected{/if}>да</option>
							</select>
						</li>
						<li><label class=property>Передавать ВидНоменклатуры у товара</label>
							<select name="onevid" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->onevid == '0'}selected{/if}>да</option>
								<option value='1' {if $settings->onevid == '1'}selected{/if}>нет</option>
							</select>
						</li>
						<li style="display:none;"><label class=property>Вариант выгрузки Доставки</label>
							<select name="onedeliv" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->onedeliv == '0'}selected{/if}>$t1 = $t1 (услуга)</option>
								<option value='1' {if $settings->onedeliv == '1'}selected{/if}>$t1_1 = $t1->addChild (услуга)</option>
								<option value='2' {if $settings->onedeliv == '2'}selected{/if}>$t1_1 = $t1->addChild (товар)</option>
							</select>
						</li>
						<li><label class=property>Название параметра заказа, используемого как телефон</label>
							<select name="onephone" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->onephone == '0'}selected{/if}>ТелефонРабочий</option>
								<option value='1' {if $settings->onephone == '1'}selected{/if}>Телефон (старые версии 1С)</option>
							</select>
						</li>
						<li style="display:none;"><label class=property>Передавать блок Скидка у товара</label>
							<select name="oneskid" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->oneskid == '0'}selected{/if}>нет</option>
								<option value='1' {if $settings->oneskid == '1'}selected{/if}>да</option>
							</select>
						</li>
						<li><label class=property>Обновлять при импорте</label>
							<select name="oneprodupdate" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->oneprodupdate == '0'}selected{/if}>товар целиком</option>
								<option value='1' {if $settings->oneprodupdate == '1'}selected{/if}>только варианты товара</option>
							</select>
						</li>
						<li><label class=property>Предварительно очищать при каждом импорте все варианты товаров</label>
							<select name="oneflushvar" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->oneflushvar == '0'}selected{/if}>нет</option>
								<option value='1' {if $settings->oneflushvar == '1'}selected{/if}>да</option>
							</select>
						</li>
						<li><label class=property>Импортировать единицы измерения</label>
							<select name="oneunits" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->oneunits == '0'}selected{/if}>нет</option>
								<option value='1' {if $settings->oneunits == '1'}selected{/if}>да</option>
							</select>
							<p style="max-width:600px;margin:10px 0 15px 0;font-style:italic;">Единицы измерения должны совпадать с используемыми на сайте (см в выпадающем списке в карточке товара).</p>
						</li>
						<li><label class=property>Пересчитывать цены в базовую валюту</label>
							<select name="onecurrency" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->onecurrency == '0'}selected{/if}>нет</option>
								<option value='1' {if $settings->onecurrency == '1'}selected{/if}>да</option>
							</select>
						</li>
						<li><label class=property>Вариант загрузки изображений из 1С</label>
							<select name="oneimages" class="fivecms_inp">
								<option value='0' {if $settings->oneimages == '0'}selected{/if}>стандартный</option>
								<option value='1' {if $settings->oneimages == '1'}selected{/if}>локальный</option>
							</select>
							<p style="max-width:600px;margin:10px 0 15px 0;font-style:italic;">Если выбран вариант "локальный", то необходимо выгрузить картинки из 1С локально и затем через файловый менеджер на хостинге или FTP-клиент их залить (обратите внимание, <strong>не должно быть подпапок</strong> у изображений) в папку /files/originals</p>
						</li>
						<li><label class=property>Для всех товаров передаются варианты/модификации в offers</label>
							<select name="onevariants" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->onevariants == '0'}selected{/if}>да</option>
								<option value='1' {if $settings->onevariants == '1'}selected{/if}>нет</option>
							</select>
							<p style="max-width:600px;margin:10px 0 15px 0;font-style:italic;">Если после импорта вы видите пустые варианты товаров, то выберите "да"</p>
						</li>
						<li><label class=property>Обрабатывать ХарактеристикиТовара "Размер" и "Цвет"</label>
							<select name="onesizecol" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->onesizecol == '0'}selected{/if}>нет</option>
								<option value='1' {if $settings->onesizecol == '1'}selected{/if}>да</option>
							</select>
							<p style="max-width:600px;margin-top:10px;font-style:italic;">Если выбрано "да", то в ХарактеристикиТовара не должно быть ничего иного кроме "Размер" и "Цвет". Если выбрано "нет", то "Размер" и "Цвет" будут просто объединены в название варианта товара.</p>
						</li>
					</ul>

			<input style="margin-top:15px;" class="button_green" type="submit" name="settings" value="Применить" />
		</form>
	</div>		
	<div class="border_box" style="display:table; width:400px;clear:both; margin-top: 25px; border-top: 2px dashed #bdbdbd; padding-top:20px;height:2px;"></div>
	<a class="bigbutton" href="http://5cms.ru/blog/1s" target="_blank">Инструкция по настройке 1C</a>
	<div class="border_box" style="display:table; width:400px;clear:both; margin-top: 35px; border-top: 2px dashed #bdbdbd; padding-top:20px;height:2px;"></div>
	<div class="block" style="padding-top: 10px;margin-bottom:40px;">
		<span onClick="$('.quest').hide();$('.confirm').show();" class="button_green quest">Удалить все товары?</span>
		<div class="confirm" style="display:none;">
			<div style="display:table;background-color:#5a5858;" class="button_green delete_ajax">Нажмите еще раз для подтверждения удаления!</div>
			
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
</style>
<script>
$('.delete_ajax').click(function() {
	$('.confirm .message_error').hide();
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
