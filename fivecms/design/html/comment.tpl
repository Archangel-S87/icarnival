{* Вкладки *}
{capture name=tabs}
	<li class="active"><a href="index.php?module=CommentsAdmin">{$tr->comments|escape}</a></li>
	{if in_array('feedbacks', $manager->permissions)}<li><a href="index.php?module=FeedbacksAdmin">{$tr->feedback|escape}</a></li>{/if}
	{if in_array('feedbacks', $manager->permissions)}<li><a href="index.php?module=FormsAdmin">{$tr->forms|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MailTemplatesAdmin">{$tr->mail_templates|escape}</a></li>{/if}
{/capture}

{* Title *}
{$meta_title = $tr->comment scope=root}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

{* On document load *}
<script src="design/js/jquery/datepicker/jquery.ui.datepicker-ru.js"></script>

<script>
$(function() { 
	$('input[name="date"]').datepicker({ 
		regional:'{$admin_lang}'
	});
});
</script>

<div id="onecolumn" class="commentpage">

	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span>{if $message_success == 'updated'}{$tr->updated|escape}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input class="name" name=name type="text" value="{$comment->name|escape}"/> 
			<input name=id type="hidden" value="{$comment->id|escape}"/> 
			<input name="type" type="hidden" value="{$comment->type|escape}">
			<input name="email" type="hidden" value="{$comment->email|escape}">
			<input name="object_id" type="hidden" value="{$comment->object_id|escape}">
			<div class="checkbox">
				<input name=approved value='1' type="checkbox" id="active_checkbox" {if $comment->approved}checked{/if}/> <label for="active_checkbox">{$tr->approved|escape}</label>
			</div>
		</div> 
	
		<!-- Левая колонка -->
		<div id="column_left">
				
			<!-- Параметры страницы -->
			<div class="block">
				<ul>
					<li><label style="margin-right:10px;" class=property>{$tr->date|escape}</label>{$comment->date|date} в {$comment->date|time}</li>
					{if $comment->type == 'product'}
						<li><label style="margin-right:10px;" class=property>{$tr->comment_product|escape}</label><a target="_blank" href="{$config->root_url}/products/{$comment->product->url}#comment_{$comment->id}">{$comment->product->name}</a></li>
					{elseif $comment->type == 'blog' && !empty($comment->post->name)}
						<li><label style="margin-right:10px;" class=property>{$tr->comment_blog|escape}</label><a target="_blank" href="{$config->root_url}/blog/{$comment->post->url}#comment_{$comment->id}">{$comment->post->name}</a></li>
					{elseif $comment->type == 'response' && !empty($comment->response->name)}
						<li><label style="margin-right:10px;" class=property>Комментарий к странице</label><a target="_blank" href="{$config->root_url}/{$comment->response->url}">{$comment->response->name}</a></li>	
					{/if}
	
				</ul>
			</div>
		</div>
		<!-- Левая колонка (The End)--> 
		
		<!-- Правая колонка -->	
		<div id="column_right">
			<div class="block">
				<ul>
					<li><label class=property>E-mail</label>{$comment->email}</li>
					<li><label class=property>IP</label>{$comment->ip}</li>
				</ul>
			</div>
		</div>
		<!-- Правая колонка (The End)--> 
	
		<!-- Комментарий -->
		<div class="block layer">
			<h2>{$tr->comment_text|escape}</h2>
			<textarea name="text" style="width:99%;max-width:99%;height:150px;">{$comment->text|escape}</textarea>
	
		</br></br>
		<h2>{$tr->comment_otvet|escape}</h2> 
		<textarea name="otvet" class="editor_small" style="clear: right;">{$comment->otvet|escape}</textarea>
		{if $comment->email}<div style="margin-top: 10px;">		
			<input type="checkbox" value="1" id="notify_user" name="notify_user">
			<label for="notify_user">{$tr->comment_notify|escape}</label>
			</div>
		{/if}
	
		</div>
	
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Основная форма (The End) -->

</div>

