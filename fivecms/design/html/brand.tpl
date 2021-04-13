{* Tabs | Вкладки *}
{capture name=tabs}
	{if in_array('products', $manager->permissions)}<li><a href="index.php?module=ProductsAdmin">{$tr->products|escape}</a></li>{/if}
	{if in_array('categories', $manager->permissions)}<li><a href="index.php?module=CategoriesAdmin">{$tr->categories|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=BrandsAdmin">{$tr->brands|escape}</a></li>
	{if in_array('features', $manager->permissions)}<li><a href="index.php?module=FeaturesAdmin">{$tr->features|escape}</a></li>{/if}
{/capture}

{if !empty($brand->id)}
	{$meta_title = $brand->name scope=root}
{else}
	{$meta_title = $tr->new_post scope=root}
{/if}

{include file='tinymce_init.tpl'}

{* On document load *}
{literal}
<script>
$(function() {

	// Delete images | Удаление изображений
	$(".images a.delete").click( function() {
		$("input[name='delete_image']").val('1');
		$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
		return false;
	});

	// Auto fill meta-tags | Автозаполнение мета-тегов
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
	$('input[textarea="meta_description"]').change(function() { meta_description_touched = true; });
	$('input[name="url"]').change(function() { url_touched = true; });
	
	$('input[name="name"]').keyup(function() { set_meta(); });
	
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
		name = $('input[name="name"]').val();
		return name;
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

});

</script>
 
{/literal}

<div id="onecolumn" class="brandpage">

	{if isset($message_success)}
	<!-- System message | Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success}{/if}</span>
		<a class="link" target="_blank" href="../brands/{$brand->url}">{$tr->open_on_page|escape}</a>
		{if $smarty.get.return}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	
		<span class="share">		
			<a href="#" onClick='window.open("http://vkontakte.ru/share.php?url={$config->root_url|urlencode}/brands/{$brand->url|urlencode}&title={$brand->name|urlencode}&description={$brand->description|urlencode}&image={$config->root_url|urlencode}/files/brands/{$brand->image|urlencode}&noparse=true","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/vk_icon.png" /></a>
			<a href="#" onClick='window.open("http://www.facebook.com/sharer.php?u={$config->root_url|urlencode}/brands/{$brand->url|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/facebook_icon.png" /></a>
			<a href="#" onClick='window.open("http://twitter.com/share?text={$brand->name|urlencode}&url={$config->root_url|urlencode}/brands/{$brand->url|urlencode}&hashtags={$brand->meta_keywords|replace:' ':''|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/twitter_icon.png" /></a>
		</span>
	
	
	</div>
	<!-- System message | Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- System message | Системное сообщение -->
	<div class="message message_error">
		<span class="text">{if $message_error=='url_exists'}{$tr->exists|escape}{else}{$message_error}{/if}</span>
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
	</div>
	<!-- System message | Системное сообщение (The End)-->
	{/if}
	
	
	<!-- Main form | Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input placeholder="{$tr->enter_name|escape}" class="name" name=name type="text" value="{if !empty($brand->name)}{$brand->name|escape}{/if}" required /> 
			<input name=id type="hidden" value="{if !empty($brand->id)}{$brand->id|escape}{/if}"/> 
			
			{if !empty($brand->external_id)}<div class="brand external_id">External_ID (1C): {$brand->external_id|escape}</div>{/if}
		</div> 
	
		<!-- Left column | Левая колонка -->
		<div id="column_left">
				
			<!-- Page parameters | Параметры страницы -->
			<div class="block layer">
				<h2>{$tr->page_parameters|escape}</h2>
				<ul>
					<li><label style="width: 90px;" class=property>{$tr->url|escape}</label><div class="page_url"> /brands/</div><input style="width: 354px;" name="url" class="page_url" type="text" value="{if !empty($brand->url)}{$brand->url|escape}{/if}" /></li>
					<li><label style="width: 90px;" class=property>{$tr->meta_title|escape}</label><input id="text-count1" name="meta_title" class="fivecms_inp" type="text" value="{if !empty($brand->meta_title)}{$brand->meta_title|escape}{/if}" /><span style="margin-left: 5px;" id="count1"></span></li>
					<li><label style="width: 90px;" class=property>{$tr->keywords|escape}</label><input id="text-count2" name="meta_keywords" class="fivecms_inp" type="text" value="{if !empty($brand->meta_keywords)}{$brand->meta_keywords|escape}{/if}" /><span style="margin-left: 5px;" id="count2"></span></li>
					<li><label style="width: 90px;" class=property>{$tr->meta_description|escape}</label><textarea id="text-count3" style="width: 400px;" maxlength="250" name="meta_description" class="fivecms_inp" />{if !empty($brand->meta_description)}{$brand->meta_description|escape}{/if}</textarea><span style="margin-left: 5px;" id="count3"></span></li>
				</ul>
			</div>
			<!-- Page parameters | Параметры страницы (The End)-->
			
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
		<!-- Left column | Левая колонка (The End)--> 
		
		<!-- Right column | Правая колонка -->	
		<div id="column_right">
		
			<!-- Brand image | Изображение бренда -->	
			<div class="block layer images">
				<h2>{$tr->image|escape} 160x160px</h2>
				<input class='upload_image' name=image type=file>			
				<input type=hidden name="delete_image" value="">
				{if !empty($brand->image)}
				<ul>
					<li>
						<a href='#' class="delete"><img src='design/images/cross-circle-frame.png'></a>
						<img src="../{$config->brands_images_dir}{$brand->image}?{math equation='rand(10,1000)'}" alt="" />
					</li>
				</ul>
				{/if}
			</div>
			<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		</div>
		<!-- Right column | Правая колонка (The End)--> 
		
		<!-- Brand description | Описание бренда -->
		<div class="block layer">
			<div class="tabs">
				<div class="tab_item"><a href="#tab1" title="{$tr->description|escape}">{$tr->description|escape}</a></div>	
				<div class="tab_item"><a href="#tab2" title="{$tr->description_seo|escape}">{$tr->description_seo|escape}</a></div>
				<span class="helper">(<a class="helperlink" href="#helper">{$tr->standart|escape}</a>)</span>							
			</div>
		
			<div class="tab_container">
				<div id="tab1" class="tab_content">
					<textarea name="description" class="editor_small">{if !empty($brand->description)}{$brand->description|escape}{/if}</textarea>
				</div>
				<div id="tab2" class="tab_content">
					<textarea style="height:260px;" name="description_seo" class="editor_small">{if !empty($brand->description_seo)}{$brand->description_seo|escape}{/if}</textarea>
				</div>	
			</div>
		</div>
		<!-- Brand description | Описание бренда (The End)-->
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Main form| Основная форма (The End) -->
	
</div>	

{* Tabs *}
<script>
	$(document).ready(function() { 
		$(".tab_content").hide();
		$(".tabs .tab_item:first").addClass("active").show();
		$(".tab_content:first").show();
		$(".tabs .tab_item").click(function() {
			$(".tabs .tab_item").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();
			var activeTab = $(this).find("a").attr("href");
			$(activeTab).fadeIn();
			return false;
		});
	});
</script>
