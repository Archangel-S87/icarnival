<!DOCTYPE html>
{$wrapper='' scope=root}
<html>
<head>
	<base href="{$config->root_url}/"/>
	<title>{$tr->order|escape} №{$order->id}</title>	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="description" content="Заказ №{$order->id}" />
	<style>
		body {
			width: 1000px;
			height: 1414px;
			margin-left: auto;
			margin-right: auto;
			font-family: Trebuchet MS, times, arial, sans-serif;
			font-size: 10pt;
			color: black;
			background-color: white;
		}

		div#header {
			margin-left: 50px;
			margin-top: 50px;
			height: 150px;
			width: 500px;
			float: left;
		}

		div#company {
			margin-right: 50px;
			margin-top: 50px;
			height: 150px;
			width: 400px;
			float: right;
			text-align: right;
		}

		div#customer {
			margin-right: 50px;
			height: 200px;
			width: 300px;
			float: right;
		}

		div#customer table {
			margin-bottom: 20px;
			font-size: 20px;
		}

		div#map {
			margin-left: 50px;
			width: 550px;
			height: 370px;
			float: left;
		}

		div#purchases {
			margin-left: 50px;
			margin-bottom: 20px;
			min-height: 600px;
			width: 100%;
			float: left;
		}

		div#purchases table {
			width: 900px;
			border-collapse: collapse
		}

		div#purchases table th {
			font-weight: normal;
			text-align: left;
			font-size: 25px;
		}

		div#purchases td, div#purchases th {
			font-size: 18px;
			padding-top: 10px;
			padding-bottom: 10px;
			margin: 0;
		}

		div#purchases td {
			border-top: 1px solid black;
		}

		div#total {
			float: right;
			margin-right: 50px;
			height: 100px;
			width: 500px;
			text-align: right;
		}

		div#total table {
			width: 500px;
			float: right;
			border-collapse: collapse
		}

		div#total th {
			font-weight: 700;
			text-align: left;
			font-size: 22px;
			border-top: 1px solid black;
		}

		div#total td {
			text-align: right;
			border-top: 1px solid black;
			font-size: 18px;
			padding-top: 10px;
			padding-bottom: 10px;
			margin: 0;
		}

		div#total .total {
			font-size: 30px;
		}

		h1 {
			margin: 0;
			font-weight: normal;
			font-size: 40px;
		}

		h2 {
			margin: 0;
			font-weight: normal;
			font-size: 24px;
		}

		p {
			margin: 0;
			font-size: 20px;
		}

		.align_right {
			text-align: right;
		}

		.align_center {
			text-align: center;
		}

		.view_purchase {
			white-space: nowrap;
		}

		div#purchases td.align_right, div#purchases th.align_right {
			text-align: right;
		}
	</style>
</head>

<body onload="window.print();">

<div id="header">
	<h1>{$tr->order|escape} №{$order->id}</h1>
	<p style="display: inline-block; margin-right: 20px;">{$order->date|date}</p>
	{if $order->paid}<img src="/fivecms/design/images/paid.png" style="position: absolute; margin-left: 120px;" alt="Оплачено"/>{/if}
</div>

<div id="company">
	<h2>{$settings->company_name}</h2>
	<p>{$config->root_url}</p>
</div>


<div id="customer">
	<h2>{$tr->customer|escape}:</h2>
	<table>
		<tr>
			<td>{$order->name|escape}</td>
		</tr>	
		<tr>
			<td>{$order->phone|escape}</td>
		</tr>	
		<tr>
			<td>{$order->email|escape}</td>
		</tr>	
		<tr>
			<td>{$order->address|escape}</td>
		</tr>	
		<tr>
			<td><i>{$order->comment|escape|nl2br}</i></td>
		</tr>
	</table>
	
	{*{if $order->note}
	<table>		
		<tr>
			<td><h2><i>{$tr->manager_note|escape}</i></h2><i>{$order->note|escape|nl2br}</i></td>
		</tr>
	</table>
	{/if}*}
</div>

{if $coords}
	<div id="map"></div>
	<script src="https://api-maps.yandex.ru/2.1/?apikey={$api_key}&lang=ru_RU&coordorder=longlat" type="text/javascript"></script>
	<script type="text/javascript">
		ymaps.ready(init);
		let myMap,
			myPlacemark;

		function init(){
			myMap = new ymaps.Map ("map", {
				center: [{$coords}],
				zoom: 16,
				controls: ["zoomControl", "fullscreenControl"]
			});

			myPlacemark = new ymaps.Placemark([{$coords}], { content: '1', balloonContent: '{$order->address|escape|wordwrap:3000|strip}}' });
			myMap.geoObjects.add(myPlacemark);
		}
	</script>
{else}
	<div id="map">
		<iframe width="550" height="370" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
				src="https://maps.google.com/maps?ie=UTF8&iwloc=near&hl=ru&t=m&z=16&mrt=loc&geocode=&q={$order->address|escape|urlencode}&output=embed"></iframe>
	</div>
{/if}

<div id="purchases">
	<table>
		<tr>
			<th>{$tr->product|escape}</th>
			<th class="align_right">{$tr->price|escape}</th>
			<th class="align_right">{$tr->count|escape}</th>
			<th class="align_right">{$tr->total|escape}</th>
		</tr>
		{foreach from=$purchases item=purchase}
		<tr>
			<td>
				<span class=view_purchase>
					{$purchase->product_name} {$purchase->variant_name} {if $purchase->sku} ({$tr->sku|escape} {$purchase->sku}){/if}
				</span>
			</td>
			<td class="align_right">
				<span class=view_purchase>{$purchase->price|convert}</span> {$currency->sign}
			</td>
			<td class="align_right">			
				<span class=view_purchase>
					{$purchase->amount} {if $purchase->unit}{$purchase->unit}{else}{$settings->units}{/if}
				</span>
			</td>
			<td class="align_right">
				<span class=view_purchase>{($purchase->price*$purchase->amount)|convert}</span> {$currency->sign}
			</td>
		</tr>
		{/foreach}

		{* Если стоимость доставки входит в сумму заказа *}
		{if $order->delivery_price>0}
			<tr>
				<td colspan=3>{$delivery->name|escape}{if $order->separate_delivery} (оплачивается отдельно){/if}</td>
				<td class="align_right">{$order->delivery_price|convert}&nbsp;{$currency->sign}</td>
			</tr>
		{/if}
		{if $order->calc ne ''}
			<tr>
				<td colspan=3>{$order->calc|escape}</td>
			</tr>
		{/if}
		
	</table>
</div>


<div id="total">
	<table>
		{if $order->discount>0}
		<tr>
			<th>{$tr->discount|escape}</th>
			<td>{$order->discount} %</td>
		</tr>
		{/if}
		{if $order->coupon_discount>0}
		<tr>
			<th>{$tr->coupon|escape}{if $order->coupon_code} ({$order->coupon_code}){/if}</th>
			<td>{$order->coupon_discount}&nbsp;{$currency->sign}</td>
		</tr>
		{/if}		
		{if $order->bonus_discount>0}
		<tr>
			<th>{$tr->used_points|escape}</th>
			<td>{$order->bonus_discount}&nbsp;{$currency->sign}</td>
		</tr>
		{/if}
		<tr>
			<th>{$tr->total_amount|escape}</th>
			<td class="total">{$order->total_price|convert}&nbsp;{$currency->sign}</td>
		</tr>
		{if !empty($payment_method)}
		<tr>
			<td colspan="2">{$tr->payment_method|escape}: {$payment_method->name}</td>
		</tr>
		<tr>
			<th>{$tr->for_payment|escape}</th>
			<td class="total">{$order->total_price|convert:$payment_method->currency_id}&nbsp;{$payment_currency->sign}</td>
		</tr>
		{/if}
	</table>
</div>

</body>
</html>

