{capture name=tabs}
	{if in_array('blog', $manager->permissions)}<li><a href="index.php?module=BlogCategoriesAdmin">{$tr->blog_categories|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=BlogAdmin{if !empty($post->category)}&category_id={$post->category}{/if}">{$tr->blog|escape}</a></li>
	{if in_array('articles_categories', $manager->permissions)}<li><a href="{url module=ArticlesCategoriesAdmin page=null keyword=null}">{$tr->articles_categories|escape}</a></li>{/if}
	{if in_array('articles', $manager->permissions)}<li><a href="index.php?module=ArticlesAdmin">{$tr->articles|escape}</a></li>{/if}
{/capture}

{if !empty($post->id)}
	{$meta_title = $post->name scope=root}
{else}
	{$meta_title = $tr->new_post scope=root}
{/if}

{include file='tinymce_init.tpl'}

{* On document load *}
{literal}
<script src="design/js/jquery/datepicker/jquery.ui.datepicker-ru.js"></script>

<script>
$(function() {

	$('input[name="date"]').datepicker({
		regional:'ru'
	});
	
	$(".images ul").sortable({ tolerance: 'pointer' });

	$(".images a.delete").live('click', function() {
		 $(this).closest("li").fadeOut(200, function() { $(this).remove(); });
		 return false;
	});

	$('#upload_image').click(function() {
		$("<input class='upload_image' name=images[] type=file multiple  accept='image/jpeg,image/png,image/gif,image/webp,image/jp2,image/jxr'>").appendTo('div#add_image').focus().click();
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
	$('textarea[name="meta_description"]').change(function() { meta_description_touched = true; });
	$('input[name="url"]').change(function() { url_touched = true; });
	
	$('input[name="name"]').keyup(function() { set_meta(); });
	$('select[name="brand_id"]').change(function() { set_meta(); });
	$('select[name="categories[]"]').change(function() { set_meta(); });
	
});

function set_meta()
{
	if(!meta_title_touched)
		$('input[name="meta_title"]').val(generate_meta_title());
	if(!meta_keywords_touched)
		$('input[name="meta_keywords"]').val(generate_meta_keywords());
	if(!meta_description_touched)
	{
		descr = $('textarea[name="meta_description"]');
		descr.val(generate_meta_description());
		descr.scrollTop(descr.outerHeight());
	}
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
		return myCustomGetContent( "annotation" );
	}
	else
		return $('textarea[name=annotation]').val().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ").replace(/^\s+|\s+$/g, '').substr(0, 512);
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

<div id="onecolumn" class="postpage">

	{if isset($message_success)}
	<!-- System message | Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success == 'added'}{$tr->added|escape}{elseif $message_success == 'updated'}{$tr->updated|escape}{/if}</span>
		<a class="link" target="_blank" href="../blog/{$post->url}">{$tr->open_on_page|escape}</a>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	
		<span class="share">		
			<a href="#" onClick='window.open("http://vkontakte.ru/share.php?url={$config->root_url|urlencode}/blog/{$post->url|urlencode}&title={$post->name|urlencode}&description={$post->annotation|urlencode}&noparse=false","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/vk_icon.png" /></a>
			<a href="#" onClick='window.open("http://www.facebook.com/sharer.php?u={$config->root_url|urlencode}/blog/{$post->url|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/facebook_icon.png" /></a>
			<a href="#" onClick='window.open("http://twitter.com/share?text={$post->name|urlencode}&url={$config->root_url|urlencode}/blog/{$post->url|urlencode}&hashtags={$post->meta_keywords|replace:' ':''|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/twitter_icon.png" /></a>
		</span>
	
	</div>
	<!-- System message | Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- System message | Системное сообщение -->
	<div class="message message_error">
		<span class="text">{if $message_error == 'url_exists'}{$tr->exists|escape}{/if}</span>
		{if isset($smarty.get.return)}
			<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- System message | Системное сообщение (The End)-->
	{/if}
	
	
	<!-- Main form | Основная форма -->
	<form class="blogpage" method=post id=product enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input placeholder="{$tr->enter_name|escape}" class="name" name=name type="text" value="{if !empty($post->name)}{$post->name|escape}{/if}" required /> 
			<input name=id type="hidden" value="{if !empty($post->id)}{$post->id|escape}{/if}"/> 
			<div class="checkbox">
				<input name=visible value='1' type="checkbox" id="active_checkbox" {if !empty($post->visible)}checked{/if}/> <label for="active_checkbox">{$tr->active|escape}</label>
			</div>
		</div> 
	
		<!-- Left column | Левая колонка -->
		<div id="column_left">
				
			<!-- Page parameters | Параметры страницы -->
			<div class="block">
				<ul>
					<li><label style="width: 90px;" class="property">{$tr->date|escape}</label><input type=text name=date value='{$post->date|date}'></li>
					<li>
						<label style="width: 90px;" class="property">{$tr->category|escape}</label>
						<select name="category">
							<option value="0">{$tr->root_category|escape}</option>
							{foreach $categories as $category}
								<option value="{$category->id}" {if $post->category == $category->id}selected{/if}>{$category->name}</option>
							{/foreach}	
						</select>
					</li>
				</ul>
			</div>
			<div class="block layer">
			
				<h2>{$tr->page_parameters|escape}</h2>
			
				<ul style="display: table; width: 650px;">
					<li style="width: 100%;"><label style="width: 90px;" class=property>{$tr->url|escape}</label><div class="page_url" style="width: 35px;"> /blog/</div><input style="width: 414px;" name="url" class="page_url" type="text" value="{if !empty($post->url)}{$post->url|escape}{/if}" /></li>
					<li style="width: 100%;"><label style="width: 90px;" class=property>{$tr->meta_title|escape}</label><input maxlength="250" style="width: 450px;" id="text-count1" name="meta_title" type="text" value="{if !empty($post->meta_title)}{$post->meta_title|escape}{/if}" /><span style="margin-left: 5px;" id="count1"></span></li>
					<li style="width: 100%;"><label style="width: 90px;" class=property>{$tr->keywords|escape}</label><input maxlength="250" style="width: 450px;" id="text-count2" name="meta_keywords"  type="text" value="{if !empty($post->meta_keywords)}{$post->meta_keywords|escape}{/if}" /></li>
					<li style="width: 100%;"><label style="width: 90px;" class=property>{$tr->meta_description|escape}</label><textarea style="width: 450px; height: 50px;" maxlength="250" id="text-count3" name="meta_description" />{if !empty($post->meta_description)}{$post->meta_description|escape}{/if}</textarea><span style="margin-left: 5px;" id="count3"></span></li>
				</ul>
			</div>
			{* tags *}
			<script src="design/js/inputosaurus/inputosaurus.js"></script>
			<div class="block layer">
                <h2>{$tr->hash_tags|escape} <span style="font-size:13px;">{$tr->hash_help|escape}</span></h2>
                <input type="text" name="tags" value="{if !empty($post->tags)}{foreach $post->tags as $tag}{$tag->value|escape}{if !$tag@last},{/if}{/foreach}{/if}" />
                <p style="margin:10px 0;">{$tr->hash_info}</p>
                <script>
                $('input[name=tags]').inputosaurus({ 
                    activateFinalResult : true
                });
                </script>
            </div>
			{* tags @ *}
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
			<div class="block layer images">
				<h2>{$tr->images|escape}</h2>
				<div style="font-size:12px;margin-bottom:10px;">{$tr->images_annotation|escape}</div>
				<ul>
					{$i=0}
					{math assign='random' equation='rand(10,1000)'}
					{foreach from=$post_images item=image}
						{$i=$i+1}
						<li>
							{if $i==1}<span class="toolannot" title="{$tr->toolannot|escape}">{$tr->annotation|escape}</span>{/if}
							<a href='#' class="delete"><img src='design/images/cross-circle-frame.png'></a>
							<a href="{$image->filename|resize:1024:768:w:$config->resized_blog_images_dir}?{$random}" class="zoom" data-rel="group"><img src="{$image->filename|resize:400:400:false:$config->resized_blog_images_dir}?{$random}" alt="" /></a>
							<input type=hidden name='images[]' value='{$image->id}'>
						</li>	
					{/foreach}
				</ul>
				<div id=add_image></div>
				<span class=upload_image><i class="dash_link" id="upload_image">{$tr->upload_image|escape}</i></span>
				<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
			</div>
		</div>
		<!-- Right column | Правая колонка (The End)--> 
		
		<!-- Description | Описание -->
		<div class="block layer">
		
			<div class="tabs">
				<div class="tab_item"><a href="#tab1" title="{$tr->short_description|escape}">{$tr->short_description|escape}</a></div>	
				<div class="tab_item"><a href="#tab2" title="{$tr->full_description|escape}">{$tr->full_description|escape}</a></div>
				<span class="helper">(<a class="helperlink" href="#helper">{$tr->standart|escape}</a>)</span>							
			</div>
		
			<div class="tab_container">
				<div id="tab1" class="tab_content">
					<textarea name="annotation" class='editor_small'>{if !empty($post->annotation)}{$post->annotation|escape}{/if}</textarea>
				</div>
				<div id="tab2" class="tab_content">
					<textarea style="height:400px;" name="body" class='editor_small'>{if !empty($post->text)}{$post->text|escape}{/if}</textarea>
				</div>	
			</div>

		</div>
		<!-- Description | Описание (The End)-->
		
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
	
	</form>
	<!-- Main form | Основная форма (The End) -->

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