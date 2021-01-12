<link href="design/css/slides.css" rel="stylesheet" type="text/css" />
{literal}
<style>
#list{width:500px;}
#list .cell{float:left !important;width:490px;}
.title{text-align:left;}
.form_title {max-width:395px;display:inline-block;margin-left:10px;color:#156fa2;text-decoration:none;font-weight:700;}
</style>
{/literal}
{capture name=tabs}
	{if in_array('comments', $manager->permissions)}<li><a href="index.php?module=CommentsAdmin">{$tr->comments|escape}</a></li>{/if}
	{if in_array('feedbacks', $manager->permissions)}<li><a href="index.php?module=FeedbacksAdmin">{$tr->feedback|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=FormsAdmin">{$tr->forms|escape}</a></li>
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MailTemplatesAdmin">{$tr->mail_templates|escape}</a></li>{/if}
{/capture}

{$meta_title = $tr->forms|escape scope=root}

{* Title | Заголовок *}
<div id="header">
	<h1>{$tr->forms|escape}</h1> 
	<a class="add" href="{url module=FormAdmin return=$smarty.server.REQUEST_URI}">{$tr->add|escape}</a>
</div>	

{if $forms}
<div id="main_list" class="slides">
	
	<form id="list_form" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">

		<div id="list">
			{foreach $forms as $form}            
			<div class="{if isset($form->visible) && !$form->visible}invisible{/if} row">
				<input type="hidden" name="positions[{$form->id}]" value="{if isset($form->position)}{$form->position}{/if}" />
				
				<div class="form_name cell slide">

						<div class="title">
							<input type="checkbox" name="check[]" value="{$form->id}" />	
							<a class="form_title" href="{url module=FormAdmin id=$form->id return=$smarty.server.REQUEST_URI}">
								{$form->name|escape}
							</a>
							<a title="{$tr->delete|escape}" class="delete" href='#' ></a>
							<a class="enable" title="{$tr->active|escape}" href="#"></a>
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
	
	// Choose all | Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', 1-$('#list input[type="checkbox"][name*="check"]').attr('checked'));
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
				data: {'object': 'form', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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
