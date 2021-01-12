{include file='tinymce_init.tpl'}
<link href="design/css/slides.css" rel="stylesheet" type="text/css" />
{capture name=tabs}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ThemeAdmin">{$tr->theme}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=TemplatesAdmin">{$tr->templates}</a></li>{/if}		
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=StylesAdmin">{$tr->styles}</a></li>{/if}		
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ImagesAdmin">{$tr->images}</a></li>{/if}		
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ColorAdmin">{$tr->gamma}</a></li>{/if}
	<li class="active"><a href="index.php?module=SlidesAdmin">{$tr->slider}</a></li>
{/capture}

{if !empty($slide->id)}
	{$meta_title = $slide->name scope=root}
{else}
	{$meta_title = $tr->new_post scope=root}
{/if}

{* On document load *}
{literal}
<script>
$(function() {

	// Удаление изображений
	$("a.button_slide_delete").click( function() {
		$("input[name='delete_image']").val('1');
		$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
		return false;
	});

});
</script>
{/literal}

<div id="onecolumn">
	
	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	<!-- Основная форма -->
	<form method=post  enctype="multipart/form-data">
		<input type=hidden name="session_id" value="{$smarty.session.id}">
		<ul class="slide">
			<li>
				<div class="slidetitle">
					<h2>{if !empty($slide->id)}{$tr->edit} {$tr->slide}{else}{$tr->add} {$tr->slide}{/if}</h2>
					{if $settings->slidermode == 'wideslider'}
						{$tr->wideslider_helper}
					{elseif $settings->slidermode == 'tinyslider'}
						{$tr->tinyslider_helper}
					{elseif $settings->slidermode == 'sideslider'}
						{$tr->sideslider_helper}
					{/if}
				</div>
			</li>
			<li>
				<label>{$tr->name}:</label>
				<div>
					<input class="name" name=name type="text" value="{if !empty($slide->name)}{$slide->name|escape}{/if}" required /> 
					<input name=id type="hidden" value="{if !empty($slide->id)}{$slide->id|escape}{/if}"/> 
				</div>
			</li>
			<li>
				<label>{$tr->url}:</label>
				<div>
					<input name="url" placeholder="{$tr->example}: products/samsung-s5570-galaxy-mini {$tr->or} http://site.ru" class="page_url" type="text" value="{if !empty($slide->url)}{$slide->url|escape}{/if}" />
				</div>
			</li>
			<li>
				<label>{$tr->image}:</label>
				<div>
					<ul>
						<li>
							<input class='upload_image' name=image type=file value="test">			
							<input type=hidden name="delete_image" value="">
							<input class="button_slide" type="submit" name="" value="{if !empty($slide->image)}{$tr->save}{else}{$tr->upload}{/if}" />
						</li>
						{if !empty($slide->image)}
						<ul>
							<li>
								<div class="tip">{$tr->file}: {$config->root_url}/{$slide->image}</div>
								<a href='#' class="button_slide_delete">{$tr->delete}</a>
							</li>
							<li class="image">
								<img src="../{$slide->image}?{math equation='rand(10,10000)'}" alt="" />
							</li>
						</ul>
						{/if}
					</ul>
				</div>
			</li>
			<li style="overflow:visible;">
				<label>{$tr->text}:</label>
				<div style="display: table;">
					<textarea name="description" class="editor_small">{if !empty($slide->description)}{$slide->description|escape}{/if}</textarea>
				</div>
			</li>
		</ul>
		<div class="separator" style="width:100%;">
			<input style="margin-top:20px;" class="button_slide" type="submit" name="" value="{$tr->save}" />
		</div>
	</form>
	<!-- Основная форма (The End) -->
</div>