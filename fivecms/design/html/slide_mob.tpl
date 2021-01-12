
<link href="design/css/slides.css" rel="stylesheet" type="text/css" />
{capture name=tabs}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobthemeAdmin">{$tr->gamma_mob|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=SlidesmAdmin">{$tr->slider_mob|escape}</a></li>
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobsetAdmin">{$tr->settings_mob|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobileTemplatesAdmin">{$tr->templates} ({$tr->mob})</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MobileStylesAdmin">{$tr->styles_mob|escape}</a></li>{/if}
{/capture}

{if !empty($slidem->id)}
{$meta_title = $slidem->name scope=root}
{else}
{$meta_title = $tr->slide scope=root}
{/if}

{* On document load *}
{literal}
<script>
$(function() {

	// Delete images | Удаление изображений
	$("a.button_slidem_delete").click( function() {
		$("input[name='delete_image']").val('1');
		$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
		return false;
	});

});
</script>
{/literal}

<div id="onecolumn" class="slidempage">

	{if isset($message_success)}
	<!-- System message | Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success}{/if}</span>
		{if isset($smarty.get.return)}
			<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- System message | Системное сообщение (The End)-->
	{/if}
	
	<!-- Main form | Основная форма -->
	<form method=post  enctype="multipart/form-data">
		
		<input type=hidden name="session_id" value="{$smarty.session.id}">
			
		<ul class="slide">
			<li>
				<div class="slidetitle">
					<p style="font-weight:700;">* {$tr->slide_width|escape} 1100px</p>
				</div>
			</li>
			<li>
				<label>{$tr->name|escape}:</label>
				<div>
					<input placeholder="{$tr->enter_s_name|escape}" class="name" name=name type="text" value="{if !empty($slidem->name)}{$slidem->name|escape}{/if}" required /> 
					<input name=id type="hidden" value="{if !empty($slidem->id)}{$slidem->id|escape}{/if}"/> 
				</div>
			</li>
			<li>
				<label>{$tr->url|escape}:</label>
				<div>
					<input name="url" class="page_url" type="text" value="{if !empty($slidem->url)}{$slidem->url|escape}{/if}" />
					<div class="tip">{$tr->example|escape}: <strong>/products/samsung-s5570-galaxy-mini</strong></div>
				</div>
			</li>
			<li>
				<label>{$tr->image|escape}:</label>
				<div>
					<ul>
						<li>
							<input class='upload_image' name=image type=file value="test">			
							<input type=hidden name="delete_image" value="">
							<input class="button_slide" type="submit" name="" value="{$tr->save|escape}" />
						</li>
						{if !empty($slidem->image)}
						<ul>
							<li>
								<div class="tip">
									{$img_url=$config->root_url|cat:'/'|cat:$slidem->image}
									{$img_url}
									{assign var="info" value=$img_url|getimagesize}
									&nbsp;({$info.0} x {$info.1}px)
								</div>
								<a href='#' class="button_slide_delete">{$tr->delete|escape}</a>
							</li>
							<li class="image">
								<img src="../{$slidem->image}?{math equation='rand(10,10000)'}" alt="" />
							</li>
						</ul>
						{/if}
					</ul>
				</div>
			</li>

		</ul>
	
	</form>
	<!-- Main form | Основная форма (The End) -->

</div>

