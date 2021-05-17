<div class="del_pay_prod_tab">
	{* Доставка *}
	{api module=delivery method=get_deliveries enabled=1 var=deliveries}
	{if !empty($deliveries)}
		{$total_weight = $product->features[1]->value / 1000}
		{$total_volume = $product->features[2]->value}
		{$total_price = $product->variant->price}
		{if empty($total_weight)}
			{$total_weight = $settings->min_weight}
		{/if}
		{if empty($total_volume)}
			{$total_volume = $settings->min_volume}
		{/if}
		{* Вес *}
		{if !empty($total_weight)}
		<p style="display:none;margin-top: 15px;">Общий вес:
			<span id="ems-total-weight">{$total_weight}</span>&nbsp;кг.
		</p>
		{/if} 
		{* Вес @ *}
		{* Объем *}
		{if !empty($total_volume)}
		<p style="display:none;margin-top: 15px;">Общий объем:
			<span id="total-volume">{$total_volume}</span>&nbsp;куб.м
		</p>
		{$volume=$total_volume}
		
		{* Calculate sides from volume in cm*}
		{math assign="side" equation="pow(vol*1000000, 1/3)" vol=$volume}
		<span id="cart-side" style="display: none;">{$side|round}</span>
		{* calculate sides from volume end *}
		{/if}
		{* Объем @ *}
		
		{* Rate / Пересчет в текущий курс по базовой валюте *}
		<script>
		var curr_convert;
		{if $currency->rate_to == $currency->rate_from}
			curr_convert = 1;
		{else}
			curr_convert = {1/$currency->rate_to};
		{/if}
		</script>
		{* Rate @ *}
		<h3>ВАРИАНТЫ ДОСТАВКИ:</h3>
		<ul id="deliveries" class="deliveries stars">
		{foreach $deliveries as $delivery}

			{$additional_cost = 0}
			{if $delivery->additional_cost > 0}
				{$additional_cost = ($delivery->additional_cost|convert)}
			{/if}
			<li {if $delivery->price2 > 0}data-price="{$delivery->price|convert}" data-price2="{$delivery->price2|convert}"{/if} id="li_delivery_{$delivery->id}">
				<div class="deliverywrapper">
					<label for="deliveries_{$delivery->id}" {if $delivery->description || $delivery->id == 3 || $delivery->id == 4 ||$delivery->id == 114 || $delivery->id == 121 || $delivery->widget == 1}class="hideBtn" onclick="hideShow(this);$('#deliveries_{$delivery->id}').click();return false;"{/if}
						{if $delivery->id == 3}data-role="shiptor_widget_show"{/if}>
					<span class="delivery-header">
					{$delivery->name}

						{if $delivery->separate_payment}[оплачивается отдельно]{/if}

					(<span class="del_price" id="not-null-delivery-price-{$delivery->id}">
						{if $delivery->free_from > 0 && $cart->total_price >= $delivery->free_from}
							бесплатно</span>)
						{elseif (in_array($delivery->id, array(3,4,114,121)) || $delivery->widget == 1)}
							---</span>&nbsp;{$currency->sign})
						{elseif $delivery->price2 > 0 || $additional_cost > 0}
						{$temp_price = 0}
						{$temp_price = $temp_price + $delivery->price}
						{if $delivery->price2 > 0 && $cart->total_weight > 3}
							{$temp_price = $delivery->price + $delivery->price2 * ($cart->total_weight|ceil - 3)}
						{/if}
						{if $additional_cost > 0}
							{$temp_price = $temp_price + $additional_cost}
						{/if}
						{$temp_price|convert}</span>&nbsp;{$currency->sign})
						{else}
						{$delivery->price|convert}</span>&nbsp;{$currency->sign})
						{/if}
						</span>
					</label>
					
					<div class="description" id="hideCont">
						{$delivery->description}
			
						{if $delivery->id == 114}
							{include file='cdek.tpl'}
						{/if}
						{if $delivery->id == 121}
							{include file='boxberry.tpl'}
						{/if}
						{if $delivery->id == 3}
							{include file='shiptor.tpl'}
						{/if}
						{if $delivery->id == 4}
							{include file='postrf.tpl'}
						{/if}
					</div>
				</div>
			</li>
		{/foreach}
		</ul>
	{/if}	
	
	{api module=payment method=get_payment_methods enabled=1 var=payment_methods}
	{if !empty($payment_methods)}
		<h3>СПОСОБЫ ОПЛАТЫ:</h3>     
		<ul id="payments" class="stars">
		{foreach $payment_methods as $payment_method}
			<li>
				<div class="deliverywrapper">
					<label for="payment_{$payment_method->id}" {if $payment_method->description}class="hideBtn" onclick="hideShow(this);$('#payment_{$payment_method->id}').click();return false;"{/if}>
						<div class="delivery-header">{$payment_method->name}</div>
					</label>
					<div class="description" id="hideCont">{$payment_method->description}</div>
				</div>
			</li>
		{/foreach}
		</ul>
	{/if}
</div>	

<script>
	function hideShow(el){
		$(el).toggleClass('show').siblings('div#hideCont').slideToggle('fast');return false;
	};
</script>
<style>
	.del_pay_prod_tab ul#deliveries, .del_pay_prod_tab ul#payments { padding:0;margin-top:10px; }
	.del_pay_prod_tab .deliveryinfo_wrapper, .del_pay_prod_tab .deliveryinfo{ display:none; }
	.del_pay_prod_tab ul#deliveries > li, .del_pay_prod_tab ul#payments > li{ margin-bottom:5px; }
</style>
