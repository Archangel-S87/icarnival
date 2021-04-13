{if !empty($services_categories)}
<!-- incl. mservicescat -->
<div class="box">
	<div class="box-heading">Каталог услуг</div>
	<div class="box-content">
		<div class="box-category">
			{function name=services_categories_tree level=1}
				<ul {if $level>1}class="included_cat"{/if}>
					{foreach $services_categories as $ac}
						{if $ac->visible}
						<li>
							<a href="services/{$ac->url}" data-servicescategory="{$ac->id}"{if !empty($category->id) && in_array($category->id,$ac->children)} class="filter-active"{/if} title="{$ac->name}">{$ac->menu}{if !empty($ac->subcategories)}<span>+</span>{/if}</a>
							{if !empty($ac->subcategories)}
								{services_categories_tree services_categories=$ac->subcategories level=$level+1}
							{/if}
						</li>
						{/if}
					{/foreach}
				</ul>
			{/function}
			{services_categories_tree services_categories=$services_categories}	
		</div>
	</div>
</div>
<!-- incl. mservicescat @ -->
{/if}