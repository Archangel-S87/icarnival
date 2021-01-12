{* Вкладки *}
{capture name=tabs}
	{if in_array('products', $manager->permissions)}<li><a href="index.php?module=ProductsAdmin">{$tr->products|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=CategoriesAdmin">{$tr->categories|escape}</a></li>
	{if in_array('brands', $manager->permissions)}<li><a href="index.php?module=BrandsAdmin">{$tr->brands|escape}</a></li>{/if}
	{if in_array('features', $manager->permissions)}<li><a href="index.php?module=FeaturesAdmin">{$tr->features|escape}</a></li>{/if}
{/capture}

{$meta_title = $tr->categories scope=root}

{* Заголовок *}
<div id="header">
	<h1>{$tr->categories|escape}</h1>
	<a class="add" href="{url module=CategoryAdmin return=$smarty.server.REQUEST_URI}">{$tr->add|escape}</a>
</div>	
<!-- Заголовок (The End) -->

{if $categories}

<link rel="stylesheet" href="design/css/jquery.treeview.css" />
<script type="text/javascript" src="design/js/jquery.cookie.js"></script>           
<script type="text/javascript" src="design/js/jquery.treeview.pack.js"></script>           
{literal}
	<script type="text/javascript">
		$(function() {
			$("#list").treeview({
				cookieId: 'prd_tree',
				collapsed: true,
				animated: "medium",
				control:"#sidetreecontrol",
				persist: "cookie"
			});
		})
	</script>
{/literal}

<div id="sidetreecontrol" class="treecontrol"><a href="?#">{$tr->roll_up_all|escape}</a> | <a href="?#">{$tr->expand_all|escape}</a></div>

<div id="main_list" class="categories">

<form id="list_form" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
		
		{function name=categories_tree level=0}
		{if $categories}
		<ul id="list" class="sortable">
		
			{foreach $categories as $category}
			<li class="{if !$category->visible}invisible{/if} row">		
				<div class="tree_row">
					<input type="hidden" name="positions[{$category->id}]" value="{$category->position}">
					<div class="move cell"><div class="move_zone"></div></div>
			 		<div class="checkbox cell">
						<input type="checkbox" name="check[]" value="{$category->id}" />
					</div>
					<div class="name cell">
						<a href="{url module=CategoryAdmin id=$category->id return=$smarty.server.REQUEST_URI}">{$category->name|escape}</a> 	 			
					</div>
					<div class="icons cell">
						<a class="preview" title="{$tr->open_on_page|escape}" href="../catalog/{$category->url}" target="_blank"></a>				
						<a class="enable" title="{$tr->active|escape}" href="#"></a>
						<a class="delete" title="{$tr->delete|escape}" href="#"></a>
					</div>
					<div class="clear"></div>
				</div>
				{if !empty($category->subcategories)}
					{categories_tree categories=$category->subcategories level=$level+1}
				{/if}
			</li>
			{/foreach}
	
		</ul>
		{/if}
		{/function}
		{categories_tree categories=$categories}

		<div id="action">
		<label id="check_all" class="dash_link">{$tr->choose_all|escape}</label>
		
		<span id="select">
		<select name="action">
			<option value="enable">{$tr->make_visible|escape}</option>
			<option value="disable">{$tr->make_invisible|escape}</option>
			<option value="delete">{$tr->delete|escape}</option>
		</select>
		</span>
		
		<input id="apply_action" class="button_green" type="submit" value="{$tr->save|escape}">
		
		</div>
	
	</form>
</div>
{else}
	{$tr->no_content|escape}
{/if}

{literal}
<script>
$(function() {

	// Сортировка списка
	$(".sortable").sortable({
		items:".row",
		handle: ".move_zone",
		tolerance:"pointer",
		scrollSensitivity:40,
		opacity:0.7, 
		axis: "y",
		update:function()
		{
			$("#list_form input[name*='check']").attr('checked', false);
			$("#list_form").ajaxSubmit();
		}
	});
 
	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]:not(:disabled)').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:disabled):not(:checked)').length>0);
	});	

	// Показать категорию
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'category', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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

	// Удалить 
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("li.row").find('input[type="checkbox"][name*="check"]:first').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});

	
	// Подтвердить удаление
	$("form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
			return false;	
	});

});
</script>
{/literal}


