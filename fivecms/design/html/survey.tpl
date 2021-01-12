{capture name=tabs}
	{if in_array('surveys_categories', $manager->permissions)}<li><a href="index.php?module=SurveysCategoriesAdmin">{$tr->surveys_categories|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=SurveysAdmin{if !empty($post->category_id)}&category_id={$post->category_id}{/if}">{$tr->surveys|escape}</a></li>
{/capture}

{if !empty($post->id)}
	{$meta_title = $post->name scope=root}
{else}
	{$meta_title = $tr->new_post|escape scope=root}
{/if}

{* Подключаем Tiny MCE *}
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
		$("<input class='upload_image' name=images[] type=file multiple  accept='image/jpeg,image/png,image/gif'>").appendTo('div#add_image').focus().click();
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

<div id="onecolumn" class="surveypage">

	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success == 'added'}{$tr->added|escape}{elseif $message_success == 'updated'}{$tr->updated|escape}{/if}</span>
		<a class="link" target="_blank" href="../survey/{$post->url}">{$tr->open_on_page|escape}</a>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	
		<span class="share">		
			<a href="#" onClick='window.open("http://vkontakte.ru/share.php?url={$config->root_url|urlencode}/survey/{$post->url|urlencode}&title={$post->name|urlencode}&description={$post->annotation|urlencode}&noparse=false","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/vk_icon.png" /></a>
			<a href="#" onClick='window.open("http://www.facebook.com/sharer.php?u={$config->root_url|urlencode}/survey/{$post->url|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/facebook_icon.png" /></a>
			<a href="#" onClick='window.open("http://twitter.com/share?text={$post->name|urlencode}&url={$config->root_url|urlencode}/survey/{$post->url|urlencode}&hashtags={$post->meta_keywords|replace:' ':''|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/twitter_icon.png" /></a>
		</span>
	
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span class="text">{if $message_error == 'url_exists'}{$tr->exists|escape}{/if}</span>
		<a class="button" href="">{$tr->return|escape}</a>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	
	<!-- Основная форма -->
	<form class="blogpage" method=post id=product enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input placeholder="{$tr->enter_name|escape}" class="name" name=name type="text" value="{if !empty($post->name)}{$post->name|escape}{/if}" required /> 
			<input name=id type="hidden" value="{if !empty($post->id)}{$post->id|escape}{/if}"/> 
			<div class="checkbox">
				<input name=visible value='1' type="checkbox" id="active_checkbox" {if !empty($post->visible)}checked{/if}/> <label for="active_checkbox">{$tr->active|escape}</label>
			</div>
	
		</div> 
		<div id="product_categories" {if !$surveys_categories}style='display:none;'{/if}>
			<label>{$tr->category|escape}</label>
			<div>
				<ul>
					<li>
						<select name="category_id">
							{function name=surveys_category_select level=0}
								{foreach from=$surveys_categories item=category}
									<option value='{$category->id}' {if !empty($post->category_id) && $category->id == $post->category_id}selected{/if} category_name='{$category->name|escape}'>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$category->name|escape}</option>
									{if !empty($category->subcategories)}
										{surveys_category_select surveys_categories=$category->subcategories  level=$level+1}
									{/if}
								{/foreach}
							{/function}
							{surveys_category_select surveys_categories=$surveys_categories}
						</select>
					</li>
			
				</ul>
			</div>
		</div>
		<!-- Левая колонка свойств -->
		<div id="column_left" class="surveys" style="padding-right:0;">
			<!-- Параметры страницы -->
			<div class="block">
				<ul>
					<li><label style="width:95px;" class=property>{$tr->date|escape}</label><input style="width:80px;" type=text name=date value='{$post->date|date}'></li>
					<li><label style="width:95px;" class=property>{$tr->points|escape}</label><input style="width:80px;" type=text name=points value='{if !empty($post->points)}{$post->points}{/if}'></li>
					<li><label style="width:95px;" class=property>{$tr->task_type|escape}</label>
						<select style="width:200px;" class="poll_type" name="poll_type">
							<option value="1" {if !empty($post->poll_type) && $post->poll_type == 1}selected{/if}>{$tr->vote|escape}</option>
							<option value="2" {if !empty($post->poll_type) && $post->poll_type == 2}selected{/if}>{$tr->done_task|escape}</option>
						</select>
					</li>
					<li><label style="width:95px;" class=property>{$tr->vote_type|escape}</label>
						<select style="width:200px;" class="vote_type" name="vote_type">
							<option value="1" {if !empty($post->vote_type) && $post->vote_type == 1}selected{/if}>{$tr->one_variant|escape}</option>
							<option value="2" {if !empty($post->vote_type) && $post->vote_type == 2}selected{/if}>{$tr->several_variants|escape}</option>
							<option value="3" {if !empty($post->vote_type) && $post->vote_type == 3}selected{/if}>{$tr->stared|escape}</option>
							<option value="4" {if !empty($post->vote_type) && $post->vote_type == 4}selected{/if}>{$tr->promo_code|escape}</option>
						</select>
					</li>
				</ul>
			</div>
	
		 	<!-- Варианты -->
		 	<script type="text/javascript">
			 	$(function() {
			 		$("#variants_block").sortable({ items: '#variants ul' , axis: 'y',  cancel: '#header', handle: '.move_zone' });
	
					$('a.del_variant').click(function() {
						
						$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
						
						return false;
					});
					var variant = $('#new_variant').clone(true);
					$('#new_variant').remove().removeAttr('id');
					$('#variants_block span.add').click(function() {
						$(variant).clone(true).appendTo('#variants').fadeIn('slow').find("input[name*=variant][name*=name]").focus();
						
						return false;		
					});
			 	});
		 	</script>
	
			<div id="variants_block">
				<div class="hideablehelp">
					<div class="onehelp">{$tr->enter_vote_text|escape}:</div>
					<div class="somehelp">{$tr->enter_vote_text|escape}:</div>
					<div class="starhelp">{$tr->enter_numbers_1_5|escape}:</div>
					<div class="promohelp">{$tr->enter_promo_code|escape}:</div>
				</div>
				<ul id="header">
					<li class="variant_move" style="width:20px;"></li>
					<li class="variant_name">{$tr->value|escape}</li>
					<li class="variant_amount">{if !empty($post->vote_type) && $post->vote_type == 4}{$tr->used_promo_codes|escape}{else}{$tr->count_short|escape}{/if}</li>
					<li class="variant_percent" style="text-align:center;">%</li>
				</ul>
				<div id="variants">
				{$totalvotes = 0}
				{foreach $fields as $field}
					{if !empty($field->count)}
						{$totalvotes = $totalvotes + $field->count}
					{/if}
				{/foreach}
				{foreach $fields as $field}
				<ul>
					<li class="variant_move">
						<div class="move_zone"></div>
					</li>
					<li class="variant_name">
						<input name="fields[id][]" type="hidden" value="{$field->id|escape}" />
						<input maxlength="500" name="fields[name][]" type="text" value="{$field->name|escape}" /> 
						
						<a class="del_variant" href="#"><img src="design/images/cross-circle-frame.png" alt="" /></a>
					</li>
					<li class="variant_amount">
						<input type="text" value="{if isset($field->count)}{$field->count}{/if}" readonly="">
					</li>
					<li class="variant_percent">
						{$percent = 0}
						{if !empty($totalvotes) && !empty($field->count)}
							{$percent = (($field->count * 100)/$totalvotes)|round:0}
							{if $percent>0}<div class="vote-line" style="width:{$percent}px;">{$percent}</div>{/if}
						{/if}
					</li>
				</ul>
				{/foreach}		
				</div>
				<ul id=new_variant style='display:none;'>
					<li class="variant_move">
						<div class="move_zone"></div>
					</li>
					<li class="variant_name">
						<input name="fields[id][]" type="hidden" value="" />
						<input name="fields[name][]" type="" value="" />
						<a class="del_variant" href=""><img src="design/images/cross-circle-frame.png" alt="" /></a>
					</li>
					<li class="variant_amount"> </li>
				</ul>
	
				<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
				<span class="add" id="add_variant"><i class="dash_link">{$tr->add|escape}</i></span>
		 	</div>
			<div class="block layer">
			<!-- Параметры страницы (The End)-->
				<h2>{$tr->page_parameters|escape}</h2>
			<!-- Параметры страницы -->
				<ul>
					<li style="width: 100%;"><label style="width: 90px;" class=property>{$tr->url|escape}</label><div class="page_url" style="width: 45px;"> /survey/</div><input style="width: 434px;" name="url" class="page_url" type="text" value="{if !empty($post->url)}{$post->url|escape}{/if}" /></li>
					<li style="width: 100%;"><label style="width: 90px;" class=property>{$tr->meta_title|escape}</label><input maxlength="250" style="width: 480px;" id="text-count1" name="meta_title" type="text" value="{if !empty($post->meta_title)}{$post->meta_title|escape}{/if}" /><span style="margin-left: 5px;" id="count1"></span></li>
					<li style="width: 100%;"><label style="width: 90px;" class=property>{$tr->keywords|escape}</label><input maxlength="250" style="width: 480px;" id="text-count2" name="meta_keywords"  type="text" value="{if !empty($post->meta_keywords)}{$post->meta_keywords|escape}{/if}" /><span style="margin-left: 5px;" id="count2"></span></li>
					<li style="width: 100%;"><label style="width: 90px;" class=property>{$tr->meta_description|escape}</label><textarea style="width: 480px; height: 50px;" maxlength="250" id="text-count3" name="meta_description" />{if !empty($post->meta_description)}{$post->meta_description|escape}{/if}</textarea><span style="margin-left: 5px;" id="count3"></span></li>
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
	
			<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
				
		</div>
		<!-- Левая колонка свойств (The End)--> 
		
		<!-- Описание -->
		<div class="block layer">
			<h2>{$tr->short_description|escape} <span class="helper">(<a class="helperlink" href="#helper">{$tr->standart|escape}</a>)</span></h2>
			<textarea name="annotation" class='editor_small'>{if !empty($post->annotation)}{$post->annotation|escape}{/if}</textarea>
		</div>
	
		<div class="block layer">
			<h2>{$tr->full_description|escape} <span class="helper">(<a class="helperlink" href="#helper">{$tr->standart|escape}</a>)</span></h2>
			<textarea name="body"  class='editor_small'>{if !empty($post->text)}{$post->text|escape}{/if}</textarea>
		</div>
		<!-- Описание (The End)-->
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Основная форма (The End) -->
</div>

<script type="text/javascript">
{literal}
$(window).on('load', function() {
	$(document).ready(function(){
		changeVotes();
		$('.vote_type').change(function(){
			changeVotes();
		});
		function changeVotes() {
			var optionSelected = $('.vote_type').find("option:selected");
			var valueSelected  = optionSelected.val();
			var textSelected   = optionSelected.text();
			if (valueSelected == 1) {
				$('.hideablehelp div').hide();
				$('.onehelp').show();
			} 
			if (valueSelected == 2) {
				$('.hideablehelp div').hide();
				$('.somehelp').show();
			}
			if (valueSelected == 3) {
				$('.hideablehelp div').hide();
				$('.starhelp').show();
			}
			if (valueSelected == 4) {
				$('.hideablehelp div').hide();
				$('.promohelp').show();
			}
		}
	});
})
{/literal}
</script>
