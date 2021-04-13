{* Вкладки *}
{capture name=tabs}
	{if in_array('orders', $manager->permissions)}
		<li {if isset($status) && $status===0}class="active"{/if}><a href="{url module=OrdersAdmin status=0 keyword=null id=null page=null label=null}">{$tr->new_pl|escape}</a></li>
		<li {if isset($status) && $status==4}class="active"{/if}><a href="{url module=OrdersAdmin status=4 keyword=null id=null page=null label=null}">{$tr->status_in_processing|escape}</a></li>
		<li {if isset($status) && $status==1}class="active"{/if}><a href="{url module=OrdersAdmin status=1 keyword=null id=null page=null label=null}">{$tr->status_accepted_pl|escape}</a></li>
		<li {if isset($status) && $status==5}class="active"{/if}><a href="{url module=OrdersAdmin status=5 keyword=null id=null page=null label=null}">{$tr->status_delivery_pl|escape}</a></li>
		<li {if isset($status) && $status==2}class="active"{/if}><a href="{url module=OrdersAdmin status=2 keyword=null id=null page=null label=null}">{$tr->status_completed_pl|escape}</a></li>
		<li {if isset($status) && $status==3}class="active"{/if}><a href="{url module=OrdersAdmin status=3 keyword=null id=null page=null label=null}">{$tr->status_canceled_pl|escape}</a></li>
		{if isset($keyword)}
		<li class="active"><a href="{url module=OrdersAdmin keyword=$keyword id=null label=null}">{$tr->search|escape}</a></li>
		{/if}
	{/if}
	{if in_array('labels', $manager->permissions)}
		<li><a href="{url module=OrdersLabelsAdmin keyword=null id=null page=null label=null}">{$tr->labels|escape}</a></li>
	{/if}
{/capture}

{* Title *}
{$meta_title=$tr->orders|escape scope=root}

<div class="headerseparator">
	{* Заголовок *}
	<div id="header">
		<h1 style="text-transform:capitalize;">{$tr->orders_ov|escape}: {if $orders_count}{$orders_count}{else}0{/if}</h1>		
		<a class="add" href="{url module=OrderAdmin}">{$tr->add|escape} {$tr->order|escape|lower}</a>
	</div>	
	
	{* Поиск *}
	<form method="get">
		<div id="search">
			<input type="hidden" name="module" value="OrdersAdmin">
			<input placeholder="{$tr->orders_search_placeholder|escape}" class="search" type="text" name="keyword" value="{if isset($keyword)}{$keyword|escape}{/if}"/>
			<input class="search_button" type="submit" value=""/>
		</div>
	</form>
</div>

{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">{if $message_error=='error_closing'}{$tr->out_of_stock|escape}{else}{$message_error|escape}{/if}</span>
	{if isset($smarty.get.return)}
	<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
	{/if}
</div>
{/if}

{if isset($orders) && $orders}
<div id="main_list" class="orderspage">

	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
	
	<form id="form_list" method="post">
		<input type="hidden" name="session_id" value="{$smarty.session.id}">

		<div id="list">		
			{foreach $orders as $order}
			<div class="row">
		 		<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$order->id}"/>				
				</div>
				<div class="order_date cell">				 	
	 				<div style="clear: right;">{$order->date|date} <br />{$order->date|time}</div>

					<div class="icon_status" style="margin-top: 4px;">
						{if isset($keyword)}
							{if $order->status == 0}
							<img src='design/images/new.png' alt='{$tr->new|escape}' title='{$tr->new|escape}' />
							{/if}
							{if $order->status == 4}
							<img src='design/images/new.png' alt='{$tr->status_in_processing|escape}' title='{$tr->status_in_processing|escape}' />
							{/if}
							{if $order->status == 1}
							<img src='design/images/time.png' alt='{$tr->status_accepted|escape}' title='{$tr->status_accepted|escape}' />
							{/if}
							{if $order->status == 2}
							<img src='design/images/tick.png' alt='{$tr->status_completed|escape}' title='{$tr->status_completed|escape}' />
							{/if}
							{if $order->status == 3}
							<img src='design/images/cross.png' alt='{$tr->status_canceled|escape}' title='{$tr->status_canceled|escape}' />
							{/if}
						{/if}
							{if $order->paid}
							<img src='design/images/cash_stack.png' alt='{$tr->paid|escape}' title='{$tr->paid|escape}' />
							{else}
							<img src='design/images/cash_stack_gray.png' alt='{$tr->not_paid|escape}' title='{$tr->not_paid|escape}' />				
							{/if}
					</div>
				</div>
				<div class="order_name cell">
	 				<a href="{url module=OrderAdmin id=$order->id return=$smarty.server.REQUEST_URI}">{$tr->order|escape} №{$order->id}</a><br />
	 				<div class="hide_feat">
	 					<span>{$tr->show_purchases|escape}</span>
	 					<svg x="0px" y="0px"><use xlink:href='#b_plus' /></svg>
	 				</div>
				</div>
				<div class="fio cell">{$order->name|escape}</div>
				<div class="tel cell">
					<div class="phone_line">{$order->phone|escape}</div>
					<div class="email_line">{$order->email|escape}</div>
				</div>
				<div class="address cell">
					{if !empty($order->address)}<div class="order_address">{$order->address|escape}</div>{/if}
					<div class="order_delivery">
						{foreach $deliveries as $d}
							{if $d->id==$order->delivery_id}<strong>{$d->name}</strong>{/if}
						{/foreach}
					</div>
					{if !empty($order->shipping_date)}<div class="shipment_date">{$tr->on|escape} {$order->shipping_date|date} {$order->shipping_date|time}</div>{/if}
				</div>
				
				<div class="price_name cell">
	 				{$order->total_price|convert:$currency->id} {$currency->sign}
				</div>
				
				<div class="icons cell">
					<div style="clear:right;">
						<a href="/../../order/{$order->url}" target="_blank" class="preview" title="{$tr->open_on_page|escape}"></a>
						<a href='{url module=OrderAdmin id=$order->id view=print}' target="_blank" class="print" title="{$tr->order_print}"></a>
						<a href='{url module=OrderAdmin id=$order->id view=excel}' target="_blank" class="excel" title="{$tr->order_xls_docs}"></a>
						<a href='{url module=OrderAdmin id=$order->id view=torg12}' target="_blank" class="table" title="Сформировать ТОРГ-12 в Excel"><img src="./design/images/invoice.png" width="17" title="Счет на оплату"></a>
					{*<a href='{url module=OrderAdmin id=$order->id view=excel}'  target="_blank" class="excel" title="Расходная, Кассовый ордер, Товарник в Excel"></a>*}
						<a href='#' class=delete title="{$tr->delete|escape}"></a>
					</div>
					<div style="float: right; margin-top: 5px">
						{if isset($order->labels)}
							{foreach $order->labels as $l}
								<span class="order_label_bigorder" style="background-color:#{$l->color};" title="{$l->name}"></span>
							{/foreach}
						{/if}
					</div>
				</div>

				<div class="clear"></div>
				
				<div class="purchases_list feature_values" style="display:none;">
	 					<div class="order_purchase title">
							<div class="pur_name">{$tr->product_name|escape}</div>
							<div class="pur_sku">{$tr->sku|escape}</div>
							<div class="pur_price">{$tr->price|escape}</div>
							<div class="pur_amount">{$tr->count_short|escape}</div>
						</div>
	 				{foreach $order->purchases as $p}
						<div class="order_purchase">
							<div class="pur_name">{$p->product_name} {$p->variant_name}</div>
							<div class="pur_sku">{$p->sku}</div>
							<div class="pur_price">{$p->price}</div>
							<div class="pur_amount">{$p->amount} {if $p->unit}{$p->unit}{else}{$settings->units}{/if}</div>
						</div>
					{/foreach}
				</div>
				
				<div class="utm">
					{if !empty($order->source)}
					<span title="{$tr->order_source|escape}" class="source_item"> 
						{if $order->source == 1}{$tr->in_desktop_theme|escape}
						{elseif $order->source == 2}{$tr->in_mobile_theme|escape}
						{elseif $order->source == 3}{$tr->in_ios_app|escape}
						{elseif $order->source == 4}{$tr->in_android_app|escape}
						{elseif $order->source == 5}{$tr->phone_call|escape}
						{elseif $order->source == 6}{$tr->in_chat|escape}
						{elseif $order->source == 7}{$tr->offline|escape}
						{elseif $order->source == 8}{$tr->another|escape}
						{/if}
					</span>
					{/if}
					
					{if !empty($order->referer)}
						<span title="{$tr->referer|escape}" class="referer_item">{$order->referer|escape}</span>
					{/if}
					{if !empty($order->yclid)}
						<span title="yclid" class="utm_item">yclid={$order->yclid|escape}</span>
					{/if}
					{if !empty($order->utm)}
						{$utm_array = "utm"|explode:$order->utm}
						{foreach $utm_array as $utm}
							{if !empty($utm) && $utm|strpos:'_' !== false}
							<span title="UTM-{$tr->labels|escape}" class="utm_item">utm{$utm|regex_replace:'/&.*/':''|escape}</span>
							{/if}
						{/foreach}
					{/if}
				</div>

				{if $order->note}
	 				<div class="note">{$order->note|escape}</div>
	 			{/if} 

			</div>
			{/foreach}
		</div>
	
		<div id="action">
			<label id='check_all' class="dash_link">{$tr->choose_all|escape}</label>
	
			<span id="select">
				<select name="action">
					{if isset($status)}
						{if $status!==0}<option value="set_status_0">{$tr->in} {$tr->new_pl|lower}</option>{/if}
						{if $status!==4}<option value="set_status_4">{$tr->status_in_processing|escape}</option>{/if}
						{if $status!==1}<option value="set_status_1">{$tr->in} {$tr->status_accepted_pl_e|lower}</option>{/if}
						{if $status!==2}<option value="set_status_2">{$tr->in} {$tr->status_completed_pl_e|lower}</option>{/if}
					{/if}
					{foreach $labels as $l}
					<option value="set_label_{$l->id}">{$tr->mark|escape} &laquo;{$l->name}&raquo;</option>
					{/foreach}
					{foreach $labels as $l}
					<option value="unset_label_{$l->id}">{$tr->unmark|escape} &laquo;{$l->name}&raquo;</option>
					{/foreach}
					<option value="delete">{$tr->delete|escape}</option>
					<option value="merge">{$tr->merge|escape}</option>
				</select>
			</span>
	
			<input id="apply_action" class="button_green" type="submit" value="{$tr->save|escape}"/>
		
		</div>
	</form>
	
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
		
</div>
{/if}


<!-- Меню -->
<form method="get">
<input type="hidden" name="module" value="OrdersAdmin"/>
<input type="hidden" name="status" value="{$status|escape}"/>
{if !empty($keyword)}
<input type="hidden" name="keyword" value="{$keyword|escape}"/>
{/if}

<div id="right_menu" class="ordersright right_menu_filter">
	{if !empty($labels)}		
	<div class="o_filer_title">{$tr->labels|escape}</div>
	<ul id="labels">
		{foreach $labels as $l}
		<li data-label-id="{$l->id}">
			<label>
				<span class="chbox">
					<input type="checkbox" name="label_id[]" value="{$l->id}" {if !empty($label_id) && in_array($l->id, $label_id)}checked{/if} />
				</span>
				<span style="background-color:#{$l->color};" class="order_label"></span>
				<span>{$l->name|escape}</span>
			</label>
		</li>
		{/foreach}
	</ul>
	<div>
		<input id="apply_action" class="button_green" type="submit" value="{$tr->filter|escape}"/>
		{*<a class="bigbutton" href="{url module=OrdersAdmin status=$status keyword=null filter=null filter_two=null id=null page=null label_id=null}">{$tr->reset|escape}</a>*}
		<a class="bigbutton" href="{url module=OrdersAdmin status=$status keyword=null id=null page=null label_id=null}">{$tr->reset|escape}</a>
	</div>
	{/if}
</div>

<div class="right_menu ordersright right_menu_filter">
	{* Фильтр по дате заказа *}
	<div id="search-date">
		{literal}
		<script src="design/js/jquery/datepicker/jquery.ui.datepicker-ru.js"></script>
		<script>
			$(function() {
				$('input[name="filter[date_from]"]').datepicker({
					regional:'ru'
				});
				$('input[name="filter[date_to]"]').datepicker({
					regional:'ru'
				});
			});
		</script>
		{/literal}
		<div class="search-dbody">
			<div class="o_filer_title">{$tr->filter_by_order_date|escape}</div>
			<div id='filter_fields'>
				<div class="filter_date_wrapper">
					<label>{$tr->from|escape}&nbsp;</label><input type=text name="filter[date_from]" value='{if isset($date_from)}{$date_from}{/if}' autocomplete="off" /><br />
					<label>{$tr->to|escape}&nbsp;</label><input type=text name="filter[date_to]" value='{if isset($date_to)}{$date_to}{/if}' autocomplete="off" />
				</div>
				<input id="apply_action" class="button_green" type="submit" value="{$tr->filter|escape}"/>
				{*<a class="bigbutton" href="{url module=OrdersAdmin status=$status keyword=null filter=null filter_two=null id=null page=null label_id=null}">{$tr->reset|escape}</a>*}
				<a class="bigbutton" href="{url module=OrdersAdmin status=$status keyword=null filter=null id=null page=null}">{$tr->reset|escape}</a>
			</div>
		</div>
	</div>
	{* Фильтр по дате заказа @ *}
</div>

<div class="right_menu ordersright right_menu_filter">	
	{* Фильтр по дате отправки *}
	<div id="search-date-shipment">
		<script>
			$(function() {
				$('input[name="filter_two[date_from]"]').datepicker({
					regional:'ru'
				});
				$('input[name="filter_two[date_to]"]').datepicker({
					regional:'ru'
				});
			});
		</script>
		<div class="search-dbody">
			<div class="o_filer_title">{$tr->filter_by_order_shipment|escape}</div>
			<div id='shipment_fields'>
				<div class="filter_date_wrapper">
					<label>{$tr->from|escape}&nbsp;</label><input type=text name="filter_two[date_from]" value='{if isset($date_from_two)}{$date_from_two}{/if}' autocomplete="off" /><br />
					<label>{$tr->to|escape}&nbsp;</label><input type=text name="filter_two[date_to]" value='{if isset($date_to_two)}{$date_to_two}{/if}' autocomplete="off" />
				</div>
				<input id="apply_action" class="button_green" type="submit" value="{$tr->filter|escape}"/>
				{*<a class="bigbutton" href="{url module=OrdersAdmin status=$status keyword=null filter=null filter_two=null id=null page=null label_id=null}">{$tr->reset|escape}</a>*}
				<a class="bigbutton" href="{url module=OrdersAdmin status=$status keyword=null filter_two=null id=null page=null}">{$tr->reset|escape}</a>
			</div>
		</div>
	</div>
	{* Фильтр по дате отправки @ *}
</div>

</form>
<!-- Меню  (The End) -->

<svg style="display:none;"> <symbol id="b_plus" fill="#1b6f9f" viewBox="0 0 24 24" enable-background="new 0 0 24 24" xml:space="preserve"> <g id="Bounding_Boxes_cf"> <g id="ui_x5F_spec_x5F_header_copy_3_cf" display="none"> </g> <path fill="none" d="M0,0h24v24H0V0z"/> </g> <g id="Outline_cf"> <g id="ui_x5F_spec_x5F_header_cf" display="none"> </g> <path d="M13,7h-2v4H7v2h4v4h2v-4h4v-2h-4V7z M12,2C6.48,2,2,6.48,2,12s4.48,10,10,10s10-4.48,10-10S17.52,2,12,2z M12,20
			c-4.41,0-8-3.59-8-8s3.59-8,8-8s8,3.59,8,8S16.41,20,12,20z"/> </g> </symbol> 
</svg>


{literal}
<script>
$(function() {

	$(document).on('click','.hide_feat',function(){
		$(this).toggleClass('show').parent().siblings('.feature_values').fadeToggle('normal');return false;
	});
	
	// Перетаскивание меток
	$("#labels").sortable({
		items:             "li",
		tolerance:         "pointer",
		scrollSensitivity: 40,
		opacity:           0.7
	});
	
	$("#main_list #list .row").droppable({
		activeClass: "drop_active",
		hoverClass: "drop_hover",
		tolerance: "pointer",
		drop: function(event, ui){
			label_id = $(ui.helper).attr('data-label-id');
			$(this).find('input[type="checkbox"][name*="check"]').attr('checked', true);
			$(this).closest("form").find('select[name="action"] option[value=set_label_'+label_id+']').attr("selected", "selected");		
			$(this).closest("form").submit();
			return false;	
		}		
	});
	
	// Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();

	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Удалить 
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest(".row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});

	// Подтверждение удаления
	$("form").submit(function() {
		if($('#list input[type="checkbox"][name*="check"]:checked').length>0)
			if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_deletion|escape}{literal}'))
				return false;	
	});
});

</script>
{/literal}
