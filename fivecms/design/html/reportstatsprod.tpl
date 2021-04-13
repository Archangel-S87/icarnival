{* Вкладки *}
{capture name=tabs}
	<li><a href="{url module=StatsAdmin id=null return=null}">{$tr->stats|escape}</a></li>
    <li class="active"><a href="{url module=ReportStatsAdmin id=null return=null}">{$tr->sales_report|escape}</a></li>
    <li><a href="{url module=ReportStatsCategoriesAdmin id=null return=null}">{$tr->sales_cat_report}</a></li>
{/capture}

{* Title *}
{$meta_title=$tr->sales_report|escape scope=root}

<script src="design/js/chartjs/Chart.min.js"></script>
<script src="design/js/jquery/datepicker/jquery.ui.datepicker-ru.js"></script>
<style>
	canvas { 
		-moz-user-select: none;
		-webkit-user-select: none;
		-ms-user-select: none; 
	}
	#list td, #list th { padding: 7px 5px; text-align: left; }
	#list td.c, #list th.c { text-align: center; }
	.sort.top:before { content:"↑ "; border-bottom:none; }
	.sort.bottom:before { content: "↓ "; border-bottom:none; }
	#list tfoot { background: #d0d0d0; }
</style>

<script>
    $(function(){ 
        $('input[name="date_from"]').datepicker({ regional:'ru'});
        $('input[name="date_to"]').datepicker({ regional:'ru'});

		$('.date_filter').on('change', function() {
			$('#check').prop('checked', false);
		});
    });

    function show_fields(){ 
        document.getElementById("filter_fields").style.display = document.getElementById("check").checked ? 'block' : 'none';
    }
	
		'use strict';

		window.chartColors = {
			red: 'rgb(255, 99, 132)',
			orange: 'rgb(255, 159, 64)',
			yellow: 'rgb(255, 205, 86)',
			green: 'rgb(75, 192, 192)',
			blue: 'rgb(54, 162, 235)',
			purple: 'rgb(153, 102, 255)',
			grey: 'rgb(201, 203, 207)'
		};
	
		var barChartData = {
			labels: [{foreach $product_report as $prod_report}'{$prod_report->date|date}',{/foreach}],
			datasets: [{
				label: '{$tr->amount|escape}',
				backgroundColor: window.chartColors.grey,
				data: [
					{foreach $product_report as $prod_report}{$prod_report->price},{/foreach}
				]
			}, {
				label: '{$tr->count_short|escape}',
				backgroundColor: window.chartColors.blue,
				data: [
					{foreach $product_report as $prod_report}{$prod_report->amount},{/foreach}
				]
			}]
		};
		
		window.onload = function() {
			var ctx = document.getElementById('canvas').getContext('2d');
			window.myBar = new Chart(ctx, {
				type: 'bar',
				data: barChartData,
				options: {
					/*title: {
						display: true,
						fontSize: 15,
						text: 'СТАТИСТИКА ПО СУММЕ ЗАКАЗОВ'
					},*/
					tooltips: {
						mode: 'index',
						bodySpacing: 7,
						intersect: true
					},
					responsive: true,
					scales: {
						xAxes: [{
							stacked: true,
						}],
						yAxes: [{
							stacked: true
						}]
					}
				}
			});
			
		};
</script>
	
{* Заголовок *}
<div id="header">
	<h1>{$product->name}: {$tr->sales_report|lower|escape}</h1>
</div>	

<div id="main_list" class="statspage">

    <canvas id="canvas"></canvas>

    {assign 'total_summ' 0}
    {assign 'total_amount' 0}

	<div id="list" class="reportpageinner">
        <table width="100%">
            <thead class="thead">
                <th class="c">{$tr->date|escape}</th>
                <th>{$tr->product_name|escape}</th>
                <th class="c">{$tr->sales_sum|escape}</th>
                <th class="c">{$tr->count_short|escape}</th>
            </thead>
            <tbody>
                {foreach $product_report as $prod_report}
                {assign 'total_summ' $total_summ+$prod_report->price}
                {assign 'total_amount' $total_amount+$prod_report->amount}
                <tr class="row">
                    <td class="c">{$prod_report->date|date}</td>
                    <td><a title="{$prod_report->product_name|escape}" href="{url module=ProductAdmin id=$prod_report->product_id return=null}">{$prod_report->product_name}</a> {$prod_report->variant_name}</td>
                    <td class="c">{$prod_report->price} {$currency->sign|escape}</td>
                    <td class="c">{$prod_report->amount} {if $prod_report->unit}{$prod_report->unit}{else}{$settings->units}{/if}</td>                                                                            
                </tr>
                {/foreach}
            </tbody>
            <tfoot> 
                <td colspan="2" style="text-align: right">Итого:</td>        
                <td class="c">{$total_summ|string_format:'%.2f'} {$currency->sign|escape}</td>        
                <td class="c">{$total_amount} {$tr->items}</td>        
            </tfoot> 
        </table>
	</div>
		
</div>

<!-- Меню -->
<div id="right_menu" class="statsright">
	  <form method="post">
	  	<input type=hidden name="session_id" value="{$smarty.session.id}">
	  	
	  	<h4>{$tr->product_variants|escape}</h4>
	  	<select name="variant_id" style="margin:10px 0;">
			<option value="" {if empty($variant_id)}selected{/if}>{$tr->all|escape} {$tr->variants|escape}</option>
			{foreach $variants as $variant}
			<option value="{$variant->id}" {if !empty($variant_id) && $variant_id==$variant->id}selected{/if}>{$variant->name}</option>
			{/foreach}
		</select>
		
		<h4>{$tr->orders_status|escape}</h4>
	    <select name="status" style="margin:10px 0;">
			<option value=0 {if empty($status)}selected{/if}>{$tr->all_orders|escape}</option>
	        <option value=1 {if !empty($status) && $status==1}selected{/if}>{$tr->new_pl|escape}</option>   
	        <option value=5 {if !empty($status) && $status==5}selected{/if}>{$tr->status_in_processing|escape}</option>
	        <option value=2 {if !empty($status) && $status==2}selected{/if}>{$tr->status_accepted_pl|escape}</option>
	        <option value=3 {if !empty($status) && $status==3}selected{/if}>{$tr->status_completed_pl|escape}</option>
	        <option value=4 {if !empty($status) && $status==4}selected{/if}>{$tr->status_canceled_pl|escape}</option>
		</select>
	    
	    <h4>{$tr->period|escape}</h4>
	    <select class="date_filter" name="date_filter" style="margin:10px 0;">
	    	<option value="all" {if $date_filter == all}selected{/if}>{$tr->all_time|escape}</option> 
	        <option value="today" {if $date_filter == today}selected{/if}>{$tr->today|escape}</option>
	        <option value="this_week" {if $date_filter == this_week}selected{/if}>{$tr->current_sh} {$tr->week}</option>
	        <option value="this_month" {if $date_filter == this_month}selected{/if}>{$tr->current_sh} {$tr->month}</option>
	        <option value="this_year" {if $date_filter == this_year}selected{/if}>{$tr->current_sh} {$tr->year}</option>
	        <option value="yesterday" {if $date_filter == yesterday}selected{/if}>{$tr->yesterday|escape}</option>
	        <option value="last_week" {if $date_filter == last_week}selected{/if}>{$tr->prev} {$tr->week}</option>
	        <option value="last_month" {if $date_filter == last_month}selected{/if}>{$tr->prev} {$tr->month}</option>   
	        <option value="last_year" {if $date_filter == last_year}selected{/if}>{$tr->prev} {$tr->year}</option>
	        <option value="last_24hour" {if $date_filter == last_24hour}selected{/if}>{$tr->last_pl} 24 {$tr->hours}</option>
	        <option value="last_7day" {if $date_filter == last_7day}selected{/if}>{$tr->last_pl} 7 {$tr->days}</option>
	        <option value="last_30day" {if $date_filter == last_30day}selected{/if}>{$tr->last_pl} 30 {$tr->days}</option>  
	    </select>
	    
	    <div class="periodchooser">
			<div id='filter_check'>
				<input type="checkbox" name="filter_check" id="check" value='1' {if !empty($filter_check)}checked{/if} onclick="show_fields();"/>
				<label for="check">{$tr->filter_by_order_date|escape}</label>
			</div>
		
			<div id='filter_fields' {if empty($filter_check)}style="display: none"{/if}>
				<div style="margin: 5px 0 0 0">
					<label style="display:inline-block;width:30px;">{$tr->from|escape} </label><input style="width:80px;margin-top:5px;" type=text name=date_from value='{if !empty($date_from)}{$date_from}{/if}' autocomplete="off"><br />
					<label style="display:inline-block;width:30px;">{$tr->to|escape} </label><input style="width:80px;margin-top:5px;" type=text name=date_to value='{if !empty($date_to)}{$date_to}{/if}' autocomplete="off">
				</div>
			</div>
	    </div>
	    
		<h4>{$tr->order_source|escape}</h4>
		<select name="source" style="margin:10px 0;">
				<option value=0 {if empty($source)}selected{/if}>{$tr->not_set|lower|escape}</option>
				<option value=1 {if !empty($source) && $source == 1}selected{/if}>{$tr->in_desktop_theme|escape}</option>
				<option value=2 {if !empty($source) && $source == 2}selected{/if}>{$tr->in_mobile_theme|escape}</option>
				<option value=3 {if !empty($source) && $source == 3}selected{/if}>{$tr->in_ios_app|escape}</option>
				<option value=4 {if !empty($source) && $source == 4}selected{/if}>{$tr->in_android_app|escape}</option>
				<option value=5 {if !empty($source) && $source == 5}selected{/if}>{$tr->phone_call|escape}</option>
				<option value=6 {if !empty($source) && $source == 6}selected{/if}>{$tr->in_chat|escape}</option>
				<option value=7 {if !empty($source) && $source == 7}selected{/if}>{$tr->offline|escape}</option>
				<option value=8 {if !empty($source) && $source == 8}selected{/if}>{$tr->another|escape}</option>
		</select>
		
		{if !empty($deliveries)}	
		<h4>{$tr->delivery|escape}</h4>
		<select name="delivery_id" style="margin:10px 0;max-width:100%;">
			<option value="0" {if empty($delivery_id)}selected{/if}>{$tr->not_set|lower|escape}</option>
			{foreach $deliveries as $d}
				{if $d->enabled}
					<option value="{$d->id}" {if !empty($delivery_id) &&  $d->id == $delivery_id}selected{/if}>{$d->name}</option>
				{/if}
			{/foreach}
		</select>
		{/if}
		
		{if !empty($labels)}
		<h4>{$tr->labels|escape}</h4>
		<select name="label_id" style="margin:10px 0;max-width:100%;">
			<option value="0" {if empty($label_id)}selected{/if}>{$tr->not_set|lower|escape}</option>
			{foreach $labels as $l}
				<option value="{$l->id}" {if !empty($label_id) &&  $l->id == $label_id}selected{/if}>{$l->name}</option>
			{/foreach}
		</select>
		{/if}
			
		<h4>YCLID</h4>
		<input placeholder="7194137021201330494" class="utm_stat" type="text" name="yclid" value="{if !empty($yclid)}{$yclid|escape}{/if}" />
			
		<h4>UTM-{$tr->labels|escape}</h4>
		<input placeholder="source=google" class="utm_stat" type="text" name="utm" value="{if !empty($utm)}{$utm|escape}{/if}" />
			
		<h4>{$tr->referer|escape}</h4>
		<input placeholder="site.com" class="utm_stat" type="text" name="referer" value="{if !empty($referer)}{$referer|escape}{/if}" />
		
		{* поиск по пользователю *}
		<h4>{$tr->customer|escape} <a href="#" {if empty($user)}style="display:none;"{/if} class="delete_user"><img class="delete_user_img" src="design/images/delete.png" alt="{$tr->delete|escape}" title="{$tr->delete|escape}"></a></h4>
		{if !empty($user)}
			<div class="view_user"><a href="index.php?module=UserAdmin&id={$user->id}" target=_blank>{$user->name|escape}</a> ({$user->email|escape})</div>
		{/if}
		<div class='edit_user'>
			<input type=hidden name='user_id' value='{if !empty($user->id)}{$user->id}{/if}'>
			<input type=text id='user' class="input_autocomplete chooseuser" placeholder="{$tr->select_user|escape}">
		</div>
		<script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
		{literal}
		<script>
		$('input#user').autocomplete({
		serviceUrl:'ajax/search_users.php',
		minChars:0,
		noCache: false, 
		onSelect:
			function(suggestion){
				$('input[name="user_id"]').val(suggestion.data.id);
				$('.delete_user').show();
			}
		});
		// Удалить пользователя
		$("a.delete_user").click(function() {
			deleteUser();
		});
		function deleteUser() {
			$('input[name="user_id"]').val(0);
			$('.view_user').hide();
			$('input#user').val('');
			$('.delete_user').hide();
		}
		</script>
		<style>
		.view_user{margin-top:8px;word-break:break-word;}
		.chooseuser{box-sizing:border-box;margin:10px 0 20px 0;width:100% !important;max-width:100%;}
		.delete_user_img{vertical-align:middle;margin-left:10px;}
		</style>
		{/literal}
		{* поиск по пользователю @ *}
		
		<input style="width:100%;" class="button_green color_blue" type="submit" value="{$tr->search|escape}" />

		<a style="margin-top:20px;" class="reset_filter tiny_button color_red" href="#">{$tr->reset|escape} {$tr->filter|lower|escape}</a>
		{literal}
		<script>
		$(".reset_filter").click(function() {
			$('form input[type=text]').val('');
			$('form input[type=checkbox]').removeAttr('checked');
			$('form option').removeAttr('selected');
			deleteUser();
			return false;
		});
		</script>
		{/literal}
	  </form>  
</div>
<!-- Меню  (The End) -->

{* On document load *}
{literal}
<script>
$(function() {

	// Сортировка списка
	$("#labels").sortable({
		items:             "li",
		tolerance:         "pointer",
		scrollSensitivity: 40,
		opacity:           0.7
	});

	// Раскраска строк
	function colorize()
	{
		$("#list tr.row:even").addClass('even');
		$("#list tr.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();

});
</script>
{/literal}
