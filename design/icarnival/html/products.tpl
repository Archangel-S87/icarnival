{* ajax pagination *}
{if !empty($smarty.server.HTTP_X_REQUESTED_WITH) && $smarty.server.HTTP_X_REQUESTED_WITH|strtolower == 'xmlhttprequest'}
    {$wrapper = '' scope=root}
    	
	<input class="refresh_title" type="hidden" value="
		{if !empty($metadata_page)}
			{if !empty($metadata_page->meta_title)}
				{$metadata_page->meta_title|escape}{if $current_page_num>1} - страница {$current_page_num}{/if}
			{else}
				{$meta_title|escape}{if $current_page_num>1} - страница {$current_page_num}{/if}
			{/if}
		{else}
			{$meta_title|escape}{if $current_page_num>1} - страница {$current_page_num}{/if}
		{/if}
	" />
{/if}
{* ajax pagination end *}

{if !empty($metadata_page)}
	{$canonical="{$smarty.server.REQUEST_URI}" scope=root}
{elseif !empty($filter_features) && $settings->filtercan == 1}
	{$canonical="{$smarty.server.REQUEST_URI}" scope=root}
{elseif !empty($filter_features) && $settings->filtercan == 0}
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

{* метки для обозначения подменяемых текстов для модуля Метаданные фильтра 
* <!--h1--><!--/h1-->
* <!--desc--><!--/desc-->
* <!--seo--><!--/seo-->
* метки для обозначения подменяемых тегов для модуля Метаданные фильтра 
* <!--canonical--><!--/canonical-->
*}

{if !empty($h1_title)}
				  <div class="section__head">
                <div class="section__title color--pink"><!--h1-->{$h1_title|escape}<!--/h1--></div>
              </div>          
{elseif !empty($keyword)}
				  <div class="section__head">
                <div class="section__title color--pink"><!--h1-->Результаты поиска по: "{$keyword|escape}"<!--/h1--></div>
              </div>   
{elseif !empty($page)}
				  <div class="section__head">
                <div class="section__title color--pink" data-page="{$page->id}">{$page->name|escape}</div>
              </div>   
{elseif $settings->filtercan == 1 && ( !empty($filter_features) || !empty($smarty.get.b)  || !empty($smarty.get.v) || !empty($smarty.get.v1) || !empty($smarty.get.v2) )}
    {if !empty($meta_title)}{$mt = $meta_title|escape}{/if}
    
    {if !empty($category->name) && !empty($brand->name)}
    	{$ht = $category->name|escape|cat:' | '|cat:$brand->name|escape}
    {elseif !empty($brand->name)}
		{$ht = $brand->name|escape}
	{elseif !empty($category->name)}
		{$ht = $category->name|escape}
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
    	{$ftags = $ht scope=root}
				  <div class="section__head">
                <div class="section__title color--pink">{$ht}</div>
              </div>    	
    {/if}
    {if !empty($md)}
    	{$meta_description = $md scope=root}
    {/if}
{else}
	<div class="section__head">             
	<div class="section__title color--pink" {if !empty($category->id)}data-category="{$category->id}"{elseif !empty($brand->id)}data-brand="{$brand->id}"{/if}><!--h1-->{if !empty($category->name)}{$category->name|escape}{/if} {if !empty($brand->name)}{$brand->name|escape}{/if} {if !empty($keyword)}{$keyword|escape}{/if}<!--/h1--></div>
	</div>
{/if}





{* Категории в бренде *}
{* if !empty($brand) && !empty($brand_cat) && $brand_cat|count > 1}
	<div class="brand_cat">
		<div class="brand_disc">Категории:</div>
		<a class="various {if ($smarty.server.REQUEST_URI|strstr:'brands')}buttonred{/if}" href="brands/{$brand->url}">Все категории</a>
		{foreach $brand_cat as $bc}
		<a class="various {if !empty($category->url) && $category->url == $bc->url}buttonred{/if}" href="catalog/{$bc->url}/{$brand->url}">{$bc->name}</a>
		{/foreach}
		
		{* Вывод категорий 2-го уровня вложенности }
		{*{foreach $brand_cat as $bc}
			{function name=categories_tree_brand level=0}
				{if !empty($categories)}
					{foreach $categories as $c}
						{if $c->visible}
							{if in_array($bc->id, $c->children)}
								{if $level == 2}
									<a class="various {if !empty($category->url) && $category->url == $bc->url}buttonred{/if}" href="catalog/{$bc->url}/{$brand->url}">{$bc->name}</a>
								{/if}
								{if !empty($c->subcategories)}{categories_tree_brand categories=$c->subcategories level=$level+1}{/if}
							{/if}
						{/if}
					{/foreach}
				{/if}
			{/function}
			{categories_tree_brand categories=$categories}
		{/foreach}*}
		
		{* Или добавить к категории название родительской}
		{*{foreach $brand_cat as $bc}
			{if !empty($categories)}
				{foreach $categories as $c}
					{if in_array($bc->id, $c->children)}
						{$parent = $c->name}
					{/if}
				{/foreach}
			{/if}
			<a class="various {if !empty($category->url) && $category->url == $bc->url}buttonred{/if}" href="catalog/{$bc->url}/{$brand->url}">{$bc->name} {if $parent != $bc->name}{$parent|lower}{/if}</a>
		{/foreach}}
		
	</div>
{/if*}

{* Вывод товаров *}

              <div class="section__options"> 
                <div class="row justify-content-between no-gutters row--y-indent-15 align-items-center">
                  <div class="col-item">
                    <div class="breadcrumbs list--unstyled">
							<a href="/">Главная</a>
							{if $category}
							{foreach $category->path as $cat}
							{if $category->id == $cat->id}
							<li>{$cat->name|escape}</li>
							{else}
							<li><a href="catalog/{$cat->url}">{$cat->name|escape}</a></li>
							{/if}
							{/foreach}  
							{if $brand}
							<li><a href="catalog/{$cat->url}/{$brand->url}">{$brand->name|escape}</a></li>
							{/if}
							{elseif $brand}
							<li><a href="brands/{$brand->url}">{$brand->name|escape}</a></li>
							{elseif $keyword}
							<li>Поиск</li>
							{/if}                    
                    </div>
                  </div>
                  <div class="col-item">
                    <div class="row row--x-indent-10 align-items-center">
                    	 {include file='product_filter.tpl'}
                    </div>
                  </div>
                </div>
              </div>

{if !empty($products)}




	<div class="row row--y-indent-30 row--y-indent-15-md">         
		{foreach $products as $product}
		<div class="col-xl-4 col-sm-6">
		<div class="product__grid">
			{include file='products_item.tpl'}
		</div>
		</div>
		{/foreach}
	</div>

	{include file='pagination.tpl'}	


{else}
	<p>Товары не найдены</p>
	<br />
	<div class="prod-back">
		<a href="javascript:history.go(-1)" class="buttonblue">Назад</a>
	</div>
	<div class="filter-back">
		<a href="{strtok($smarty.server.REQUEST_URI,'?')}" class="buttonblue">Сбросить фильтр</a>
	</div>
{/if}	

{* SEO-текст *}
{if !empty($current_page_num) && $current_page_num==1}
<div {if !isset($keyword) && !empty($brand->description) && !empty($category->description)}style="margin-bottom: 18px;"{/if}>

	{* schema *}
		<div class="catdescription" itemscope itemtype="http://schema.org/Article">
			<meta content="{$meta_title|escape}" itemprop="name" />
			<meta content="{$config->root_url}" itemprop="author" />
			{if !empty($category)}
			<meta content="{$category->last_modify|date_format:'c'}" itemprop="datePublished" />
			<meta content="{$category->last_modify|date_format:'c'}" itemprop="dateModified" />
			{elseif !empty($brand)}
			<meta content="{$brand->last_modify|date_format:'c'}" itemprop="datePublished" />
			<meta content="{$brand->last_modify|date_format:'c'}" itemprop="dateModified" />
			{/if}
			<meta content="{$meta_title|escape}" itemprop="headline" />
			{$seo_description = $meta_title|cat:$settings->seo_description|cat:" ✩ "|cat:$settings->site_name|cat:" ✩"}
			<meta content="{if !empty($meta_description)}{$meta_description|escape}{elseif !empty($seo_description)}{$seo_description|escape}{/if}" itemprop="description" />
			<meta content="" itemscope itemprop="mainEntityOfPage" itemType="https://schema.org/WebPage" itemid="{$config->root_url}{$canonical}" /> 
			<div style="display:none;" itemprop="image" itemscope itemtype="https://schema.org/ImageObject">				
				{if !empty($category->image)}
					{$img_url=$config->root_url|cat:'/'|cat:$config->categories_images_dir|cat:$category->image}
				{elseif !empty($brand->image)}
					{$img_url=$config->root_url|cat:'/'|cat:$config->brands_images_dir|cat:$brand->image}
				{else}
					{$img_url=$config->root_url|cat:'/files/logo/logo.png'}
				{/if}
					<img itemprop="url contentUrl" src="{$img_url}" alt="{$meta_title|escape}" title="{$meta_title|escape}"/>
					<meta itemprop="image" content="{$img_url}" />
					{assign var="info" value=$img_url|getimagesize}
					<meta itemprop="width" content="{$info.0}" />
					<meta itemprop="height" content="{$info.1}" />
			</div>

			<div style="display:none;" itemprop="publisher" itemscope itemtype="https://schema.org/Organization">
			    <div itemprop="logo" itemscope itemtype="https://schema.org/ImageObject">
			        <img itemprop="url" src="{$config->root_url}/files/logo/logo.png" alt="{$settings->company_name|escape}" title="{$settings->company_name|escape}"/>
					<meta itemprop="image" content="{$config->root_url}/files/logo/logo.png" />
			    </div>
				<meta itemprop="name" content="{$settings->company_name|escape}" />
				<meta itemprop="address" content="{$config->root_url}" />
				<meta itemprop="telephone" content="{$settings->phone|escape}" />
			</div>

			{* Описание *}
			{if !empty($metadata_page->description)}		
			    <div class="page-pg" style="margin-bottom: 15px;"><div class="top cutouter" style="max-height:{$settings->cutouter|escape}px;"><div class="disappear" style="display:none;"></div><div class="cutinner" itemprop="articleBody" ><!--desc-->{$metadata_page->description}<!--/desc--></div></div><div class="top cutmore" style="display:none;">Развернуть...</div></div>	
			{elseif !empty($page->body)}
				<div class="page-pg" itemprop="articleBody" style="margin-bottom: 15px;"><div class="top cutouter" style="max-height:{$settings->cutouter|escape}px;"><div class="disappear" style="display:none;"></div><div class="cutinner"><!--desc-->{$page->body}<!--/desc--></div></div><div class="top cutmore" style="display:none;">Развернуть...</div></div>
			{else}
				{if !empty($current_page_num) && $current_page_num==1}
					{if !empty($brand->description)}
						<div class="page-pg" style="margin-bottom: 15px;"><div class="top cutouter" style="max-height:{$settings->cutouter|escape}px;"><div class="disappear" style="display:none;"></div><div class="cutinner" itemprop="articleBody" ><!--desc-->{$brand->description}<!--/desc--></div></div><div class="top cutmore" style="display:none;">Развернуть...</div></div>
					{elseif !empty($category->description)}
						<div class="page-pg" style="margin-bottom: 15px;"><div class="top cutouter" style="max-height:{$settings->cutouter|escape}px;"><div class="disappear" style="display:none;"></div><div class="cutinner" itemprop="articleBody" ><!--desc-->{$category->description}<!--/desc--></div></div><div class="top cutmore" style="display:none;">Развернуть...</div></div>
					{else}
						{*<div style="display:none;" itemprop="articleBody">{if !empty($meta_description)}{$meta_description|escape}{elseif !empty($seo_description)}{$seo_description|escape}{/if}</div>*}
						<div class="page-pg"><div class="top cutouter" style="max-height:{$settings->cutouter|escape}px;"><div class="disappear" style="display:none;"></div><div class="cutinner" itemprop="articleBody" ><!--desc--><!--/desc--></div></div><div class="top cutmore" style="display:none; margin-bottom:15px;">Развернуть...</div></div>
					{/if}
				{/if}
			{/if}
		</div>
	{* schema end *}



</div>



	<div class="page-pg catdescription" style="margin-top:17px;">
		<div class="bottom cutouter" style="max-height:{$settings->cutseo|escape}px;">
			<div class="disappear"></div>
			<div class="cutinner"><!--seo-->{if !empty($brand->description_seo)}{$brand->description_seo}{elseif !empty($category->description_seo)}{$category->description_seo}{/if}<!--/seo--></div>
		</div>
		<div class="bottom cutmore" style="display:none;">Развернуть...</div>
	</div>
{/if}

{* 	убирание под кат }
{if $settings->cutseo > 0}
	<script>
		heightb=$('.bottom .cutinner').height();	
		if(heightb<{$settings->cutseo|escape}){
			$('.bottom.cutouter').addClass('fullheight');
			$('.bottom .disappear').hide();
		} else {
			$('.bottom.cutmore').show();
		}
	</script>
{/if}
{if $settings->cutouter > 0}
	<script>
		heightt=$('.top .cutinner').height();	
		if(heightt<{$settings->cutouter|escape}){
			$('.top.cutouter').addClass('fullheight');
		} else {
			$('.top.cutmore').show();
			$('.top .disappear').show();
		}
	</script>
{/if}
<script>
	$('.cutmore').click(function() { 
		$(this).toggleText('Развернуть...', 'Свернуть...');
		$(this).prev().toggleClass('fullheight');
		$(this).prev().find('.disappear').toggle();
	});
</script>
{* 	убирание под кат end *}
