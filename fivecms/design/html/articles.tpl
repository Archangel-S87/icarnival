{* Вкладки *}
{capture name=tabs}
	{if in_array('blog', $manager->permissions)}<li><a href="index.php?module=BlogCategoriesAdmin">{$tr->blog_categories|escape}</a></li>{/if}
	{if in_array('blog', $manager->permissions)}<li><a href="{url module=BlogAdmin page=null keyword=null}">{$tr->blog|escape}</a></li>{/if}
	{if in_array('articles_categories', $manager->permissions)}<li><a href="{url module=ArticlesCategoriesAdmin page=null keyword=null}">{$tr->articles_categories|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=ArticlesAdmin">{$tr->articles|escape}</a></li>
{/capture}

{$meta_title = $tr->articles scope=root}

{* Title | Заголовок *}
<div class="headerseparator">
	<div id="header">
		{if isset($keyword) && $posts_count}
			<h1>{$tr->found|escape} {$tr->found_posts|escape}: {$posts_count}</h1>
		{elseif $posts_count}
			<h1 style="text-transform: capitalize">{$tr->found_posts|escape}: {$posts_count}</h1>
		{else}
			<h1>{$tr->no_content|escape}</h1>
		{/if}
		<a class="add" href="{url module=ArticleAdmin return=$smarty.server.REQUEST_URI}">{$tr->add|escape}</a>
	</div>	
	
	{* Search | Поиск *}
	{if $posts || isset($keyword)}
	<form method="get">
	<div id="search">
		<input type="hidden" name="module" value='ArticlesAdmin'>
		<input class="search" type="text" name="keyword" value="{if isset($keyword)}{$keyword|escape}{/if}" />
		<input class="search_button" type="submit" value=""/>
	</div>
	</form>
	{/if}
</div>


{if $posts}
<div id="main_list" class="articlespage">
	
	<!-- Pagination | Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Pagination | Листалка страниц (The End) -->

	<form id="form_list" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
	
		<div id="list">
			{foreach $posts as $post}
			<div class="{if !$post->visible}invisible{/if} row">
			
				<input type="hidden" name="positions[{$post->id}]" value="{$post->position}">
				<div class="move cell"><div class="move_zone"></div></div>				
		 		<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$post->id}" />				
				</div>
				<div class="name cell">		
					<a href="{url module=ArticleAdmin id=$post->id return=$smarty.server.REQUEST_URI}">{$post->name|escape}</a>
					<br>
					{$post->date|date}
				</div>
				<div class="icons cell">
					<a class="preview" title="{$tr->open_on_page|escape}" href="../article/{$post->url}" target="_blank"></a>
					<a class="enable" title="{$tr->active|escape}" href="#"></a>
					<a class="delete" title="{$tr->delete|escape}" href="#"></a>
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
			<option value="delete">{$tr->delete|escape}</option>
		</select>
		</span>
	
		<input id="apply_action" class="button_green" type="submit" value="{$tr->save|escape}">
		
		</div>
				
	</form>	

	<!-- Pagination | Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Pagination | Листалка страниц (The End) -->
	
</div>
{/if}

<!-- Menu| Меню -->
<div id="right_menu" class="articlesright">
	<!-- Categories | Категории -->
	{function name=articles_categories_tree}
	{if $articles_categories}
	<ul>
		{if $articles_categories[0]->parent_id == 0}
			<li {if !isset($category->id)}class="selected"{/if}><a href="{url category_id=null}">{$tr->all_categories|escape}</a></li>	
		{/if}
		{foreach $articles_categories as $c}
			<li category_id="{$c->id}" {if isset($category->id) && $category->id == $c->id}class="selected"{else}class="droppable category"{/if}><a href='{url keyword=null page=null category_id={$c->id}}'>{$c->name}</a></li>
			{if isset($c->subcategories)}
				{articles_categories_tree articles_categories=$c->subcategories}
			{/if}
		{/foreach}
	</ul>
	{/if}
	{/function}
	{articles_categories_tree articles_categories=$articles_categories}
	<!-- Categories | Категории (The End)-->
</div>	
	
	
{* On document load *}
{literal}

<script>
$(function() {

	// List sort | Сортировка списка
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
			$("#form_list input[name*='check']").attr('checked', false);
			$("#form_list").ajaxSubmit(function() {
				colorize();
			});
		}
	});

	// Colorize items | Раскраска строк
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

	// Delete | Удалить 
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest(".row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Enable | Скрыт/Видим
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'articles', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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
	
	// Confirm deletion | Подтверждение удаления
	$("form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
			return false;	
	});
});

</script>
{/literal}