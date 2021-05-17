{if !empty($services_categories)}
<!-- incl. mservicescat -->
<div class="box servicescat">
	<div class="box-heading">Каталог</div>
	<div class="box-content">
		<div class="box-category" role="navigation">
			{function name=services_categories_tree level=1}
			<ul {if $level>1}class="included_cat"{/if}>
				{foreach $services_categories as $uc}
					{if $uc->visible}
					<li>
						<a title="{$uc->name}" href="services/{$uc->url}" data-servicescategory="{$uc->id}"{if !empty($category->id) && in_array($category->id,$uc->children)} class="filter-active"{/if}>{$uc->menu}{if !empty($uc->subcategories)}<span>+</span>{/if}</a>
						{if !empty($uc->subcategories)}
							{services_categories_tree services_categories=$uc->subcategories level=$level+1}
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