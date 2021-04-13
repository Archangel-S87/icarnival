{* Вкладки *}
{capture name=tabs}
		{if in_array('comments', $manager->permissions)}<li><a href="index.php?module=CommentsAdmin">{$tr->comments|escape}</a></li>{/if}
		<li class="active"><a href="index.php?module=FeedbacksAdmin">{$tr->feedback|escape}</a></li>
		{if in_array('feedbacks', $manager->permissions)}<li><a href="index.php?module=FormsAdmin">{$tr->forms|escape}</a></li>{/if}
		{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MailTemplatesAdmin">{$tr->mail_templates|escape}</a></li>{/if}
{/capture}

{* Title *}
{$meta_title = $tr->feedback scope=root}


<div class="headerseparator">
	{* Заголовок *}
	<div id="header">
		{if $feedbacks_count}
		<h1>{$tr->feedbacks|escape}: {$feedbacks_count}</h1> 
		{else}
		<h1>{$tr->no_feedbacks|escape}</h1> 
		{/if}
	</div>	
	{* Поиск *}
	{if isset($feedbacks) || isset($keyword)}
	<form method="get">
	<div id="search">
		<input type="hidden" name="module" value='FeedbacksAdmin'>
		<input class="search" type="text" name="keyword" value="{if isset($keyword)}{$keyword|escape}{/if}" />
		<input class="search_button" type="submit" value=""/>
	</div>
	</form>
	{/if}
</div>

<div id="main_list" class="feedbackpage" style="max-width:800px;">
	
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
		
	{if $feedbacks}
		<form id="list_form" method="post">
		<input type="hidden" name="session_id" value="{$smarty.session.id}">
		
			<div id="list">
				
				{foreach $feedbacks as $feedback}
				<div class="row">
			 		<div class="checkbox cell">
						<input type="checkbox" name="check[]" value="{$feedback->id}" />				
					</div>
					<div class="name cell commentcell">
						<div class='comment_name'>
						<a href="mailto:{$feedback->name|escape}<{$feedback->email|escape}>?subject={$tr->feedback_subject|escape} {$feedback->name|escape}">{$feedback->name|escape}</a>

						</div>
						<div class='comment_text'>
							{$feedback->message|strip_tags|escape|nl2br}
						</div>
						<div class='comment_info'>
							{$feedback->date|date} {$feedback->date|time}{if !empty($feedback->ip)} | IP: {$feedback->ip|escape}{/if}
						</div>
					</div>
					<div class="icons cell">
						<a href='#' title='{$tr->delete|escape}' class="delete"></a>
					</div>
					<div class="clear"></div>
				</div>
				{/foreach}
			</div>
		
			<div id="action">
			<label id='check_all' class='dash_link'>{$tr->choose_all|escape}</label>
		
			<span id=select>
			<select name="action">
				<option value="delete">{$tr->delete|escape}</option>
			</select>
			</span>
		
			<input id='apply_action' class="button_green" type=submit value="{$tr->save|escape}">
		
			
		</div>
		</form>
		
	{else}
		{$tr->no_content|escape}
	{/if}
		
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
			
</div>



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
	
	// Подтверждение удаления
	$("form#list_form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
			return false;	
	});

});

</script>
{/literal}









