              <div class="site-aside jsFilterToggleContent">
                <div class="site-aside__col">
                  <div class="site-aside__title jsFilterToggleSectionBtn">Категории<i class="icon-down-arrow"></i></div>
                  <div class="site-aside__content">
                    <div class="jsFilterToggleSection">
							{function name=categories_tree level=1}
							<ul{if $level == 1} class="list--unstyled list--indent list"{/if}>
								{foreach $categories as $c}
									{if $c->visible}
									<li>
										<a title="{$c->name|escape}" {if in_array($category->id,$c->children)}class="is--active"{/if} href="catalog/{$c->url}">
											{$c->name|escape}
										</a>
										{if !empty($c->subcategories) && $category && in_array($category->id,$c->children)}
											{categories_tree categories=$c->subcategories level=$level+1}
										{/if}
									</li>
									{/if}
								{/foreach}
							</ul>
							{/function}
							{categories_tree categories=$categories}                    
                    </div>
                  </div>
                </div>
 	{if $settings->b3manage > 0}
		<div id="cfeatures" {if (isset($minCost) && isset($maxCost) && $minCost<$maxCost) || !empty($features) || (!empty($category->brands) && $category->brands|count>1)}{else}style="display: none;"{/if}>
				{include file='cfeatures.tpl'}
		</div>
		{* ajax filter *}
			<script>
				var current_url = '{$config->root_url}';
				{if !empty($category)}
					current_url += '/catalog/{$category->url}';
					{if !empty($brand)}
						current_url += '/{$brand->url}';
					{/if}
				{elseif !empty($keyword)}
					current_url += '/products';
				{elseif !empty($page->url)}
					current_url += '/{$page->url}';	
				{elseif !empty($brand)}
					current_url += '/brands/{$brand->url}';
				{else}
					current_url += '/products';
				{/if}
			</script>
		{* ajax filter end *}
	{/if}               
                <div class="site-aside__title jsFilterToggleSectionBtn">Вы просматривали<i class="icon-down-arrow"></i></div>
                <div class="site-aside__content">
                  <div class="jsFilterToggleSection"></div>
                </div>
              </div>