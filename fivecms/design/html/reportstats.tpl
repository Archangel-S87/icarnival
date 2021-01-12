{* On document load *}
{literal}
<script src="design/js/jquery/datepicker/jquery.ui.datepicker-ru.js"></script>
<script type="text/javascript">
	$(function() {
		$('input[name="date_from"]').datepicker({regional:'ru'});
		$('input[name="date_to"]').datepicker({regional:'ru'});
		
		$('.date_filter').on('change', function() {
			$('#check').prop('checked', false);
		});
	});

	function show_fields() {
		document.getElementById("filter_fields").style.display = document.getElementById("check").checked ? 'block' : 'none';
	}
</script>
<style>
	#list td, #list th { padding: 7px 5px; text-align: left; }
	#list td.c, #list th.c { text-align: center; }
	.sort.top:before { content:"↑ "; border-bottom:none; }
	.sort.bottom:before { content: "↓ "; border-bottom:none; }
	#list tfoot { background: #d0d0d0; }
</style>
{/literal}

{* Вкладки *}
{capture name=tabs}
        <li><a href="{url module=StatsAdmin}">{$tr->stats|escape}</a></li>
        <li class="active"><a href="{url module=ReportStatsAdmin}">{$tr->sales_report|escape}</a></li>
{/capture}

{* Title *}
{$meta_title=$tr->stats|escape scope=root}

<div id="chart_div" style="width:900px;height:900px;display:none;">
    <div id="chart_cont"></div>
    <div id="chart_amount" style="margin-top:25px;"></div>
</div>
    
<div id="main_list" class="reportspage">
    <form id="form_list" method="post">
    <input type="hidden" name="session_id" value="{$smarty.session.id}">

        <div id="list">
            
            {assign 'total_summ' 0}
            {assign 'total_amount' 0}
            
            <table width="100%">
                <tbody>
                    <thead class="thead">
                        <th width="65%">{$tr->product_name|escape}</th>
                        <th width="20%" class="c"><span class="sort {if $sort_prod=='price'}top{elseif $sort_prod=='price_in'}bottom{/if}">{$tr->sales_sum|escape}</span></th>
                        <th width="15%" class="c"><span class="sort {if $sort_prod=='amount'}top{elseif $sort_prod=='amount_in'}bottom{/if}">{$tr->count_short|escape}</span></th>
                    <thead>
                    {foreach $report_stat_purchases as $purchase}
                    {assign 'total_summ' $total_summ+$purchase->sum_price}
                    {assign 'total_amount' $total_amount+$purchase->amount}
                    {if $purchase->product_id}<tr class="row">
                        <td>
							<a title="{$purchase->product_name|escape}" href="{url module=ReportStatsProdAdmin id=$purchase->product_id return=$smarty.server.REQUEST_URI}">{$purchase->product_name}</a> {$purchase->variant_name}
                        </td>
                        <td class="c">{$purchase->sum_price} {$currency->sign|escape}</td>
                        <td class="c">{$purchase->amount} {if $purchase->unit}{$purchase->unit}{else}{$settings->units}{/if}</td>
                    </tr>{/if}
                    {/foreach}
                    <tfoot> 
                        <td style="text-align: right">{$tr->total_amount|escape}:</td>        
                        <td class="c">{$total_summ|string_format:'%.2f'} {$currency->sign|escape}</td>        
                        <td class="c">{$total_amount} {$settings->units}</td>        
                    </tfoot>         
                </tbody>
            </table>
        </div>
    </form>
        
</div>

<!-- Меню -->
<div id="right_menu" class="statsright">
	<form method="post">
	  	<input type=hidden name="session_id" value="{$smarty.session.id}">
	  	<h4>{$tr->sort_by|escape}</h4>
	    <select name="sort_prod" style="margin:10px 0;">
			<option value="price" {if !empty($sort_prod) && $sort_prod=="price"}selected{/if}>{$tr->sales_sum|escape} &uarr;</option>
	        <option value="price_in" {if !empty($sort_prod) && $sort_prod=="price_in"}selected{/if}>{$tr->sales_sum|escape} 	&darr;</option>   
	        <option value="amount" {if !empty($sort_prod) && $sort_prod=="amount"}selected{/if}>{$tr->count_short|escape} &uarr;</option>
	        <option value="amount_in" {if !empty($sort_prod) && $sort_prod=="amount_in"}selected{/if}>{$tr->count_short|escape} 	&darr;</option>
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
			
		<h4>{$tr->delivery|escape}</h4>
		<select name="delivery_id" style="margin:10px 0;max-width:100%;">
			<option value="0" {if empty($delivery_id)}selected{/if}>{$tr->not_set|lower|escape}</option>
			{foreach $deliveries as $d}
				{if $d->enabled}
					<option value="{$d->id}" {if !empty($delivery_id) &&  $d->id == $delivery_id}selected{/if}>{$d->name}</option>
				{/if}
			{/foreach}
		</select>	
			
		<h4>YCLID</h4>
		<input placeholder="7194137021201330494" class="utm_stat" type="text" name="yclid" value="{if !empty($yclid)}{$yclid|escape}{/if}" />
			
		<h4>UTM-{$tr->labels|escape}</h4>
		<input placeholder="source=google" class="utm_stat" type="text" name="utm" value="{if !empty($utm)}{$utm|escape}{/if}" />
			
		<h4>{$tr->referer|escape}</h4>
		<input placeholder="site.com" class="utm_stat" type="text" name="referer" value="{if !empty($referer)}{$referer|escape}{/if}" />
		<input style="width:100%;" class="button_green color_blue" type="submit" value="{$tr->search|escape}" />

		<a style="margin-top:20px;" class="reset_filter tiny_button color_red" href="index.php?module=ReportStatsAdmin">{$tr->reset|escape} {$tr->filter|lower|escape}</a>
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
