{if !empty($articles_categories)}
<!-- incl. marticlescat -->
	<div class="box">
		<div class="box-heading">Каталог статей</div>
		<div class="box-content">
			<div class="box-category" role="navigation">
				{function name=articles_categories_tree level=1}
				{if $articles_categories}
					<ul>
						{foreach $articles_categories as $ac}
							{if $ac->visible}
								<li>
									<a href="articles/{$ac->url}" data-articlescategory="{$ac->id}"{if isset($category->id) && in_array($category->id,$ac->children)} class="filter-active"{/if} title="{$ac->name}">{$ac->name}{if isset($ac->subcategories)}{$vis=0}{foreach $ac->subcategories as $sc}{if $sc->visible}{$vis=$vis+1}{/if}{/foreach}{if $vis>0}<span{if $level>1} style="font-size: 18px;"{/if}>+</span>{/if}{/if}</a>
									{if isset($ac->subcategories)}
										{articles_categories_tree articles_categories=$ac->subcategories level=$level+1}
									{/if}
								</li>
							{/if}
						{/foreach}
					</ul>
				{/if}
				{/function}
				{articles_categories_tree articles_categories=$articles_categories}	
			</div>
		</div>
	</div>
<!-- incl. marticlescat @ -->	
{/if}
