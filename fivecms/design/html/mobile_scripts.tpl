{capture name=tabs}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobthemeAdmin">{$tr->gamma_mob|escape}</a></li>{/if}
	{if in_array('slides', $manager->permissions)}<li><a href="index.php?module=SlidesmAdmin">{$tr->slider_mob|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobsetAdmin">{$tr->settings_mob|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobileTemplatesAdmin">{$tr->templates|escape} ({$tr->mob|escape})</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobileStylesAdmin">{$tr->styles_mob|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=MobileScriptsAdmin">JS</a></li>		
{/capture}

{if $script_file}
{$meta_title = "$script_file" scope=root}
{/if}

{* Подключаем редактор кода *}
<link rel="stylesheet" href="design/js/codemirror/lib/codemirror.css">
<script src="design/js/codemirror/lib/codemirror.js"></script>

<script src="design/js/codemirror/mode/javascript/javascript.js"></script>
<script src="design/js/codemirror/addon/selection/active-line.js"></script>
 
{literal}
<style type="text/css">

.CodeMirror{
	font-family:'Courier New';
	margin-bottom:10px;
	border:1px solid #c0c0c0;
	background-color: #ffffff;
	height: auto;
	min-height: 300px;
	width:100%;
}
.CodeMirror-scroll
{
	overflow-y: hidden;
	overflow-x: auto;
}
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
			url: 'ajax/save_script.php',
			data: {'content': content, 'theme':'{/literal}{$theme}{literal}', 'script': '{/literal}{$script_file}{literal}', 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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

<h1>{$tr->theme}: {$theme}, {$tr->file}: {$script_file}</h1>

{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">
	{if $message_error == 'permissions'}{$tr->set_permissions} {$script_file}
	{elseif $message_error == 'theme_locked'}{$tr->theme_protected}.
	{else}{$message_error}{/if}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

<div class="block layer">
	<div class="templates_names">
		{foreach item=s from=$scripts}
			<a {if $script_file == $s}class="selected"{/if} href='index.php?module=MobileScriptsAdmin&file={$s}'>{$s}</a>
		{/foreach}
	</div>
</div>

{if $script_file}
<div class="block">
	<form>
		<textarea id="content" name="content" style="width:700px;height:500px;">{$script_content|escape}</textarea>
	</form>

	<input class="button_green button_save" type="button" name="save" value="{$tr->save}" />
</div>

{* Подключение редактора *}
{literal}
<script>
	var editor = CodeMirror.fromTextArea(document.getElementById("content"), {
		mode: "javascript",		
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