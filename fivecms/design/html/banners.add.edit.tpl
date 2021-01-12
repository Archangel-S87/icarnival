{* Вкладки *}
{capture name=tabs}
	<li><a href="index.php?module=BannersAdmin&do=groups">{$tr->banners_groups|escape}</a></li>
	{if !empty($banners_group->name)}<li><a href="{$smarty.get.return}">{$tr->group|escape} » {$banners_group->name}</a></li>{/if}
	<li class="active"><a href="{$smarty.server.REQUEST_URI}">{if !empty($banner)}{$tr->change_banner|escape} » "{$banner->name}"{else}{$tr->add_banner|escape}{/if}</a></li>
{/capture}

{* Title *}
{$meta_title=$tr->banner|escape scope=root}

{include file='tinymce_init.tpl'}

<div id="onecolumn">
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->

	{* Заголовок *}
	<div id="header" style="margin-bottom:0px;">	
		<h1>{if !empty($banner)}{$tr->change_banner|escape} "{$banner->name}"{else}{$tr->add_banner|escape}{/if}</h1>
	</div>

	<link href="design/css/banners.css" rel="stylesheet" type="text/css" />
	
	{if !empty($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span>{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success|escape}{/if}</span>
		{if $smarty.get.return}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}

	{if !empty($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span>{if $message_error=='error_uploading_image'}{$tr->upload_error}{elseif $message_error=='empty_name'}{$tr->enter_s_name}{elseif $message_error=='not_image'}{$tr->not_image|escape}{elseif $message_error=='empty_url'}{$tr->banner_empty_url|escape}{else}{$message_error|escape}{/if}</span>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if empty($message_success)}
	{* Основная форма *}
	<form method=post id=product enctype="multipart/form-data">
		<input type=hidden name="session_id" value="{if !empty($smarty.session.id)}{$smarty.session.id}{/if}">
		{if !empty($banner->image)}<input type=hidden name="image_exist" value="yes">{/if}
		
		<table><tr><td valign="top" style="padding:5px;">
			<div class="checkbox" style="display:block; padding:0;margin-bottom:10px;">
				<input name="visible" value="1" type="checkbox" {if !empty($banner->visible)}checked{/if}/> <label for="active_checkbox">{$tr->enabled|escape}</label>
			</div>
			<div class="block">
				<ul>
					<li><label class=property>{$tr->name|escape}</label>						
					<input type="text" class="fivecms_inp" value="{if !empty($banner->name)}{$banner->name}{/if}" name="name" required /></li>
					<li><label class=property>{$tr->link|escape}</label>						
					<input placeholder="{$tr->form_url_placeholder|escape} /test" type="text" class="fivecms_inp" value="{if !empty($banner->url)}{$banner->url}{/if}" name="url"/></li>
					<li><label class=property>{$tr->banner_image|escape}</label>			
					<input type="file" class="fivecms_inp" value="" name="image"" id="imageFile"/></li>
					<li><label style="display:table;font-weight:700;margin-bottom:10px;">{$tr->description|escape}</label>						
					<textarea class="editor_small" name="description" style="width:93%;max-width:93%;">{if !empty($banner->description)}{$banner->description}{/if}</textarea></li>
				</ul>
			</div>
		</td>
		<td id="imageThumb">{if !empty($banner->image)}{math assign='random' equation='rand(10,1000)'}<img src="/{$config->banners_images_dir}{$banner->image}?{$random}" alt="">{else}<span>{$tr->no_image|escape}</span>{/if}
		</td>
		</tr></table>
		<br />
		<div>
			<table><tr><td valign="top"  style="padding:5px;">
				<h2>{$tr->banner|escape} {$tr->show_on|escape}:</h2>				
				<input name="show_all_pages" value="1" type="checkbox" {if !empty($banner->show_all_pages)}checked{/if} id="show_all_pages"/> <label for="show_all_pages" class="property" style="display:inline;float:none;color:black;">{$tr->all_site_pages|escape}</label>
				<br/><br/>
				<ul>
					<li>
						<p class=property style="font-weight:700;margin-bottom:10px;">{$tr->pages|escape}:</p>
						<select name="pages[]" multiple="multiple" size="10" style="width:450px;height:150px;">
							<option value='0' {if empty($banner->page_selected) || 0|in_array:$banner->page_selected}selected{/if}>{$tr->dont_show|escape}</option>
							{foreach from=$pages item=page}
								{if $page->name != ''}<option value='{$page->id}' {if isset($banner->page_selected) && $page->id|in_array:$banner->page_selected}selected{/if}>{$page->name|escape}</option>{/if}
							{/foreach}
						</select>
					</li>
					<li>
						<p class=property style="font-weight:700;margin:10px 0;">{$tr->brands|escape}:</p>
						<select name="brands[]" multiple="multiple" size="10" style="width:450px;height:150px;">
							<option value='0' {if empty($banner->brand_selected) || 0|in_array:$banner->brand_selected}selected{/if}>{$tr->dont_show|escape}</option>
							{foreach from=$brands item=brand}
								<option value='{$brand->id}' {if isset($banner->brand_selected) && $brand->id|in_array:$banner->brand_selected}selected{/if}>{$brand->name|escape}</option>
							{/foreach}
						</select>
					</li>
				</ul>
			</td><td valign="top" style="padding-top:75px; padding-left:20px; width:50%">
				<ul>
					<li>
						<p class=property style="font-weight:700;margin-bottom:10px;">{$tr->categories|escape}:</p>
						<select name="categories[]" multiple="multiple" size="10" style="width:450px;height:325px;">
							<option value='0' {if empty($banner->category_selected) || 0|in_array:$banner->category_selected}selected{/if}>{$tr->dont_show|escape}</option>
							{function name=category_select level=0}
								{foreach from=$categories item=category}
										<option value='{$category->id}' {if isset($selected) && $category->id|in_array:$selected}selected{/if}>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$category->name|escape}</option>
										{if !empty($category->subcategories)}
											{category_select categories=$category->subcategories selected=$banner->category_selected  level=$level+1}
										{/if}
								{/foreach}
							{/function}
							{category_select categories=$categories selected=$banner->category_selected}
						</select>
					</li>
				</ul>
			</td></tr></table>
		</div>
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
	</form>

	{literal}
	<script>
	  function handleFileSelect(evt) {
		var files = evt.target.files; // FileList object

		// Loop through the FileList and render image files as thumbnails.
		for (var i = 0, f; f = files[i]; i++) {

		  // Only process image files.
		  if (!f.type.match('image.*')) {
			continue;
		  }

		  var reader = new FileReader();

		  // Closure to capture the file information.
		  reader.onload = (function(theFile) {
			return function(e) {
			  // Render thumbnail.
			  $("#imageThumb").html('<img valign="absmiddle" src="'+e.target.result+'" title="'+escape(theFile.name)+'"/>');
			};
		  })(f);

		  // Read in the image file as a data URL.
		  reader.readAsDataURL(f);
		}
	  }

	  document.getElementById('imageFile').addEventListener('change', handleFileSelect, false);
	</script>
	{/literal}
	{/if}
</div>