{* Вкладки *}
{capture name=tabs}
	{if in_array('surveys_categories', $manager->permissions)}<li><a href="{url module=SurveysCategoriesAdmin page=null keyword=null}">{$tr->surveys_categories}</a></li>{/if}
	<li class="active"><a href="index.php?module=SurveysAdmin">{$tr->surveys}</a></li>
{/capture}

{* Title *}
{$meta_title=$tr->surveys scope=root}

<div class="headerseparator">		
{* Заголовок *}
<div id="header">
	{if !empty($keyword) && !empty($posts_count)}
	<h1>{$tr->found|escape} {$tr->found_posts|escape}: {$posts_count}</h1>
	{elseif $posts_count}
	<h1>{$tr->found_posts|capitalize}: {$posts_count}</h1>
	{else}
	<h1>{$tr->no_content|escape}</h1>
	{/if}
	<a class="add" href="{url module=SurveyAdmin return=$smarty.server.REQUEST_URI}">{$tr->add|escape}</a>
</div>	

{* Поиск *}
{if !empty($posts) || !empty($keyword)}
<form method="get">
<div id="search">
	<input type="hidden" name="module" value='SurveysAdmin'>
	<input class="search" type="text" name="keyword" value="{if !empty($keyword)}{$keyword|escape}{/if}" />
	<input class="search_button" type="submit" value=""/>
</div>
</form>
{/if}
</div>

{if $posts}
<div id="main_list" class="surveyspage">
	
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->

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
					<a href="{url module=SurveyAdmin id=$post->id return=$smarty.server.REQUEST_URI}">{$post->name|escape}</a>
					<br>
					{$post->date|date} [<a class="participants" href="{url module=ParticipantSurveyAdmin id=$post->id return=$smarty.server.REQUEST_URI}">{$tr->participants|lower}</a>]
				</div>
				<div class="icons cell">
					<a class="preview" title="{$tr->open_on_page|escape}" href="../survey/{$post->url}" target="_blank"></a>
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

	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
	
</div>
{/if}
<!-- Меню -->
<div id="right_menu" slacc="surveysright">

	<!-- Категории -->
	{function name=surveys_categories_tree}
	{if $surveys_categories}
	<ul>
		{if $surveys_categories[0]->parent_id == 0}
		<li {if empty($category->id)}class="selected"{/if}><a href="{url category_id=null}">{$tr->all_categories}</a></li>	
		{/if}
		{foreach $surveys_categories as $c}
			<li category_id="{$c->id}" {if !empty($category->id) && $category->id == $c->id}class="selected"{else}class="droppable category"{/if}><a href='{url keyword=null page=null category_id={$c->id}}'>{$c->name}</a></li>
			{if !empty($c->subcategories)}
				{surveys_categories_tree surveys_categories=$c->subcategories}
			{/if}	
		{/foreach}
	</ul>
	{/if}
	{/function}
	{surveys_categories_tree surveys_categories=$surveys_categories}
	<!-- Категории (The End)-->
</div>	
	
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

	// Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();

	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Удалить 
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest(".row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Скрыт/Видим
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'surveys', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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
	
	// Подтверждение удаления
	$("form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_deletion|escape}{literal}'))
			return false;	
	});
});

</script>
{/literal}
