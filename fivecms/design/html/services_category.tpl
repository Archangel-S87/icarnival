{capture name=tabs}
	<li class="active"><a href="index.php?module=ServicesCategoriesAdmin">{$tr->services|escape}</a></li>
{/capture}

{if !empty($category->id)}
	{$meta_title = $category->name scope=root}
{else}
	{$meta_title = $tr->new_post|escape scope=root}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

{* On document load *}
{literal}
<style>
	.autocomplete-w1 { background:url(img/shadow.png) no-repeat bottom right; position:absolute; top:0px; left:0px; margin:6px 0 0 6px; /* IE6 fix: */ _background:none; _margin:1px 0 0 0; }
	.autocomplete { border:1px solid #999; background:#FFF; cursor:default; text-align:left; overflow-x:auto; min-width: 300px; overflow-y: auto; margin:-6px 6px 6px -6px; /* IE6 specific: */ _height:350px;  _margin:0; _overflow-x:hidden; }
	.autocomplete .selected { background:#F0F0F0; }
	.autocomplete div { padding:2px 5px; white-space:nowrap; }
	.autocomplete strong { font-weight:normal; color:#3399FF; }
</style>

<script>
$(function() {

	// Удаление изображений
	$(".images a.delete").click( function() {
		$("input[name='delete_image']").val('1');
		$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
		return false;
	});

	$(".images ul").sortable({ tolerance: 'pointer' });

	$(".images a.deletes").live('click', function() {
		 $(this).closest("li").fadeOut(200, function() { $(this).remove(); });
		 return false;
	});

	$('#upload_image').click(function() {
		$("<input class='upload_image' name=images[] type=file multiple  accept='image/jpeg,image/png,image/gif,image/webp,image/jp2,image/jxr'>").appendTo('div#add_image').focus().click();
	});

	// Автозаполнение мета-тегов
	meta_title_touched = true;
	meta_keywords_touched = true;
	meta_description_touched = true;
	menu_item_name_touched = true;
	url_touched = true;
	
	if($('input[name="menu"]').val() == generate_menu_item_name() || $('input[name="menu"]').val() == '')
		menu_item_name_touched = false;
	if($('input[name="meta_title"]').val() == generate_meta_title() || $('input[name="meta_title"]').val() == '')
		meta_title_touched = false;
	if($('input[name="meta_keywords"]').val() == generate_meta_keywords() || $('input[name="meta_keywords"]').val() == '')
		meta_keywords_touched = false;
	if($('textarea[name="meta_description"]').val() == generate_meta_description() || $('textarea[name="meta_description"]').val() == '')
		meta_description_touched = false;
	if($('input[name="url"]').val() == generate_url() || $('input[name="url"]').val() == '')
		url_touched = false;
		
	$('input[name="menu"]').change(function() { menu_item_name_touched = true; });	
	$('input[name="meta_title"]').change(function() { meta_title_touched = true; });
	$('input[name="meta_keywords"]').change(function() { meta_keywords_touched = true; });
	$('textarea[name="meta_description"]').change(function() { meta_description_touched = true; });
	$('input[name="url"]').change(function() { url_touched = true; });
	
	$('input[name="name"]').keyup(function() { set_meta(); });
	  
});

function set_meta()
{
	if(!menu_item_name_touched)
		$('input[name="menu"]').val(generate_menu_item_name());
	if(!meta_title_touched)
		$('input[name="meta_title"]').val(generate_meta_title());
	if(!meta_keywords_touched)
		$('input[name="meta_keywords"]').val(generate_meta_keywords());
	if(!meta_description_touched)
		$('textarea[name="meta_description"]').val(generate_meta_description());
	if(!url_touched)
		$('input[name="url"]').val(generate_url());
}

function generate_menu_item_name()
{
	name = $('input[name="name"]').val();
	return name;
}

function generate_meta_title()
{
	name = $('input[name="name"]').val();
	return name;
}

function generate_meta_keywords()
{
	name = $('input[name="name"]').val();
	return name;
}

function generate_meta_description()
{
	if( typeof tinymce != "undefined" )
	{
		return myCustomGetContent( "description" );
	}
	else
		return $('textarea[name=description]').val().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ").replace(/^\s+|\s+$/g, '').substr(0, 512);
}

function generate_url()
{
	url = $('input[name="name"]').val();
	url = url.replace(/[\s]+/gi, '-');
	url = translit(url);
	url = url.replace(/[^0-9a-z_\-]+/gi, '').toLowerCase();	
	return url;
}

function translit(str)
{
	var ru=("А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я").split("-")   
	var en=("A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch-'-'-Y-y-'-'-E-e-YU-yu-YA-ya").split("-")   
 	var res = '';
	for(var i=0, l=str.length; i<l; i++)
	{ 
		var s = str.charAt(i), n = ru.indexOf(s); 
		if(n >= 0) { res += en[n]; } 
		else { res += s; } 
    } 
    return res;  
}
</script>
 
{/literal}

<div id="onecolumn" class="servicescategory">

	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success}{/if}</span>
		<a class="link" target="_blank" href="../services/{$category->url}">{$tr->open_on_page|escape}</a>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span class="text">{if $message_error=='url_exists'}{$tr->exists|escape}{else}{$message_error}{/if}</span>
		<a class="button" href="">{$tr->return|escape}</a>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
		<input type=hidden name="session_id" value="{$smarty.session.id}" />
		<div id="name">
			<input placeholder="{$tr->enter_name|escape}" class="name" name=name type="text" value="{if !empty($category->name)}{$category->name|escape}{/if}" required /> 
			<input name=id type="hidden" value="{if !empty($category->id)}{$category->id|escape}{/if}"/> 
			<div class="checkbox">
				<input name=visible value='1' type="checkbox" id="active_checkbox" {if !empty($category->visible)}checked{/if}/> <label for="active_checkbox">{$tr->active|escape}</label>
			</div>
		</div> 
	
		<div id="product_categories">
				<select name="parent_id">
					<option value='0'>{$tr->root_category|escape}</option>
					{function name=services_category_select level=0}
						{foreach from=$services_cats item=cat}
							{if !empty($category->id) && $category->id == $cat->id}
							{else}
								<option value='{$cat->id}' {if !empty($category->parent_id) && $category->parent_id == $cat->id}selected{/if}>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$cat->menu}</option>
								{if !empty($cat->subcategories)}
									{services_category_select services_cats=$cat->subcategories level=$level+1}
								{/if}
							{/if}
						{/foreach}
					{/function}
					{services_category_select services_cats=$services_categories}
				</select>
		</div>
			
		<!-- Левая колонка свойств -->
		<div id="column_left" style="display:table;">
				
			<!-- Параметры страницы -->
			<div class="block layer">
				<ul>
					<li>
						<label style="width: 180px;" class=property>{$tr->name_menu_item|escape}</label><input style="width:390px;" name="menu" class="fivecms_inp" type="text" value="{if !empty($category->menu)}{$category->menu|escape}{/if}" required />
					</li>
				</ul>
				<h2>{$tr->page_parameters|escape}</h2>
				<ul>
					<li><label style="width: 78px;" class=property>{$tr->url|escape}</label><div class="page_url">/services/</div><input style="width:426px;" name="url" class="page_url" type="text" value="{if !empty($category->url)}{$category->url|escape}{/if}" /></li>
					<li><label style="width: 90px;" class=property>{$tr->meta_title|escape}</label><input style="width:480px;" id="text-count1" name="meta_title" class="fivecms_inp" type="text" value="{if !empty($category->meta_title)}{$category->meta_title|escape}{/if}" /><span style="margin-left: 5px;" id="count1"></span></li>
					<li><label style="width: 90px;" class=property>{$tr->keywords|escape}</label><input style="width:480px;" id="text-count2" name="meta_keywords" class="fivecms_inp" type="text" value="{if !empty($category->meta_keywords)}{$category->meta_keywords|escape}{/if}" /><span style="margin-left: 5px;" id="count2"></span></li>
					<li><label style="width: 90px;" class=property>{$tr->meta_description|escape}</label><textarea id="text-count3" style="width: 480px; max-width: 480px; min-width: 480px;" maxlength="200" name="meta_description" class="fivecms_inp" />{if !empty($category->meta_description)}{$category->meta_description|escape}{/if}</textarea><span style="margin-left: 5px;" id="count3"></span></li>
				</ul>
			</div>
			<!-- Параметры страницы (The End)-->
			
		</div>
		<!-- Левая колонка свойств (The End)--> 
		
		<!-- Правая колонка свойств -->	
		<div id="column_right">
			<!-- Изображение категории -->	
			{math assign='random' equation='rand(10,1000)'}
			<div class="block layer images">
				<h2>{$tr->main_image|escape} 160x160px</h2>
				<input class='upload_image' name=image type=file>			
				<input type=hidden name="delete_image" value="">
				{if !empty($category->image)}
				<ul>
					<li>
						<a href='#' class="delete"><img src='design/images/cross-circle-frame.png'></a>
						<img src="../{$config->services_categories_images_dir}{$category->image}?{$random}" alt="" />
					</li>
				</ul>
				{/if}
			</div>
			<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
	
			<div class="block layer images">
				<h2>{$tr->additional_images|escape}</h2>
				<p style="margin-bottom:15px;">({$tr->max|escape} 800x600px {$tr->or|escape} 600x600px)</p>
				<ul>
					{foreach from=$post_images item=image}
					<li>
						<a href='#' class="deletes"><img src='design/images/cross-circle-frame.png'></a>
						<a href="{$image->filename|resize:800:600:w:$config->resized_services_images_dir}?{$random}" class="zoom" data-rel="group"><img src="{$image->filename|resize:400:400:false:$config->resized_services_images_dir}?{$random}" alt="" /></a>
						<input type=hidden name='images[]' value='{$image->id}'>
					</li>
					{/foreach}
				</ul>
				<div id=add_image></div>
				<span class=upload_image><i class="dash_link" id="upload_image">{$tr->upload_image|escape}</i></span>
				<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
			</div>
		</div>
		<!-- Правая колонка свойств (The End)--> 
		<!-- Описание категории -->
		<div class="block layer">
			<h2>{$tr->page_text|escape} <span class="helper">(<a class="helperlink" href="#helper">{$tr->standart|escape}</a>)</span></h2>
			<textarea name="description" class="editor_small">{if !empty($category->description)}{$category->description|escape}{/if}</textarea>
		</div>
		<!-- Описание категории (The End)-->
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
	</form>
	<!-- Основная форма (The End) -->
</div>

<script type="text/javascript">
{literal}
	$(function()
	{
		$('#text-count3').keyup(function()
		{
			var curLength = $('#text-count3').val().length;
			var remaning = curLength;
			if (remaning < 0) remaning = 0;
			$('#count3').html(remaning);
		})
		$('#text-count1').keyup(function()
		{
			var curLength = $('#text-count1').val().length;
			var remaning = curLength;
			if (remaning < 0) remaning = 0;
			$('#count1').html(remaning);  
		})
	});
{/literal}
</script>
