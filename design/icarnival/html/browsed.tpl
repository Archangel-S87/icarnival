{$meta_title = "Просмотренные товары" scope=root}
{$page_name = "Просмотренные товары" scope=root}
<h1>Вы просматривали</h1>

{get_browsed_products var=browsed_products limit=200}
{if !empty($browsed_products)}
	<ul class="relcontent tiny_products">
		{foreach $browsed_products as $browsed_product}
		<li class="product">
			<div onClick="window.location='/products/{$browsed_product->url}'" class="image" style="cursor:pointer;">
				{if !empty($browsed_product->image)}
					<a href="products/{$browsed_product->url}" title="{$browsed_product->name|escape}"><img src="{$browsed_product->image->filename|resize:300:300}" alt="{$browsed_product->name|escape}" title="{$browsed_product->name|escape}" /></a>
				{else}
					<a href="products/{$browsed_product->url}" title="{$browsed_product->name|escape}"><svg><use xlink:href='#no_photo' /></svg></a>
				{/if}
			</div>

			<div class="product_info">
				<h3 class="product_title"><a data-product="{$browsed_product->id}" href="products/{$browsed_product->url}" title="{$browsed_product->name|escape}">{$browsed_product->name|escape}</a></h3>
			</div>
		</li>
		{/foreach}
	</ul>
{else}
	<p>Список пуст</p>
{/if}
