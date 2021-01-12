{* Вкладки *}
{capture name=tabs}
	{if in_array('products', $manager->permissions)}<li><a href="index.php?module=ProductsAdmin">{$tr->products|escape}</a></li>{/if}
	{if in_array('categories', $manager->permissions)}<li><a href="index.php?module=CategoriesAdmin">{$tr->categories|escape}</a></li>{/if}
	{if in_array('brands', $manager->permissions)}<li><a href="index.php?module=BrandsAdmin">{$tr->brands|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=FeaturesAdmin">{$tr->features|escape}</a></li>
{/capture}

{* Title *}
{$meta_title = $tr->features|escape scope=root}

{* Заголовок *}
<div id="header">
	<h1>{$tr->features|escape}</h1> 
	<a class="add" href="{url module=FeatureAdmin return=$smarty.server.REQUEST_URI}">{$tr->add|escape}</a>
</div>	

{if $features}
<div id="main_list" class="features">
	
	<form id="list_form" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">

		<div id="list">
			{foreach $features as $feature}
			<div class="{if $feature->in_filter}in_filter{/if} row">
				<input type="hidden" name="positions[{$feature->id}]" value="{$feature->position}">
				<div class="move cell"><div class="move_zone"></div></div>
		 		<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$feature->id}" />				
				</div>
				<div class="name cell">
					<a href="{url module=FeatureAdmin id=$feature->id return=$smarty.server.REQUEST_URI}">{$feature->name|escape}</a> [id={$feature->id}]
				</div>
				<div class="icons cell">
					<a title="{$tr->use_in_filter|escape}" class="in_filter" href='#' ></a>
					<a title="{$tr->delete|escape}" class="delete" href='#' ></a>
				</div>
				<div class="clear"></div>
			</div>
			{/foreach}
		</div>
		
		<div id="action">
			<label id="check_all" class="dash_link">{$tr->choose_all|escape}</label>
			<span id="select">
				<select name="action">
					<option value="set_in_filter">{$tr->use_in_filter|escape}</option>
					<option value="unset_in_filter">{$tr->dont_use_in_filter|escape}</option>
					<option value="delete">{$tr->delete|escape}</option>
				</select>
			</span>
			<input id="apply_action" class="button_green" type="submit" value="{$tr->save|escape}">
		</div>

	</form>

</div>
{else}
<div id="main_list" class="features">
	{$tr->no_content|escape}
</div>
{/if}
 
 <!-- Меню -->
<div id="right_menu" class="featuresright">
	
	<!-- Категории товаров -->
	<link rel="stylesheet" href="design/css/jquery.treeview.new.css" />
	<script src="design/js/jquery.treeview.pack.js"></script>
	
	{function name=categories_tree}
	{if $categories}
		{if $categories[0]->parent_id == 0}
		<li {if !isset($category->id)}class="selected"{/if} style="padding-left:0; background:none;"><a href="{url category_id=null brand_id=null}">{$tr->all_categories|escape}</a></li>	
		{/if}
		{foreach $categories as $c}
		<li category_id="{$c->id}" {if isset($category->id) && $category->id == $c->id}class="selected"{else}class="droppable category"{/if}><a href='{url keyword=null brand_id=null page=null category_id={$c->id}}'>{$c->name}</a>
			{if isset($c->subcategories)}<ul>{categories_tree categories=$c->subcategories}</ul>{/if}
		</li>
		{/foreach}
	{/if}
	{/function}
	<ul id="navigation">
		{categories_tree categories=$categories}
	</ul>
	<!-- Категории товаров (The End)-->	

</div>
<!-- Левое меню  (The End) -->

{literal}
<script>
$(function() {

	// second example
	$("#navigation").treeview({
		persist: "location",
		collapsed: true,
		unique: true
	});

	// Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();
	
	// Сортировка списка
	$("#list").sortable({
		items:             ".row",
		tolerance:         "pointer",
		handle:            ".move_zone",
		axis: 'y',
		scrollSensitivity: 40,
		opacity:           0.7, 
		forcePlaceholderSize: true,
		
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
	
	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	
	
	// Указать "в фильтре"/"не в фильтре"
	$("a.in_filter").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('in_filter')?0:1;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'feature', 'id': id, 'values': {'in_filter': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				icon.removeClass('loading_icon');
				if(!state)
					line.removeClass('in_filter');
				else
					line.addClass('in_filter');				
			},
			dataType: 'json'
		});	
		return false;	
	});

	// Удалить
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Подтверждение удаления
	$("form").submit(function() {
		if($('#list input[type="checkbox"][name*="check"]:checked').length>0)
			if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
				return false;	
	});
	
});
</script>
{/literal}

