{* Tabs | Вкладки *}
{capture name=tabs}
	{if in_array('blog', $manager->permissions)}<li><a href="index.php?module=BlogCategoriesAdmin">{$tr->blog_categories|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=BlogAdmin">{$tr->blog|escape}</a></li>
	{if in_array('articles_categories', $manager->permissions)}<li><a href="{url module=ArticlesCategoriesAdmin page=null keyword=null}">{$tr->articles_categories|escape}</a></li>{/if}
	{if in_array('articles', $manager->permissions)}<li><a href="index.php?module=ArticlesAdmin">{$tr->articles|escape}</a></li>{/if}
{/capture}

{$meta_title = $tr->blog scope=root}
	
{* Title | Заголовок *}
<div class="headerseparator" style="margin-bottom:15px;">
	<div id="header">
		{if isset($keyword) && $posts_count}
			<h1>{$tr->found|escape} {$tr->found_posts|escape}: {$posts_count}</h1>
		{elseif $posts_count}
			<h1 style="text-transform: capitalize">{$tr->found_posts|escape}: {$posts_count}</h1>
		{else}
			<h1>{$tr->no_content|escape}</h1>
		{/if}
		<a class="add" href="{url module=PostAdmin return=$smarty.server.REQUEST_URI}">{$tr->add|escape}</a>
	</div>	
	
	{* Search | Поиск *}
	{if $posts || isset($keyword)}
	<form method="get">
		<div id="search">
			<input type="hidden" name="module" value='BlogAdmin'>
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
	<!-- Pagination| Листалка страниц (The End) -->

	<form id="form_list" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
	
		<div id="list">
			{foreach $posts as $post}
			<div class="{if !$post->visible}invisible{/if} row">
				<input type="hidden" name="positions[{$post->id}]" value="{if isset($post->position)}{$post->position}{/if}">
		 		<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$post->id}" />				
				</div>
				<div class="name cell">		
					<a href="{url module=PostAdmin id=$post->id return=$smarty.server.REQUEST_URI}">{$post->name|escape}</a>
					<br>
					{$post->date|date}
				</div>
				<div class="icons cell">
					<a class="preview" title="{$tr->open_on_page|escape}" href="../blog/{$post->url}" target="_blank"></a>
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

<div id="right_menu" class="articlesright">
	<!-- Categories | Категории -->
	<ul>
		<li {if empty($cat)}class="selected"{/if}><a href="index.php?module=BlogAdmin"><i class="fa fa-angle-right"></i>Все записи</a></li>
		{foreach $blog_categories as $bc}
		<li {if $bc->id == $cat->id}class="selected"{/if}><a href="index.php?module=BlogAdmin&category_id={$bc->id}"><i class="fa fa-angle-right"></i>{$bc->name}</a></li>
		{/foreach}
	</ul>
	<!-- Categories | Категории (The End)-->
</div>	


{* On document load *}
{literal}

<script>
$(function() {

	// Colorize list items | Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Colorize on page load | Раскрасить строки сразу
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
			data: {'object': 'blog', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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