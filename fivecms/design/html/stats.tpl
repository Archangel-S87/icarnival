{capture name=tabs}
    <li class="active"><a href="{url module=StatsAdmin}">{$tr->stats}</a></li>
    <li><a href="{url module=ReportStatsAdmin}">{$tr->sales_report}</a></li>
    <li><a href="{url module=ReportStatsCategoriesAdmin}">{$tr->sales_cat_report}</a></li>
{/capture}
{$meta_title=$tr->stats scope=root}


<script src="design/js/chartjs/Chart.min.js"></script>
<script src="design/js/jquery/datepicker/jquery.ui.datepicker-ru.js"></script>
<style>
	canvas { 
		-moz-user-select: none;
		-webkit-user-select: none;
		-ms-user-select: none; 
	}
	.stat_table p { font-weight:700; text-transform:uppercase;margin-bottom:10px; }
	.stat_table{ margin:5px 0px 20px 20px; }
	.stat_table td{ padding:5px;border: 1px solid #dadada;background-color:#ffffff; }
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
			
			{$count_orders = 0}
			{$new_orders = 0}
			{$newtwo_orders = 0}
			{$confirm_orders = 0}
			{$complite_orders = 0}
			{$delete_orders = 0}
			
			labels: [{foreach $stat as $s}'{$s.title}',{$count_orders = $count_orders + 1}
			{$new_orders = $new_orders + $s.new}
			{$newtwo_orders = $newtwo_orders + $s.newtwo}
			{$confirm_orders = $confirm_orders + $s.confirm}
			{$complite_orders = $complite_orders + $s.complite}
			{$delete_orders = $delete_orders + $s.delete}
			{/foreach}],
			datasets: [{
				label: '{$tr->new_pl}',
				backgroundColor: window.chartColors.grey,
				data: [
					{foreach $stat as $s}{$s.new},{/foreach}
				]
			}, {
				label: '{$tr->status_in_processing}',
				backgroundColor: window.chartColors.blue,
				data: [
					{foreach $stat as $s}{$s.newtwo},{/foreach}
				]
			}, {
				label: '{$tr->status_accepted_pl}',
				backgroundColor: window.chartColors.yellow,
				data: [
					{foreach $stat as $s}{$s.confirm},{/foreach}
				]
			}, {
				label: '{$tr->status_completed_pl}',
				backgroundColor: window.chartColors.green,
				data: [
					{foreach $stat as $s}{$s.complite},{/foreach}
				]
			}, {
				label: '{$tr->status_canceled_pl}',
				backgroundColor: window.chartColors.red,
				data: [
					{foreach $stat as $s}{$s.delete},{/foreach}
				]
			}]
		};
		
		var barNumChartData = {
			
			{$count_orders = 0}
			{$count_new_orders = 0}
			{$count_newtwo_orders = 0}
			{$count_confirm_orders = 0}
			{$count_complite_orders = 0}
			{$count_delete_orders = 0}
			
			labels: [{foreach $stat_orders as $s}'{$s.title}',{$count_orders = $count_orders + 1}
			{$count_new_orders = $count_new_orders + $s.new}
			{$count_newtwo_orders = $count_newtwo_orders + $s.newtwo}
			{$count_confirm_orders = $count_confirm_orders + $s.confirm}
			{$count_complite_orders = $count_complite_orders + $s.complite}
			{$count_delete_orders = $count_delete_orders + $s.delete}
			{/foreach}],
			datasets: [{
				label: '{$tr->new_pl}',
				backgroundColor: window.chartColors.grey,
				data: [
					{foreach $stat_orders as $s}{$s.new},{/foreach}
				]
			}, {
				label: '{$tr->status_in_processing}',
				backgroundColor: window.chartColors.blue,
				data: [
					{foreach $stat_orders as $s}{$s.newtwo},{/foreach}
				]
			}, {
				label: '{$tr->status_accepted_pl}',
				backgroundColor: window.chartColors.yellow,
				data: [
					{foreach $stat_orders as $s}{$s.confirm},{/foreach}
				]
			}, {
				label: '{$tr->status_completed_pl}',
				backgroundColor: window.chartColors.green,
				data: [
					{foreach $stat_orders as $s}{$s.complite},{/foreach}
				]
			}, {
				label: '{$tr->status_canceled_pl}',
				backgroundColor: window.chartColors.red,
				data: [
					{foreach $stat_orders as $s}{$s.delete},{/foreach}
				]
			}]
		};
		
		window.onload = function() {
			var ctx = document.getElementById('canvas').getContext('2d');
			window.myBar = new Chart(ctx, {
				type: 'bar',
				data: barChartData,
				options: {
					title: {
						display: true,
						fontSize: 15,
						text: '{$tr->stat_orders_amount|upper}'
					},
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
			var ctx = document.getElementById('canvas_num').getContext('2d');
			window.myBar = new Chart(ctx, {
				type: 'bar',
				data: barNumChartData,
				options: {
					title: {
						display: true,
						fontSize: 15,
						text: '{$tr->stat_orders_number|upper}'
					},
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

<div>
	{if $count_orders > 0}
	<div id="main_list" class="statspage">
		<canvas id="canvas"></canvas>
		
		<div class="stat_table">
			<p>{$tr->period_orders_amount}:</p>
			<table>
				<tr><td>{$tr->new_pl}</td><td>{$new_orders} {$currency->sign}</td></tr>
				<tr><td>{$tr->status_in_processing}</td><td>{$newtwo_orders} {$currency->sign}</td></tr>
				<tr><td>{$tr->status_accepted_pl}</td><td>{$confirm_orders} {$currency->sign}</td></tr>
				<tr><td>{$tr->status_completed_pl}</td><td>{$complite_orders} {$currency->sign}</td></tr>
				<tr><td>{$tr->status_canceled_pl}</td><td>{$delete_orders} {$currency->sign}</td></tr>
			</table>
		</div>
		
		<canvas id="canvas_num"></canvas>
		
		<div class="stat_table">
			<p>{$tr->period_orders_num}:</p>
			<table>
				<tr><td>{$tr->new_pl}</td><td>{$count_new_orders}</td></tr>
				<tr><td>{$tr->status_in_processing}</td><td>{$count_newtwo_orders}</td></tr>
				<tr><td>{$tr->status_accepted_pl}</td><td>{$count_confirm_orders}</td></tr>
				<tr><td>{$tr->status_completed_pl}</td><td>{$count_complite_orders}</td></tr>
				<tr><td>{$tr->status_canceled_pl}</td><td>{$count_delete_orders}</td></tr>
			</table>
		</div>
		
	</div>
	{else}
	<div id="main_list" class="statspage" style="padding:20px;margin-bottom:20px;">{$tr->no_stats}</div>
	{/if}
	
	<!-- Меню -->
	<div id="right_menu" class="statsright">
	  <form method="post">
	  	<input type=hidden name="session_id" value="{$smarty.session.id}">
		<h4>{$tr->orders_status}</h4>
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
	    	<option value="all" {if empty($date_filter) || (!empty($date_filter) && $date_filter == all)}selected{/if}>{$tr->all_time|escape}</option> 
	        <option value="today" {if !empty($date_filter) && $date_filter == today}selected{/if}>{$tr->today|escape}</option>
	        <option value="this_week" {if !empty($date_filter) && $date_filter == this_week}selected{/if}>{$tr->current_sh} {$tr->week}</option>
	        <option value="this_month" {if !empty($date_filter) && $date_filter == this_month}selected{/if}>{$tr->current_sh} {$tr->month}</option>
	        <option value="this_year" {if !empty($date_filter) && $date_filter == this_year}selected{/if}>{$tr->current_sh} {$tr->year}</option>
	        <option value="yesterday" {if !empty($date_filter) && $date_filter == yesterday}selected{/if}>{$tr->yesterday|escape}</option>
	        <option value="last_week" {if !empty($date_filter) && $date_filter == last_week}selected{/if}>{$tr->prev} {$tr->week}</option>
	        <option value="last_month" {if !empty($date_filter) && $date_filter == last_month}selected{/if}>{$tr->prev} {$tr->month}</option>   
	        <option value="last_year" {if !empty($date_filter) && $date_filter == last_year}selected{/if}>{$tr->prev} {$tr->year}</option>
	        <option value="last_24hour" {if !empty($date_filter) && $date_filter == last_24hour}selected{/if}>{$tr->last_pl} 24 {$tr->hours}</option>
	        <option value="last_7day" {if !empty($date_filter) && $date_filter == last_7day}selected{/if}>{$tr->last_pl} 7 {$tr->days}</option>
	        <option value="last_30day" {if !empty($date_filter) && $date_filter == last_30day}selected{/if}>{$tr->last_pl} 30 {$tr->days}</option>  
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
		
		{* Метки чекбоксами *}
		{*{if !empty($labels)}
		<h4>{$tr->labels|escape}</h4>
		<ul id="labels">
			{foreach $labels as $l}
			<li>
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
		{/if}*}
		
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
</div>
