{* Вкладки *}
{capture name=tabs}
	{if in_array('orders', $manager->permissions)}
		<li {if isset($status) && $status===0}class="active"{/if}><a href="{url module=OrdersAdmin status=0 keyword=null id=null page=null label=null}">{$tr->new_pl|escape}</a></li>
		<li {if isset($status) && $status==4}class="active"{/if}><a href="{url module=OrdersAdmin status=4 keyword=null id=null page=null label=null}">{$tr->status_in_processing|escape}</a></li>
		<li {if isset($status) && $status==1}class="active"{/if}><a href="{url module=OrdersAdmin status=1 keyword=null id=null page=null label=null}">{$tr->status_accepted_pl|escape}</a></li>
		<li {if isset($status) && $status==5}class="active"{/if}><a href="{url module=OrdersAdmin status=5 keyword=null id=null page=null label=null}">{$tr->status_delivery_pl|escape}</a></li>
		<li {if isset($status) && $status==2}class="active"{/if}><a href="{url module=OrdersAdmin status=2 keyword=null id=null page=null label=null}">{$tr->status_completed_pl|escape}</a></li>
		<li {if isset($status) && $status==3}class="active"{/if}><a href="{url module=OrdersAdmin status=3 keyword=null id=null page=null label=null}">{$tr->status_canceled_pl|escape}</a></li>
		{if isset($keyword)}
		<li class="active"><a href="{url module=OrdersAdmin keyword=$keyword id=null label=null}">{$tr->search|escape}</a></li>
		{/if}
	{/if}
	<li class="active"><a href="{url module=OrdersLabelsAdmin keyword=null id=null page=null label=null}">{$tr->labels|escape}</a></li>
{/capture}

{* Title *}
{$meta_title=$tr->orders_labels scope=root}

{* Заголовок *}
<div id="header">
	<h1>{if $labels}{$tr->orders_labels|escape}{else}Нет меток{/if}</h1>
	<a class="add" href="{url module=OrdersLabelAdmin}">{$tr->add|escape}</a>
</div>

{if $labels}
<div id="main_list" style="max-width:71%;min-width:780px;">
 
	<form id="list_form" method="post">
		<input type="hidden" name="session_id" value="{$smarty.session.id}">
		<div id="list">		
			{foreach $labels as $label}
			<div class="row">
				<input type="hidden" name="positions[{$label->id}]" value="{$label->position}">
				<div class="move cell"><div class="move_zone"></div></div>
		 		<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$label->id}" />				
				</div>
				<div class="name cell">
					<span style="background-color:#{$label->color};" class="order_label"></span>
					<a href="{url module=OrdersLabelAdmin id=$label->id return=$smarty.server.REQUEST_URI}">{$label->name|escape}</a>
				</div>
				<div class="icons cell">
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
		forcePlaceholderSize: true,
		axis: 'y',
		
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
		$(".row:even").addClass('even');
		$(".row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();
 

	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Удалить 
	$("a.delete").click(function() {
		$('#list_form input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest(".row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Подтверждение удаления
	$("form").submit(function() {
		if($('#list input[type="checkbox"][name*="check"]:checked').length>0)
			if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_deletion|escape}{literal}'))
				return false;	
	});
});
</script>
{/literal}
