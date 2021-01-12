<!-- incl. mservicescat -->
<div class="box servicescat">
	<div class="box-heading">Каталог</div>
	<div class="box-content">
		<div class="box-category" role="navigation">
			{function name=services_categories_tree level=1}
				{if !empty($services_categories)}
						<ul>
							{foreach $services_categories as $uc}
								{if $uc->visible}
									<li>
										<a href="services/{$uc->url}" data-servicescategory="{$uc->id}"{if !empty($category->id) && in_array($category->id,$uc->children)} class="filter-active"{/if} title="{$uc->name}">{$uc->menu}{if !empty($uc->subcategories)}{$vis=0}{foreach $uc->subcategories as $suc}{if $suc->visible}{$vis=$vis+1}{/if}{/foreach}{if $vis>0}<span{if $level>1} style="font-size: 18px;"{/if}>+</span>{/if}{/if}</a>
										{if !empty($uc->subcategories)}
											{services_categories_tree services_categories=$uc->subcategories level=$level+1}
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