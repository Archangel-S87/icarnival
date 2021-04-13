{if $order->paid}
{$subject = "Заказ №`$order->id` оплачен" scope=root}
{else}
{$subject = "Новый заказ №`$order->id`" scope=root}
{/if}
<h3 style="font-weight:700;font-family:arial;">
	<a href="{$config->root_url}/fivecms/index.php?module=OrderAdmin&id={$order->id}">ЗАКАЗ №{$order->id}</a>
</h3>
<table cellpadding="6" cellspacing="0" style="border-collapse: collapse;">
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			Статус заказа
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{if $order->status == 0}
				ждет обработки     
			{elseif $order->status == 4}
				в обработке  
			{elseif $order->status == 1}
				выполняется
			{elseif $order->status == 2}
				выполнен
			{elseif $order->status == 3}
				отменен
			{/if}
		</td>
	</tr>
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			Оплата
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{if $order->paid == 1}
			<font color="green">оплачен</font>
			{else}
			еще не оплачен
			{/if}
		</td>
	</tr>
	{if $order->name}
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			Имя
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->name|escape}
			{if $order->user_id}(<a href="{$config->root_url}/fivecms/index.php?module=UserAdmin&id={$order->user_id}">зарегистрированный пользователь</a>){/if}
		</td>
	</tr>
	{/if}
	{if $order->email}
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			Email
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->email|escape}
		</td>
	</tr>
	{/if}
	{if $order->phone}
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			Телефон
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->phone|escape}
		</td>
	</tr>
	{/if}
	{if $order->address}
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			Адрес доставки
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->address|escape}
		</td>
	</tr>
	{/if}
	{if $order->calc}
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			Комментарий по доставке
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->calc|escape}
		</td>
	</tr>
	{/if}
	{if $order->comment}
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			Комментарий
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->comment|escape|nl2br}
		</td>
	</tr>
	{/if}
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			Дата
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->date|date} {$order->date|time}
		</td>
	</tr>
</table>

<h3 style="font-weight:normal;font-family:arial;">Покупатель заказал:</h3>

<table cellpadding="5" cellspacing="0" style="border-collapse: collapse;">
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;"></td>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">Товар</td>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">Цена</td>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">Артикул</td>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">Поставщик</td>
	</tr>
	{foreach name=purchases from=$purchases item=purchase}
	<tr>
		<td align="center" style="padding:6px; border:1px solid #e0e0e0;font-family:arial;">
			{$image = $purchase->product->images[0]}
			{if !empty($image)}
			<img style="max-width:50px; max-height:50px;" border="0" src="{$image->filename|resize:100:100}">
			{/if}
		</td>
		<td style="padding:6px; border:1px solid #e0e0e0;font-family:arial;">
			<a href="{$config->root_url}/products/{$purchase->product->url}">{$purchase->product_name|escape}</a>
			{$purchase->variant_name|escape}
		</td>
		<td style="padding:6px; border:1px solid #e0e0e0;font-family:arial;white-space:nowrap;">
			{$purchase->price|convert:$main_currency->id}&nbsp;{$main_currency->sign} &times; {$purchase->amount} {if $purchase->unit}{$purchase->unit|escape}{else}{$settings->units|escape}{/if}
		</td>
		<td style="padding:6px; border:1px solid #e0e0e0;font-family:arial;">
			{if !empty($purchase->variant->sku)}{$purchase->variant->sku}{/if}
		</td>
		<td style="padding:6px; border:1px solid #e0e0e0;font-family:arial;">
			{if !empty($purchase->brand)}<a href="{$config->root_url}/brands/{$purchase->brand->url}">{$purchase->brand->name|escape}</a>{/if}
		</td>
	</tr>
	{/foreach}
</table>

<table cellpadding="2" cellspacing="0" style="margin-top:25px;border-collapse: collapse;">	
	{if $order->discount>0}
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			Скидка
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->discount}&nbsp;%
		</td>
	</tr>
	{/if}

	{if $order->coupon_discount>0}
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			Купон {$order->coupon_code}
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			&minus;{$order->coupon_discount|convert:$main_currency->id}&nbsp;{$main_currency->sign}
		</td>
	</tr>
	{/if}

	{if !empty($delivery)}
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			{$delivery->name|escape}{if $order->separate_delivery} (оплачивается отдельно){/if}
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->delivery_price|convert:$main_currency->id}&nbsp;{$main_currency->sign}
		</td>
	</tr>
	{/if}

	{if !empty($payment_method)}
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;">
			Способ оплаты
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$payment_method->name|escape}
		</td>
	</tr>
	{/if}
	
	{*<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;font-weight:bold;">
			Итого
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;font-weight:bold;">
			{$order->total_price|convert:$main_currency->id}&nbsp;{$main_currency->sign}
		</td>
	</tr>*}
	
	<tr>
		<td style="padding:6px; background-color:#f4f4f4; border:1px solid #e0e0e0;font-family:arial;font-weight:bold;">
			{if empty($order->paid)}Итого к оплате{else}Итого{/if}
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;font-weight:bold;">
			{$order->total_price|convert:$payment_method->currency_id}&nbsp;{if isset($all_currencies[$payment_method->currency_id]->sign)}{$all_currencies[$payment_method->currency_id]->sign}{/if}
		</td>
	</tr>
	
</table>

<br>
Страница заказа на сайте:<br>
<a href="{$config->root_url}/order/{$order->url}">{$config->root_url}/order/{$order->url}</a>
<br>