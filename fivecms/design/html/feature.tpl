{* Вкладки *}
{capture name=tabs}
	{if in_array('products', $manager->permissions)}<li><a href="index.php?module=ProductsAdmin">{$tr->products|escape}</a></li>{/if}
	{if in_array('categories', $manager->permissions)}<li><a href="index.php?module=CategoriesAdmin">{$tr->categories|escape}</a></li>{/if}
	{if in_array('brands', $manager->permissions)}<li><a href="index.php?module=BrandsAdmin">{$tr->brands|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=FeaturesAdmin">{$tr->features|escape}</a></li>
{/capture}

{if isset($feature->name)}
	{$meta_title = $feature->name scope=root}
{else}
	{$meta_title = $tr->new_post|escape scope=root}
{/if}

<div id="onecolumn" class="featurepage">

	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span class="text">{$message_error}</span>
		<a class="button" href="">{$tr->return|escape}</a>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	<!-- Основная форма -->
	<form method=post id=product>
	
		<div id="name">
			<input placeholder="{$tr->enter_s_name|escape}" required class="name" name=name type="text" value="{if isset($feature->name)}{$feature->name|escape}{/if}"/> 
			<input name=id type="hidden" value="{if isset($feature->id)}{$feature->id|escape}{/if}"/> 
		</div> 
	
		<!-- Левая колонка свойств товара -->
		<div id="column_left" style="width:auto;">
				
			<!-- Категории -->	
			<div class="block">
				<h2>{$tr->use_in_categories|escape}</h2>
				{*<select class=multiple_categories multiple name="feature_categories[]">
					{if !isset($product_category)}{$product_category = 0}{/if}
					{function name=category_select selected_id=$product_category level=0}
						{foreach from=$categories item=category}
							<option value='{$category->id}' {if in_array($category->id, $feature_categories)}selected{/if} category_name='{if isset($category->single_name)}{$category->single_name}{/if}'>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$category->name}</option>
							{if isset($category->subcategories)}
								{category_select categories=$category->subcategories selected_id=$selected_id  level=$level+1}
							{/if}
						{/foreach}
					{/function}
					{category_select categories=$categories}
				</select>*}
				{* checkbox *}
					<link rel="stylesheet" href="design/css/jquery.treeview.new.css" />
					<script src="design/js/jquery.treeview.pack.js"></script>
					
					<!-- Свернуть/развернуть -->
					<div id="sidetreecontrol"><a class="dash_link" href="?#">{$tr->roll_up_all}</a> | <a class="dash_link" href="?#">{$tr->expand_all}</a></div>
					<!-- Свернуть/развернуть @ -->
					
					<label id="check_all" class="dash_link" style="margin-left:20px;">{$tr->choose_all}</label>
					
					{function name=category_select_check level=0}
						{foreach from=$categories item=category}
							<li class="cat_item {if in_array($category->id, $feature_categories)}selected{else}droppable category{/if} cat_{$category->id}"><input type="checkbox" name="feature_categories[]" value="{$category->id}" id="{$category->id}" {if in_array($category->id, $feature_categories)}checked{/if} >
							<label for="{$category->id}">{$category->name}</label>
							{if isset($category->subcategories)}
								{* Отметить вложенные *}
								<div data-parent="{$category->id}" class="check_sub">{$tr->choose_sub}</div>
								{* Отметить вложенные @ *}
								<ul class="sub_cat_features parent_{$category->id}">{category_select_check categories=$category->subcategories  level=$level+1}</ul>{/if}
							</li>
						{/foreach}
					{/function}
					<ul id="navigation" style="margin-top:10px;">
					{category_select_check categories=$categories}
					</ul>

					{* Отметить вложенные *}
					<script>
					$(".check_sub").click(function() {
						var parent_cat = $(this).attr('data-parent');
						// раскрыть список при выделении
						/*$('.parent_'+parent_cat).show();
						$('.parent_'+parent_cat+' ul').show();
						$('.cat_'+parent_cat+' .hitarea').removeClass('expandable-hitarea').addClass('collapsable-hitarea');
						$('.parent_'+parent_cat+' .cat_item').removeClass('expandable').addClass('collapsable').removeClass('lastExpandable').addClass('lastCollapsable');*/
						// отметить
						$('input[type="checkbox"]#'+parent_cat).prop('checked', $('input[type="checkbox"]#'+parent_cat+':not(:checked)').length>0);
						$('.parent_'+parent_cat+' input[type="checkbox"]').prop('checked',$('.parent_'+parent_cat+' input[type="checkbox"]:not(:checked)').length>0);
					});	
					</script>
					{* Отметить вложенные @ *}

					<script>
					// Выделить все
					$("#check_all").click(function() {
						$('.cat_item input[type="checkbox"][name*="feature_categories"]').attr('checked', $('.cat_item input[type="checkbox"][name*="feature_categories"]:not(:checked)').length>0);
					});	
					// Инициализация дерева категорий
					$("#navigation").treeview({
						collapsed: true,
						animated: "medium",
						control:"#sidetreecontrol",
						persist: "location"
					});
					</script>
				{* checkbox @ *}
			</div>
	 
		</div>
		<!-- Левая колонка свойств товара (The End)--> 
		
		<!-- Правая колонка свойств товара -->	
		<div id="column_right">
			
			<!-- Параметры страницы -->
			<div class="block">
				<h2>{$tr->feature_settings|escape}</h2>
				<ul>
					<li><label for="step">{$tr->feature_type|escape}</label>
						<p style="margin:10px 0;font-size:13px;">{$tr->only_to_catalogue|escape}</p>
						<select style="width:auto;" class="in_filter" name="in_filter">
							<option value='0' {if isset($feature->in_filter) && $feature->in_filter == 0}selected{/if}>{$tr->dont_show|escape}</option>
							<option value='1' {if isset($feature->in_filter) && $feature->in_filter == 1}selected{/if}>{$tr->normal|escape}</option>
							<option value='2' {if isset($feature->in_filter) && $feature->in_filter == 2}selected{/if}>{$tr->range|escape}</option>
						</select>
					</li>
				</ul>
			</div>
			<!-- Параметры страницы (The End)-->
			<input type=hidden name='session_id' value='{$smarty.session.id}'>
			<input class="button_green" type="submit" name="" value="{$tr->save|escape}" />
	
			{$tr->feature_help}			
		</div>
		<!-- Правая колонка свойств товара (The End)--> 
		
	</form>
	<!-- Основная форма (The End) -->

</div>
