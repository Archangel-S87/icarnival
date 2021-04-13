{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=SetCatAdmin">{$tr->settings_cat|escape}</a></li>
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SetModAdmin">{$tr->settings_modules|escape}</a></li>{/if}
{/capture}
 
{$meta_title = $tr->settings_cat|escape scope=root}

<div id="onecolumn" class="promopage">

	{if isset($message_success)}
		<!-- Системное сообщение -->
		<div class="message message_success">
			<span class="text">{if $message_success == 'saved'}{$tr->updated|escape}{elseif $message_success == 'cache_cleared'}{$tr->cache_cleared|escape}{/if}</span>
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
	
				<!-- Параметры -->
				<div class="block layer">
					<h2>{$tr->price_format|escape}</h2>
					<ul>
						<li><label class=property>{$tr->decimals_point|escape}</label>
							<select name="decimals_point" class="fivecms_inp">
								<option value='.' {if $settings->decimals_point == '.'}selected{/if}>12.45</option>
								<option value=',' {if $settings->decimals_point == ','}selected{/if}>12,45</option>
							</select>
						</li>
						<li><label class=property>{$tr->thousands_separator|escape}</label>
							<select name="thousands_separator" class="fivecms_inp">
								<option value='' {if $settings->thousands_separator == ''}selected{/if}>1245678</option>
								<option value=' ' {if $settings->thousands_separator == ' '}selected{/if}>1 245 678</option>
							</select>
						
						</li>
					</ul>
				</div>
				<!-- Параметры (The End)-->
				
				<!-- Параметры -->
				<div id="managecat" class="block layer">
					<h2>{$tr->settings_cat|escape}</h2>
					<ul>
						<li><label class=property>{$tr->prods_on_page|escape}</label><input style="max-width: 50px;" name="products_num" class="fivecms_inp" min="0" step="1" type="number" value="{$settings->products_num|escape}" /></li>
						<li><label class=property>{$tr->prods_on_page_admin|escape}</label><input style="max-width: 50px;" name="products_num_admin" class="fivecms_inp" min="0" step="1" type="number" value="{$settings->products_num_admin|escape}" /></li>
						<li><label class=property>{$tr->max_prods_order}</label><input style="max-width: 50px;" name="max_order_amount" class="fivecms_inp" min="0" step="1" type="number" placeholder="100" value="{$settings->max_order_amount|escape}" /></li>
						
						<li><label class=property>{$tr->prods_unit|escape} {$tr->default|escape}</label><input style="max-width: 50px;" name="units" class="fivecms_inp" type="text" value="{$settings->units|escape}" /></li>
						
						<li><label class=property>{$tr->individual_prods_units|escape}</label>
							<select name="b9manage" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->b9manage == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
								<option value='1' {if $settings->b9manage == '1'}selected{/if}>{$tr->show|lower|escape}</option>
							</select>
						</li>
						
						<li><label class=property></label><input placeholder="{$tr->comma_separated|escape}" style="max-width: 300px;" name="units_list" class="fivecms_inp" type="text" value="{$settings->units_list|escape}" /></li>
						
						<li><label class=property>{$tr->prods_sort_by|escape}</label>
							<select name="sort_by" class="fivecms_inp" style="width: auto;">
								<option value="position" {if $settings->sort_by == 'position'}selected{/if}>{$tr->by_position|escape}</option>
								<option value="priceup" {if $settings->sort_by == 'priceup'}selected{/if}>{$tr->by_price|escape} &#8593;</option>
								<option value="pricedown" {if $settings->sort_by == 'pricedown'}selected{/if}>{$tr->by_price|escape} &#8595;</option>
								<option value="name" {if $settings->sort_by == 'name'}selected{/if}>{$tr->by_name|escape}</option>
								<option value="date" {if $settings->sort_by == 'date'}selected{/if}>{$tr->by_date|escape}</option>
								<option value="stock" {if $settings->sort_by == 'stock'}selected{/if}>{$tr->by_stock|escape}</option>
								<option value="rating" {if $settings->sort_by == 'rating'}selected{/if}>{$tr->by_rating|escape}</option>
							</select>
						</li>
						
						<li><label class=property>{$tr->menu_brand_link|escape}</label>
							<select name="show_brands" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->show_brands == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
								<option value='1' {if $settings->show_brands == '1'}selected{/if}>{$tr->show|lower|escape}</option>
							</select>
						</li>
	
						<li><label class=property>{$tr->variant_filter|escape}</label>
							<select name="b10manage" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->b10manage == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
								<option value='1' {if $settings->b10manage == '1'}selected{/if}>{$tr->show|lower|escape}</option>
							</select>
						</li>
						
						<li><label class=property>{$tr->size_filter|escape}</label>
							<select name="sizemanage" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->sizemanage == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
								<option value='1' {if $settings->sizemanage == '1'}selected{/if}>{$tr->show|lower|escape}</option>
							</select>
						</li>
						
						<li><label class=property>{$tr->color_filter|escape}</label>
							<select name="colormanage" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->colormanage == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
								<option value='1' {if $settings->colormanage == '1'}selected{/if}>{$tr->show|lower|escape}</option>
							</select>
						</li>
		
						<li><label class=property>{$tr->out_of_stock_prods|escape}</label>
							<select name="showinstock" class="fivecms_inp" style="width: auto;">
								<option value='0' {if $settings->showinstock == '0'}selected{/if}>{$tr->show|lower|escape}</option>
								<option value='1' {if $settings->showinstock == '1'}selected{/if}>{$tr->hide|lower|escape}</option>
								<option value='2' {if $settings->showinstock == '2'}selected{/if}>{$tr->to_end_list|escape}</option>
							</select>
						</li>

						<li><label class=property>{$tr->min_order_amount|escape}</label><input min="0" step="1" style="max-width: 85px;" name="minorder" class="fivecms_inp" type="number" value="{$settings->minorder|escape}" /> {$currency->sign}</li>
						
						<li><label class=property>{$tr->rating_num|escape} {$tr->default|escape}</label><input min="0" max="5" step="0.1" style="max-width: 85px;" name="prods_rating" class="fivecms_inp" type="number" value="{$settings->prods_rating|escape}" /></li>
						
						<li><label class=property>{$tr->votes_num|escape} {$tr->default|escape}</label><input min="0" step="1" style="max-width: 85px;" name="prods_votes" class="fivecms_inp" type="number" value="{$settings->prods_votes|escape}" /></li>
						
						<li><label class=property>{$tr->cut_description_height|escape}</label><input min="100" step="1" style="max-width: 55px;" name="cutouter" class="fivecms_inp" type="number" value="{$settings->cutouter|escape}" /> px</li>
						<li><label class=property>{$tr->cut_seo_height|escape}</label><input min="0" step="1" style="max-width: 55px;" name="cutseo" class="fivecms_inp" type="number" value="{$settings->cutseo|escape}" /> px</li>
						
						<li><label class="property">{$tr->check_download|escape}</label>
							<select name="check_download" class="fivecms_inp" style="width:75px;min-width:75px;">
								<option value='0' {if $settings->check_download == '0'}selected{/if}>{$tr->no|escape}</option>
								<option value='1' {if $settings->check_download == '1'}selected{/if}>{$tr->yes|escape}</option>
							</select>
						</li>

					</ul>
				</div>
				<!-- Параметры (The End)-->
				
				<!-- Параметры -->
				<div id="manageproduct" class="block layer">
					<ul>
						<li><label class="property">{$tr->to_cart_name}</label><input style="max-width: 185px;" name="to_cart_name" class="fivecms_inp" type="text" value="{$settings->to_cart_name|escape}" /></li>
					
						<li><label class="property">{$tr->show1click}</label>
							<select name="show1click" class="fivecms_inp" style="width:100px;">
								<option value='0' {if $settings->show1click == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
								<option value='1' {if $settings->show1click == '1'}selected{/if}>{$tr->show|lower|escape}</option>
							</select>
						</li>
					
						<li><label class=property>{$tr->sku|capitalize|escape} {$tr->in_product_card|escape}</label>
							<select name="showsku" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->showsku == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
								<option value='1' {if $settings->showsku == '1'}selected{/if}>{$tr->show|lower|escape}</option>
							</select>
						</li>

						<li><label class=property>{$tr->stock_available|escape} {$tr->in_product_card|escape}</label>
							<select name="showstock" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->showstock == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
								<option value='1' {if $settings->showstock == '1'}selected{/if}>{$tr->show|lower|escape}</option>
							</select>
						</li>
						
						<li><label class=property>"{$tr->payment} & {$tr->delivery|lower}" {$tr->in_product_card|escape}</label>
							<select name="del_pay" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->del_pay == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
								<option value='1' {if $settings->del_pay == '1'}selected{/if}>{$tr->show|lower|escape}</option>
							</select>
						</li>
						
						<div><label style="margin-bottom:10px;" class="property1"><strong>{$tr->youtube|escape}</strong></label>
						<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more|escape}</a><div id="hideCont" style="clear:both;">
					
							<li><label class=property></label>
								<select name="youtube_product" class="fivecms_inp" style="width:75px;min-width:75px;">
									<option value='0' {if $settings->youtube_product == '0'}selected{/if}>{$tr->hide|lower|escape}</option>
									<option value='1' {if $settings->youtube_product == '1'}selected{/if}>{$tr->show|lower|escape}</option>
								</select>
							</li>		
						
							<li><label class=property>Browser {$tr->or|escape} API key <a class="bluelink" href="https://5cms.ru/blog/youtube" target="_blank">(?)</a></label><input style="max-width:320px;" name="youtube_key" class="fivecms_inp" type="text" value="{$settings->youtube_key}" /></li>
						</div>
					</div>
							
					</ul>
				</div>
				<!-- Параметры (The End)-->
				<input style="margin: 0 0 20px 0; float:left;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
				<!-- Параметры -->
				<div id="managecache" class="block layer">
					<h2>{$tr->cache_settings|escape}:</h2>
					<ul style="margin:12px 0 0 0;">
						<li><label class="property">{$tr->cache_bd|escape}</label>
							<select name="cached" class="fivecms_inp" style="width:75px;min-width:75px;">
								<option value='0' {if $settings->cached == '0'}selected{/if}>{$tr->no|escape}</option>
								<option value='1' {if $settings->cached == '1'}selected{/if}>{$tr->yes|escape}</option>
							</select>
						</li>
						<li><label class="property">{$tr->cache_serv}</label>
							<select name="cache_type" class="fivecms_inp" style="width: 120px;">
								<option value='0' {if $settings->cache_type == '0'}selected{/if}>Memcache</option>
								<option value='1' {if $settings->cache_type == '1'}selected{/if}>Memcached</option>
							</select>
						</li>
						<li><label class="property">{$tr->cache_lifetime|escape}</label><input min="60" step="1" placeholder="напр.: 86400" min="0" step="1" style="max-width: 105px;width: 105px;" name="cache_time" class="fivecms_inp" type="number" value="{$settings->cache_time|escape}" /> сек</li>
						<li style="display:none;"><label class="property">{$tr->ex_cache|escape}</label>
							<select name="ex_cached" class="fivecms_inp" style="width:75px;min-width:75px;">
								<option value='0' {if $settings->ex_cached == '0'}selected{/if}>{$tr->no|escape}</option>
								<option value='1' {if $settings->ex_cached == '1'}selected{/if}>{$tr->yes|escape}</option>
							</select>
						</li>
					</ul>
					<input class="tiny_button color_blue" name="clear_cache" type="submit" value="{$tr->clear_cache|escape}" />
				</div>
				<!-- Параметры (The End)-->
				
				<!-- Параметры -->
				<div id="manageyandex" class="block layer">
					<h2>{$tr->y_market|escape} ({$tr->export} YML):</h2>
					<p style="margin:12px 0;"><span class="helper"><a target="_blank" href="https://5cms.ru/blog/upravlenie-vygruzkoj-v-yandeksmarket" class="bluelink">{$tr->instruction|capitalize|escape}</a></span></p>
					<ul class="stars" style="margin-bottom:10px;">
						<li>{$tr->ym_dynamic|escape}: <strong>{$config->root_url}/yandex.xml</strong></li>
					</ul>
					
					<div style="border:1px dashed #dadada;background-color:#f2f2f2;padding:10px 10px 3px 10px;border-radius:10px;">
					<p style="margin:0px 0 10px 0;">{$tr->ym_cron}: <strong>{$config->root_url}/create_ym.php</strong></p> 
					<ul class="stars" style="margin-bottom:0;">
						<li>{$tr->ym_static|escape}: <strong>{$config->root_url}/files/yandex.xml</strong></li>
					</ul>
					</div>
					
					<ul style="margin-top:12px;">
						
						<li><label class=property>{$tr->vendor_model|escape}</label>
							<select name="vendor_model" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->vendor_model == '0'}selected{/if}>{$tr->no|escape}</option>
								<option value='1' {if $settings->vendor_model == '1'}selected{/if}>{$tr->yes|escape}</option>
							</select>
						</li>
						
						<li><label class=property>{$tr->export_not_in_stock|escape}</label>
							<select name="export_not_in_stock" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->export_not_in_stock == '0'}selected{/if}>{$tr->no|escape}</option>
								<option value='1' {if $settings->export_not_in_stock == '1'}selected{/if}>{$tr->yes|escape}</option>
							</select>
						</li>
						
						<li><label class=property>{$tr->ym_delivery|escape} (<strong>delivery</strong>)</label>
							<select name="ym_delivery" class="fivecms_inp" style="width: 100px;">
								<option value='1' {if $settings->ym_delivery == '1'}selected{/if}>{$tr->yes|escape}</option>
								<option value='0' {if $settings->ym_delivery == '0'}selected{/if}>{$tr->no|escape}</option>
							</select>
						</li>
						
						<li><label class=property>{$tr->for_retail_store|escape} (<strong>store</strong>)</label>
							<select name="for_retail_store" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->for_retail_store == '0'}selected{/if}>{$tr->no|escape}</option>
								<option value='1' {if $settings->for_retail_store == '1'}selected{/if}>{$tr->yes|escape}</option>
							</select>
						</li>
						
						<li><label class=property>{$tr->pickup}</label>
							<select name="for_reservation" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->for_reservation == '0'}selected{/if}>{$tr->no|escape}</option>
								<option value='1' {if $settings->for_reservation == '1'}selected{/if}>{$tr->yes|escape}</option>
							</select>
						</li>

						<li><label class=property>{$tr->export_to_yandex|escape}</label>
							<select name="short_description" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->short_description == '0'}selected{/if}>{$tr->short_description|lower|escape}</option>
								<option value='1' {if $settings->short_description == '1'}selected{/if}>{$tr->full_description|lower|escape} (HTML)</option>
							</select>
						</li>
						
						<li><label class=property>{$tr->manufacturer_warranty|escape}</label>
							<select name="manufacturer_warranty" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->manufacturer_warranty == '0'}selected{/if}>{$tr->no|escape}</option>
								<option value='1' {if $settings->manufacturer_warranty == '1'}selected{/if}>{$tr->yes|escape}</option>
							</select>
						</li>
						
						<li><label class=property>{$tr->seller_warranty|escape}</label>
							<select name="seller_warranty" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->seller_warranty == '0'}selected{/if}>{$tr->no|escape}</option>
								<option value='1' {if $settings->seller_warranty == '1'}selected{/if}>{$tr->yes|escape}</option>
							</select>
						</li>
						
						<li><label class=property>Sales notes ({$tr->max|escape} 50 {$tr->symbols|escape})</label><input style="width:450px;max-width:450px;" maxlength="50" name="sales_notes" class="fivecms_inp" type="text" value="{$settings->sales_notes}" /></li>

					</ul>
				</div>
				<!-- Параметры (The End)-->

			</div>
			<input style="margin: 0 0 20px 0; float:left;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
		</form>
		<!-- Основная форма (The End) -->
		
	</div>

</div>
