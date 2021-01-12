<style type="text/css">
.icons a.edit { background-image: url(design/images/pencil.png); }
</style>

{* Вкладки *}
{capture name=tabs}
	<li class="active"><a href="index.php?module=CommentsAdmin">{$tr->comments|escape}</a></li>
	{if in_array('feedbacks', $manager->permissions)}<li><a href="index.php?module=FeedbacksAdmin">{$tr->feedback|escape}</a></li>{/if}
	{if in_array('feedbacks', $manager->permissions)}<li><a href="index.php?module=FormsAdmin">{$tr->forms|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MailTemplatesAdmin">{$tr->mail_templates|escape}</a></li>{/if}
{/capture}

{* Title *}
{$meta_title = $tr->comments scope=root}

<div class="headerseparator">
	{* Заголовок *}
	<div id="header">
		{if !empty($keyword) && $comments_count || empty($type)}
		<h1>{$tr->comments_count|escape}: {$comments_count}</h1> 
		{elseif $type=='product'}
		<h1>{$tr->comments_count|escape} {$tr->comments_products|escape}: {$comments_count}</h1> 
		{elseif $type=='blog'}
		<h1>{$tr->comments_count|escape} {$tr->comments_blog|escape}: {$comments_count}</h1> 
		{/if}
	</div>	
	
	{* Поиск *}
	{if !empty($comments) || !empty($keyword)}
	<form method="get">
	<div id="search">
		<input type="hidden" name="module" value='CommentsAdmin'>
		<input class="search" type="text" name="keyword" value="{if !empty($keyword)}{$keyword|escape}{/if}" />
		<input class="search_button" type="submit" value=""/>
	</div>
	</form>
	{/if}
</div>

{if $comments}
<div id="main_list" class="commentspage" style="width:730px;">
	
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
	
	<form id="list_form" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
	
		<div id="list" class="sortable">
			{foreach $comments as $comment}
			<div class="{if !$comment->approved}unapproved{/if} row">
		 		<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$comment->id}"/>				
				</div>
				<div class="name cell">
					<div class="comment_name">
					{$comment->name|escape} ({$comment->email|escape}) IP: {$comment->ip|escape}
					<a class="approve" href="#">{$tr->approve|escape}</a>
					</div>
					
					<div class="comment_body">{$comment->text|escape|nl2br}</div>
			
					{if $comment->otvet}
					<div class="comment_admint">{$tr->comment_otvet|escape}:</div>
					<div class="comment_admin">
						{$comment->otvet}
					</div>
					{/if}

					<div class="comment_info">
					{$comment->date|date} {$comment->date|time}
					{if $comment->type == 'product'}
						{$tr->comment_product|escape} <a target="_blank" href="{$config->root_url}/products/{$comment->product->url}#comment_{$comment->id}">{$comment->product->name}</a>
					{elseif $comment->type == 'blog' && !empty($comment->post->name)}
						{$tr->comment_blog|escape} <a target="_blank" href="{$config->root_url}/blog/{$comment->post->url}#comment_{$comment->id}">"{$comment->post->name}"</a>
					{elseif $comment->type == 'response' && !empty($comment->response->name)}
						{$tr->page|capitalize} <a target="_blank" href="{$config->root_url}/{$comment->response->url}">"{$comment->response->name}"</a>
					{elseif $comment->type == 'response'}
						{$tr->website_responses}
					{/if}
					</div>
				</div>
				<div class="icons cell">
					<a style="margin-right: 10px;" class="edit" title="{$tr->edit|escape}" href="{url module=CommentAdmin id=$comment->id return=$smarty.server.REQUEST_URI}"></a>
					<a class="delete" title="{$tr->delete|escape}" href="#"></a>
				</div>
				<div class="clear"></div>
			</div>
			{/foreach}
		</div>
	
		<div id="action">
		{$tr->choose_comments} 
	
		<span id="select">
		<select name="action">
			<option value="approve">{$tr->approve|escape}</option>
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
{else}
	<div id="main_list" class="commentspage">
		{$tr->no_content|escape}
	</div>
{/if}

<!-- Меню -->
<div id="right_menu" class="commentsright">
	<ul>
		<li {if !isset($type)}class="selected"{/if}><a href="{url type=null}">{$tr->all_comments|escape}</a></li>
	</ul>
	<ul>
		<li {if !empty($type) && $type == 'product'}class="selected"{/if}><a href='{url keyword=null type=product}'>{$tr->comments_products|escape}</a></li>
		<li {if !empty($type) && $type == 'blog'}class="selected"{/if}><a href='{url keyword=null type=blog}'>{$tr->comments_blog|escape}</a></li>
		<li {if !empty($type) && $type == 'response'}class="selected"{/if}><a href='{url keyword=null type=response}'>{$tr->website_responses|lower}</a></li>
	</ul>
</div>
<!-- Меню  (The End) -->

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

	// Выделить ожидающие
	$("#check_unapproved").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$('#list .unapproved input[type="checkbox"][name*="check"]').attr('checked', true);
	});	

	// Удалить 
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest(".row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Одобрить
	$("a.approve").click(function() {
		var line        = $(this).closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'comment', 'id': id, 'values': {'approved': 1}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				line.removeClass('unapproved');
			},
			dataType: 'json'
		});	
		return false;	
	});
	
	$("form#list_form").submit(function() {
		if($('#list_form select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
			return false;	
	});	
 	
});

</script>
{/literal}

