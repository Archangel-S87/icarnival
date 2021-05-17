{if !empty($blog_categories)}
<!-- incl. mblog_cat -->
<div class="box">
	<div class="box-heading">Разделы блога</div>
	<div class="box-content">
		<div class="box-category" role="navigation">
			<ul>
			{foreach $blog_categories as $bc}
				{if $bc->visible}
				<li>
					<a href="sections/{$bc->url}" data-blogcategory="{$bc->id}"{if isset($category->id) && $category->id == $bc->id} class="filter-active"{/if} title="{$bc->name}">{$bc->name}</a>
				</li>
				{/if}
			{/foreach}
			</ul>
		</div>
	</div>
</div>
<!-- incl. mblog_cat @-->
{/if}