<li class="product {if !empty($settings->show_cart_wishcomp)}visible_button{/if}">
	<div class="labelsblock">
		{if !empty($product->featured)}
			<svg class="hit"><use xlink:href='#hit' /></svg>
		{/if}
		{if !empty($product->is_new)}
			<svg class="new"><use xlink:href='#new' /></svg>
		{/if}
		{if !empty($product->variant->compare_price)}
			<svg class="lowprice"><use xlink:href='#lowprice' /></svg>
		{/if}
	</div>
	<div class="image" onclick="window.location='products/{$product->url}'">
		{if !empty($product->image)}
			<img loading="lazy" alt="{$product->name|escape}" title="{$product->name|escape}" class="lazy" src="{$product->image->filename|resize:300:300}" />
		{else}
			<svg class="nophoto"><use xlink:href='#no_photo' /></svg>
		{/if}
	</div>

	<div class="product_info separator">
		<h3><a href="products/{$product->url}">{$product->name|escape}</a></h3>

		{* rating *}
		{if isset($product->rating) && $product->rating > 0}
			{$prod_rating = $product->rating}
		{else}
			{$prod_rating = $settings->prods_rating|floatval}
		{/if}
		<div class="ratecomp" id="product_{$product->id}">
			<div class="statVal catrater">
				<span class="rater_sm">
					<span class="rater-starsOff_sm" style="width:60px;">
						<span class="rater-starsOn_sm" style="width:{$prod_rating*60/5|string_format:"%.0f"}px"></span>
					</span>
				</span>
			</div>
		</div>
		{* rating (The End) *}
			
		{if !empty($product->variants) && $product->variants|count > 0}
			<form class="variants" action="/cart">
				{if $product->vproperties}
					{$cntname1 = 0}	
					<span class="pricelist" style="display:none;">
						{foreach $product->variants as $v}
							<span class="c{$v->id}" v_unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}">{$v->price|convert}</span>
							{if $v->name1}{$cntname1 = 1}{/if}
						{/foreach}
					</span>
			
					{$cntname2 = 0}
					<span class="pricelist2" style="display:none;">
						{foreach $product->variants as $v}
							{if $v->compare_price > 0}<span class="c{$v->id}">{$v->compare_price|convert}</span>{/if}
							{if $v->name2}{$cntname2 = 1}{/if}
						{/foreach}
					</span>
					
					<input class="vhidden" name="variant" value="" type="hidden"  />
					
					<div style="display: table; margin-bottom: 5px; height: 20px;">
						<select class="p0"{if $cntname1 == 0} style="display:none;"{/if}>
							{foreach $product->vproperties[0] as $pname => $pclass}
								<option value="{$pclass}" class="{$pclass}">{$pname}</option>
							{/foreach}
						</select>
						<select class="p1"{if $cntname2 == 0} style="display:none;"{/if}>
							{foreach $product->vproperties[1] as $pname => $pclass}
								<span><option value="{$pclass}" class="{$pclass}">{$pname}</option></span>
							{/foreach}
						</select>
					</div>
					<div class="pricecolor">
						{if !empty($settings->show_cart_wishcomp)}
							<span class="amount_wrap"><input type="number" min="1" size="2" name="amount" value="1">&nbsp;x&nbsp;</span>
						{/if}
						<span ID="priceold" class="compare_price"></span> <span ID="price" class="price"></span> <span class="currency">{$currency->sign|escape}{if $settings->b9manage}/<span class="unit">{if $product->variant->unit}{$product->variant->unit}{else}{$settings->units}{/if}</span>{/if}</span>
					</div>
				{else}
					{if $product->variants|count==1  && !$product->variant->name}
						<span style="display: block; height: 20px;"></span>
					{/if}

					<select class="b1c_option" name="variant" {if $product->variants|count==1  && !$product->variant->name}style='display:none;'{/if}>
						{foreach $product->variants as $v}
							<option value="{$v->id}" v_unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}" {if $v->compare_price > 0}compare_price="{$v->compare_price|convert}"{/if} price="{$v->price|convert}" click="{$v->name}">
								{$v->name}
							</option>
						{/foreach}
					</select>
										
					<div class="price">
						{if !empty($settings->show_cart_wishcomp)}
							<span class="amount_wrap">
								<input size="2" name="amount" min="1" type="number" value="1">&nbsp;x&nbsp;
							</span>
						{/if}
						{if $product->variant->compare_price > 0}
							<span class="compare_price">{$product->variant->compare_price|convert}</span>
						{/if}
						<span class="price">{$product->variant->price|convert}</span>
						<span class="currency">{$currency->sign|escape}{if $settings->b9manage}/<span class="unit">{if $product->variant->unit}{$product->variant->unit}{else}{$settings->units}{/if}</span>{/if}</span>
					</div>
				{/if}
				{if !empty($settings->show_cart_wishcomp)}
					<div class="sub_wishcomp_wrap">
						<input {if !empty($product->ref_url)}onClick="window.open('{$product->ref_url|escape}', '_blank');return false;"{/if} type="submit" class="buttonred" value="{$settings->to_cart_name|escape}" data-result-text="добавлено"/>
						{include file='wishcomp.tpl'}
					</div>
				{/if}
			</form>
		{else}
			<div style="display: table; margin-top: 15px; margin-bottom: 15px;">Нет в наличии</div>
			{if !empty($settings->show_cart_wishcomp)}
				{include file='wishcomp.tpl'}
			{/if}
		{/if}
	</div>
</li>