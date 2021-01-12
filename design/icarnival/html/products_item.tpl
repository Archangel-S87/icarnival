              <div class="product">
              <form class="variants" action="cart">
                {if !empty($product->featured)}<div class="product__badge-bg product__badge-bg--green">Хит</div>
                {elseif !empty($product->is_new)}<div class="product__badge-bg product__badge-bg--pink">Новинка</div>{/if}
                <div class="product__top">
                {*<span class="product__badge product__badge--pink">нет в наличии</span>*}
                {if !empty($product->variant->compare_price)}<span class="product__badge product__badge--purple">распродажа</span>{/if}
                <a class="product__thumb" href="products/{$product->url}">
		{if !empty($product->image)}
			<img loading="lazy" src="{$product->image->filename|resize:300:300}" alt="{$product->name|escape}" title="{$product->name|escape}"/>
		{else}
		<svg id="no_photo" viewBox="0 0 24 24"> <circle cx="12" cy="12" r="3.2"></circle> <path d="M9 2L7.17 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2h-3.17L15 2H9zm3 15c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5z"></path> <path d="M0 0h24v24H0z" fill="none"></path> </svg>
		{/if}
                </a>
                  <div class="product__content">
                  <a class="product__title" href="products/{$product->url}">{$product->name|escape}</a>
                  
                    <div class="row align-items-center no-gutters">
			{if $product->variants|count > 0}
			
				<div class="col-6">
				{if $product->vproperties}
					{$cntname1 = 0}	
					<span class="pricelist" style="display:none;">
						{foreach $product->variants as $v}
							<span class="c{$v->id}" data-unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}">{$v->price|convert}₽</span>
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
					<div>
						<select {if $cntname1 == 0}class="p0" style="display:none;"{else}class="p0 product__select showselect"{/if}>
							{foreach $product->vproperties[0] as $pname => $pclass}
								<option {if $cntname1 == 0}label="size"{/if} value="{$pclass}" class="{$pclass}">{$pname}</option>
							{/foreach}
						</select>
	
						<select {if $cntname2 == 0}class="p1" style="display:none;"{else}class="p1 product__select showselect"{/if}>
							{foreach $product->vproperties[1] as $pname => $pclass}
								<option value="{$pclass}" class="{$pclass}">{$pname}</option>
							{/foreach}
						</select>
	
						{if $cntname2 == 0 || $cntname1 == 0}
							{if !empty($smarty.cookies.view) && $smarty.cookies.view == 'table' && $mod == 'ProductsView'}<div style="display: table; height: 27px;"></div>{/if}
						{/if}
					</div>
				{else}
					<select name="variant" {if $product->variants|count==1 && !$product->variant->name}class="b1c_option product__select" style="display:none;"{else}class="b1c_option product__select showselect"{/if}>
						{foreach $product->variants as $v}
							<option value="{$v->id}" data-unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}" {if $v->compare_price > 0}data-cprice="{$v->compare_price|convert}"{/if} data-varprice="{$v->price|convert}">
										{$v->name}&nbsp;
							</option>
						{/foreach}
					</select>

				{/if}
				</div>
            <div class="col-6">
					<div class="price product__price align--right">
						<span class="compare_price">{if $product->variant->compare_price > 0}{$product->variant->compare_price|convert}{/if}</span>
						<span class="price">{$product->variant->price|convert}</span><span class="currency">₽{if $settings->b9manage}/<span class="unit">{if $product->variant->unit}{$product->variant->unit}{else}{$settings->units}{/if}</span>{/if}</span>
					</div>            
            
				
				</div>

			
			{else}
				<div class="notinstocksep" style="display: table;">Нет в наличии</div>

			{/if}                    
                    </div>
                    
                  </div>
                </div>
                <div class="product__footer">
                  <div class="row align-items-center justify-content-between row--x-indent-5">
                    <div class="col-md-7 col-8">
						  {if $product->variants|count > 0}
                    <button class="btn btn--size-md btn--border-pink txt--upperacse is--active" {if $settings->trigger_id}onmousedown="try { rrApi.addToBasket({$product->variant->id}) } catch(e) {}"{/if} type="submit"><span class="btn__icon"><i class="icon-shopping-cart"></i></span><span>В Корзину</span></button>
                    {/if}
                    </div>
                    <div class="col-md-5 col-4">
                      <div class="row row--x-indent-5 justify-content-end row--y-indent-4">
                        <div class="col-item"><a class="jsRefresProductSlider product__action product__action--green product__action--size-24" href="#ex1" data-id="{$product->id}" rel="modal:open"><i class="icon-info"></i></a></div>
                        <div class="col-item"><a class="product__action product__action--orange tooltipe tooltipe--full" href="" data-tooltip="Сравнить товар"><i class="icon-analytics"></i></a></div>
                      </div>
                    </div>
                  </div>
                </div>
                </form>
              </div>
{* 
<div class="product">
	<div class="labelsblock">
		{if !empty($product->featured)}<div class="hit">Хит</div>{/if}
		{if !empty($product->is_new)}<div class="new">Новинка</div>{/if}
		{if !empty($product->variant->compare_price)}<div class="lowprice">- {100-($product->variant->price*100/$product->variant->compare_price)|round}%</div>{/if}
	</div>
	<div class="image" onclick="window.location='/products/{$product->url}'" {if !empty($product->images[1]->filename)}
				onmouseover="$(this).find('img').attr('src', '{$product->images[1]->filename|resize:300:300}');"
				onmouseout="$(this).find('img').attr('src', '{$product->image->filename|resize:300:300}');"
			{/if}>
		{if !empty($product->image)}
			<img loading="lazy" src="{$product->image->filename|resize:300:300}" alt="{$product->name|escape}" title="{$product->name|escape}"/>
		{else}
			<svg><use xlink:href='#no_photo' /></svg>
		{/if}
	</div>
	<div class="product_info product_item">
		<h3 class="product_title"><a title="{$product->name|escape}" data-product="{$product->id}" href="products/{$product->url}">{$product->name|escape}</a></h3>
		{if !empty($smarty.cookies.view) && $smarty.cookies.view == 'table' && $mod == 'ProductsView'}
			<div class="annotation">
				{if $product->brand}<div class="table_brand">Производитель: <span class="bluelink" onclick="window.location='/brands/{$product->brand_url}'">{$product->brand}</span></div>{/if}
				<div class="table_body">{$product->annotation}</div>
				{if $product->options}
				<div class="features">
					{foreach $product->options as $f}
						<p>{$f->name} : {$f->value}</p>
					{/foreach}
				</div>
				{/if}
			</div>
		{/if}
		<div {if !empty($smarty.cookies.view) && $smarty.cookies.view == 'table' && $mod == 'ProductsView'}id="prod_right"{/if}>
			{if isset($product->rating) && $product->rating|floatval > 0}
				{$prod_rating = $product->rating}
			{else}
				{$prod_rating = $settings->prods_rating|floatval}
			{/if}
			<div class="ratecomp">
				<div class="catrater">
					<div class="statVal">
						<span class="rater_sm">
							<span class="rater-starsOff_sm" style="width:60px;">
								<span class="rater-starsOn_sm" style="width:{$prod_rating*60/5|string_format:'%.0f'}px"></span>
							</span>
						</span>
					</div>
				</div>
			</div>
			{if $product->variants|count > 0}
			<form class="variants" action="/cart">
				{if $product->vproperties}
					{$cntname1 = 0}	
					<span class="pricelist" style="display:none;">
						{foreach $product->variants as $v}
							<span class="c{$v->id}" data-unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}">{$v->price|convert}</span>
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
					<div>
						<select {if $cntname1 == 0}class="p0" style="display:none;"{else}class="p0 showselect"{/if}>
							{foreach $product->vproperties[0] as $pname => $pclass}
								<option {if $cntname1 == 0}label="size"{/if} value="{$pclass}" class="{$pclass}">{$pname}</option>
							{/foreach}
						</select>
	
						<select {if $cntname2 == 0}class="p1" style="display:none;"{else}class="p1 showselect"{/if}>
							{foreach $product->vproperties[1] as $pname => $pclass}
								<option value="{$pclass}" class="{$pclass}">{$pname}</option>
							{/foreach}
						</select>
	
						{if $cntname2 == 0 || $cntname1 == 0}
							{if !empty($smarty.cookies.view) && $smarty.cookies.view == 'table' && $mod == 'ProductsView'}<div style="display: table; height: 27px;"></div>{/if}
						{/if}
					</div>
				{else}
					{if $product->variants|count==1 && !$product->variant->name && !empty($smarty.cookies.view) && $smarty.cookies.view == 'table' && $mod == 'ProductsView'}
						<span class="varspacer" style="display: block; height:55px;"></span>
					{/if}
					<select name="variant" {if $product->variants|count==1 && !$product->variant->name}class="b1c_option" style="display:none;"{else}class="b1c_option showselect"{/if}>
						{foreach $product->variants as $v}
							<option value="{$v->id}" data-unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}" {if $v->compare_price > 0}data-cprice="{$v->compare_price|convert}"{/if} data-varprice="{$v->price|convert}">
										{$v->name}&nbsp;
							</option>
						{/foreach}
					</select>
					<div class="price">
						<span class="amountwrapper"><input type="number" name="amount" value="1" autocomplete="off">&nbsp;x&nbsp;</span>
						<span class="compare_price">{if $product->variant->compare_price > 0}{$product->variant->compare_price|convert}{/if}</span>
						<span class="price">{$product->variant->price|convert}</span>
						<span class="currency">{$currency->sign|escape}{if $settings->b9manage}/<span class="unit">{if $product->variant->unit}{$product->variant->unit}{else}{$settings->units}{/if}</span>{/if}</span>
					</div>
				{/if}
				<input {if $settings->trigger_id}onmousedown="try { rrApi.addToBasket({$product->variant->id}) } catch(e) {}"{/if} type="submit" class="buttonred" value="в корзину" data-result-text="добавлено"/>
				
				{include file='wishcomp.tpl'}
			</form>
			{else}
				<div class="notinstocksep" style="display: table;">Нет в наличии</div>
				{include file='wishcomp.tpl'}
			{/if}
		</div>
	</div>
</div>
*}