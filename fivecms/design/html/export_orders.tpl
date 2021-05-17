{* Вкладки *}
{capture name=tabs}
	{if in_array('orders', $manager->permissions)}
		<li><a href="{url module=OrdersAdmin status=0 keyword=null id=null page=null label=null}">{$tr->new_pl|escape}</a></li>
		<li><a href="{url module=OrdersAdmin status=4 keyword=null id=null page=null label=null}">{$tr->status_in_processing|escape}</a></li>
		<li><a href="{url module=OrdersAdmin status=1 keyword=null id=null page=null label=null}">{$tr->status_accepted_pl|escape}</a></li>
		<li><a href="{url module=OrdersAdmin status=2 keyword=null id=null page=null label=null}">{$tr->status_completed_pl|escape}</a></li>
		<li><a href="{url module=OrdersAdmin status=3 keyword=null id=null page=null label=null}">{$tr->status_canceled_pl|escape}</a></li>
		<li class="active"><a href="index.php?module=ExportOrdersAdmin">{$tr->export} {$tr->orders_ov}</a></li>
	{/if}	
{/capture}
{$meta_title = {$tr->export|cat:' '|cat:$tr->orders_ov} scope=root}

<script src="design/js/piecon/piecon.js"></script>
<script>
	var in_process=false;

	{literal}	
	var in_process=false;

	$(function() {

		// On document load
		$('input#start').click(function() {
			Piecon.setOptions({fallback: 'force'});
			Piecon.setProgress(0);
			$("#progressbar").progressbar({ value: 0 });
			$("#start").hide('fast');
			$("#filter").hide('fast');
			do_export();
		});
  
		function do_export(page)
		{
			page = typeof(page) != 'undefined' ? page : 1;

			var status= $('.status').val();
 			var date_from= $('.date_from').val();
			var date_to= $('.date_to').val();

			$.ajax({
					url: "ajax/export_orders.php",
					data: {page:page, date_from:date_from, date_to:date_to, status:status},
					dataType: 'json',
					success: function(data){
						if(data && !data.end)
						{
							Piecon.setProgress(Math.round(100*data.page/data.totalpages));
							$("#progressbar").progressbar({ value: 100*data.page/data.totalpages });
							do_export(data.page*1+1);
						}
						else
						{	
							Piecon.setProgress(100);
							$("#progressbar").hide('fast');
							window.location.href = '/fivecms/files/export_orders/orders.csv?{/literal}{math equation='rand(1,10000)'}{literal}';

						}
					},
					error:function(xhr, status, errorThrown) {	
					alert(errorThrown+'\n'+xhr.responseText);
				}  				
				
			});
	
		}
	});
	{/literal}
</script>

<style>
	.ui-progressbar-value { background-image: url(design/images/progress.gif); background-position:left; border-color: #009ae2;}
	#progressbar{ clear: both; height:29px; }
	#result{ clear: both; width:100%;}
	#download{ display:none;  clear: both; }
	#filter{ display:table; }
	.filter_menu h3{ text-transform:uppercase;margin-bottom:10px; }
	.button_green { margin-top:20px; }
</style>


{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">
	{if $message_error == 'no_permission'}{$tr->no_permission|escape} {$export_files_dir}
	{else}{$message_error}{/if}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}


<div>
	<h1>CSV {$tr->export} {$tr->orders_ov}</h1>
	{if isset($message_error) && $message_error == 'no_permission'}
	{else}
	<div id='progressbar'></div>
	
	<!-- Меню -->
	<div id="filter">

		<div class="filter_menu ">
			<h3>{$tr->orders_status}</h3>
			<select class="status" name="status">
				<option value='all'>{$tr->all|escape}</option>
				<option value='0'>{$tr->new|escape}</option>
				<option value='4'>{$tr->status_in_processing|escape}</option>
				<option value='1'>{$tr->status_accepted|escape}</option>
				<option value='2'>{$tr->status_completed|escape}</option>
				<option value='3'>{$tr->status_canceled|escape}</option>
			</select>
		</div>

		<div class="filter_menu" style="margin-top:20px;">
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
					<h3>{$tr->filter_by_order_date|escape}</h3>
					<div id='filter_fields'>
						<div class="filter_date_wrapper">
							<label>{$tr->from|escape}&nbsp;</label><input class="date_from" type=text name="filter[date_from]" value='{if isset($date_from)}{$date_from}{/if}' autocomplete="off" /><br />
							<label>{$tr->to|escape}&nbsp;</label><input class="date_to" type=text name="filter[date_to]" value='{if isset($date_to)}{$date_to}{/if}' autocomplete="off" />
						</div>
					</div>
				</div>
			</div>
			{* Фильтр по дате заказа @ *}
		</div>
	</div>
	<!-- Меню  (The End) -->
	
	
	<input class="button_green" id="start" type="button" name="" value="{$tr->to_export|escape}" />
	{/if}
</div>
 

