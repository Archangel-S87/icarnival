{capture name=tabs}
	<li class="active"><a href="index.php?module=SurveysCategoriesAdmin">{$tr->surveys_categories}</a></li>
	{if in_array('surveys', $manager->permissions)}<li><a href="index.php?module=SurveysAdmin">{$tr->surveys}</a></li>{/if}
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
<script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
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

	// Автозаполнение мета-тегов
	meta_title_touched = true;
	meta_keywords_touched = true;
	meta_description_touched = true;
	url_touched = true;
	
	if($('input[name="meta_title"]').val() == generate_meta_title() || $('input[name="meta_title"]').val() == '')
		meta_title_touched = false;
	if($('input[name="meta_keywords"]').val() == generate_meta_keywords() || $('input[name="meta_keywords"]').val() == '')
		meta_keywords_touched = false;
	if($('textarea[name="meta_description"]').val() == generate_meta_description() || $('textarea[name="meta_description"]').val() == '')
		meta_description_touched = false;
	if($('input[name="url"]').val() == generate_url() || $('input[name="url"]').val() == '')
		url_touched = false;
		
	$('input[name="meta_title"]').change(function() { meta_title_touched = true; });
	$('input[name="meta_keywords"]').change(function() { meta_keywords_touched = true; });
	$('textarea[name="meta_description"]').change(function() { meta_description_touched = true; });
	$('input[name="url"]').change(function() { url_touched = true; });
	
	$('input[name="name"]').keyup(function() { set_meta(); });
	  
});

function set_meta()
{
	if(!meta_title_touched)
		$('input[name="meta_title"]').val(generate_meta_title());
	if(!meta_keywords_touched)
		$('input[name="meta_keywords"]').val(generate_meta_keywords());
	if(!meta_description_touched)
		$('textarea[name="meta_description"]').val(generate_meta_description());
	if(!url_touched)
		$('input[name="url"]').val(generate_url());
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

<div id="onecolumn" class="surveyscategorypage">

	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success}{/if}</span>
		<a class="link" target="_blank" href="../surveys/{$category->url}">{$tr->open_on_page|escape}</a>
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
	<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input placeholder="{$tr->enter_name|escape}" class="name" name=name type="text" value="{if !empty($category->name)}{$category->name|escape}{/if}" required /> 
			<input name=id type="hidden" value="{if !empty($category->id)}{$category->id|escape}{/if}"/> 
			<div class="checkbox">
				<input name=visible value='1' type="checkbox" id="active_checkbox" {if !empty($category->visible)}checked{/if}/> <label for="active_checkbox">{$tr->active|escape}</label>
			</div>
		</div> 
	
		<div id="product_categories">
				<select name="parent_id">
					<option value='0'>{$tr->root_category}</option>
					{function name=surveys_category_select level=0}
						{foreach from=$surveys_cats item=cat}
							{if !empty($category->id) && $category->id == $cat->id}
							{else}
								<option value='{$cat->id}' {if $category->parent_id == $cat->id}selected{/if}>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$cat->name}</option>
								{if !empty($cat->subcategories)}
									{surveys_category_select surveys_cats=$cat->subcategories level=$level+1}
								{/if}
							{/if}
						{/foreach}
					{/function}
					{surveys_category_select surveys_cats=$surveys_categories}
				</select>
		</div>
			
		<!-- Левая колонка -->
		<div id="column_left">
				
			<!-- Параметры страницы -->
			<div class="block layer">
				<h2>{$tr->page_parameters|escape}</h2>
				<ul>
					<li><label style="width: 90px;" class=property>{$tr->url|escape}</label><div class="page_url">/surveys/</div><input style="width:334px;" name="url" class="page_url" type="text" value="{if !empty($category->url)}{$category->url|escape}{/if}" /></li>
					<li><label style="width: 90px;" class=property>{$tr->meta_title|escape}</label><input id="text-count1" name="meta_title" class="fivecms_inp" type="text" value="{if !empty($category->meta_title)}{$category->meta_title|escape}{/if}" /><span style="margin-left: 5px;" id="count1"></span></li>
					<li><label style="width: 90px;" class=property>{$tr->keywords|escape}</label><input id="text-count2" name="meta_keywords" class="fivecms_inp" type="text" value="{if !empty($category->meta_keywords)}{$category->meta_keywords|escape}{/if}" /><span style="margin-left: 5px;" id="count2"></span></li>
					<li><label style="width: 90px;" class=property>{$tr->meta_description|escape}</label><textarea id="text-count3" style="width: 400px;" maxlength="200" name="meta_description" class="fivecms_inp" />{if !empty($category->meta_description)}{$category->meta_description|escape}{/if}</textarea><span style="margin-left: 5px;" id="count3"></span></li>
				</ul>
			</div>
			<!-- Параметры страницы (The End)-->

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
	
		</div>
		<!-- Левая колонка (The End)--> 
		
		<!-- Правая колонка -->	
		<div id="column_right">
			
			<!-- Изображение категории -->	
			<div class="block layer images">
				<h2>{$tr->category_image} (160x160px)</h2>
				<input class='upload_image' name=image type=file>			
				<input type=hidden name="delete_image" value="">
				{if !empty($category->image)}
				<ul>
					<li>
						<a href='#' class="delete"><img src='design/images/cross-circle-frame.png'></a>
						<img src="../{$config->surveys_categories_images_dir}{$category->image}" alt="" />
					</li>
				</ul>
				{/if}
			</div>
				<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
	
		</div>
		<!-- Правая колонка (The End)--> 
	
		<!-- Описание категории -->
		<div class="block layer">
			<h2>{$tr->description} <span class="helper">(<a class="helperlink" href="#helper">{$tr->standart}</a>)</span></h2>
			<textarea name="description" class="editor_small">{if !empty($category->description)}{$category->description|escape}{/if}</textarea>
		</div>
		<!-- Описание категории (The End)-->
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Основная форма (The End) -->

</div>
