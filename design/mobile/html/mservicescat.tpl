<!-- incl. mservicescat -->
<div class="box">
	<div class="box-heading">Каталог услуг</div>
	<div class="box-content">
		<div class="box-category">
			{function name=services_categories_tree level=1}
			{if $services_categories}
				<ul>
					{foreach $services_categories as $ac}
						{if $ac->visible}
						<li>
							<a href="services/{$ac->url}" data-servicescategory="{$ac->id}"{if !empty($category->id) && in_array($category->id,$ac->children)} class="filter-active"{/if} title="{$ac->name}">{$ac->menu}{if !empty($ac->subcategories)}{$vis=0}{foreach $ac->subcategories as $sc}{if $sc->visible}{$vis=$vis+1}{/if}{/foreach}{if $vis>0}<span{if $level>1} style="font-size: 18px;"{/if}>+</span>{/if}{/if}</a>
							{if !empty($ac->subcategories)}
								{services_categories_tree services_categories=$ac->subcategories level=$level+1}
							{/if}
						</li>
						{/if}
					{/foreach}
				</ul>
			{/if}
			{/function}
			{services_categories_tree services_categories=$services_categories}	
		</div>
	</div>
</div>
<!-- incl. mservicescat @ -->	