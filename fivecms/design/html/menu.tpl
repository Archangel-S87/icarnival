{capture name=tabs}
	{if in_array('pages', $manager->permissions)}<li><a href="index.php?module=PagesAdmin">{$tr->pages|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=MenuAdmin">{$tr->pages_menu|escape}</a></li>
{/capture}

{$meta_title = $tr->pages_menu scope=root}

{* On document load *}
{literal}
<script>
$(function() {

	// Сортировка списка
	$("#currencies_block").sortable({ items: 'ul.sortable' , axis: 'y',  cancel: '#header', handle: '.move_zone' });

	// Добавление меню
	var curr = $('#new_currency').clone(true);
	$('#new_currency').remove().removeAttr('id');
	$('a#add_currency').click(function() {
		$(curr).clone(true).appendTo('#currencies').fadeIn('slow').find("input[name*=menu][name*=name]").focus();
		return false;		
	});	
	
	// Удаление меню
	$("a.delete").click(function() {
		$('input[type="hidden"][name="action"]').val('delete');
		$('input[type="hidden"][name="action_id"]').val($(this).closest("ul").find('input[type="hidden"][name*="menu[id]"]').val());
		$(this).closest("form").submit();
	});
	
	// Скрыт/Видим
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest("ul");
		var id          = line.find('input[name*="menu[id]"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'menu', 'id': id, 'values': {'enabled': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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
	
	$("form").submit(function() {
		if($('input[type="hidden"][name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_deletion}{literal}'))
			return false;	
	});

});

</script>
{/literal}

<div id="onecolumn" class="menupage">

	<!-- Заголовок -->
	<div id="header">
		<h1>{$tr->pages_menu|escape}</h1>
		<a class="add" id="add_currency" href="#">{$tr->add|escape}</a>
	<!-- Заголовок (The End) -->	
	</div>	

	<form method=post>
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
	
	<!-- Меню -->
	<div id="currencies_block">
		<ul id="header">
			<li class="move"></li>
			<li class="menuID">ID</li>	
			<li class="name">{$tr->menu_name|escape}</li>	
		</ul>
		<div id="currencies">
		{foreach from=$menus item=m}
		<ul class="sortable {if !$m->enabled}invisible{/if}">
			<li class="move"><div class="move_zone"></div></li>
			<li class="menuID"><input name="menu[id][{$m->id}]" type="hidden" value="{$m->id|escape}" /><span>{$m->id|escape}</span></li>
			<li class="name"><input name="menu[name][{$m->id}]" type="" value="{$m->name|escape}" /></li>
			<li class="icons">
			{*{if !$m@first}*}
				{if $m->id != 1 && $m->id != 18}
				<a class="enable" title="{$tr->active|escape}" href="#"></a>
				{/if}
				{if $m->id > 20 || $m->id == 2}
				<a class="delete" href="#" title="{$tr->delete|escape}"></a>	
				{/if}
			{*{/if}*}
			</li>
		</ul>
		{/foreach}
		<ul id="new_currency" style='display:none;'>
			<li class="move"><div class="move_zone"></div></li>
			<li class="menuID"><input name="menu[id][]" type="hidden" value="" /></li>
			<li class="name"><input name="menu[name][]" type="" value="" /></li>
			<li class="icons"></li>
		</ul>
		</div>

	</div>
	<!-- Меню (The End)--> 

	<div id="action">
		<input type=hidden name=action value=''>
		<input type=hidden name=action_id value=''>
		<input id='apply_action' class="button_green" type=submit value="{$tr->save|escape}">
	</div>
	</form>

</div>

