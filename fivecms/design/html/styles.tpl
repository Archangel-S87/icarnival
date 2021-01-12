{capture name=tabs}
	<li><a href="index.php?module=ThemeAdmin">{$tr->theme|escape}</a></li>
	<li><a href="index.php?module=TemplatesAdmin">{$tr->templates|escape}</a></li>		
	<li class="active"><a href="index.php?module=StylesAdmin">{$tr->styles|escape}</a></li>		
	<li><a href="index.php?module=ImagesAdmin">{$tr->images|escape}</a></li>
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ColorAdmin">{$tr->gamma|escape}</a></li>{/if}
	{if in_array('slides', $manager->permissions)}<li><a href="index.php?module=SlidesAdmin">{$tr->slider|escape}</a></li>{/if}		
{/capture}

{if $style_file}
{$meta_title = "$style_file" scope=root}
{/if}

{* Подключаем редактор кода *}
<link rel="stylesheet" href="design/js/codemirror/lib/codemirror.css">
<script src="design/js/codemirror/lib/codemirror.js"></script>

<script src="design/js/codemirror/mode/css/css.js"></script>
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
			url: 'ajax/save_style.php',
			data: {'content': content, 'theme':'{/literal}{$theme}{literal}', 'style': '{/literal}{$style_file}{literal}', 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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

<h1>{$tr->theme}: {$theme}, CSS: {$style_file}</h1>

{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">
	{if $message_error == 'permissions'}{$tr->set_permissions} {$style_file}
	{elseif $message_error == 'theme_locked'}{$tr->theme_protected}.
	{else}{$message_error}{/if}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

<div class="block layer">
	<div class="templates_names">
		{foreach item=s from=$styles}
			<a {if $style_file == $s}class="selected"{/if} href='index.php?module=StylesAdmin&file={$s}'>{$s}</a>
		{/foreach}
	</div>
</div>

{if $style_file}
<div class="block">
	<form>
		<textarea id="content" name="content" style="width:700px;height:500px;">{$style_content|escape}</textarea>
	</form>

	{if isset($message_error) && $message_error == 'theme_locked'}
		<div class="message message_error"><span class="text">
			{$tr->theme_protected}.
		</span></div>
	{else}
		<input class="button_green button_save" type="button" name="save" value="{$tr->save}" />
	{/if}
</div>

{* Подключение редактора *}
{literal}
<script>
	var editor = CodeMirror.fromTextArea(document.getElementById("content"), {
		mode: "css",		
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