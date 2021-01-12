<link href="design/css/slides.css" rel="stylesheet" type="text/css" />
{capture name=tabs}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ThemeAdmin">{$tr->theme}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=TemplatesAdmin">{$tr->templates}</a></li>{/if}		
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=StylesAdmin">{$tr->styles}</a></li>{/if}		
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ImagesAdmin">{$tr->images}</a></li>{/if}		
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ColorAdmin">{$tr->gamma}</a></li>{/if}
	<li class="active"><a href="index.php?module=SlidesAdmin">{$tr->slider}</a></li>
{/capture}

{* Title *}
{$meta_title=$tr->slider scope=root}

{* Заголовок *}
<div id="header">
	<h1>{$tr->slider}</h1> 
	<a class="add" href="{url module=SlideAdmin return=$smarty.server.REQUEST_URI}">{$tr->add} {$tr->slide|lower}</a>
</div>	

{if $slides}
<div id="list" class="slides">

	<form id="slidermode_form" method="post" style="border-bottom:2px dashed #dadada;padding-bottom:20px;">
		<input type="hidden" name="session_id" value="{$smarty.session.id}">
		<ul style="margin-bottom:15px;">
			<li><label style="font-weight:700;margin-right:10px;" class="property">{$tr->choose} {$tr->slider_type}:</label>
				<select name="slidermode" class="fivecms_inp" style="width: 180px;">
					<option value='wideslider' {if $settings->slidermode == 'wideslider'}selected{/if}>{$tr->wideslider}</option>
					<option value='tinyslider' {if $settings->slidermode == 'tinyslider'}selected{/if}>{$tr->tinyslider}</option>
					<option value='sideslider' {if $settings->slidermode == 'sideslider'}selected{/if}>{$tr->sideslider}</option>
				</select>
			</li>
		</ul>
		<input class="button_green" type="submit" value="{$tr->save}">
		<a class="bigbutton" href="index.php?module=ThreeBannersAdmin">{$tr->banners} {$tr->close_slider}</a>
	</form>
	
	<form id="list_form" method="post">
		<input type="hidden" name="session_id" value="{$smarty.session.id}">
		<h2 style="text-transform:uppercase; margin-top:20px;">{$tr->slides}:</h2>
		<div id="list">
			{foreach $slides as $slide}            
			<div class="{if !$slide->visible}invisible{/if} row">
				<input type="hidden" name="positions[{$slide->id}]" value="{$slide->position}" />
				
				<div class="cell slide">
					<div class="slide_wrapper">
						
						<div class="title">
							<input type="checkbox" name="check[]" value="{$slide->id}" />	
							<a href="{url module=SlideAdmin id=$slide->id return=$smarty.server.REQUEST_URI}">
							{$slide->name|escape}
							</a>
							<a title="{$tr->delete}" class="delete" href='#' ></a>
							<a title="{$tr->active}" class="enable" href="#"></a>
						</div>
						
						<div class="slide">
							<a href="{url module=SlideAdmin id=$slide->id return=$smarty.server.REQUEST_URI}">
							{if $slide->image}
								<img src="../{$slide->image}?{math equation='rand(10,10000)'}">
							{else}
								{$tr->no_image}
							{/if}
							</a>
						</div>
						
						{if $slide->image}
						<div class="tip">
							{$img_url=$config->root_url|cat:'/'|cat:$slide->image}
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

	// Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();
	
	// Сортировка списка
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
	
	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Удалить
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Подтверждение удаления
	$("form").submit(function() {
		if($('#list input[type="checkbox"][name*="check"]:checked').length>0)
			if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_deletion|escape}{literal}'))
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
            data: {'object': 'slide', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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