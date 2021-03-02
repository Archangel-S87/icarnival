{* Страница заказа *}
{$meta_title = "Ваш заказ №`$order->id`" scope=root}
{$page_name = "Заказ №`$order->id`" scope=root}

<h1>Ваш заказ №{$order->id} 
{if $order->status == 0}ждет обработки
{elseif $order->status == 4}в обработке
{elseif $order->status == 1}выполняется
{elseif $order->status == 2}выполнен
{elseif $order->status == 3}отменен
{elseif $order->status == 5}в пути
{/if}
{if $order->paid == 1}, оплата поступила{/if}
</h1>

{* Не даем оплачивать пока не разрешено *}
{api module=delivery method=get_deliveries var=deliveries enabled=1}
	{if !$order->paid && $order->status != 3}
		{* Выбор способа оплаты *}
		{if $payment_methods && !isset($payment_method) && $order->total_price>0}
			<div class="cart-blue">
				<span class="whitecube">3</span><h2>Выберите способ оплаты</h2>
			</div>

			<form id="orderform" method="post">
			<ul id="deliveries">
				{foreach $payment_methods as $payment_method}
					<li>
						<div class="checkbox">
							<input type=radio name=payment_method_id value='{$payment_method->id}' {if $payment_method@first}checked{/if} id=payment_{$payment_method->id}>
						</div>			
						<span class="delivery-header"><label for=payment_{$payment_method->id}>	{$payment_method->name}, к оплате {$order->total_price|convert:$payment_method->currency_id}&nbsp;{if isset($all_currencies[$payment_method->currency_id]->sign)}{$all_currencies[$payment_method->currency_id]->sign}{/if}</label></span>{if $payment_method->description}<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">подробнее</a>{/if}
						<div class="description" id="hideCont">
						{$payment_method->description}
						</div>
					</li>
				{/foreach}
			</ul>
			<input type='submit' class="button" value='Подтвердить выбор' style="margin-bottom:15px;">
			</form>
			{$payment_control = 0}
		{elseif !empty($payment_method)}
			{* Выбраный способ оплаты *}
			<h2>Способ оплаты: {$payment_method->name}
			<form id="paymentform" method=post><input type=submit id="reset_payment" class="button" name='reset_payment_method' value='Выбрать другой способ оплаты'></form>	
			</h2>
			{*<p>
			{$payment_method->description}
			</p>*}
			{if empty($settings->payment_control) || 
					( $settings->payment_control==1 && in_array($order->status, array(1,2)) ) ||
					( $settings->payment_control==2 && (empty($deliveries|count) || !empty($delivery)) )
				}
				{$payment_control = 1}
				<h2>
				К оплате: {$order->total_price|convert:$payment_method->currency_id}&nbsp;{if isset($all_currencies[$payment_method->currency_id]->sign)}{$all_currencies[$payment_method->currency_id]->sign}{/if}
				</h2>

				{* Форма оплаты, генерируется модулем оплаты *}
				{checkout_form order_id=$order->id module=$payment_method->module}
			{/if}
		{/if}	
	{/if}


<div class="page-pg">
	<div class="attention" style="display:table;clear:both;width:300px;text-align:center;padding:15px 15px 8px 15px;margin: 20px auto 20px auto">
		<p style="font-size:16px;text-transform:uppercase;">Спасибо за заказ!</p>
		{if empty($order->paid) && $order->status != 3}
			<div style="width:600px;padding-top:5px;">
				{if !empty($payment_control)}
					<p>Если вы выбрали вариант онлайн-оплаты, то произведите ее на этой странице.</p>
				{/if}	
				<p>С вами в ближайшее время свяжется наш менеджер.</p>
			</div>
		{/if}
	</div>
</div>

<h2 style="text-transform:uppercase;">Детали заказа:</h2>
{* Список покупок *}
<table id="purchases1">

	<tr id="carttitles">
		<td class="image" style="border-radius: 5px 0 0 5px;">
		</td>
		<td class="name">
			Наименование		
		</td>
		<td class="price">
			Цена за шт.
		</td>
		<td class="amount">
			Кол-во
		</td>
		<td class="price" style="border-radius: 0 5px 5px 0;">
			Итого
		</td>
	</tr>

	{foreach $purchases as $purchase}
	<tr>
		{* Изображение товара *}
		<td class="image">
			{if !empty($purchase->product->images)}
				{$image = $purchase->product->images|first}
				<span class="purimage"><a href="products/{$purchase->product->url}"><img src="{$image->filename|resize:100:100}" alt="{$purchase->product->name|escape}"></a></span>
			{else}
				<span class="purimage"><a href="products/{$purchase->product->url}"><svg class="nophoto"><use xlink:href='#no_photo' /></a></span>
			{/if}
		</td>
	
		{* Название товара *}
		<td class="name">
			<a href="products/{$purchase->product->url}">{$purchase->product_name|escape}</a>
			{$purchase->variant_name|escape}
			{if $order->paid && $purchase->variant->attachment}
				<a class="download_attachment" href="order/{$order->url}/{$purchase->variant->attachment}">скачать файл</a>
			{/if}
		</td>

		{* Цена за единицу *}
		<td class="price">
			{($purchase->price)|convert}&nbsp;{$currency->sign}
		</td>

		{* Количество *}
		<td class="amount">
			&times; {$purchase->amount}&nbsp;{if $purchase->unit}{$purchase->unit}{else}{$settings->units}{/if}
		</td>

		{* Цена *}
		<td class="price">
			{($purchase->price*$purchase->amount)|convert}&nbsp;{$currency->sign}
		</td>
	</tr>
	{/foreach}
	{* Скидка, если есть *}
	{if $order->discount > 0}
	<tr id="discount" style="height: 30px; background:none;">
		<th class="image"></th>
		<th class="name" style="font-size: 14px; font-weight: 700;">Скидка</th>
		<th class="price1"></th>
		<th class="amount"></th>
		<th class="price" style="font-size: 14px; font-weight: 700;">
			{$order->discount}&nbsp;%
		</th>
	</tr>
	{/if}
	{* Купон, если есть *}
	{if $order->coupon_discount > 0}
	<tr id="discount" style="height: 30px; background:none;">
		<th class="image"></th>
		<th class="name" style="font-size: 14px; font-weight: 700;">Купон</th>
		<th class="price1"></th>
		<th class="amount"></th>
		<th class="price" style="font-size: 14px; font-weight: 700;">
			&minus;{$order->coupon_discount|convert}&nbsp;{$currency->sign}
		</th>
	</tr>
	{/if}
	{* Если стоимость доставки входит в сумму заказа *}
	{if $delivery && !$order->separate_delivery}
	<tr id="discount" style="height: 30px;">
		<th class="image"></th>
		<th class="name" style="font-size: 14px; font-weight: 700;">
			<p>Доставка: {$delivery->name|escape}</p>
			{*{if $total_weight>0}
			<p style="font-size: 13px; font-weight: 400;">Общий вес: {$total_weight}&nbsp;кг.</p> 
			{/if}  
			{if $total_volume>0}
			<p style="font-size: 13px; font-weight: 400;">Общий объем: {$total_volume}&nbsp;куб.м.</p>
			{/if} *}
		</th>
		<th class="price1"></th>
		<th class="amount"></th>
		<th class="price" style="font-size: 14px; font-weight: 700;">
			{if $order->delivery_price > 0}
				{$order->delivery_price|convert}&nbsp;{$currency->sign}
			{else}
				бесплатно
			{/if}
		</th>
	</tr>
	{/if}
	{* Итого *}
	<tr id="discount" style="height: 35px;">
		<th class="image"></th>
		<th class="name">Итого</th>
		<th class="price1"></th>
		<th class="amount"></th>
		<th class="price">
			{$order->total_price|convert}&nbsp;{$currency->sign}
		</th>
	</tr>

	{* Если стоимость доставки не входит в сумму заказа *}
	{if $order->separate_delivery}
	<tr style="height: 35px;">
		<td class="image"></td>
		<td class="name">Доставка: {$delivery->name|escape} (оплачивается отдельно)</td>
		<td class="price1"></td>
		<td class="amount"></td>
		<td class="price">
			{$order->delivery_price|convert}&nbsp;{$currency->sign}
		</td>
	</tr>
	{/if}
</table>

<div class="separator" style="width:100%;">
	<div class="order-details">
		{* Детали заказа *}
		<table class="order_info">
			<tr>
				<td>Дата заказа</td>
				<td>
					{$order->date|date} в
					{$order->date|time}
				</td>
			</tr>
			{if $order->name}
			<tr>
				<td>Имя</td>
				<td>
					{$order->name|escape}
				</td>
			</tr>
			{/if}
			{if $order->email}
			<tr>
				<td>Email</td>
				<td>
					{$order->email|escape}
				</td>
			</tr>
			{/if}
			{if $order->phone}
			<tr>
				<td>Телефон</td>
				<td>{$order->phone|escape}</td>
			</tr>
			{/if}
			{if $order->address}
			<tr>
				<td>Адрес</td>
				<td>
					{$order->address|escape}
				</td>
			</tr>
			{/if}
			{if $order->comment}
			<tr>
				<td>Комментарий</td>
				<td>
					{$order->comment|escape|nl2br}
				</td>
			</tr>
			{/if}
			{if $order->calc}
			<tr>
				<td>Данные по доставке</td>
				<td>{$order->calc|escape}</td>
			</tr>
			{/if}
			{if $order->track}
			<tr>
				<td>Трек-код</td>
				<td>
					{$order->track|escape}
				</td>
			</tr>
			{/if}
		</table>
	</div>

	{if $cms_files}
		{* Загруженные файлы *}
		<div class="attached">
			<h2>Прикрепленные файлы:</h2>
			<ul class="stars">
				{foreach $cms_files as $file}
					<li><a href="{$config->cms_files_dir}{$file->filename}">{if $file->name}{$file->name}{else}{$file->filename}{/if}</a></li>
				{/foreach}
			</ul>
		</div>
		{* Загруженные файлы end *}
	{/if}
</div>


