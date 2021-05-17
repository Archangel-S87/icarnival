{if isset($smarty.server.HTTP_X_REQUESTED_WITH) && $smarty.server.HTTP_X_REQUESTED_WITH|strtolower == 'xmlhttprequest'}
    {$wrapper = '' scope=root}
	<input class="refresh_title" type="hidden" value="
		{if !empty($metadata_page)}
			{if $metadata_page->meta_title}
				{$metadata_page->meta_title|escape}{if $current_page_num>1} - страница {$current_page_num}{/if}
			{else}
				{$meta_title|escape}{if $current_page_num>1} - страница {$current_page_num}{/if}
			{/if}
		{else}
			{$meta_title|escape}{if $current_page_num>1} - страница {$current_page_num}{/if}
		{/if}
	" />
{/if}

{if !empty($metadata_page)}
	{$canonical="{$smarty.server.REQUEST_URI}" scope=root}
{elseif !empty($filter_features) && $settings->filtercan == 1}
	{$canonical="{$smarty.server.REQUEST_URI}" scope=root}
{elseif !empty($filter_features) && $settings->filtercan == 0 && !empty($category)}
	{$canonical="/catalog/{$category->url}" scope=root}
{elseif !empty($category) && !empty($brand)}
	{$canonical="/catalog/{$category->url}/{$brand->url}" scope=root}
{elseif !empty($category)}
	{$canonical="/catalog/{$category->url}" scope=root}
{elseif !empty($brand)}
	{$canonical="/brands/{$brand->url}" scope=root}
{elseif !empty($keyword)}
	{$canonical="/products?keyword={$keyword|escape}" scope=root}
{else}
	{$canonical="/products" scope=root}
{/if}

{if $settings->filtercan == 1 && (!empty($filter_features) || !empty($smarty.get.b))}
	{if !empty($meta_title)}
		{$mt = $meta_title|escape}
	{else}
    	{$mt = ""}	
	{/if}
	
	{if !empty($category->name) && !empty($brand->name)}
    	{$ht = $category->name|escape|cat:' | '|cat:$brand->name|escape}
    {elseif !empty($brand->name)}
		{$ht = $brand->name|escape}
	{elseif !empty($category->name)}
		{$ht = $category->name|escape}
	{else}
		{$ht = ""}	
	{/if}
	
	{$seo_description = $meta_title|cat:$settings->seo_description|cat:" ★ "|cat:$settings->site_name}
	{if !empty($meta_description)}{$md = $meta_description|escape}{elseif !empty($seo_description)}{$md = $seo_description|escape}{/if}
	
	{if !empty($smarty.get.b) && !empty($category->brands)}
    	{foreach name=brands item=b from=$category->brands}
			{if $b->id|in_array:$smarty.get.b}
				{$mt = $mt|cat:' | '|cat:$b->name|escape}
				{$md = $md|cat:' ★ '|cat:$b->name|escape}
				{$ht = $ht|cat:' | '|cat:$b->name|escape}
			{/if}
		{/foreach}
	{/if}
	
	{if !empty($smarty.get.v) && !empty($features_variants)}
    	{foreach $features_variants as $o}
			{if $o|in_array:$smarty.get.v}
				{$mt = $mt|cat:' | '|cat:$o|escape}
				{$md = $md|cat:' ★ '|cat:$o|escape}
				{$ht = $ht|cat:' | '|cat:$o|escape}
			{/if}
		{/foreach}
	{/if}
	{if !empty($smarty.get.v1) && !empty($features_variants1)}
    	{foreach $features_variants1 as $o}
			{if $o|in_array:$smarty.get.v1}
				{$mt = $mt|cat:' | '|cat:$o|escape}
				{$md = $md|cat:' ★ '|cat:$o|escape}
				{$ht = $ht|cat:' | '|cat:$o|escape}
			{/if}
		{/foreach}
	{/if}
	{if !empty($smarty.get.v2) && !empty($features_variants2)}
    	{foreach $features_variants2 as $o}
			{if $o|in_array:$smarty.get.v2}
				{$mt = $mt|cat:' | '|cat:$o|escape}
				{$md = $md|cat:' ★ '|cat:$o|escape}
				{$ht = $ht|cat:' | '|cat:$o|escape}
			{/if}
		{/foreach}
	{/if}
    
    {if !empty($filter_features) && !empty($features)}
		{foreach $features as $f}
			{foreach $f->options as $o}
				{if !empty($filter_features.{$f->id}) && in_array($o->value,$filter_features.{$f->id})}                        
					{$mt = $mt|cat:' | '|cat:$f->name|cat:' - '|cat:$o->value}
					{$md = $md|cat:' ★ '|cat:$f->name|cat:' - '|cat:$o->value}
					{$ht = $ht|cat:' | '|cat:$f->name|cat:' - '|cat:$o->value}
				{/if}       
			{/foreach}
		{/foreach}
    {/if}
	
	{if !empty($mt)}
    	{$meta_title = $mt scope=root}
    {/if}	
    {if !empty($ht)}
    	{$page_name = $ht scope=root}
    {/if}
	{if !empty($md)}
		{$meta_description = $md scope=root}
	{/if}
{/if}

<input class="curr_page" type="hidden" data-url="{url page=$current_page_num}" value="{$current_page_num}" />
<input class="refresh_curr_page" type="hidden" data-url="{url page=$current_page_num}" value="{$current_page_num}" />
{if $current_page_num<$total_pages_num}<input class="refresh_next_page" type="hidden" data-url="{url page=$current_page_num+1}" value="{$current_page_num+1}" />{/if}
{if $current_page_num==2}<input class="refresh_prev_page" type="hidden" data-url="{url page=null}" value="{$current_page_num-1}" />{/if}
{if $current_page_num>2}<input class="refresh_prev_page" type="hidden" data-url="{url page=$current_page_num-1}" value="{$current_page_num-1}" />{/if}
<input class="total_pages" type="hidden" value="{$total_pages_num}" />

{include file='cfeatures.tpl'}

{if !empty($metadata_page->description)}		
	<div class="page-pg categoryintro" style="margin-bottom:16px;"><div class="top cutouter" style="max-height:{$settings->cutmob|escape}px;"><div class="disappear" style="display:none;"></div><div class="cutinner"><!--desc-->{$metadata_page->description}<!--/desc--></div></div><div class="top cutmore" style="display:none;">Развернуть...</div></div>	
{elseif !empty($page->body)}
	<div class="page-pg categoryintro" style="margin-bottom:16px;"><div class="top cutouter" style="max-height:{$settings->cutmob|escape}px;"><div class="disappear" style="display:none;"></div><div class="cutinner"><!--desc-->{$page->body}<!--/desc--></div></div><div class="top cutmore" style="display:none;">Развернуть...</div></div>
{else}
	{if $current_page_num==1}
		<div class="page-pg categoryintro" style="{if !empty($brand->description) || !empty($category->description)}margin-bottom:16px;{else}margin:0 15px;{/if}"><div class="top cutouter" style="max-height:{$settings->cutmob|escape}px;"><div class="disappear" style="display:none;"></div><div class="cutinner"><!--desc-->{if !empty($brand->description)}{$brand->description}{elseif !empty($category->description)}{$category->description}{/if}<!--/desc--></div></div><div class="top cutmore" style="display:none;">Развернуть...</div></div>
	{/if}
{/if}

{* subcat start *}
{if !empty($category->subcategories)}
	<ul class="category_products separator">
		{foreach name=cats from=$category->subcategories item=c}
		{if $c->visible}
		<li class="product" onClick="window.location='catalog/{$c->url}'">
			<div class="image">
			{if $c->image}
				<img loading="lazy" alt="{$c->name|escape}" title="{$c->name|escape}" src="{$config->categories_images_dir}{$c->image}" />
			{else}
				<svg class="nophoto"><use xlink:href='#folder' /></svg>
			{/if}
			</div>
			<div class="product_info">
				<h3>{$c->name|escape}</h3>
			</div>
		</li>
		{/if}
		{/foreach}
	</ul>
{/if}
{* subcat end *}

{* Категории в бренде *}
{if !empty($brand) && !empty($brand_cat) && $brand_cat|count > 1 && $current_page_num && $current_page_num == 1}
	<div class="page-pg brand_cat">
		<div class="brand_disc">Категории:</div>
		<a class="brand_item {if ($smarty.server.REQUEST_URI|strstr:'brands')}selected{/if}" href="brands/{$brand->url}">Все категории</a>
		{foreach $brand_cat as $bc}
		<a class="brand_item {if !empty($category->url) && $category->url == $bc->url}selected{/if}" href="catalog/{$bc->url}/{$brand->url}">{$bc->name}</a>
		{/foreach}
		
		{* Вывод категорий 2-го уровня вложенности *}
		{*{foreach $brand_cat as $bc}
			{function name=categories_tree_brand level=0}
				{if !empty($categories)}
					{foreach $categories as $c}
						{if $c->visible}
							{if in_array($bc->id, $c->children)}
								{if $level == 2}
									<a class="brand_item {if !empty($category->url) && $category->url == $bc->url}selected{/if}" href="catalog/{$bc->url}/{$brand->url}">{$bc->name}</a>
								{/if}
								{if !empty($c->subcategories)}{categories_tree_brand categories=$c->subcategories level=$level+1}{/if}
							{/if}
						{/if}
					{/foreach}
				{/if}
			{/function}
			{categories_tree_brand categories=$categories}
		{/foreach}*}
		
		{* Или добавить к категории название родительской*}
		{*{foreach $brand_cat as $bc}
			{if !empty($categories)}
				{foreach $categories as $c}
					{if in_array($bc->id, $c->children)}
						{$parent = $c->name}
					{/if}
				{/foreach}
			{/if}
			<a class="brand_item {if !empty($category->url) && $category->url == $bc->url}selected{/if}" href="catalog/{$bc->url}/{$brand->url}">{$bc->name} {if $parent != $bc->name}{$parent|lower}{/if}</a>
		{/foreach}*}
		
	</div>
{/if}

{if !empty($products)}
	<div class="ajax_pagination">
		{*{include file='pagination.tpl'}*}
	
		{if $current_page_num >= 2}
			<div class="infinite_prev" style="display:none;">
				<div class="trigger_prev infinite_button">Загрузить пред. страницу</div>
			</div>
		{/if}

		<ul id="start" class="tiny_products infinite_load">
			{$numdashed=0}
			{foreach $products as $product}
				{include file='products_item.tpl'}
			{/foreach}
		</ul>

		{if $total_pages_num >1}
			<div class="infinite_pages infinite_button" style="display:none;">
				<div>Стр. {$current_page_num} из {$total_pages_num}</div>
			</div>
			<div class="infinite_trigger"></div>
		{/if}
		{*<div class="paginationwrapper">{include file='pagination.tpl'}</div>*}	

	</div>
	<script>
		function clicker(that) {
		  var pick = that.options[that.selectedIndex].value;
		  location.href = pick;
		};
	</script>

{else}
	<div class="page-pg"><p>Товары не найдены</p></div>
{/if}	

{if $current_page_num==1}
	<div class="page-pg categoryintro">
		<div class="bottom cutouter" style="max-height:{$settings->cutmob|escape}px;">
			<div class="disappear"></div>
			<div class="cutinner"><!--seo-->{if !empty($brand->description_seo)}{$brand->description_seo}{elseif !empty($category->description_seo)}{$category->description_seo}{/if}<!--/seo--></div>
		</div>
		<div class="bottom cutmore" style="display:none;">Развернуть...</div>
	</div>
{/if}

{if empty($mobile_app)}
	<script>
		window.addEventListener("orientationchange", function() {
			location.reload();
		}, false);
	</script>
{/if}
