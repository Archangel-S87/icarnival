<!-- incl. cart_informer -->
<!--noindex-->
	{if $cart->total_products>0}
		В корзине
		{$cart->purchases|count} {$cart->purchases|count|plural:'товар':'товаров':'товара'}
		{*{$cart->total_products} {$cart->total_products|plural:'товар':'товаров':'товара'}*}
		<br />на {$cart->total_price|convert} {$currency->sign|escape}
		{if !empty($cart->full_discount)}(-{$cart->full_discount}%){/if} 
	{else}
		<div class="empty_cart">Ваша корзина пуста</div>
	{/if}

	<div style="display:none">
		<div id="data">
			<div class="heading">
            В вашей корзине:
			</div>
			<div class="cartt_content">
			{if !empty($cart) && $cart->total_products>0}
				<table class="incart">
				  <tbody>
					{foreach from=$cart->purchases item=purchase}
						<tr {if $purchase->amount > 0}{else}style="display:none;"{/if}>
							<td class="fimage">
								<a href="products/{$purchase->product->url}">
									{if !empty($purchase->product->images)}
										{$image = $purchase->product->images|first}
										<img src="{$image->filename|resize:100:100}" alt="{$purchase->product->name|escape}">
									{else}
										<svg><use xlink:href='#no_photo' /></svg>
									{/if}
								</a>
							</td>
							<td class="name">
								<a href="products/{$purchase->product->url}">{$purchase->product->name|escape}</a>
								{if $purchase->variant->name}<div>{$purchase->variant->name|escape}</div>{/if}
							</td>
							<td class="price">
								{($purchase->variant->price)|convert} {$currency->sign}
							</td>
							<td class="amount">
								<form class="cartt" id="cart_{$purchase->variant->id}" method="post">
									<input type=hidden name=variant_id value='{$purchase->variant->id}'>
									&nbsp;&times;&nbsp; {$purchase->amount}
									{*<select class="amounts" name="amount" onchange="$('#cart_{$purchase->variant->id}').submit();">
										{section name=amounts start=1 loop=$purchase->variant->stock+1 step=1}
										<option value="{$smarty.section.amounts.index-$purchase->amount}" {if $purchase->amount==$smarty.section.amounts.index}selected{/if}>{$smarty.section.amounts.index}</option>
										{/section}
									</select>*}
									<span class="cart_unit"> {if $purchase->variant->unit}{$purchase->variant->unit}{else}{$settings->units}{/if}</span>
									<input type="submit" style="display:none;" />
								</form>
							</td>
							<td class="amount_sign">&nbsp;=&nbsp;</td>
							<td class="totalb" id="amount_{$purchase->variant->id}">
								{($purchase->variant->price*$purchase->amount)|convert}&nbsp;{$currency->sign}
							</td>

							<td class="remove">
								<form class="cart_mini" method="get">
									<input type=hidden name=variant_id value='{$purchase->variant->id}'>
									<input type="submit" class="remove_cart" />
								</form>
							</td>
					   </tr>
					{/foreach}
					</tbody>
				</table>
            
                <div class="ftotal">
                	Итого товаров на {$cart->total_price|convert} {$currency->sign|escape} 
				
					{if !empty($cart->full_discount)}(скидка {$cart->full_discount}%){/if} 

					{if $cart->total_price < $settings->minorder}<span class="minorder_inf">Минимальная сумма заказа <strong>{$settings->minorder|convert} {$currency->sign}</strong><br/> Чтобы оформить заказ Вам нужно <a href="javascript:$.fancybox.close();">добавить в корзину еще товаров!</a></span>{/if}
                </div>
				<div class="checkout">
					<div class="button fleft" onClick="$.fancybox.close();">Продолжить покупки</div>
					<div class="button fright" onClick="window.location='/cart'"><span>Редактировать{if $cart->total_price < $settings->minorder} заказ</span>{else} </span>/ <span class="cartt_chekout">оформить заказ</span>{/if}</div>
				</div>
			{else}
				<span id="cart_total">Ваша корзина пуста</span>

				<div class="checkout">
					<div style="float: none;" class="button" onClick="$.fancybox.close();">Продолжить покупки</div>
				</div>
			{/if}
			</div>
       
		</div>
	</div>
<!--/noindex-->
<!-- incl. cart_informer @ -->
