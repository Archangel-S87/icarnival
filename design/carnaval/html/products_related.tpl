		<li class="product">
			<div onClick="window.location='/products/{$related_product->url}'" class="image" style="cursor:pointer;">
				{if !empty($related_product->image)}
					<a href="products/{$related_product->url}" title="{$related_product->name|escape}"><img loading="lazy" src="{$related_product->image->filename|resize:300:300}" alt="{$related_product->name|escape}" title="{$related_product->name|escape}" /></a>
				{else}
					<a href="products/{$related_product->url}" title="{$related_product->name|escape}"><svg><use xlink:href='#no_photo' /></svg></a>
				{/if}
			</div>

			<div class="product_info">
				<h3 class="product_title"><a data-product="{$related_product->id}" href="products/{$related_product->url}" title="{$related_product->name|escape}">{$related_product->name|escape}</a></h3>
				{if isset($related_product->rating) && $related_product->rating > 0}
					{$related_rating = $related_product->rating}
				{else}
					{$related_rating = $settings->prods_rating|floatval}
				{/if}
				<div class="ratecomp">
					<div class="catrater">
						<div class="statVal">
							<span class="rater_sm">
								<span class="rater-starsOff_sm" style="width:60px;">
									<span class="rater-starsOn_sm" style="width:{$related_rating*60/5|string_format:"%.0f"}px"></span>
								</span>
							</span>
						</div>
					</div>
					<div style="float: right">
						{foreach $related_product->variants as $v}
							{if $v@first}
								<span class="price">{$v->price|convert} <span class="currency">{$currency->sign|escape}</span></span>
							{/if}
						{/foreach}
					</div>
				</div>
			</div>
		</li>