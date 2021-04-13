
{* Вкладки *}
{capture name=tabs}
	<li class="active"><a href="{url module=ProductsAdmin keyword=null category_id=null brand_id=null filter=null page=null}">{$tr->products|escape}</a></li>
	{if in_array('categories', $manager->permissions)}<li><a href="index.php?module=CategoriesAdmin">{$tr->categories|escape}</a></li>{/if}
	{if in_array('brands', $manager->permissions)}<li><a href="index.php?module=BrandsAdmin">{$tr->brands|escape}</a></li>{/if}
	{if in_array('features', $manager->permissions)}<li><a href="index.php?module=FeaturesAdmin">{$tr->features|escape}</a></li>{/if}
{/capture}

{* Title *}
{if !empty($category)}
	{$meta_title=$category->name scope=root}
{else}
	{$meta_title=$tr->products|escape scope=root}
{/if}
{$categories_count = $categories|count}

{* Заголовок *}
<div class="headerseparator">
	<div id="header">	
		{if $products_count}
			{if !empty($category->name) || isset($brand->name)}
				<h1>{if !empty($category->name)}{$category->name}{/if}{if !empty($brand->name)} {$brand->name}{/if} ({$products_count} {$products_count|plural:($tr->product|lower):($tr->purchases|lower):$tr->product_a})</h1>
			{elseif !empty($keyword)}
				<h1>{$tr->found|escape}: {$products_count} {$products_count|plural:($tr->product|lower):($tr->purchases|lower):$tr->product_a}</h1>
			{else}
				<h1>{$products_count} {$products_count|plural:($tr->product|lower):($tr->purchases|lower):$tr->product_a}</h1>
			{/if}		
		{else}
			<h1>{if !empty($keyword)}{$tr->search_by|escape} "{$keyword}"{else}{$tr->no_products|escape}{/if}</h1>
		{/if}
	
		<a class="add" href="{url module=ProductAdmin return=$smarty.server.REQUEST_URI}">{$tr->add_product|escape}</a>
	
	</div>	
	
	{* Поиск *}
	<form method="get">
	<div id="search">
		<input type="hidden" name="module" value="ProductsAdmin" />
		<input placeholder="{$tr->prod_search_help|escape}" class="search" type="text" name="keyword" value="{if !empty($keyword)}{$keyword|escape}{/if}" />
		<input class="search_button" type="submit" value="" />
		{if !empty($category->id)}
			<input type="checkbox" checked name="category_id" value="{$category->id}" /> <div style="display:inline-block;vertical-align:middle;">{$tr->search_in_this_cat|escape}</div>
		{/if}
		{if !empty($brand->id)}
			<input type="hidden" name="brand_id" value="{$brand->id}" />
		{/if}
	</div>
	</form>
</div>

<div id="main_list" class="productspage">
	
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
		
	{if $products}

	<div id="expand">
	<!-- Свернуть/развернуть варианты -->
	<a href="#" class="dash_link" id="expand_all">{$tr->expand_all|escape} {$tr->variants|escape}</a>
	<a href="#" class="dash_link" id="roll_up_all" style="display:none;">{$tr->roll_up_all|escape} {$tr->variants|escape}</a>
	<!-- Свернуть/развернуть варианты (The End) -->
	</div>

	{* Основная форма *}
	<form id="list_form" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
		{math assign='random' equation='rand(10,1000)'}
		<div id="list">
		{foreach $products as $product}
		<div class="{if !$product->visible}invisible{/if} {if $product->featured}featured{/if} {if $product->is_new}is_new{/if} {if $product->to_yandex}yandex{/if} row">
			<input type="hidden" name="positions[{$product->id}]" value="{$product->position}">
			<div class="move cell"><div class="move_zone"></div></div>
	 		<div class="checkbox cell">
				<input type="checkbox" name="check[]" value="{$product->id}"/>				
			</div>
			<div class="image cell">
				{$image = $product->images|@first}
				{if $image}
				<a href="{$image->filename|escape|resize:1024:768:w}?{$random}" class="zoom"><img class="expando" onmouseover="style.zIndex='100';" onmouseout="style.zIndex='1';" style="position: relative; z-index: 1;" src="{$image->filename|escape|resize:100:100}?{$random}" /></a>
				{/if}
			</div>
			<div class="name product_name cell">
			 	
			 	<div class="variants">
					<ul>
						{foreach $product->variants as $variant}
						<li {if !$variant@first}class="variant" style="display:none;"{/if}>
							<i title="{$variant->name|escape}">
								{$variant->name|escape|truncate:30:'…':true:true}
								{if $variant->sku} (арт.:{$variant->sku|escape}){/if}
								
								{if $variant->discount > 0}
								<div class="variant_discount"><strong>-{$variant->discount}%</strong>{if $variant->discount_date > 0} до {$variant->discount_date|date} {$variant->discount_date|time}{/if}</div>
								{/if}
							</i>
							<span class="price-stock">
								{if !empty($variant->currency_id) && !empty($currencies[$variant->currency_id])}{$sign = $currencies[$variant->currency_id]->sign}{else}{$sign = $currency->sign}{/if}
								<input class="price {if $variant->compare_oprice>0}compare_price{/if}" type="text" name="price[{$variant->id}]" value="{$variant->oprice}" {if $variant->compare_oprice>0}title="{$tr->old_price|escape} - {$variant->compare_oprice} {$sign}"{/if} />{$sign} 
								<input class="stock" type="text" name="stock[{$variant->id}]" value="{if $variant->infinity}∞{else}{$variant->stock}{/if}" />
								{if $variant->unit}{$variant->unit}{else}{$settings->units}{/if}
							</span>
						</li>
						{/foreach}
					</ul>
	
					{$variants_num = $product->variants|count}
					{if $variants_num>1}
					<div class="expand_variant">
						<a class="dash_link expand_variant" href="#">{$variants_num} {$variants_num|plural:$tr->variant:$tr->variant_ov:$tr->variant_a} &or;</a>
						<a class="dash_link roll_up_variant" style="display:none;" href="#">{$variants_num} {$variants_num|plural:$tr->variant:$tr->variant_ov:$tr->variant_a} &and;</a>
					</div>
					{/if}
				</div>
				
				<div class="prdname"><a href="{url module=ProductAdmin id=$product->id return=$smarty.server.REQUEST_URI}">{$product->name|escape}</a></div>
	 			
			</div>
			<div class="icons cell" >
				<span>
				<a class="preview"   title="{$tr->open_on_page|escape}" href="../products/{$product->url}" target="_blank"></a>			
				<a class="enable"    title="{$tr->active|escape}"                 href="#"></a>
				<a class="duplicate" title="{$tr->copy|escape}"             href="#"></a>
				<a class="delete"    title="{$tr->delete|escape}"                 href="#"></a>
				</span>
				
				<span style="clear: both; display: block; margin-top: 10px;">
				<a class="featured"  title="{$tr->bestseller|escape}"           href="#"></a>
				<a class="is_new"  title="{$tr->novelties|escape}"           href="#"></a>
				<a class="yandex"  title="{$tr->export_to_yandex|escape}"           href="#"></a>
				</span>
				
			</div>
			
			<div class="clear"></div>
		</div>
		{/foreach}
		</div>

		<div id="action">
			<label id="check_all" class="dash_link">{$tr->choose_all|escape}</label>
		
			<span id="select">
			<select name="action">
				<option value="enable">{$tr->make_visible|escape}</option>
				<option value="disable">{$tr->make_invisible|escape}</option>
				<option value="set_featured">{$tr->mark_as_hit|escape}</option>
				<option value="unset_featured">{$tr->unmark_as_hit|escape}</option>
				<option value="set_is_new">{$tr->mark_as_new|escape}</option>
				<option value="unset_is_new">{$tr->unmark_as_new|escape}</option>
				<option value="set_yandex">{$tr->export_to_yandex|escape}</option>
				<option value="unset_yandex">{$tr->dont_export_to_yandex|escape}</option>
				<option value="duplicate">{$tr->copy|escape}</option>
				{if $pages_count>1}
				<option value="move_to_page">{$tr->move_to_page|escape}</option>
				{/if}
				{if $categories_count>1}
				<option value="move_to_category">{$tr->move_to_category|escape}</option>
				<option value="add_to_category">{$tr->add_category|escape}</option>
				{/if}
				{if $all_brands|count>0}
				<option value="move_to_brand">{$tr->add_brand|escape}</option>
				{/if}
				<option value="delete">{$tr->delete|escape}</option>
			</select>
			</span>
		
			<span id="move_to_page">
			<select name="target_page">
				{section target_page $pages_count}
				<option value="{$smarty.section.target_page.index+1}">{$smarty.section.target_page.index+1}</option>
				{/section}
			</select> 
			</span>
		
			<span id="move_to_category">
			<select name="target_category">
				{function name=category_select level=0}
					{foreach $categories as $category}
						<option value='{$category->id}'>{section sp $level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$category->name|escape}</option>
						{if !empty($category->subcategories)}
							{if !isset($selected_id)}{$selected_id=''}{/if}
							{category_select categories=$category->subcategories selected_id=$selected_id level=$level+1}
						{/if}
					{/foreach}
				{/function}
				{category_select categories=$categories}
			</select> 
			</span>
			
			<span id="move_to_brand">
			<select name="target_brand">
				<option value="0">{$tr->not_set|escape}</option>
				{foreach $all_brands as $b}
				<option value="{$b->id}">{$b->name}</option>
				{/foreach}
			</select> 
			</span>
		
			<input id="apply_action" class="button_green" type="submit" value="{$tr->save|escape}">		
		</div>
		{/if}
	</form>

	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->		
</div>


<!-- Меню -->
<div id="right_menu" class="productsright">

	<!-- Фильтры -->
	<ul>
		<li {if !isset($filter)}class="selected"{/if}><a href="{url brand_id=null category_id=null keyword=null page=null filter=null minCurr=null maxCurr=null}">{$tr->all|escape} {$tr->products|lower|escape}</a></li>
		
		<li {if !empty($filter) && $filter=='featured'}class="selected"{/if}><a href="{url page=null filter='featured'}">{$tr->hits|escape}</a></li>
		<li {if !empty($filter) && $filter=='is_new'}class="selected"{/if}><a href="{url page=null filter='is_new'}">{$tr->novelties|escape}</a></li>
		<li {if !empty($filter) && $filter=='to_yandex'}class="selected"{/if}><a href="{url page=null filter='to_yandex'}">{$tr->y_market|escape}</a></li>
		<li {if !empty($filter) && $filter=='discounted'}class="selected"{/if}><a href="{url page=null filter='discounted'}">{$tr->with_old_price|escape}</a></li>
		<li {if !empty($filter) && $filter=='visible'}class="selected"{/if}><a href="{url page=null filter='visible'}">{$tr->enabled_pl|escape}</a></li>
		<li {if !empty($filter) && $filter=='hidden'}class="selected"{/if}><a href="{url page=null filter='hidden'}">{$tr->disabled_pl|escape}</a></li>
		<li {if !empty($filter) && $filter=='outofstock'}class="selected"{/if}><a href="{url page=null filter='outofstock'}">{$tr->out_stock|escape}</a></li>
	</ul>
	<!-- Фильтры -->
	
	<div class="product_sort">
		<p>{$tr->sort_by|escape}:</p>
		<select onchange="location.href = this.value;">
			<option value="{url sort=position}" {if !empty($sort) && $sort=='position'}selected{/if}>{$tr->by_position|escape}</option>
			<option value="{url sort=priceup}" {if !empty($sort) && $sort=='priceup'}selected{/if}>{$tr->by_price|escape} &#8593;</option>
			<option value="{url sort=pricedown}" {if !empty($sort) && $sort=='pricedown'}selected{/if}>{$tr->by_price|escape} &#8595;</option>
			<option value="{url sort=name}" {if !empty($sort) && $sort=='name'}selected{/if}>{$tr->by_name|escape}</option>
			<option value="{url sort=date}" {if !empty($sort) && $sort=='date'}selected{/if}>{$tr->by_date|escape}</option>
			<option value="{url sort=stock}" {if !empty($sort) && $sort=='stock'}selected{/if}>{$tr->by_stock|escape}</option>
			<option value="{url sort=rating}" {if !empty($sort) && $sort=='rating'}selected{/if}>{$tr->by_rating|escape}</option>
		</select>	
	</div>
	
	{* Сортировка по цене *}
	<div class="formCost">
		<div class="pr-cost">{$tr->filter_by_price|escape}:</div>
		<div class="price_filter_wrap">
			<input type="number" name="minCurr" id="minCurr" value="{$minCurr}" autocomplete="off"/>
			<label for="maxCurr">-</label> 
			<input type="number" name="maxCurr" id="maxCurr" value="{$maxCurr}" autocomplete="off"/>
		</div>
	</div>
	<div class="button_green blue price_choose">{$tr->save|escape}</div>
	<script>
	$(document).on('click','.price_choose', function(){
		url_min = '';
		url_max = '';
		minCurr = $('#minCurr').val();
		if(minCurr > 0)
			url_min = '&minCurr='+minCurr;
		maxCurr = $('#maxCurr').val();
		if(maxCurr > 0)
			url_max = '&maxCurr='+maxCurr;	
		{$url_price = {url page=null minCurr=null maxCurr=null}}	
		location.href = '{$url_price}{if strpos($url_price, "?") === false}?{/if}'+url_min+url_max;
	});
	</script>
	{* Сортировка по цене @ *}
	
	<!-- Категории товаров -->
	{if $categories_count < 100}
		<link rel="stylesheet" href="design/css/jquery.treeview.new.css" />
		<script src="design/js/jquery.treeview.pack.js"></script>
	
		{function name=categories_tree}
		{if !empty($categories)}
			{if $categories[0]->parent_id == 0}
			<li {if empty($category_id)}class="selected"{/if} style="padding-left:0; background:none;"><a href="{url brand_id=null page=null limit=null category_id=null}">{$tr->all_categories|escape}</a></li>
			<li {if isset($category_id) && $category_id==-1}class="selected"{/if} style="padding-left:0; background:none;"><a href="{url brand_id=null page=null limit=null category_id=-1}">{$tr->no_category|escape}</a></li>
			{/if}
		
			{foreach $categories as $c}
			<li category_id="{$c->id}" {if !empty($category->id) && $category->id == $c->id}class="selected"{else}class="droppable category"{/if}><a href='{url brand_id=null page=null category_id={$c->id}}'>{$c->name}</a>
				{if !empty($c->subcategories)}<ul>{categories_tree categories=$c->subcategories}</ul>{/if}
			</li>
			{/foreach}
		{/if}
		{/function}
		
		<ul id="navigation" style="display:none;">
			{categories_tree categories=$categories}
		</ul>
		
		<script>
		$(function() {
			$("#navigation").treeview({
				persist: "location",
				collapsed: true,
				unique: true
			});
		});	
		</script>
	{else}
		{function name=categories_tree_select level=0}
		{if !empty($categories)}
			{if $categories[0]->parent_id == 0}
			<option {if !isset($category->id)}selected{/if} value="{url category_id=null brand_id=null}">{$tr->all_categories|escape}</option>	
			<option {if isset($category_id) && $category_id==-1}selected{/if} value="{url brand_id=null page=null limit=null category_id=-1}">{$tr->no_category|escape}</option>		
			{/if}
			{foreach $categories as $c}
			<option category_id="{$c->id}" {if !empty($category->id) && $category->id == $c->id}selected{/if} 
				value='{url keyword=null brand_id=null page=null category_id={$c->id}}'>{section name=sp loop=$level}&nbsp;&nbsp;{/section}{$c->name}
				{if !empty($c->subcategories)}{categories_tree_select categories=$c->subcategories level=$level+1}{/if}
			</option>
			{/foreach}
		{/if}
		{/function}
		<select class="navigation_cats" onchange="window.location.href = this.value;">
			{categories_tree_select categories=$categories}
		</select>
	{/if}
	<!-- Категории товаров (The End)-->	
	
	{if !empty($brands)}
	<!-- Бренды -->
	<select class="brand_select" name="brand_select" onchange="window.location.href = this.value;">
		<option value="{url brand_id=null}" {if empty($brand_id)}selected{/if}>{$tr->all_brands|escape}</option>
		<option value="{url brand_id=-1}" {if isset($brand_id) && $brand_id == -1}selected{/if}>{$tr->no_brand|escape}</option>
		{foreach $brands as $b}
			<option value="{url page=null brand_id=$b->id}" {if !empty($brand->id) && $brand->id == $b->id}selected{/if}>{$b->name}</option>
		{/foreach}
	</select>
	<!-- Бренды (The End) -->
	{/if}
	
</div>
<!-- Меню  (The End) -->

{* On document load *}
{literal}
<script>

$(function() {
	// Сортировка списка
	$("#list").sortable({
		items:             ".row",
		tolerance:         "pointer",
		handle:            ".move_zone",
		scrollSensitivity: 40,
		opacity:           0.7, 
		
		helper: function(event, ui){		
			if($('input[type="checkbox"][name*="check"]:checked').size()<1) return ui;
			var helper = $('<div/>');
			$('input[type="checkbox"][name*="check"]:checked').each(function(){
				var item = $(this).closest('.row');
				helper.height(helper.height()+item.innerHeight());
				if(item[0]!=ui[0]) {
					helper.append(item.clone());
					$(this).closest('.row').remove();
				}
				else {
					helper.append(ui.clone());
					item.find('input[type="checkbox"][name*="check"]').attr('checked', false);
				}
			});
			return helper;			
		},	
 		start: function(event, ui) {
  			if(ui.helper.children('.row').size()>0)
				$('.ui-sortable-placeholder').height(ui.helper.height());
		},
		beforeStop:function(event, ui){
			if(ui.helper.children('.row').size()>0){
				ui.helper.children('.row').each(function(){
					$(this).insertBefore(ui.item);
				});
				ui.item.remove();
			}
		},
		update:function(event, ui)
		{
			$("#list_form input[name*='check']").attr('checked', false);
			$("#list_form").ajaxSubmit(function() {
				colorize();
			});
		}
	});
	
	// Перенос товара на другую страницу
	$("#action select[name=action]").change(function() {
		if($(this).val() == 'move_to_page')
			$("span#move_to_page").show();
		else
			$("span#move_to_page").hide();
	});
	$("#pagination a.droppable").droppable({
		activeClass: "drop_active",
		hoverClass: "drop_hover",
		tolerance: "pointer",
		drop: function(event, ui){
			$(ui.helper).find('input[type="checkbox"][name*="check"]').attr('checked', true);
			$(ui.draggable).closest("form").find('select[name="action"] option[value=move_to_page]').attr("selected", "selected");		
			$(ui.draggable).closest("form").find('select[name=target_page] option[value='+$(this).html()+']').attr("selected", "selected");
			$(ui.draggable).closest("form").submit();
			return false;	
		}		
	});

	// Перенос товара в другую категорию или добавить товару категорию
	$("#action select[name=action]").change(function() {
		if ($(this).val() == 'move_to_category' || $(this).val() == 'add_to_category')
			$("span#move_to_category").show();
		else
			$("span#move_to_category").hide();
	});
	
	$("#right_menu .droppable.category").droppable({
		activeClass: "drop_active",
		hoverClass: "drop_hover",
		tolerance: "pointer",
		drop: function(event, ui){
			$(ui.helper).find('input[type="checkbox"][name*="check"]').attr('checked', true);
			$(ui.draggable).closest("form").find('select[name="action"] option[value=move_to_category]').attr("selected", "selected");	
			$(ui.draggable).closest("form").find('select[name=target_category] option[value='+$(this).attr('category_id')+']').attr("selected", "selected");
			$(ui.draggable).closest("form").submit();
			return false;			
		}
	});

	// Перенос товара в другой бренд
	$("#action select[name=action]").change(function() {
		if($(this).val() == 'move_to_brand')
			$("span#move_to_brand").show();
		else
			$("span#move_to_brand").hide();
	});
	$("#right_menu .droppable.brand").droppable({
		activeClass: "drop_active",
		hoverClass: "drop_hover",
		tolerance: "pointer",
		drop: function(event, ui){
			$(ui.helper).find('input[type="checkbox"][name*="check"]').attr('checked', true);
			$(ui.draggable).closest("form").find('select[name="action"] option[value=move_to_brand]').attr("selected", "selected");			
			$(ui.draggable).closest("form").find('select[name=target_brand] option[value='+$(this).attr('brand_id')+']').attr("selected", "selected");
			$(ui.draggable).closest("form").submit();
			return false;			
		}
	});

	// Если есть варианты, отображать ссылку на их разворачивание
	if($("li.variant").size()>0)
		$("#expand").show();

	// Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();

	// Показать все варианты
	$("#expand_all").click(function() {
		$("a#expand_all").hide();
		$("a#roll_up_all").show();
		$("a.expand_variant").hide();
		$("a.roll_up_variant").show();
		$(".variants ul li.variant").fadeIn('fast');
		return false;
	});

	// Свернуть все варианты
	$("#roll_up_all").click(function() {
		$("a#roll_up_all").hide();
		$("a#expand_all").show();
		$("a.roll_up_variant").hide();
		$("a.expand_variant").show();
		$(".variants ul li.variant").fadeOut('fast');
		return false;
	});

	// Показать вариант
	$("a.expand_variant").click(function() {
		$(this).closest("div.cell").find("li.variant").fadeIn('fast');
		$(this).closest("div.cell").find("a.expand_variant").hide();
		$(this).closest("div.cell").find("a.roll_up_variant").show();
		return false;
	});

	// Свернуть вариант
	$("a.roll_up_variant").click(function() {
		$(this).closest("div.cell").find("li.variant").fadeOut('fast');
		$(this).closest("div.cell").find("a.roll_up_variant").hide();
		$(this).closest("div.cell").find("a.expand_variant").show();
		return false;
	});

	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Удалить товар
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Дублировать товар
	$("a.duplicate").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=duplicate]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Показать товар
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest("div.row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'product', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				icon.removeClass('loading_icon');
				if(state)
					line.removeClass('invisible');
				else
					line.addClass('invisible');				
			},
			dataType: 'json'
		});	
		return false;	
	});

	// Сделать лидером продаж или рекомендуем
	$("a.featured").click(function() {
		var icon        = $(this);
		var line        = icon.closest("div.row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('featured')?0:1;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'product', 'id': id, 'values': {'featured': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				icon.removeClass('loading_icon');
				if(state)
					line.addClass('featured');				
				else
					line.removeClass('featured');
			},
			dataType: 'json'
		});	
		return false;	
	});


	// Сделать новинкой
	 $("a.is_new").click(function() {
	 var icon = $(this);
	 var line = icon.closest("div.row");
	 var id = line.find('input[type="checkbox"][name*="check"]').val();
	 var state = line.hasClass('is_new')?0:1;
	 icon.addClass('loading_icon');
	 $.ajax({
	 type: 'POST',
	 url: 'ajax/update_object.php',
	 data: {'object': 'product', 'id': id, 'values': {'is_new': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
	 success: function(data){
	 icon.removeClass('loading_icon');
	 if(state)
	 line.addClass('is_new'); 
	 else
	 line.removeClass('is_new');
	 },
	 dataType: 'json'
	 }); 
	 return false; 
	 });

	// Yandex.market
	$("a.yandex").click(function() {
		var icon        = $(this);
		var line        = icon.closest("div.row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('yandex')?0:1;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'product', 'id': id, 'values': {'to_yandex': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				icon.removeClass('loading_icon');
				if(state)
					line.addClass('yandex');                
				else
					line.removeClass('yandex');
			},
			dataType: 'json'
		}); 
		return false;   
	});

	// Подтверждение удаления
	$("form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_deletion|escape}{literal}'))
			return false;	
	});
	
	// Бесконечность на складе
	$("input[name*=stock]").focus(function() {
		if($(this).val() == '∞')
			$(this).val('');
		return false;
	});
	$("input[name*=stock]").blur(function() {
		if($(this).val() == '')
			$(this).val('∞');
	});
});

$("a.zoom").fancybox({ 'hideOnContentClick' : true });

$(window).load(function() {
	$('#navigation').show();
});

</script>
{/literal}

<script src="/js/zoomprod.js"></script>

