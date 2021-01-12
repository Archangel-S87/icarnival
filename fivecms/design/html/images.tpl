{capture name=tabs}
	<li><a href="index.php?module=ThemeAdmin">{$tr->theme|escape}</a></li>
	<li><a href="index.php?module=TemplatesAdmin">{$tr->templates|escape}</a></li>		
	<li><a href="index.php?module=StylesAdmin">{$tr->styles|escape}</a></li>		
	<li class="active"><a href="index.php?module=ImagesAdmin">{$tr->images|escape}</a></li>
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ColorAdmin">{$tr->gamma|escape}</a></li>{/if}
	{if in_array('slides', $manager->permissions)}<li><a href="index.php?module=SlidesAdmin">{$tr->slider|escape}</a></li>{/if}	
{/capture}

{$meta_title = $tr->images|escape scope=root}

{* On document load *}
{literal}
<script>
$(function() {

	// Редактировать
	$("a.edit").click(function() {
		name = $(this).closest('li').attr('name');
		inp1 = $('<input type=hidden name="old_name[]">').val(name);
		inp2 = $('<input type=text name="new_name[]">').val(name);
		$(this).closest('li').find("p.name").html('').append(inp1).append(inp2);
		inp2.focus().select();
		return false;
	});
 
	// Удалить 
	$("a.delete").click(function() {
		name = $(this).closest('li').attr('name');
		$('input[name=delete_image]').val(name);
		$(this).closest("form").submit();
	});
	
	// Загрузить
	$("#upload_image").click(function() {
		$(this).closest('div').append($('<input type=file name=upload_images[]>'));
	});
	
	$("form").submit(function() {
		if($('input[name="delete_image"]').val()!='' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
			return false;	
	});

});
</script>
{/literal}

<h1>{$tr->images|escape} (<span style="text-transform:lowercase;">{$tr->theme|escape}</span> "{$theme}")</h1>

{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">{if $message_error == 'permissions'}{$tr->set_permissions|escape} {$images_dir}
	{elseif $message_error == 'name_exists'}{$tr->file_exists|escape}
	{elseif $message_error == 'theme_locked'}{$tr->theme_protected}
	{elseif $message_error == 'not_allowed_extention'}{$tr->not_allowed_extention|escape}
	{else}{$message_error}{/if}</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

<form method="post" enctype="multipart/form-data">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
	<input type="hidden" name="delete_image" value="">
	<!-- Список файлов для выбора -->
	<div class="block layer">
		<ul class="theme_images">
			{foreach item=image from=$images}
				<li name='{$image->name|escape}'>
				<a href='#' class='delete' title="{$tr->delete|escape}"><img src='design/images/delete.png'></a>
				<a href='#' class='edit' title="{$tr->rename|escape}"><img src='design/images/pencil.png'></a>
				<p class="name">{$image->name|escape|truncate:16:'...'}</p>
			
					{$pathinfo = $image->name|escape|pathinfo:$smarty.const.PATHINFO_EXTENSION}
					{if in_array($pathinfo, array('png', 'gif', 'jpg', 'jpeg', 'ico', 'webp', 'jp2', 'jxr'))}
					<div class="theme_image">
						<a class="preview zoom" href='../{$images_dir}{$image->name|escape}'><img src='../{$images_dir}{$image->name|escape}'></a>
					</div>
					<p class=size>{if $image->size>1024*1024}{($image->size/1024/1024)|round:2} Mb{elseif $image->size>1024}{($image->size/1024)|round:2} Kb{else}{$image->size} b{/if}, {$image->width}&times;{$image->height} px</p>	
					{else}
					<div class="theme_image">
						<span class="preview">
							<svg id="folder" style="fill: #dadada;width:96px;height:96px;" viewBox="0 0 24 24"> <path d="M10 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z"></path><path d="M0 0h24v24H0z" fill="none"></path> </svg>
						</span>
					</div>
					<p class=size>{if $image->size>1024*1024}{($image->size/1024/1024)|round:2} Mb{elseif $image->size>1024}{($image->size/1024)|round:2} Kb{else}{$image->size} b{/if}</p>
					{/if}
			
				</li>
			{/foreach}
		</ul>
	</div>

	<div class="block upload_image">
		<span id="upload_image"><i class="dash_link">{$tr->upload_image|escape}</i></span>
	</div>

	<div class="block">
		<input class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
	</div>

</form>
