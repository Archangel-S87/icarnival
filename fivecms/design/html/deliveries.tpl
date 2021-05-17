{* Вкладки *}
{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main|escape}</a></li>{/if}
	{if in_array('currency', $manager->permissions)}<li><a href="index.php?module=CurrencyAdmin">{$tr->currencies|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=DeliveriesAdmin">{$tr->delivery|escape}</a></li>
	{if in_array('payment', $manager->permissions)}<li><a href="index.php?module=PaymentMethodsAdmin">{$tr->payment|escape}</a></li>{/if}
	{if in_array('managers', $manager->permissions)}<li><a href="index.php?module=ManagersAdmin">{$tr->managers|escape}</a></li>{/if}
	{if in_array('discountgroup', $manager->permissions)}<li><a href="index.php?module=DiscountGroupAdmin">{$tr->discounts|escape}</a></li>{/if}
{/capture}

{* Title *}
{$meta_title = $tr->delivery scope=root}

{* Заголовок *}
<div id="header" style="margin-bottom:0;">
	<h1>{$tr->delivery|escape}</h1>
	<a class="add" href="{url module=DeliveryAdmin}">{$tr->add|escape}</a>
</div>	

<div id="main_list" style="max-width: 680px;">
	
	<form id="list_form" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
	
	<div class="block" style="margin-bottom:20px;">
		<ul>
			<li style="margin-bottom:5px;"><label style="width:430px;display:inline-block;" class="property">{$tr->feature_weight}:</label>
				<input style="max-width:50px;font-size:14px;" name="feature_weight" class="fivecms_inp" type="number" value="{$settings->feature_weight|escape}" min="1" step="1"/>
			</li>
			<li style="margin-bottom:5px;"><label style="width:430px;display:inline-block;" class="property">{$tr->feature_volume}:</label>
				<input style="max-width:50px;font-size:14px;" name="feature_volume" class="fivecms_inp" type="number" value="{$settings->feature_volume|escape}" min="1" step="1"/>
			</li>
			<li style="margin-bottom:5px;"><label style="width:430px;display:inline-block;" class="property">{$tr->min_weight}:</label>
				<input style="max-width:50px;font-size:14px;" name="min_weight" class="fivecms_inp" type="number" value="{$settings->min_weight|escape}" min="0" step="0.01"/>
			</li>
			<li><label style="width:430px;display:inline-block;" class="property">{$tr->min_volume}:</label>
				<input style="max-width:50px;font-size:14px;" name="min_volume" class="fivecms_inp" type="number" value="{$settings->min_volume|escape}" min="0" step="0.001"/>
			</li>
		</ul>
	</div>

	<div id="list">
		{foreach $deliveries as $delivery}
				<div class="{if !$delivery->enabled}invisible{/if} row">
					<input type="hidden" name="positions[{$delivery->id}]" value="{$delivery->position}">
					<div class="move cell"><div class="move_zone"></div></div>
			 		<div class="checkbox cell">
						<input {if $delivery->id == 3 || $delivery->id == 4 || $delivery->id == 114 || $delivery->id == 121}disabled{/if} type="checkbox" name="check[]" value="{$delivery->id}" />				
					</div>
					<div class="name cell">
						<a href="{url module=DeliveryAdmin id=$delivery->id return=$smarty.server.REQUEST_URI}">{$delivery->name|escape}</a> [id={$delivery->id}]
					</div>
					<div class="icons cell">
						<a class="enable" title="{$tr->active|escape}" href="#"></a>
						{if $delivery->id == 3 || $delivery->id == 4 || $delivery->id == 114 || $delivery->id == 121}{else}<a class="delete" title="{$tr->delete|escape}" href="#"></a>{/if}
					</div>
					<div class="clear"></div>
				</div>
		{/foreach}
	</div>

	<div id="action">
	<label id="check_all" class='dash_link'>{$tr->choose_all|escape}</label>

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
			data: {'object': 'delivery', 'id': id, 'values': {'enabled': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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
		if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete}{literal}'))
			return false;	
	});


});

</script>
{/literal}
