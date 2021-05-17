{* Вкладки *}
{capture name=tabs}
	{if in_array('orders', $manager->permissions)}
		<li {if (isset($order->status) && $order->status==0) || !isset($order->status)}class="active"{/if}><a href="index.php?module=OrdersAdmin&status=0">{$tr->new_pl|escape}</a></li>
		<li {if !empty($order->status) && $order->status==4}class="active"{/if}><a href="index.php?module=OrdersAdmin&status=4">{$tr->status_in_process_pl|escape}</a></li>
		<li {if !empty($order->status) && $order->status==1}class="active"{/if}><a href="index.php?module=OrdersAdmin&status=1">{$tr->status_accepted_pl|escape}</a></li>
		<li {if !empty($order->status) && $order->status==2}class="active"{/if}><a href="index.php?module=OrdersAdmin&status=2">{$tr->status_completed_pl|escape}</a></li>
		<li {if !empty($order->status) && $order->status==3}class="active"{/if}><a href="index.php?module=OrdersAdmin&status=3">{$tr->status_canceled_pl|escape}</a></li>
		{if !empty($keyword)}
			<li class="active"><a href="{url module=OrdersAdmin keyword=$keyword id=null label=null}">{$tr->search|escape}</a></li>
		{/if}
	{/if}
	{if in_array('labels', $manager->permissions)}
		<li><a href="{url module=OrdersLabelsAdmin keyword=null id=null page=null label=null}">{$tr->labels|escape}</a></li>
	{/if}
{/capture}

{if !empty($order->id)}
	{$meta_title = "{$tr->order} №`$order->id`" scope=root}
{else}
	{$meta_title = $tr->new_order|escape scope=root}
{/if}

<div id="onecolumn" class="orderadmin">

	<div style="font-size:13px; margin-bottom:15px; ">
		{$tr->status_helper}
	</div>
	
	{* Основная форма *}
	<form method=post id=order enctype="multipart/form-data" onSubmit="$('input[type=submit]').prop('disabled', true);" >
		<input type=hidden name="session_id" value="{$smarty.session.id}">
	
		<div id="name">
			<input name=id type="hidden" value="{if !empty($order->id)}{$order->id|escape}{/if}"/> 
			<h1>{if !empty($order->id)}{$tr->order|escape} №{$order->id|escape}{else}{$tr->new_order|escape}{/if}
			<select class=status name="status">
				<option value='0' {if !empty($order->status) && $order->status == 0}selected{/if}>{$tr->new|escape}</option>
				<option value='4' {if !empty($order->status) && $order->status == 4}selected{/if}>{$tr->status_in_processing|escape}</option>
				<option value='1' {if !empty($order->status) && $order->status == 1}selected{/if}>{$tr->status_accepted|escape}</option>
				<option value='2' {if !empty($order->status) && $order->status == 2}selected{/if}>{$tr->status_completed|escape}</option>
				<option value='3' {if !empty($order->status) && $order->status == 3}selected{/if}>{$tr->status_canceled|escape}</option>
			</select>
			</h1>
			{if !empty($order->id)}
				<a href="{url view=print id=$order->id}" target="_blank"><img src="./design/images/printer.png" name="export" title="{$tr->order_print|escape}"></a>
				<a style="margin:0 10px;" href="{url view=excel id=$order->id}" target="_blank"><img src="./design/images/export_excel.png" name="export" title="{$tr->order_xls_docs|escape}"></a>
				<a href="{url view=torg12 id=$order->id}" target="_blank"><img src="./design/images/table.png" name="export" title="Сформировать ТОРГ-12 в Excel"></a>
				<a href="{url view=invoice id=$order->id}" target="_blank"><img src="./design/images/invoice.png" name="export" title="Счет на оплату"></a>
				<a href="/../../order/{$order->url}" target="_blank"><img src="./design/images/monitor@2x.png" name="export" title="{$tr->open_on_page|escape}"></a>
			{/if}
			<div id=next_order>
				{if !empty($prev_order->id)}
					<a class=prev_order href="{url id=$prev_order->id}">&lsaquo;</a>
				{/if}
				{if !empty($next_order->id)}
					<a class=next_order href="{url id=$next_order->id}">&rsaquo;</a>
				{/if}
			</div>
		</div> 
	
		{if isset($message_error)}
		<!-- Системное сообщение -->
		<div class="message message_error">
			<span class="text">{if $message_error=='error_closing'}{$tr->out_of_stock|escape}{else}{$message_error|escape}{/if}</span>
			{if isset($smarty.get.return)}
			<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
			{/if}
		</div>
		<!-- Системное сообщение (The End)-->
		{elseif isset($message_success)}
		<!-- Системное сообщение -->
		<div class="message message_success">
			<span class="text">{if $message_success=='updated'}{$tr->updated|escape}{elseif $message_success=='added'}{$tr->added|escape}{else}{$message_success}{/if}</span>
			{if isset($smarty.get.return)}
			<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
			{/if}
		</div>
		<!-- Системное сообщение (The End)-->
		{/if}
	
		<div id="order_details">
			<h2>{$tr->order_details|escape} <a href='#' class="edit_order_details"><img src='design/images/pencil.png' alt='{$tr->edit|escape}' title='{$tr->edit|escape}'></a></h2>
		
			<div id="user">
			<ul class="order_details">
				<li>
					<label class=property>{$tr->date|escape}</label>
					<div class="edit_order_detail view_order_detail">
					{if !empty($order->date)}{$order->date|date} {$order->date|time}{/if} {if !empty($order->time)}{$order->time}{/if}
					</div>
				</li>
				
				<li>
					<label class=property>{$tr->person_name|escape}</label> 
					<div class="edit_order_detail" style='display:none;'>
						<input name="name" class="fivecms_inp" type="text" value="{$order->name|escape}" />
					</div>
					<div class="view_order_detail">
						{$order->name|escape}
					</div>
				</li>
				<li>
					<label class=property>Email</label>
					<div class="edit_order_detail" style='display:none;'>
						<input name="email" class="fivecms_inp" type="text" value="{$order->email|escape}" />
					</div>
					<div class="view_order_detail">
						{if !empty($order->id)}
							<a href="mailto:{$order->email|escape}?subject=Заказ%20№{$order->id}">{$order->email|escape}</a>
						{else}
							{$order->email|escape}
						{/if}
					</div>
					{if $order->email}
					{include file='send_order_message.tpl'}
					<input id="backform" style="margin-bottom: 10px;" type="button" class="button_green" value="{$tr->send_message|escape}" />
					{/if}
				</li>
				<li>
					<label class=property>{$tr->phone|escape}</label>
					<div class="edit_order_detail" style='display:none;'>
						<input name="phone" class="fivecms_inp " type="text" value="{$order->phone|escape}" />
					</div>
					<div class="view_order_detail">
						{if $order->phone}<span class="ip_call" data-phone="{$order->phone|escape}" target="_blank">{$order->phone|escape}</span>{else}{$order->phone|escape}{/if}
					</div>
				</li>
			
				<li>
					<label class=property>{$tr->address|escape} <a href='http://maps.yandex.ru/' id=address_link target=_blank><img align=absmiddle src='design/images/map.png' alt='{$tr->map_new_window|escape}' title='{$tr->map_new_window|escape}'></a></label>
					<div class="edit_order_detail" style='display:none;'>
						<textarea name="address" style="height: 60px;">{$order->address|escape}</textarea>
					</div>
					<div class="view_order_detail">
						{$order->address|escape}
					</div>
				</li>
			
				{if !empty($order->calc)}
				<li>
					<label class=property>{$tr->delivery_additional_info|escape}</label>
					<div class="edit_order_detail" style='display:none;'>
						<textarea style="min-height:140px;" name="calc">{$order->calc|escape}</textarea>
					</div>
					<div class="view_order_detail">
						{$order->calc|escape}
					</div>
				</li>
				{/if}
			
				<li>
					<label class=property>{$tr->user_comment|escape}</label>
					<div class="edit_order_detail" style='display:none;'>
						<textarea name="comment">{if !empty($order->comment)}{$order->comment|escape}{/if}</textarea>
					</div>
					<div class="view_order_detail">
						{if !empty($order->comment)}{$order->comment|escape|nl2br}{/if}
					</div>
				</li>
				
				<li>
					<label class=property>{$tr->shipment_date|escape}</label>
					<div class="edit_order_detail" style="display:none;">
						<input id="shipping_date" name="shipping_date" class="fivecms_inp datetime" type="text" value="{if !empty($order->shipping_date)}{$order->shipping_date|date} {$order->shipping_date|time}{/if}" autocomplete="off"/>
					</div>
					<div class="view_order_detail">
						{if !empty($order->shipping_date)}{$order->shipping_date|date} {$order->shipping_date|time}{/if}
					</div>
				</li>

				<li>
					<label class=property>Дата доставки</label>
					<div class="edit_order_detail" style="display:none;">
						<input id="delivery_date" name="delivery_date" class="fivecms_inp datetime" type="text" value="{if !empty($order->delivery_date)}{$order->delivery_date|date} {$order->delivery_date|time}{/if}" autocomplete="off"/>
					</div>
					<div class="view_order_detail">
						{if !empty($order->delivery_date)}{$order->delivery_date|date} {$order->delivery_date|time}{/if}
					</div>
				</li>

				<link rel="stylesheet" type="text/css" href="../../js/jquery/datetime/jquery.datetimepicker.css"/>
				<script src="../../js/jquery/datetime/jquery.datetimepicker.full.min.js"></script>
				<script>
					$('.datetime').datetimepicker({ lang:'ru', format:'d.m.Y H:i', dayOfWeekStart:'1' });
					$.datetimepicker.setLocale('ru');
				</script>

				<li>
					<label class=property>Телефон курьера</label>
					<div class="edit_order_detail" style='display:none;'>
						<input name="phone_delivery" class="fivecms_inp " type="text" value="{$order->phone_delivery|escape}" />
					</div>
					<div class="view_order_detail">
						{if $order->phone_delivery}<span class="ip_call" data-phone="{$order->phone_delivery|escape}" target="_blank">{$order->phone_delivery|escape}</span>{else}{$order->phone_delivery|escape}{/if}
					</div>
				</li>
			
				<li>
					<label class=property>{$tr->track_code|escape}</label> 
					<div class="edit_order_detail" style='display:none;'>
						<input name="track" class="fivecms_inp" type="text" value="{if !empty($order->track)}{$order->track|escape}{/if}" />
					</div>
					<div class="view_order_detail">
						{if !empty($order->track)}{$order->track|escape}{/if}
					</div>
	
					{if !empty($order->track) && !empty($order->email)}
					{include file='send_track_message.tpl'}
					<input id="tbackform" style="margin-bottom: 3px;"  type="button" class="button_green" value="{$tr->send_track_code|escape}" />
					{/if}
	
				</li>
			</ul>
			</div>
		
			{if $labels}
			<div class='layer'>
			<h2>{$tr->labels|escape}</h2>
			<!-- Метки -->
			<ul>
				{foreach $labels as $l}
				<li>
				<label for="label_{$l->id}">
				<input id="label_{$l->id}" type="checkbox" name="order_labels[]" value="{$l->id}" {if in_array($l->id, $order_labels)}checked{/if}>
				<span style="background-color:#{$l->color};" class="order_label"></span>
				{$l->name}
				</label>
				</li>
				{/foreach}
			</ul>
			<!-- Метки -->
			</div>
			{/if}
	
			<div class='layer'>
			<h2>{$tr->customer|escape} <a href='#' class="edit_user"><img src='design/images/pencil.png' alt='{$tr->edit|escape}' title='{$tr->edit|escape}'></a> <a href="#" class='delete_user'><img src='design/images/delete.png' alt='{$tr->delete|escape}' title='{$tr->delete|escape}'></a></h2>
				<div class='view_user'>
				{if empty($user)}
					{$tr->not_registered|escape}
				{else}
					<a href='index.php?module=UserAdmin&id={$user->id}' target=_blank>{$user->name|escape}</a> ({$user->email|escape})
					<div class="user_discount">
						{if !empty($user->discount)}<ul class="stars"><li>Групповая скидка {$user->discount}%</li></ul>{/if}
						{if !empty($user->tdiscount)}<ul class="stars"><li>Накопительная скидка {$user->tdiscount}%</li></ul>{/if}
					</div>
				{/if}
				</div>
				<div class='edit_user' style='display:none;'>
				<input type=hidden name=user_id value='{if !empty($user->id)}{$user->id}{/if}'>
				<input type=text id='user' class="input_autocomplete chooseuser" placeholder="{$tr->select_user|escape}">
				</div>
			</div>
			
			<div class="layer" style="margin-bottom:18px;word-break:break-word;">
				<h2>{$tr->order_source|escape}</h2>
				
				{if !empty($order->source) && ($order->source == 3 || $order->source == 4)}
					<ul class="stars">
						<li>{if $order->source == 3}{$tr->in_ios_app|escape}{else}{$tr->in_android_app|escape}{/if}</li>
					</ul>
				{/if}
				<select name="source" {if !empty($order->source) && ($order->source == 3 || $order->source == 4)}style="display:none;"{/if}>
					<option value=0 {if empty($order->source)}selected{/if}>{$tr->not_set|lower|escape}</option>
					<option value=1 {if !empty($order->source) && $order->source == 1}selected{/if}>{$tr->in_desktop_theme|escape}</option>
					<option value=2 {if !empty($order->source) && $order->source == 2}selected{/if}>{$tr->in_mobile_theme|escape}</option>
					<option value=3 {if !empty($order->source) && $order->source == 3}selected{/if}>{$tr->in_ios_app|escape}</option>
					<option value=4 {if !empty($order->source) && $order->source == 4}selected{/if}>{$tr->in_android_app|escape}</option>
					<option value=5 {if !empty($order->source) && $order->source == 5}selected{/if}>{$tr->phone_call|escape}</option>
					<option value=6 {if !empty($order->source) && $order->source == 6}selected{/if}>{$tr->in_chat|escape}</option>
					<option value=7 {if !empty($order->source) && $order->source == 7}selected{/if}>{$tr->offline|escape}</option>
					<option value=8 {if !empty($order->source) && $order->source == 8}selected{/if}>{$tr->another|escape}</option>
				</select>
				
				{if !empty($order->referer)}
					<h2 style="margin-top:15px;">{$tr->referer|escape}</h2>
					<p>{$order->referer|escape}</p>
				{/if}
				{if !empty($order->yclid)}
					<h2 style="margin-top:15px;">YCLID</h2>
					<p>{$order->yclid|escape}</p>
				{/if}
				{if !empty($order->utm)}
				<h2 style="margin-top:15px;">UTM-{$tr->labels|escape}</h2>
					{$utm_array = "utm"|explode:$order->utm}
					{foreach $utm_array as $utm}
						{if !empty($utm) && $utm|strpos:'_' !== false}
						<p class="order_utm">{$utm|regex_replace:'/&.*/':''|escape}</p>
						{/if}
					{/foreach}
				{/if}
			</div>
			
			{if $settings->apiid && $order->phone}
				<div class='layer'>
					<h2>SMS <a href='#' class="edit_sms"><img src='design/images/pencil.png' alt=''></a></h2>
					<ul class="order_details">
						<li>
							<div class="edit_sms" style="display:none;">
								<p style="margin-bottom: 5px;"><strong>{$tr->enter_text|escape} SMS:</strong></p>
								<textarea class="smstext" name="smstext"></textarea>
								<div class="button_green customsms" style="padding: 5px 10px;background:#618499;font-size:13px;text-align:center;">{$tr->send|escape} SMS</div>
								<div class="smssended" style="display:none;">SMS {$tr->sended|escape}</div>
							</div>
					
							<script>
								phone = {$order->phone|escape};
								$(".customsms").click(function(){ 
									message = "{$tr->order|escape} №{$order->id|escape} "+$('.smstext').val();
								{literal}
									$.ajax({ 
										type: "GET",
										url: "ajax/sms.php",
										data: {phone: phone, 
											message: message, 
										}, 
										success: function(result){ 
											$('.customsms').hide();
											$('.smssended').show();
											setTimeout( function(){$('.customsms').show();$('.smssended').hide();}, 6000);
										}
									});
								});
								{/literal}
							</script>
						</li>
					</ul>
				</div>
				{if $order->track}
				<div class='layer' style="padding-bottom: 18px;">
						<div class="button_green tracksms" style="padding: 5px 10px;background:#618499;font-size:13px;text-align:center;">{$tr->send|escape} SMS {$tr->track_code|lower|escape}</div>
						<div class="tracksended" style="display:none;">SMS {$tr->track_code|lower|escape} {$tr->sended|escape}</div>
						<script>
								phone = {$order->phone|escape};
								message = "{$tr->your|escape} {$tr->order|lower|escape} №{$order->id|escape} {$tr->sended_he|lower|escape} {$delivery->name}, {$tr->track_code|lower|escape} {$order->track|escape}";
						
								{literal}
								$(".tracksms").click(function(){ 
									$.ajax({ 
										type: "GET",
										url: "../ajax/sms.php",
										data: {phone: phone, 
											message: message, 
										}, 
										success: function(result){ 
											$('.tracksms').hide();
											$('.tracksended').show();
											setTimeout( function(){$('.tracksms').show();$('.tracksended').hide();}, 6000);
										}
									});
								});
								{/literal}
						</script>
				</div>
				{/if}
			{/if}	
	
			<div class='layer'>
				<h2 style="font-size:14px;">{$tr->manager_note|escape} <a href='#' class="edit_note"><img src='design/images/pencil.png' alt='{$tr->edit|escape}' title='{$tr->edit|escape}'></a></h2>
				<ul class="order_details">
					<li>
						<div class="edit_note" style='display:none;'>
							<label class=property>{$tr->note_hidden|escape}</label>
							<textarea name="note">{if !empty($order->note)}{$order->note|escape}{/if}</textarea>
						</div>
						<div class="view_note" {if empty($order->note)}style='display:none;'{/if}>
							<label class=property>{$tr->note_hidden|escape}</label>
							<div class="note_text">{if !empty($order->note)}{$order->note|escape}{/if}</div>
						</div>
					</li>
				</ul>
			</div>
	
			<!-- загрузка файлов -->
			<div class="block layer" style="margin-bottom:15px;">
					<h2>{$tr->file|escape}</h2>
					<p style="font-size:12px;margin-bottom:10px;">{$tr->only|escape}: pdf, txt, doc, docx, xls, xlsx, odt, ods, odp, gif, jpg, png, psd, cdr, ai, zip, rar, gzip</p>
					<p style="font-size:12px;margin-bottom:10px;">{$tr->max_size|escape}: {$settings->maxattachment|escape} Мб!</p>
					{if !empty($cms_files)}
						<div id="list" class="sortable files_products">
							{foreach $cms_files as $file}
							<div class="row">
								<div class="move cell">
									<div class="move_zone"></div>
								</div>
								<div class="name cell">
									<input maxlength="100" style="max-width: 100%;" placeholder="{$tr->filename|escape}" type="text" name='files[name][]' value='{$file->name}'>
								</div>					
								<div class="name cell" style="max-width: 83%;padding:0 10px 5px 5px;">
									<input type=hidden name='files[id][]' value='{$file->id}'>
									<a style="word-wrap:break-word;font-size: 12px;" href="../{$config->cms_files_dir}{$file->filename}" download="{$file->filename}">
										{$file->filename} 
										<span style="white-space:nowrap;">({assign var=fn value="`$config->cms_files_dir``$file->filename`"}{(filesize($fn)/1024/1024)|round:2} Mb)</span>
									</a>
								   
								</div>
								<div class="icons cell" style="min-width:30px;max-width:30px;">
									<a href='#' class="delete" title="{$tr->delete|escape}"></a>
								</div>
								<div class="clear"></div>
							</div>
							{/foreach}
						</div>
					{else}
						<p style="font-size:12px;">{$tr->no_files|escape}</p>
					{/if}<br/>
					<input class='upload_file attachment' name=files[] type=file multiple  accept='pdf/txt/doc/docx/xls/xlsx/odt/ods/odp/gif/jpg/jpeg/png/psd/cdr/ai/zip/rar/gzip'>	
					<div class="errorupload errortype" style="display:none; margin:5px 0px 5px 0px;">{$tr->not_allowed_extention|escape}</div>
					<div class="errorupload errorsize" style="display:none; margin:5px 0px 5px 0px;">{$tr->file_size_more|escape} {$settings->maxattachment|escape} Mb!</div>
			</div>
			<script type="text/javascript">
				$('.attachment').bind('change', function() {
					$('.errorsize, .errortype').hide();
					var size = this.files[0].size; 
					var name = this.files[0].name;
					if({$settings->maxattachment|escape * 1024 * 1024}<size){
						$('.errorsize').show();
						$('.attachment').val('');
						setTimeout(function(){ $('.errorsize').fadeOut('slow'); },3000);
					}
					var fileExtension = ['pdf', 'txt', 'doc', 'docx', 'xls', 'xlsx', 'odt', 'ods', 'odp', 'gif', 'jpg', 'jpeg', 'png', 'psd', 'cdr', 'ai', 'zip', 'rar', 'gzip'];
					if ($.inArray(name.split('.').pop().toLowerCase(), fileExtension) == -1) {
						$('.errortype').show();
						$('.attachment').val('');
						setTimeout(function(){ $('.errortype').fadeOut('slow'); },3000);
					}
				});
			</script>
			<!-- загрузка файлов end-->
		</div>
		
	
		<div id="purchases">
			<div id="list" class="purchases">
				{foreach from=$purchases item=purchase}
				<div class="row">
					<div class="image cell">
						<input type=hidden name=purchases[id][{$purchase->id}] value='{$purchase->id}'>
						{if !empty($purchase->product->images)}
							{$image = $purchase->product->images|first}
							{if !empty($image)}
								<a href="{$image->filename|resize:1024:768:w}" class="zoom"><img class=product_icon src='{$image->filename|resize:100:100}'></a>
							{/if}
						{/if}
					</div>
					<div class="purchase_name cell">
						<div class='purchase_variant'>				
							<span class=edit_purchase style='display:none;'>
								<select name=purchases[variant_id][{$purchase->id}] {if $purchase->product->variants|count==1 && $purchase->variant_name == '' && $purchase->variant->sku == ''}style='display:none;'{/if}>					
								{if !$purchase->variant}<option price='{$purchase->price}' amount='{$purchase->amount}' unit="{if $purchase->unit}{$purchase->unit}{else}{$settings->units}{/if}" value=''>{$purchase->variant_name|escape} {if $purchase->sku}({$tr->sku_short}. {$purchase->sku}) {/if}{if $purchase->unit}{$purchase->unit}{else}{$settings->units}{/if}</option>{/if}
								{foreach $purchase->product->variants as $v}
									{if $v->stock>0 || $v->id == $purchase->variant->id}
									<option price='{$v->price}' amount='{$v->stock}' unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}" value='{$v->id}' {if $v->id == $purchase->variant_id}selected{/if} >
									{$v->name}
									{if $v->sku}({$tr->sku_short}. {$v->sku}) {/if}[{$v->stock} {if $v->unit}{$v->unit}{else}{$settings->units}{/if}]
									</option>
									{/if}
								{/foreach}
								</select>
							</span>
							<span class=view_purchase>
								{$purchase->variant_name} {if $purchase->sku}({$tr->sku_short}. {$purchase->sku}){/if}			
							</span>
						</div>
			
						{if $purchase->product}
							<div class="oprdname"><a class="related_product_name" href="index.php?module=ProductAdmin&id={$purchase->product->id}&return={$smarty.server.REQUEST_URI|urlencode}">{$purchase->product_name}</a></div>
						{else}
							{$purchase->product_name}				
						{/if}
					</div>
					<div class="price cell">
						<span class=view_purchase>{$purchase->price}</span>
						<span class=edit_purchase style='display:none;'>
						<input type=text name=purchases[price][{$purchase->id}] value='{$purchase->price}' size=5>
						</span>
						{$currency->sign}
					</div>
					<div class="amount cell">			
						<span class=view_purchase>
							{$purchase->amount} {if $purchase->variant->unit}{$purchase->variant->unit}{else}{$settings->units}{/if}
						</span>
						<span class="edit_purchase" style='display:none;'>
							{if $purchase->variant}
								{math equation="max(x,y)" x=$purchase->variant->stock+$purchase->amount*($order->closed) y=$purchase->amount assign="loop"}
							{else}
								{math equation="x" x=$purchase->amount assign="loop"}
							{/if}
							<input class="edit_amount" type="number" max="{$loop}" name="purchases[amount][{$purchase->id}]" value="{$purchase->amount}" />
							<span class="unit">{if $purchase->variant->unit}{$purchase->variant->unit}{else}{$settings->units}{/if}</span>	
						</span>			
					</div>
					<div class="icons cell instock" title="{$tr->stock_available|escape}">		
						{if !$order->closed}
							{if !$purchase->product}
							<img src='design/images/error.png' alt='{$tr->product} {$tr->was_deleted}' title='{$tr->product} {$tr->was_deleted}' > {*Товар был удалён*}
							{elseif !$purchase->variant}
							<img src='design/images/error.png' alt='{$tr->product_variant} {$tr->was_deleted}' title='{$tr->product_variant} {$tr->was_deleted}' > {*Вариант товара был удалён*}
							{elseif $purchase->variant->stock < $purchase->amount}
							<img src='design/images/error.png' alt='{$tr->stock_available|escape} {$purchase->variant->stock}' title='{$tr->stock_available|escape} {$purchase->variant->stock}'  > {*{$tr->stock_available|escape} {$purchase->variant->stock}*}
							{else}
							[ {$purchase->variant->stock|escape} ]&nbsp;&nbsp;
							{/if}
						{else}
							{if !$purchase->product}
							<img src='design/images/error.png' alt='{$tr->product} {$tr->was_deleted}' title='{$tr->product} {$tr->was_deleted}' > {*Товар был удалён*}
							{elseif !$purchase->variant}
							<img src='design/images/error.png' alt='{$tr->product_variant} {$tr->was_deleted}' title='{$tr->product_variant} {$tr->was_deleted}' > {*Вариант товара был удалён*}
							{else}
							[ {$purchase->variant->stock|escape} ]&nbsp;&nbsp;
							{/if}
						{/if}
						<a href='#' class="delete" title="{$tr->delete|escape}"></a>	
					</div>
					<div class="clear"></div>
				</div>
				{/foreach}
				<div id="new_purchase" class="row" style='display:none;'>
					<div class="image cell">
						<input type=hidden name=purchases[id][] value=''>
						<img class=product_icon src=''>
					</div>
					<div class="purchase_name cell">
						<div class='purchase_variant'>				
							<select name=purchases[variant_id][] style='display:none;'></select>
						</div>
						<a class="purchase_name" href=""></a>
					</div>
					<div class="price cell">
						<input type=text name=purchases[price][] value='' size=5> {$currency->sign}
					</div>
					<div class="amount cell">
						<input class="edit_amount" type="number" max="" name="purchases[amount][]" value="1" />
						<span class="unit"></span>	
					</div>
					<div class="icons cell">
						<a href='#' class="delete" title="Удалить"></a>	
					</div>
					<div class="clear"></div>
				</div>
			</div>
	
			<div id="add_purchase" {if $purchases}style='display:none;'{/if}>
				<input type=text name=related id='add_purchase' class="input_autocomplete" placeholder='{$tr->enter_name_sku|escape}'>
			</div>
			{if $purchases}
				<a href='#' class="dash_link edit_purchases">{$tr->edit_purchases|escape}</a>
				<div class="subtotal">
					{$tr->purchases|escape}: {$purchases_count} | {$tr->total|escape}: <strong>{$subtotal} {$currency->sign}</strong>
				</div>
			{/if}
	
			<div class="block discount layer">
				<h2 style="display:table;width:100%;">{$tr->discount|escape}</h2>
				<p>{$tr->permanent_discount}.: <input style="margin-left:10px;" type="text" name="discount2" value="{if !empty($order->discount2)}{$order->discount2}{else}0{/if}"> <span class=currency>%</span></p>	
				
				<p>{$tr->enablediscounts2}: <input style="margin-left:10px;" type="text" name="discount_group" value="{if !empty($order->discount_group)}{$order->discount_group}{else}0{/if}"> <span class=currency>%</span></p>
					
				{if !empty($order->source) && ($order->source == 3 || $order->source == 4)}
					<p style="margin:8px 0 10px 0;">
						{$tr->order|escape} {$tr->in|lower} {if $order->source == 3}iOS{elseif $order->source == 4}Android{/if}-{$tr->app_pl|escape}{if !empty($settings->mob_discount)}, {$tr->discount|lower|escape}: {$settings->mob_discount|escape}%{/if}
					</p>
				{/if}
				
				<p style="font-weight:700;font-size:15px;">{$tr->total_discount}: <input style="margin-left:10px;" type="text" name="discount" value="{if !empty($order->discount)}{$order->discount}{else}0{/if}"> <span class=currency>%</span></p>
			</div>
			
			{if !empty($order->discount) && $order->discount > 0}
				<div class="subtotal layer">
				{$tr->including_discount}: <strong>{($subtotal-$subtotal*$order->discount/100)|round:2} {$currency->sign}</strong>
				</div>
			{/if}
		
			<div class="block discount layer">
				<h2>{$tr->used_points}</h2>
				<div class="used_bonus">
					<input type=text name="bonus_discount" value='{if !empty($order->bonus_discount)}{$order->bonus_discount}{/if}'> <span class=currency>{$currency->sign}</span>   
				</div>
				{if isset($order->bonus_discount) && $order->bonus_discount > 0}
				<div class="return_bonus">
					<input type="checkbox" name="return_bonus" id="return_bonus" value="1"><label for="return_bonus">{$tr->return_points}</label>
				</div>  
				{/if}
			</div>
	
			<div class="block discount layer">
				<h2>{$tr->coupon}{if !empty($order->coupon_code)} ({$order->coupon_code}){/if}</h2>
				<input class="couponcode" type=text name=coupon_discount value='{if !empty($order->coupon_discount)}{$order->coupon_discount}{/if}'> <span class=currency>{$currency->sign}</span>		
			</div>
	
			{if !empty($order->coupon_discount) || !empty($order->bonus_discount)}
				{if !empty($order->coupon_discount)}{$coupon_discount = $order->coupon_discount}{else}{$coupon_discount = 0}{/if}
				{if !empty($order->bonus_discount)}{$bonus_discount = $order->bonus_discount}{else}{$bonus_discount = 0}{/if}
				<div class="subtotal layer">
				{$tr->including_coupon_point}: <strong> {($subtotal-$subtotal*$order->discount/100-$coupon_discount-$bonus_discount)|round:2} {$currency->sign}</strong>
				</div> 
			{/if}
		
			<div class="block delivery">
				<h2>{$tr->delivery|escape}</h2>
				<select name="delivery_id">
					<option value="0">{$tr->not_choosed|escape}</option>
					{foreach $deliveries as $d}
						{if $d->enabled}
							<option value="{$d->id}" {if !empty($delivery->id) &&  $d->id==$delivery->id}selected{/if}>{$d->name}</option>
						{/if}
					{/foreach}
				</select>	
				<input type=text name=delivery_price value='{if !empty($order->delivery_price)}{$order->delivery_price}{/if}'> <span class=currency>{$currency->sign}</span>
				<div class="separate_delivery">
							<input type=checkbox id="separate_delivery" name=separate_delivery value='1' {if !empty($order->separate_delivery)}checked{/if}> <label  for="separate_delivery">{$tr->separate_payment|lower|escape}</label>
				</div>
			</div>
			{if !empty($total_weight)}
			<div class="totalweight">
				{$tr->weight|escape}: <strong>{$total_weight} кг</strong>
			</div>
			{/if}
			{if !empty($total_volume)}
			<div class="totalweight">
				{$tr->volume|escape}: <strong>{$total_volume} куб.м.</strong>
			</div>
			{/if}
			<div class="total layer" style="border-style:solid;">
				{$tr->total_amount|escape}: <strong>{if isset($order->total_price)}{$order->total_price} {$currency->sign}{/if}</strong>
			</div>
			
			<div class="block payment">
				<h2>{$tr->payment|escape}</h2>
				<select name="payment_method_id">
					<option value="0">{$tr->not_choosed|escape}</option>
					{foreach $payment_methods as $pm}
					<option value="{$pm->id}" {if !empty($payment_method->id) && $pm->id==$payment_method->id}selected{/if}>{$pm->name}</option>
					{/foreach}
				</select>
			
				<div style="{if empty($order->id)}display:none;{else}display:inline-block;{/if}">
					<input type=checkbox name="paid" id="paid" value="1" {if !empty($order->paid)}checked{/if}> <label for="paid" {if !empty($order->paid)}class="green"{/if}>{$tr->order} {$tr->paid}</label> {if isset($order->payment_date)}({$order->payment_date|date} {$order->payment_date|time}){/if}
				</div>

				{if !empty($order->payment_details)}<p style="margin-top:10px;">Платежная информация: {$order->payment_details|escape}</p>{/if}
			</div>
	
			{if !empty($payment_method)}
			<div class="subtotal layer" style="border:0;">
				{$tr->for_payment|escape}: <strong>{$order->total_price|convert:$payment_currency->id} {$payment_currency->sign}</strong>
			</div>
			{/if}
	
			<div class="block_save">
				<input type="checkbox" value="1" id="notify_user" name="notify_user">
				<label for="notify_user">{$tr->notify_user_order|escape}</label>
				<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
			</div>
		</div>
	
	</form>
	<!-- Основная форма (The End) -->

</div>


{* On document load *}
{literal}
<script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>

<script>
$(function() {

	// Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();
	
	// Удаление товара
	$(".purchases a.delete").live('click', function() {
		 $(this).closest(".row").fadeOut(200, function() { $(this).remove(); });
		 return false;
	});
 
	// Добавление товара 
	var new_purchase = $('.purchases #new_purchase').clone(true);
	$('.purchases #new_purchase').remove().removeAttr('id');

	$("input#add_purchase").autocomplete({
		serviceUrl:'ajax/add_order_product.php',
		minChars:0,
		noCache: false, 
		width: 359,
		onSelect:
			function(suggestion){
				new_item = new_purchase.clone().appendTo('.purchases');
				new_item.removeAttr('id');
				new_item.find('a.purchase_name').html(suggestion.data.name);
				new_item.find('a.purchase_name').attr('href', 'index.php?module=ProductAdmin&id='+suggestion.data.id);
			
				// Добавляем варианты нового товара
				var variants_select = new_item.find('select[name*=purchases][name*=variant_id]');
					
				for(var i in suggestion.data.variants){
					var variant_amount = suggestion.data.variants[i].stock;
					variants_select.append("<option value='"+suggestion.data.variants[i].id+"' price='"+suggestion.data.variants[i].price+"' amount='"+variant_amount+"' unit='"+suggestion.data.variants[i].unit+"'>"+suggestion.data.variants[i].name+"</option>");
				}		
			
				if(suggestion.data.variants.length>1 || suggestion.data.variants[0].name != '')
					variants_select.show();
								
				variants_select.bind('change', function(){change_variant(variants_select);});
					change_variant(variants_select);
			
				if(suggestion.data.image)
					new_item.find('img.product_icon').attr("src", suggestion.data.image);
				else
					new_item.find('img.product_icon').remove();

				$("input#add_purchase").val('').focus().blur(); 
				new_item.show();
			},
			formatResult:
				function(suggestions, currentValue){
					var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
					var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
					return "<div>" + (suggestions.data.image?"<img align=absmiddle src='"+suggestions.data.image+"'> ":'') + "</div>" +  "<span>" + suggestions.value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>') + "</span>";
				}
 	});
  
  	// Изменение цены и макс количества при изменении варианта
  	function change_variant(element)
  	{
		price = element.find('option:selected').attr('price');
		amount = element.find('option:selected').attr('amount');
		unit = element.find('option:selected').attr('unit');
		element.closest('.row').find('input[name*=purchases][name*=price]').val(price);
		$(element).closest('.row').find('input[name*=purchases][name*=amount]').prop('max',amount);
		$(element).closest('.row').find('.unit').text(unit);
		return false;
  	}
  
	// Редактировать покупки
	$("a.edit_purchases").click( function() {
		 $(".purchases span.view_purchase").hide();
		 $(".purchases span.edit_purchase").show();
		 $(".edit_purchases").hide();
		 $("div#add_purchase").show();
		 return false;
	});
  
	// Редактировать получателя
	$("div#order_details a.edit_order_details").click(function() {
		 $("ul.order_details .view_order_detail").hide();
		 $("ul.order_details .edit_order_detail").show();
		 return false;
	});
  
	// Редактировать примечание
	$("div#order_details a.edit_note").click(function() {
		 $("div.view_note").hide();
		 $("div.edit_note").show();
		 return false;
	});

	$("div#order_details a.edit_sms").click(function() {
		 $("div.view_sms").hide();
		 $("div.edit_sms").show();
		 return false;
	});
  
	// Редактировать пользователя
	$("div#order_details a.edit_user").click(function() {
		 $("div.view_user").hide();
		 $("div.edit_user").show();
		 return false;
	});
	$("input#user").autocomplete({
		serviceUrl:'ajax/search_users.php',
		minChars:0,
		noCache: false, 
		//width: 224, 
		onSelect:
			function(suggestion){
				$('input[name="user_id"]').val(suggestion.data.id);
			}
	});
  
	// Удалить пользователя
	$("div#order_details a.delete_user").click(function() {
		$('input[name="user_id"]').val(0);
		$('div.view_user').hide();
		$('div.edit_user').hide();
		$('input#user').val('');
		return false;
	});

	// Посмотреть адрес на карте
	$("a#address_link").attr('href', 'http://maps.yandex.ru/?text='+$('#order_details textarea[name="address"]').val());
  
	// Подтверждение удаления
	$('select[name*=purchases][name*=variant_id]').bind('change', function(){change_variant($(this));});
	$("input[name='status_deleted']").click(function() {
		if(!confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
			return false;	
	});

});

</script>

<style>
	.autocomplete-suggestions {border: 1px solid #dadada; background: #FFF; cursor: default; overflow: hidden;overflow-y: auto;  max-width:359px;}
	.autocomplete-suggestion { padding: 2px 5px; white-space: nowrap; overflow: hidden;}
	.autocomplete-no-suggestion { padding: 2px 5px;}
	.autocomplete-selected { background: #F0F0F0; }
	.autocomplete-suggestions strong { font-weight: bold; color: #000; }
	.autocomplete-group { padding: 2px 5px; }
	.autocomplete-group strong { font-weight: bold; font-size: 16px; color: #000; display: block; border-bottom: 1px solid #000; }
	.edit_amount{min-width:50px !important;width:50px !important;}
	#list .icons img{vertical-align:middle;}
	.unit{font-size:12px !important;}
</style>
<script>
	$(function() {
		$("a.zoom").fancybox({ 'hideOnContentClick' : true });
	});

	// Удаление файлов товара
	$(".files_products a.delete").live('click', function() {
		 $(this).closest("div.row").fadeOut(200, function() { $(this).remove(); });
		 return false;
	});

	// Сортировка файлов
	$(".sortable").sortable({
		items: "div.row",
		tolerance:"pointer",
		scrollSensitivity:40,
		opacity:0.7,
		handle: '.move_zone'
	});
</script>
{/literal}

