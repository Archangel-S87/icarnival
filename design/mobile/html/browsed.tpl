{$meta_title = "Просмотренные товары" scope=root}
{$page_name = "Просмотренные товары" scope=root}
{get_browsed_products var=browsed_products limit=200}
{if !empty($browsed_products)}
	<ul id="wished" class="tiny_products">
		{foreach $browsed_products as $browsed_product}
		 <li class="product">
			<div class="image" onclick="window.location='products/{$browsed_product->url}'">
			{if !empty($browsed_product->image)}
				<img src="{$browsed_product->image->filename|resize:300:300}" />
			{else}
				<svg class="nophoto"><use xlink:href='#no_photo' /></svg>
			{/if}
			</div>
		
			<div class="product_info separator">
			<h3><a href="products/{$browsed_product->url}">{$browsed_product->name|escape}</a></h3>
			</div>
		</li>
		{/foreach}
	</ul>
	<div class="separator" style="height:60px; padding:15px;">
		{literal}
			<a name="#" onclick="if (document.referrer) { location.href=document.referrer } else { history.go(-1) }" class="buttonblue">Вернуться</a>
		{/literal}
	</div>
{else}
	<div class="page-pg">
		<h2>Список пуст</h2>
	</div>
	<div class="have-no separator">
		<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
			<path d="M0 0h24v24H0z" fill="none"/>
			<path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
		</svg>
	</div>
{/if}
