{$meta_title = "Избранное" scope=root}
{$page_name = "Избранное" scope=root}
<h1>Избранное</h1>

{if $wished_products|count}
	<div class="tiny_products relcontent">
		{foreach $wished_products as $product}
			<div class="product">
				<div class="image">
					<a class="wishlist_delete" href="wishlist/remove/{$product->id}"><img src="files/delete.png"></a>
					{if !empty($product->image)}
						<a href="products/{$product->url}" title="{$product->name|escape}"><img src="{$product->image->filename|resize:300:300}" alt="{$product->name|escape}" title="{$product->name|escape}" /></a>
					{else}
						<a href="products/{$product->url}" title="{$product->name|escape}"><svg class="nophoto"><use xlink:href='#no_photo' /></svg></a>
					{/if}
				</div>
				<div class="product_info">
					<h3 class="product_title"><a style="display: table;" data-product="{$product->id}" href="products/{$product->url}">{$product->name|escape}</a></h3>
				</div>
			</div>
		{/foreach}
	</div>
{else}
	<p>Сейчас список избранного пуст</p>
{/if}