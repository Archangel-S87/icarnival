{* available sort (or remove): position, name, date, rating, rand *}
{* from same category (or remove): category_id=$category->id *}
{if !empty($category->id)}
	{get_products var=is_new_products category_id=$category->id is_new=1 sort=rand limit=5}
	{if empty($is_new_products)}
		{get_products var=is_new_products is_new=1 sort=rand limit=5}
	{/if}
{else}
	{get_products var=is_new_products is_new=1 sort=rand limit=5}
{/if}
{if !empty($is_new_products)}
<!-- incl. mnew -->
	<div class="box-heading">Новые поступления</div>
	<div class="box-content">
		<div class="box-product">
			<div id="mnew">
				<ul id="last_products">
					{foreach $is_new_products as $product name=product}
					<li>
						<div class="image">
							<a href="products/{$product->url}" class="anewimg" title="{$product->name|escape}">
								{if !empty($product->image)}
									<img src="{$product->image->filename|resize:100:100}" alt="{$product->name|escape}" title="{$product->name|escape}" />
								{else}
									<svg><use xlink:href='#no_photo' /></svg>
								{/if}
							</a>
						</div>
						<div class="new_name"><a title="{$product->name|escape}" class='link_2' href="products/{$product->url}" data-product="{$product->id}">{$product->name|escape|truncate:50:"...":true}</a></div>
						{if $product->variant->price >0}<div class="price">{$product->variant->price|convert} {$currency->sign|escape}</div>{/if}
					</li>
					{/foreach}
				</ul>
			</div>
		</div>
	</div>
<!-- incl. mnew @ -->
{/if}
