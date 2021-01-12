{* ajax pagination *}
{if isset($smarty.server.HTTP_X_REQUESTED_WITH) && $smarty.server.HTTP_X_REQUESTED_WITH|strtolower == 'xmlhttprequest'}
    {$wrapper = '' scope=root}
	<input class="refresh_title" type="hidden" value="{$meta_title|escape}{if $current_page_num>1} - страница {$current_page_num}{/if}" />
{/if}
{* ajax pagination end *}

{if isset($keyword)}
	{$canonical="/blog?keyword={$keyword|escape}" scope=root}
{elseif isset($category)}
	{$canonical="/sections/{$category->url}{if $current_page_num>1}?page={$current_page_num}{/if}" scope=root}
{else}
	{$canonical="/blog{if $current_page_num>1}?page={$current_page_num}{/if}" scope=root}
{/if}
				  <div class="section__head">
                
{if isset($keyword)}
	<div class="section__title color--pink">Результаты поиска по: "{$keyword|escape}"
{elseif isset($page->name)}
	<div class="section__title color--pink">{$page->name}
{elseif isset($category->name)}
	<div class="section__title color--pink" data-blogcategory="{$category->id}">{$category->name|escape}
{/if}
					</div>
              </div>
              <div class="section__options">
                <div class="breadcrumbs list--unstyled">
                  <li><a href="">Главная</a></li>
                  <li><span>{if isset($page->name)}{$page->name}
{elseif isset($category->name)}
{$category->name|escape}
{/if}</span></li>
                </div>
              </div>
              <div class="row">  
{if !empty($page->body) || !empty($category->annotation)}
<div itemscope itemtype="http://schema.org/Article">
	<meta content="{$meta_title|escape}" itemprop="name" />
	<meta content="{$meta_title|escape}" itemprop="name" />
	<meta content="{$config->root_url}" itemprop="author" />
	{if !empty($page->last_modify)}
		<meta content="{$page->last_modify|date_format:'c'}" itemprop="datePublished" />
		<meta content="{$page->last_modify|date_format:'c'}" itemprop="dateModified" />
	{elseif !empty($category->last_modify)}
		<meta content="{$category->last_modify|date_format:'c'}" itemprop="datePublished" />
		<meta content="{$category->last_modify|date_format:'c'}" itemprop="dateModified" />
	{/if}
	<meta content="{$meta_title|escape}" itemprop="headline" />
	{$seo_description = $meta_title|cat:$settings->seo_description|cat:" ✩ "|cat:$settings->site_name|cat:" ✩"}
	<meta content="{if !empty($meta_description)}{$meta_description|escape}{elseif !empty($seo_description)}{$seo_description|escape}{/if}" itemprop="description" />
	<meta content="" itemscope itemprop="mainEntityOfPage" itemType="https://schema.org/WebPage" itemid="{$config->root_url}{$canonical}" /> 
	<div style="display:none;" itemprop="image" itemscope itemtype="https://schema.org/ImageObject">				
		{$img_url=$config->root_url|cat:'/files/logo/logo.png'}
		<img itemprop="url contentUrl" src="{$img_url}" alt="{$meta_title|escape}"/>
		<meta itemprop="image" content="{$img_url}" />
		{assign var="info" value=$img_url|getimagesize}
		<meta itemprop="width" content="{$info.0}" />
		<meta itemprop="height" content="{$info.1}" />
	</div>
	<div style="display:none;" itemprop="publisher" itemscope itemtype="https://schema.org/Organization">
		<div itemprop="logo" itemscope itemtype="https://schema.org/ImageObject">
			<img itemprop="url" src="{$config->root_url}/files/logo/logo.png" alt="{$settings->company_name|escape}"/>
			<meta itemprop="image" content="{$config->root_url}/files/logo/logo.png" />
		</div>
		<meta itemprop="name" content="{$settings->company_name|escape}" />
		<meta itemprop="address" content="{$config->root_url}" />
		<meta itemprop="telephone" content="{$settings->phone|escape}" />
	</div>
	<div class="post-pg" itemprop="articleBody">
		{if !empty($page->body)}{$page->body}{elseif !empty($category->annotation)}{$category->annotation}{/if}
	</div>
</div>
{/if}

{if $posts}
	{* Записи *}

        {foreach $posts as $post} 
        <div class="col-md-12 col-sm-6">
			{include file='blog_item.tpl'}
		</div>
        {/foreach} 

	{* Записи end *}    
	{include file='pagination.tpl'}
{else}
	<div class="post-pg" itemprop="description">
		Публикаций не найдено
	</div>
{/if}
              </div>