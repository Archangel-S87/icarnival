{capture name=tabs}
	<li class="active"><a href="index.php?module=ThemeAdmin">{$tr->theme|escape}</a></li>
	<li><a href="index.php?module=TemplatesAdmin">{$tr->templates|escape}</a></li>		
	<li><a href="index.php?module=StylesAdmin">{$tr->styles|escape}</a></li>		
	<li><a href="index.php?module=ImagesAdmin">{$tr->images|escape}</a></li>
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ColorAdmin">{$tr->gamma|escape}</a></li>{/if}
	{if in_array('slides', $manager->permissions)}<li><a href="index.php?module=SlidesAdmin">{$tr->slider|escape}</a></li>{/if}	
{/capture}

{if !empty($theme->name)}
	{$meta_title = "{$theme->name}" scope=root}
{/if}

<script>
{literal}
	
$(function() {

	// Выбрать тему
	$('.set_main_theme').click(function() {
     	$("form input[name=action]").val('set_main_theme');
    	$("form input[name=theme]").val($(this).closest('li').attr('theme'));
    	$("form").submit();
	});	
	
	// Клонировать текущую тему
	$('#header .add').click(function() {
     	$("form input[name=action]").val('clone_theme');
    	$("form").submit();
	});	
	
	// Редактировать название
	$("a.edit").click(function() {
		name = $(this).closest('li').attr('theme');
		inp1 = $('<input type=hidden name="old_name[]">').val(name);
		inp2 = $('<input type=text name="new_name[]">').val(name);
		$(this).closest('li').find("p.name").html('').append(inp1).append(inp2);
		inp2.focus().select();
		return false;
	});
	
	// Удалить тему
	$('.delete').click(function() {
     	$("form input[name=action]").val('delete_theme');
     	$("form input[name=theme]").val($(this).closest('li').attr('theme'));
   		$("form").submit();
	});	

	$("form").submit(function() {
		if($("form input[name=action]").val()=='delete_theme' && !confirm('{/literal}{$tr->confirm_deletion|escape}{literal}'))
			return false;	
	});
	
});
{/literal}
</script>

<div id="header">
<h1 class="{if $theme->locked}locked{/if}">{$tr->theme}: {$theme->name}</h1>
<a class="add" href="#">{$tr->copy_theme} {$settings->theme}</a>
</div>
{if $theme->locked}<p style="margin-bottom:15px;">* {$tr->edit_copy_theme}</p>{/if}
{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">{if $message_error == 'permissions'}{$tr->no_permission} {$themes_dir}
	{elseif $message_error == 'name_exists'}{$tr->theme}/{$tr->file_exists|lower}
	{else}{$message_error}{/if}</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

<div class="block layer">

<form method="post" enctype="multipart/form-data">
	<input type="hidden" name="session_id" value="{$smarty.session.id}" />
	<input type="hidden" name="action" />
	<input type="hidden" name="theme" />

	<ul class="themes">
	{foreach $themes as $t}
		{if $t->name != "mobile" && $t->name != "mail"}
			<li theme='{$t->name|escape}'>
				{if $theme->name == $t->name}<img class="tick" src='design/images/tick.png'> {/if}
				{if $t->locked}<img class="tick" src='design/images/lock_small.png'> {/if}
				{if !$t->locked}
				<a href='#' title="{$tr->delete|escape}" class='delete'><img src='design/images/delete.png'></a>
				<a href='#' title="{$tr->rename}" class='edit'><img src='design/images/pencil.png'></a>
				{/if}
				{if $theme->name == $t->name}
				<p class=name>{$t->name|escape|truncate:16:'...'}</p>
				{else}
				<p class=name><a href='#' title="{$tr->set_main_theme}" class='set_main_theme'>{$t->name|escape|truncate:16:'...'}</a></p>
				{/if}
				<a href="index.php?module=TemplatesAdmin"><img class="preview" src='../design/{$t->name}/preview.png'></a>
			</li>
		{/if}
	{/foreach}
	</ul>

	<div class="block">
		<input style="float:left;margin-top:20px;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
	</div>
</form>

</div>
