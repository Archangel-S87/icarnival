{$meta_title = "Карта сайта" scope=root}
{$page_name = "Карта сайта" scope=root}

<style>{literal}
	ul {list-style-type: none;}
	.pages strong {display: block; padding: 10px 0 10px 0;}
	#content ul ul {padding-left: 20px;}
{/literal}</style>

    <h1 class="title">Карта сайта</h1>
	<div class="page-pg">

	{if $pages}
    <div class="pages">
	<strong>Страницы:</strong>
        <ul>
		    {foreach $pages as $p}
		    	{if $p->menu_id != 18}
			        <li><a href="{$p->url}" data-page="{$p->id}" title="{$p->header}">{$p->header}</a></li>
			    {/if}
		    {/foreach}
        </ul>
    </div>
    {/if}

    {if $posts}
    <div class="pages">
	<strong><a href="blog" title="Блог">Блог</a>:</strong>
        <ul>
		    {foreach $posts as $p}
				{if $p->visible}
			    	<li><a href="blog/{$p->url}" data-post="{$p->id}" title="{$p->name}">{$p->name}</a></li>
				{/if}   
		    {/foreach}
        </ul>
    </div>
    {/if}

	{if $links}
	<div class="pages">
		<strong><a href="pages" title="Спецссылки">Спецссылки</a>:</strong>
		<ul>
		{foreach $links as $link}
		<li>
			<a data-link="{$link->id}" href="pages/{$link->url}">{$link->name|escape}</a>
		</li>
		{/foreach}
		</ul>
	</div>
	{/if}
	
	{if $surveys}
	<div class="pages">
		<strong><a href="surveys" title="Опросы">Опросы</a>:</strong>
		<ul>
		{foreach $surveys as $survey}
		<li>
			<a data-survey="{$survey->id}" href="survey/{$survey->url}">{$survey->name|escape}</a>
		</li>
		{/foreach}
		</ul>
	</div>
	{/if}
	
	{if $articles}
    <div class="pages">
	<strong>Статьи:</strong>
        <ul>
    {foreach $articles as $p}
		{if $p->visible}
            <li><a href="article/{$p->url}" data-article="{$p->id}" title="{$p->name}">{$p->name}</a></li>
		{/if}   
    {/foreach}
        </ul>
    </div>
    {/if}
    
    {if isset($services_categories)}
	<div class="pages">
		<strong>Услуги:</strong>
		{function name=services_categories_tree4}
		<ul>
			{foreach $services_categories as $sc}
				{if $sc->visible}
					<li>
						<a href="services/{$sc->url}" data-servicescategory="{$sc->id}" title="{$sc->name}">{$sc->name}</a>
						{if isset($sc->subcategories)}
							{services_categories_tree4 services_categories=$sc->subcategories}
						{/if}	
					</li>
				{/if}
			{/foreach}
		</ul>
		{/function}
	{services_categories_tree4 services_categories=$services_categories}
	</div>
	{/if}
	
    {if $cats}
    <div class="cats" style="margin-top: 15px;">
    <strong style="padding: 0px 0 10px 0;">Каталог товаров:</strong>
    {function name=cat_prod}
    {if $prod}
        <ul class="product" style="padding: 5px 0px;">
        {foreach $prod as $p}
			{if $p->visible}
            	<li><a href="products/{$p->url}" data-product="{$p->id}" title="{$p->name}">{$p->name}</a></li>
			{/if}
        {/foreach}
        </ul>
    {/if}
    {/function}    
    
    {function name=cat_tree}
    {if $cats}
        <ul style="{if isset($c->subcategories)}padding: 0px 20px;{else}padding: 5px 0px;{/if}">
        {foreach $cats as $c}
            {if $c->visible}
                <li><a href="catalog/{$c->url}" data-category="{$c->id}" title="{$c->name}"><strong>{$c->name}</strong></a>
                    {if isset($c->subcategories)}{cat_tree cats=$c->subcategories}{/if}
                    {cat_prod prod=$c->products}
                </li>
            {/if}
        {/foreach}
        </ul>
    {/if}
    {/function}
    
    {cat_tree cats=$cats} 
    </div>
    {/if}
    
</div>
