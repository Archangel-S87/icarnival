{* Tabs | Вкладки *}
{capture name=tabs}
	{if in_array('blog', $manager->permissions)}<li><a href="index.php?module=BlogCategoriesAdmin">{$tr->blog_categories|escape}</a></li>{/if}
	{if in_array('blog', $manager->permissions)}<li><a href="{url module=BlogAdmin page=null keyword=null}">{$tr->blog|escape}</a></li>{/if}
	<li class="active"><a href="{url module=ArticlesCategoriesAdmin page=null keyword=null}">{$tr->articles_categories|escape}</a></li>
	{if in_array('articles', $manager->permissions)}<li><a href="index.php?module=ArticlesAdmin">{$tr->articles|escape}</a></li>{/if}
{/capture}

{$meta_title = $tr->articles_categories scope=root}

{* Title | Заголовок *}
<div id="header">
	<h1>{$tr->articles_categories|escape}</h1>
	<a class="add" href="{url module=ArticlesCategoryAdmin return=$smarty.server.REQUEST_URI}">{$tr->add|escape}</a>
</div>	
{* Title | Заголовок (The End) *}

{if $articles_categories}
<div id="main_list" class="categories">

	<form id="list_form" method="post">
		<input type="hidden" name="session_id" value="{$smarty.session.id}">
		
		{function name=articles_categories_tree level=0}
		{if $articles_categories}
		<div id="list" class="sortable">
		
			{foreach $articles_categories as $category}
			<div class="{if !$category->visible}invisible{/if} row">		
				<div class="tree_row">
					<input type="hidden" name="positions[{$category->id}]" value="{$category->position}">
					<div class="move cell" style="margin-left:{$level*20}px"><div class="move_zone"></div></div>
			 		<div class="checkbox cell">
						<input type="checkbox" name="check[]" value="{$category->id}" />				
					</div>
					<div class="name cell">
						<a href="{url module=ArticlesCategoryAdmin id=$category->id return=$smarty.server.REQUEST_URI}">{$category->name|escape}</a> 	 			
					</div>
					<div class="icons cell">
						<a class="preview" title="{$tr->open_on_page|escape}" href="../articles/{$category->url}" target="_blank"></a>				
						<a class="enable" title="{$tr->active|escape}" href="#"></a>
						<a class="delete" title="{$tr->delete|escape}" href="#"></a>
					</div>
					<div class="clear"></div>
				</div>
				{if isset($category->subcategories)}
					{articles_categories_tree articles_categories=$category->subcategories level=$level+1}
				{/if}
			</div>
			{/foreach}
	
		</div>
		{/if}
		{/function}
		{articles_categories_tree articles_categories=$articles_categories}
		
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

	// List sort | Сортировка списка
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
 
	// Choose all | Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Show category | Показать категорию
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'articles_category', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]:first').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});

	
	// Confirm deletion | Подтвердить удаление
	$("form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
			return false;	
	});

});
</script>
{/literal}

