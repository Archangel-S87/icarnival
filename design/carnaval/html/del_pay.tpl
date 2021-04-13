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
			<li {if $delivery->price2 > 0}data-price="{$delivery->price|convert}" data-price2="{$delivery->price2|convert}"{/if} id="li_delivery_{$delivery->id}">
				<div>
					<label for="deliveries_{$delivery->id}">
					<span class="delivery-header">
					{$delivery->name}
		
					{if $delivery->separate_payment}[оплачивается отдельно]{/if} 
		
					(<span class="del_price" id="not-null-delivery-price-{$delivery->id}">{if $delivery->free_from > 0 && $total_price >= $delivery->free_from}бесплатно</span>)
					{elseif (in_array($delivery->id, array(3,114,121)) || $delivery->widget == 1)}---</span>&nbsp;{$currency->sign})
					{elseif $delivery->price == 0 && $delivery->price2 == 0}бесплатно</span>)
					{else}{if $delivery->price2 > 0}{($delivery->price + ($delivery->price2 * $total_weight|ceil))|convert}{else}{$delivery->price|convert}{/if}</span>&nbsp;{$currency->sign}){/if}
					</span>
					</label>
					{if in_array($delivery->id, array(3,114,121)) || $delivery->widget == 1}
					<a class="hideBtn show_map" {if $delivery->id == 3}data-role="shiptor_widget_show"{/if} href="javascript://">выбрать на карте</a>
					{elseif $delivery->description}
					<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">подробнее</a>
					{/if}
					<div class="description" {if $delivery->id != 3 && $delivery->id != 114 && $delivery->id != 121 && $delivery->widget != 1}id="hideCont"{/if}>
			
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
				<div><label for="payment_{$payment_method->id}"><span class="delivery-header">{$payment_method->name}</span></label>
				{if $payment_method->description}<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">подробнее</a>
					<div class="description" id="hideCont">{$payment_method->description}</div>{/if}
				</div>
			</li>
		{/foreach}
		</ul>
	{/if}
</div>	

<script>
	function hideShow(el){
		$(el).toggleText('подробнее','свернуть').toggleClass('show').siblings('div#hideCont').slideToggle('normal');return false;
	};
</script>
<style>
	.del_pay_prod_tab #deliveries .description, .del_pay_prod_tab #payments .description { width:100%;margin-top:5px; }
	.del_pay_prod_tab ul#deliveries, .del_pay_prod_tab ul#payments { border:0;padding:0;margin-top:10px; }
	.del_pay_prod_tab .deliveryinfo_wrapper, .del_pay_prod_tab .deliveryinfo{ display:none; }
	.del_pay_prod_tab li { display:table; }
	.del_pay_prod_tab .delivery-header { padding:0 10px 0 0; }
	#content .del_pay_prod_tab .hideBtn { margin-bottom:0; }
	.del_pay_prod_tab h3 { font-size:17px; }
</style>
