{$meta_title = "Избранное" scope=root}
{$page_name = "Избранное" scope=root}

{if $wished_products|count}
	<ul id="wished" class="tiny_products">
		{foreach $wished_products as $product}
		<li class="product">
			<div class="image" onclick="window.location='products/{$product->url}'">
				{if !empty($product->image)}
					<img src="{$product->image->filename|resize:300:300}" />
				{else}
					<svg class="nophoto"><use xlink:href='#no_photo' /></svg>
				{/if}
			</div>
		
			<div class="product_info separator">
				<a class="wish-remove" href="wishlist/remove/{$product->id}">
					<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
						<path d="M0 0h24v24H0z" fill="none"/>
						<path d="M14.59 8L12 10.59 9.41 8 8 9.41 10.59 12 8 14.59 9.41 16 12 13.41 14.59 16 16 14.59 13.41 12 16 9.41 14.59 8zM12 2C6.47 2 2 6.47 2 12s4.47 10 10 10 10-4.47 10-10S17.53 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/>
					</svg>
				</a>
				<h3><a href="products/{$product->url}">{$product->name|escape}</a></h3>
			</div>
		</li>
		{/foreach}
	</ul>
	<div class="separator" style="height:60px; padding:15px;">
		{literal}
			<a name="#" onclick="if (document.referrer) {location.href=document.referrer} else {history.go(-1)}" class="buttonblue">Вернуться</a>
		{/literal}
	</div>
{else}
	<div class="page-pg">
		<h2>Сейчас список избранного пуст</h2>
	</div>
	<div class="have-no separator">
		<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
			<path d="M0 0h24v24H0z" fill="none"/>
			<path d="M16.5 3c-1.74 0-3.41.81-4.5 2.09C10.91 3.81 9.24 3 7.5 3 4.42 3 2 5.42 2 8.5c0 3.78 3.4 6.86 8.55 11.54L12 21.35l1.45-1.32C18.6 15.36 22 12.28 22 8.5 22 5.42 19.58 3 16.5 3zm-4.4 15.55l-.1.1-.1-.1C7.14 14.24 4 11.39 4 8.5 4 6.5 5.5 5 7.5 5c1.54 0 3.04.99 3.57 2.36h1.87C13.46 5.99 14.96 5 16.5 5c2 0 3.5 1.5 3.5 3.5 0 2.89-3.14 5.74-7.9 10.05z"/>
		</svg>
	</div>
{/if}

<script>
	{literal}
	if (document.referrer) {history.replaceState(null, null, document.referrer)} else {history.replaceState(null, null, '/catalog')};
	{/literal}
</script>


