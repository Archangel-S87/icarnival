<link href="design/css/slides.css" rel="stylesheet" type="text/css" />
{capture name=tabs}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobthemeAdmin">{$tr->gamma_mob|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=SlidesmAdmin">{$tr->slider_mob|escape}</a></li>
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobsetAdmin">{$tr->settings_mob|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobileTemplatesAdmin">{$tr->templates} ({$tr->mob})</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobileStylesAdmin">{$tr->styles_mob|escape}</a></li>{/if}
{/capture}

{$meta_title = $tr->slider_mob scope=root}

{* Title | Заголовок *}
<div id="header">
	<h1>{$tr->slider_mob|escape}</h1> 
	<a class="add" href="{url module=SlidemAdmin return=$smarty.server.REQUEST_URI}">{$tr->add|escape}</a>
</div>	

{if $slidesm}
<div id="list" class="slides">
	
	<form id="list_form" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">

		<div id="list">
			{foreach $slidesm as $slidem}            
			<div class="{if !$slidem->visible}invisible{/if} row">
				<input type="hidden" name="positions[{$slidem->id}]" value="{$slidem->position}" />
				
				<div class="cell slide">
					<div class="slide_wrapper">
						
						<div class="title">
							<input type="checkbox" name="check[]" value="{$slidem->id}" />	
							<a href="{url module=SlidemAdmin id=$slidem->id return=$smarty.server.REQUEST_URI}">
								{$slidem->name|escape}
							</a>
							<a title="{$tr->delete|escape}" class="delete" href='#' ></a>
							<a class="enable" title="{$tr->active|escape}" href="#"></a>
						</div>
						
						<div class="slide">
							<a href="{url module=SlidemAdmin id=$slidem->id return=$smarty.server.REQUEST_URI}">
							{if $slidem->image}
								<img src="../{$slidem->image}?{math equation='rand(10,10000)'}">
							{else}
								{$tr->no_image|escape}
							{/if}
							</a>
						</div>
						
						{if $slidem->image}
						<div class="tip">
							{$img_url=$config->root_url|cat:'/'|cat:$slidem->image}
							{$img_url}
							{assign var="info" value=$img_url|getimagesize}<br />
							{$info.0} x {$info.1}px
						</div>
						{/if}
					</div>

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
	// Colorixe on load | Раскрасить строки сразу
	colorize();
	
	// Sort list | Сортировка списка
	$("#list").sortable({
		items:             ".row",
		tolerance:         "pointer",
		handle:            ".slide_wrapper",
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
	
	// Choose all | Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
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
	

	$("a.enable").click(function() {
			var icon        = $(this);
			var line        = icon.closest(".row");
			var id          = line.find('input[type="checkbox"][name*="check"]').val();
			var state       = line.hasClass('invisible')?1:0;
			icon.addClass('loading_icon');
			$.ajax({
				type: 'POST',
				url: 'ajax/update_object.php',
				data: {'object': 'slidem', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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

	});
</script>
{/literal}
