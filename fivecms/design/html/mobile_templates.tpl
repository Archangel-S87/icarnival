{capture name=tabs}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobthemeAdmin">{$tr->gamma_mob|escape}</a></li>{/if}
	{if in_array('slides', $manager->permissions)}<li><a href="index.php?module=SlidesmAdmin">{$tr->slider_mob|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobsetAdmin">{$tr->settings_mob|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=MobileTemplatesAdmin">{$tr->templates|escape} ({$tr->mob|escape})</a></li>
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobileStylesAdmin">{$tr->styles_mob|escape}</a></li>{/if}
{/capture}

{if $template_file}
{$meta_title = "$template_file ({$tr->mob|escape})" scope=root}
{/if}

{* Подключаем редактор кода *}
<link rel="stylesheet" href="design/js/codemirror/lib/codemirror.css">
<script src="design/js/codemirror/lib/codemirror.js"></script>

<script src="design/js/codemirror/mode/smarty/smarty.js"></script>
<script src="design/js/codemirror/mode/smartymixed/smartymixed.js"></script>
<script src="design/js/codemirror/mode/xml/xml.js"></script>
<script src="design/js/codemirror/mode/htmlmixed/htmlmixed.js"></script>
<script src="design/js/codemirror/mode/css/css.js"></script>
<script src="design/js/codemirror/mode/javascript/javascript.js"></script>

<script src="design/js/codemirror/addon/selection/active-line.js"></script>
 
{literal}
<style type="text/css">

.CodeMirror{
	margin-bottom:10px;
	border:1px solid #c0c0c0;
	background-color: #ffffff;
	height: auto;
	width:100%;
}
.CodeMirror-scroll
{
	overflow-y: hidden;
	overflow-x: auto;
}
.cm-s-default .cm-smarty.cm-tag{color: #ff008a;}
.cm-s-default .cm-smarty.cm-string {color: #007000;}
.cm-s-default .cm-smarty.cm-variable {color: #ff008a;}
.cm-s-default .cm-smarty.cm-variable-2 {color: #ff008a;}
.cm-s-default .cm-smarty.cm-variable-3 {color: #ff008a;}
.cm-s-default .cm-smarty.cm-property {color: #ff008a;}
.cm-s-default .cm-comment {color: #505050;}
.cm-s-default .cm-smarty.cm-attribute {color: #ff20Fa;}
</style>

<script>
$(function() {	
	// Сохранение кода аяксом
	function save()
	{
		$('.CodeMirror').css('background-color','#e0ffe0');
		content = editor.getValue();
		
		$.ajax({
			type: 'POST',
			url: 'ajax/save_template.php',
			data: {'content': content, 'theme':'{/literal}{$theme}{literal}', 'template': '{/literal}{$template_file}{literal}', 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
			
				$('.CodeMirror').animate({'background-color': '#ffffff'});
			},
			dataType: 'json'
		});
	}

	// Нажали кнопку Сохранить
	$('input[name="save"]').click(function() {
		save();
	});
	
	// Обработка ctrl+s
	var isCtrl = false;
	var isCmd = false;
	$(document).keyup(function (e) {
		if(e.which == 17) isCtrl=false;
		if(e.which == 91) isCmd=false;
	}).keydown(function (e) {
		if(e.which == 17) isCtrl=true;
		if(e.which == 91) isCmd=true;
		if(e.which == 83 && (isCtrl || isCmd)) {
			save();
			e.preventDefault();
		}
	});
});
</script>
{/literal}

<h1>{$tr->theme|escape}: {$theme}, {$tr->template|lower}: {$template_file}</h1>

{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">
	{if $message_error == 'permissions'}{$tr->set_permissions|escape} {$template_file}
	{elseif $message_error == 'theme_locked'}{$tr->theme_protected}
	{else}{$message_error}{/if}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

<!-- Список файлов для выбора -->
<div class="block layer">
	<div class="templates_names">
		{foreach item=t from=$templates}
			<a {if $template_file == $t}class="selected"{/if} href='index.php?module=MobileTemplatesAdmin&file={$t}'>{$t}</a>
		{/foreach}
	</div>
</div>

{if isset($template_file)}
	<div class="block">
		<form>
			<textarea id="template_content" name="template_content" style="width:700px;height:500px;">{$template_content|escape}</textarea>
		</form>

		{if isset($message_error) && $message_error == 'theme_locked'}
			<div class="message message_error"><span class="text">
				{$tr->theme_protected}
			</span></div>
		{else}
			<input class="button_green button_save" type="button" name="save" value="{$tr->save|escape}" />
		{/if}
	</div>

	{* Подключение редактора *}
	{literal}
	<script>
	var editor = CodeMirror.fromTextArea(document.getElementById("template_content"), {
			mode: "smartymixed",		
			lineNumbers: true,
			styleActiveLine: true,
			matchBrackets: false,
			enterMode: 'keep',
			indentWithTabs: false,
			indentUnit: 1,
			tabMode: 'classic',
			lineWrapping: true
		});
	</script>
	{/literal}
{/if}