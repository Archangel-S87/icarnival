{if $products|count>0}
<!-- incl. product_filter -->
<div class="product-filter">
   <div class="sort"><span>Сортировать по:</span>
		<select onchange="direct_pagination(this.value);" class="selectPrductSort inputbox">
			<option value="{url sort=position page=null}" {if $sort=='position'}selected{/if}>порядку</option>
			<option value="{url sort=priceup page=null}" {if $sort=='priceup'}selected{/if}>цене &#8593;</option>
			<option value="{url sort=pricedown page=null}" {if $sort=='pricedown'}selected{/if}>цене &#8595;</option>
			<option value="{url sort=name page=null}" {if $sort=='name'}selected{/if}>названию</option>
			<option value="{url sort=date page=null}" {if $sort=='date'}selected{/if}>дате</option>
			<option value="{url sort=stock page=null}" {if $sort=='stock'}selected{/if}>остатку</option>
			<option value="{url sort=rating page=null}" {if $sort=='rating'}selected{/if}>рейтингу</option>
		</select>	
    </div>

    <div class="display_num">
		<span>Товаров на странице:</span>
		<select onchange="direct_pagination(this.value);">
			<option value="{url on_page=12 page=null}" {if $on_page==12}selected="selected"{/if}>12</option>
			<option value="{url on_page=$on_pages page=null}" {if $on_page== $on_pages}selected="selected"{/if}>{$on_pages}</option>
			<option value="{url on_page=36 page=null}" {if $on_page==36}selected="selected"{/if}>36</option>
		</select>
	</div>
  
    <div class="display">
    	<div class="view">Вид:</div>
		<div class="table_v {if isset($smarty.cookies.view) && $smarty.cookies.view == 'table'}list_b{elseif isset($smarty.cookies.view) && $smarty.cookies.view == 'gallery'}list_a{else}list_a{/if}" onclick="createCookie('view', 'table', '365');direct_pagination('{url page=null}');"></div> 
		<div class="gallery_v {if isset($smarty.cookies.view) && $smarty.cookies.view == 'gallery'}grid_b{elseif isset($smarty.cookies.view) && $smarty.cookies.view == 'table'}grid_a{else}grid_b{/if}" onclick="createCookie('view', 'gallery', '365');direct_pagination('{url page=null}');"></div>
	</div>
</div>
<!-- incl. product_filter @ -->			
{/if}
