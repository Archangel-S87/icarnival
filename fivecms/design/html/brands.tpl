{* Tabs | Вкладки *}
{capture name=tabs}
	{if in_array('products', $manager->permissions)}<li><a href="index.php?module=ProductsAdmin">{$tr->products|escape}</a></li>{/if}
	{if in_array('categories', $manager->permissions)}<li><a href="index.php?module=CategoriesAdmin">{$tr->categories|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=BrandsAdmin">{$tr->brands|escape}</a></li>
	{if in_array('features', $manager->permissions)}<li><a href="index.php?module=FeaturesAdmin">{$tr->features|escape}</a></li>{/if}
{/capture}

{$meta_title = $tr->brands scope=root}

{* Title | Заголовок *}
<div id="header">
	<h1>{$tr->brands|escape}</h1> 
	<a class="add" href="{url module=BrandAdmin return=$smarty.server.REQUEST_URI}">{$tr->add|escape}</a>
</div>	

{if $brands}
<div id="main_list" class="brands">

	<form id="list_form" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
		
		<div id="list" class="brands">	
			{foreach $brands as $brand}
			<div class="{if !$brand->visible}invisible{/if} row">
		 		<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$brand->id}" />				
				</div>
				<div class="name cell">
					<a href="{url module=BrandAdmin id=$brand->id return=$smarty.server.REQUEST_URI}">{$brand->name|escape}</a> 	 			
				</div>
				<div class="icons cell">
					<a class="preview" title="{$tr->open_on_page|escape}" href="../brands/{$brand->url}" target="_blank"></a>	
					<a class="enable" title="{$tr->active|escape}" href="#"></a>			
					<a class="delete"  title="{$tr->delete|escape}" href="#"></a>
				</div>
				<div class="clear"></div>
			</div>
			{/foreach}
		</div>
		
		<div id="action">
			<label id="check_all" class="dash_link">{$tr->choose_all|escape}</label>
			
			<span id="select">
			<select name="action">
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

	// Colorize list items | Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Colorize on load | Раскрасить строки сразу
	colorize();	
	
	// Choose all | Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Показать бренд
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'brand', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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

	// Delete | Удалить
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Confirm deletion | Подтверждение удаления
	$("form").submit(function() {
		if($('#list input[type="checkbox"][name*="check"]:checked').length>0)
			if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
				return false;	
	});
 	
});
</script>
{/literal}

