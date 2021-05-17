{foreach name=categories from=$product_categories item=product_category}
{/foreach}	

{capture name=tabs}
	{if !empty($product_category->id)}
		<li class="active"><a href="{url module=ProductsAdmin category_id=$product_category->id return=null brand_id=null id=null}">{$tr->products|escape}</a></li>
	{else}
		<li class="active"><a href="{url module=ProductsAdmin category_id=null return=null brand_id=null id=null}">{$tr->products|escape}</a></li>
	{/if}
	{if in_array('categories', $manager->permissions)}<li><a href="index.php?module=CategoriesAdmin">{$tr->categories|escape}</a></li>{/if}
	{if in_array('brands', $manager->permissions)}<li><a href="index.php?module=BrandsAdmin">{$tr->brands|escape}</a></li>{/if}
	{if in_array('features', $manager->permissions)}<li><a href="index.php?module=FeaturesAdmin">{$tr->features|escape}</a></li>{/if}
{/capture}

{if !empty($product->id)}
	{$meta_title = $product->name scope=root}
{else}
	{$meta_title = $tr->new_post|escape scope=root}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

{* On document load *}
<script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
{literal}
<script>
$(function() {

	// Добавление категории
	$('#product_categories .add').click(function() {
		$("#product_categories ul li:last").clone(false).appendTo('#product_categories ul').fadeIn('slow').find("select[name*=categories]:last").focus();
		$("#product_categories ul li:last span.add").hide();
		$("#product_categories ul li:last span.delete").show();
		return false;		
	});

	// Удаление категории
	$("#product_categories .delete").live('click', function() {
		$(this).closest("li").fadeOut(200, function() { $(this).remove(); });
		return false;
	});

	// Сортировка вариантов
	$("#variants_block").sortable({ items: '#variants ul' , axis: 'y',  cancel: '#header', handle: '.move_zone' });
	// Сортировка вариантов
	$("table.related_products").sortable({ items: 'tr' , axis: 'y',  cancel: '#header', handle: '.move_zone' });

	
	// Сортировка связанных товаров
	$(".sortable").sortable({
		items: "div.row",
		tolerance:"pointer",
		scrollSensitivity:40,
		opacity:0.7,
		handle: '.move_zone'
	});
		
	// Сортировка изображений
	$(".images ul").sortable({ tolerance: 'pointer'});

	// Удаление изображений
	$(".images a.delete").live('click', function() {
		 $(this).closest("li").fadeOut(200, function() { $(this).remove(); });
		 return false;
	});
	// Загрузить изображение с компьютера
	$('#upload_image').click(function() {
		$("<input class='upload_image' name=images[] type=file multiple  accept='image/jpeg,image/png,image/gif,image/webp,image/jp2,image/jxr'>").appendTo('div#add_image').focus().click();
	});
	// Или с URL
	$('#add_image_url').click(function() {
		$("<input class='remote_image' name=images_urls[] type=text value='http://'>").appendTo('div#add_image').focus().select();
	});
	
	// Или перетаскиванием
	if(window.File && window.FileReader && window.FileList)
	{
		$("#dropZone").show();
		$("#dropZone").on('dragover', function (e){
			$(this).css('border', '1px solid #8cbf32');
		});
		$(document).on('dragenter', function (e){
			$("#dropZone").css('border', '1px dotted #8cbf32').css('background-color', '#c5ff8d');
		});
	
		dropInput = $('.dropInput').last().clone();
		
		function handleFileSelect(evt){
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
					$("<li class=wizard><a href='' class='delete'><img src='design/images/cross-circle-frame.png'></a><img onerror='$(this).closest(\"li\").remove();' src='"+e.target.result+"' /><input name=images_urls[] type=hidden value='"+theFile.name+"'></li>").appendTo('div .images ul');
					temp_input =  dropInput.clone();
					$('.dropInput').hide();
					$('#dropZone').append(temp_input);
					$("#dropZone").css('border', '1px solid #d0d0d0').css('background-color', '#ffffff');
		        };
		      })(f);
		
		      // Read in the image file as a data URL.
		      reader.readAsDataURL(f);
		    }
		}
		$('.dropInput').live("change", handleFileSelect);
	};


	// Удаление варианта
	$('a.del_variant').click(function() {
		if($("#variants ul").size()>1)
		{
			$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
		}
		else
		{
			$('#variants_block .variant_name input[name*=variant][name*=name]').val('');
			$('#variants_block .variant_name').hide('slow');
			$('#variants_block').addClass('single_variant');
		}
		return false;
	});

	// Загрузить файл к варианту
	$('.variant_download a.add_attachment').click(function() {
		$(this).hide();
		$(this).closest('li').find('div.browse_attachment').show('fast');
		$(this).closest('li').find('input[name*=attachment]').attr('disabled', false);
		return false;		
	});
	
	// Удалить файл к варианту
	$('.variant_download a.remove_attachment').click(function() {
		closest_li = $(this).closest('li');
		closest_li.find('.attachment_name').hide('fast');
		$(this).hide('fast');
		closest_li.find('input[name*=delete_attachment]').val('1');
		closest_li.find('a.add_attachment').show('fast');
		return false;		
	});


	// Добавление варианта
	var variant = $('#new_variant').clone(true);
	$('#new_variant').remove().removeAttr('id');
	$('#variants_block span.add').click(function() {
		if(!$('#variants_block').is('.single_variant'))
		{
			$(variant).clone(true).appendTo('#variants').fadeIn('slow').find("input[name*=variant][name*=name]").focus();
		}
		else
		{
			$('#variants_block .variant_name').show('slow');
			$('#variants_block').removeClass('single_variant');		
		}
		return false;		
	});
	
	function show_category_features(category_id)
	{
		$('ul.prop_ul').empty();
		$.ajax({
			url: "ajax/get_features.php",
			data: {category_id: category_id, product_id: $("input[name=id]").val()},
			dataType: 'json',
			success: function(data){
				for(i=0; i<data.length; i++)
				{
					feature = data[i];
					
					line = $("<li><label class=property></label><input class='fivecms_inp' type='text'/></li>");
					var new_line = line.clone(true);
					new_line.find("label.property").text(feature.name);
					new_line.find("input").attr('name', "options["+feature.id+"]").val(feature.value);
					new_line.appendTo('ul.prop_ul').find("input")
					.autocomplete({
						serviceUrl:'ajax/options_autocomplete.php',
						minChars:0,
						params: {feature_id:feature.id},
						noCache: false
					});
				}
			}
		});
		return false;
	}
	
	// Изменение набора свойств при изменении категории
	/*$('select[name="categories[]"]:first').change(function() {
		show_category_features($("option:selected",this).val());
	});*/

	// Автодополнение свойств
	$('ul.prop_ul input[name*=options]').each(function(index) {
		feature_id = $(this).closest('li').attr('feature_id');
		$(this).autocomplete({
			serviceUrl:'ajax/options_autocomplete.php',
			minChars:0,
			params: {feature_id:feature_id},
			noCache: false,
			containerClass: 'autocomplete-suggestions features',
			triggerSelectOnValidInput: false
		});
	});
	
	// Добавление нового свойства товара
	var new_feature = $('#new_feature').clone(true);
	$('#new_feature').remove().removeAttr('id');
	$('#add_new_feature').click(function() {
		$(new_feature).clone(true).appendTo('ul.new_features').fadeIn('slow').find("input[name*=new_feature_name]").focus();
		return false;		
	});

	// Удаление связанного товара
	$(".related_products a.delete").live('click', function() {
		 $(this).closest("div.row").fadeOut(200, function() { $(this).remove(); });
		 return false;
	});
 
	// Добавление связанного товара 
	var new_related_product = $('#new_related_product').clone(true);
	$('#new_related_product').remove().removeAttr('id');
 
	$("input#related_products").autocomplete({
		serviceUrl:'ajax/search_products.php',
		minChars:0,
		noCache: false, 
		onSelect:
			function(suggestion){
				$("input#related_products").val('').focus().blur(); 
				new_item = new_related_product.clone().appendTo('.related_products');
				new_item.removeAttr('id');
				new_item.find('a.related_product_name').html(suggestion.data.name);
				new_item.find('a.related_product_name').attr('href', 'index.php?module=ProductAdmin&id='+suggestion.data.id);
				new_item.find('input[name*="related_products"]').val(suggestion.data.id);
				if(suggestion.data.image)
					new_item.find('img.product_icon').attr("src", suggestion.data.image);
				else
					new_item.find('img.product_icon').remove();
				new_item.show();
			},
		formatResult:
            function(suggestions, currentValue){
                var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
                var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
                return "<div>" + (suggestions.data.image?"<img align=absmiddle src='"+suggestions.data.image+"'> ":'') + "</div>" +  "<span>" + suggestions.value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>') + "</span>";
            }

	});
  
	// infinity
	$("input[name*=variant][name*=stock]").focus(function() {
		if($(this).val() == '∞')
			$(this).val('');
		return false;
	});

	$("input[name*=variant][name*=stock]").blur(function() {
		if($(this).val() == '')
			$(this).val('∞');
	});
	
	// Автозаполнение мета-тегов
	meta_title_touched = false;
	meta_keywords_touched = true;
	meta_description_touched = true;
	url_touched = false;

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
	result = name;
	brand = $('select[name="brand_id"] option:selected').attr('brand_name');
	if(typeof(brand) == 'string' && brand!='')
			result += ', '+brand;
	$('select[name="categories[]"]').each(function(index) {
		c = $(this).find('option:selected').attr('category_name');
		if(typeof(c) == 'string' && c != '')
    		result += ', '+c;
	}); 
	return result;
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


<div id="onecolumn" class="productpage">

	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success|escape}{/if}</span>
		<a class="link" target="_blank" href="../products/{$product->url}">{$tr->open_on_page|escape}</a>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	
		<span class="share">		
			<a href="#" onClick='window.open("https://vk.com/share.php?url={$config->root_url|urlencode}/products/{$product->url|urlencode}&title={$product->name|urlencode}&description={$product->annotation|urlencode}{if !empty($product_images.0->filename)}&image={$product_images.0->filename|resize:1000:1000|urlencode}{/if}&noparse=true","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/vk_icon.png" /></a>
			<a href="#" onClick='window.open("https://facebook.com/sharer.php?u={$config->root_url|urlencode}/products/{$product->url|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/facebook_icon.png" /></a>
			<a href="#" onClick='window.open("https://twitter.com/share?text={$product->name|urlencode}&url={$config->root_url|urlencode}/products/{$product->url|urlencode}&hashtags={$product->meta_keywords|replace:' ':''|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
	  		<img src="{$config->root_url}/fivecms/design/images/twitter_icon.png" /></a>
		</span>
	
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span class="text">{if $message_error=='url_exists'}{$tr->product_exists|escape}{elseif $message_error=='empty_name'}{$tr->enter_s_name|escape}{else}{$message_error|escape}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
	
	 	<div id="name" style="margin-bottom: 10px;">
			<input placeholder="{$tr->product_name_h1|escape}" class="name" name=name type="text" value="{if !empty($product->name)}{$product->name|escape}{/if}" required /> 
			<input name=id type="hidden" value="{if !empty($product->id)}{$product->id|escape}{/if}"/>
		</div>

		<div class="" style="display: table; margin-bottom: 20px;">
			<div class="checkbox">
				<input name="on_request" value='1' type="checkbox" id="on_request_checkbox" {if !empty($product->on_request)}checked{/if}/><label for="on_request_checkbox">Под заказ</label>
			</div>
			<div class="checkbox">
				<input name="out_of" value='1' type="checkbox" id="out_of_checkbox" {if !empty($product->out_of)}checked{/if}/><label for="out_of_checkbox">Снято с производства</label>
			</div>
			<div class="checkbox">
				<input name=visible value='1' type="checkbox" id="active_checkbox" {if !empty($product->visible)}checked{/if}/><label for="active_checkbox">{$tr->active|escape}</label>
			</div>
			<div class="checkbox">
				<input name=featured value="1" type="checkbox" id="featured_checkbox" {if !empty($product->featured)}checked{/if} /><label title="{$tr->mark_as_hit|escape}" for="featured_checkbox">{$tr->bestseller|escape}</label>
			</div>
			<div class="checkbox">
				<input name="is_new" value="1" type="checkbox" id="new_checkbox" {if !empty($product->is_new)}checked{/if}/><label title="{$tr->mark_as_new|escape}" for="new_checkbox">New</label>
			</div>
			<div class="checkbox">
				<input name=to_yandex value="1" type="checkbox" id="yandex_checkbox" {if !empty($product->to_yandex)}checked{/if}/><label title="{$tr->export_to_yandex|escape}" for="yandex_checkbox">Yandex</label>
			</div>
		</div>

		<div id="product_brand" {if empty($brands)}style='display:none;'{/if}>
			<label>{$tr->brand|escape}</label>
			<select name="brand_id">
	            <option value='0' {if empty($product->brand_id)}selected{/if} brand_name=''>{$tr->not_set|escape}</option>
	       		{foreach from=$brands item=brand}
	       			{if !empty($brand->id)}
	            	<option value='{$brand->id}' {if !empty($product->brand_id) && $product->brand_id == $brand->id}selected{/if} brand_name='{$brand->name|escape}'>{$brand->name|escape}</option>
	            	{/if}
	        	{/foreach}
			</select>
		</div>
		
		<div id="product_categories" {if empty($categories)}style='display:none;'{/if}>
			<label>{$tr->category|escape}</label>
			<div class="cat_select">
				<ul>
					{foreach name=categories from=$product_categories item=product_category}
					<li>
						<select name="categories[]">
							<option value="0" selected disabled category_name=''>{$tr->not_set|escape}</option>
							{function name=category_select level=0}
								{foreach from=$categories item=category}
									<option value='{if !empty($category->id)}{$category->id}{/if}' {if !empty($category->id) && $category->id == $selected_id}selected{/if} category_name='{$category->name|escape}' {if $category->level > 1}data-parent="{$category->path[0]->name|escape}"{/if}>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$category->name|escape}</option>
									{if !empty($category->subcategories)}
										{category_select categories=$category->subcategories selected_id=$selected_id  level=$level+1}
									{/if}
								{/foreach}
							{/function}
							{category_select categories=$categories selected_id=$product_category->id}
						</select>
						<span {if not $smarty.foreach.categories.first}style='display:none;'{/if} class="add"><i class="dash_link">{$tr->additional_cat|escape}</i></span>
						<span {if $smarty.foreach.categories.first}style='display:none;'{/if} class="delete"><i class="dash_link">{$tr->delete|escape}</i></span>
					</li>
					{/foreach}		
				</ul>
			</div>
			{* Установка веса и объёма по умолчанию *}
			{literal}
				<script>
					$(function () {
						$('#product_categories').on('change', 'select', function () {
							const parent_cat = $(this).find('option:selected').attr('data-parent'),
								input_weight = $('.prop_ul input[name="options[1]"]'),
								input_volume = $('.prop_ul input[name="options[2]"]');
							if (!input_weight.length || !input_volume.length || !parent_cat) return;
							if (parent_cat === 'Костюмы для взрослых') {
								if (!input_weight.val()) input_weight.val(1500);
								if (!input_volume.val()) input_volume.val(0.009);
							}
							if (parent_cat === 'Костюмы для детей') {
								if (!input_weight.val()) input_weight.val(800);
								if (!input_volume.val()) input_volume.val(0.006);
							}
						})
					})
				</script>
			{/literal}
		</div>
	
	 	<!-- Варианты товара -->
		<div id="variants_block" {assign var=first_variant value=$product_variants|@first}{if $product_variants|@count <= 1 && empty($first_variant->name)}class=single_variant{/if}>
	
			<div class="sizechoose">{$tr->size_color_helper|escape}</div>
			
			<div class="hideforclothes">
				{$tr->size_color_help}
			</div>
			<ul id="header">
				<li class="variant_move" style="height:auto;"></li>
				<li class="variant_name"><strong>{$tr->variant_name|escape}</strong></li>
				<li class="variant_name2"><strong>{$tr->size|escape}</strong></li>
				<li class="variant_name2"><strong>{$tr->color|escape}</strong></li>	
				<li class="variant_sku">{$tr->sku|capitalize|escape}</li>	
				<li class="variant_price">{$tr->price|escape}</li>	
				<li class="variant_discount">{$tr->old_price|escape}</li>
				<li class="discount" {if $settings->variant_discount == '0'}style="display:none;"{/if}>{$tr->discount_to_date|escape}</li>
				<li class="variant_currency">{$tr->currency|escape}</li>
				<li class="variant_amount">{$tr->count_short|escape}</li>
			</ul>
			<div id="variants">
			{foreach from=$product_variants item=variant}
			{if !empty($variant->id)}{$variant_id = $variant->id}{else}{$variant_id = ''}{/if}
			<ul>
				<li class="variant_move"><div class="move_zone" style="cursor:help;" {if !empty($variant->id)}title="variant_ID: {$variant->id|escape}{* добавить external_id в выборку в get_variants {if !empty($variant->external_id)} | var_external_ID (1C): {$variant->external_id|escape}{/if}*}"{/if}></div></li>
				<li class="variant_name">      <input name="variants[id][{$variant_id}]"            type="hidden" value="{$variant_id|escape}" /><input maxlength="255" name="variants[name][{$variant_id}]" type="" value="{if !empty($variant->name)}{$variant->name|escape}{/if}" /> <a class="del_variant" href=""><img src="design/images/cross-circle-frame.png" alt="" /></a></li>
				<li class="variant_name2">       <input maxlength="25" name="variants[name1][{$variant_id}]"           type="text"   value="{if !empty($variant->name1)}{$variant->name1|escape}{/if}" /></li>
				<li class="variant_name2">       <input maxlength="25" class="curr" name="variants[name2][{$variant_id}]"           type="text"   value="{if !empty($variant->name2)}{$variant->name2|escape}{/if}" /></li>
				<li class="variant_sku">       <input maxlength="125" name="variants[sku][{$variant_id}]"           type="text"   value="{if !empty($variant->sku)}{$variant->sku|escape}{/if}" /></li>
				<li class="variant_price">     <input name="variants[price][{$variant_id}]"         type="text"   value="{if !empty($variant->oprice)}{$variant->oprice|escape}{/if}" /></li>
				<li class="variant_discount">  <input name="variants[compare_price][{$variant_id}]" type="text"   value="{if !empty($variant->compare_oprice)}{$variant->compare_oprice|escape}{/if}" /></li>
				<li class="discount" {if $settings->variant_discount == '0'}style="display:none;"{/if}>  
					<input class="discount_num" min=0 name="variants[discount][{$variant_id}]" type="number" value="{if !empty($variant->discount)}{$variant->discount|escape}{/if}" />
					<input class="datetime" name="variants[discount_date][{$variant_id}]" type="text" value="{if !empty($variant->discount_date)}{$variant->discount_date|date} {$variant->discount_date|time}{/if}" autocomplete="off" />
				</li>
				<li class="variant_currency"><select name="variants[currency_id][{$variant_id}]"><option value="0">*{$currency->sign}</option>{foreach $currencies as $c}<option value="{$c->id}" {if !empty($variant->currency_id) && $c->id == $variant->currency_id}selected{/if}>{$c->sign}</option>{/foreach}</select></li>
				<li class="variant_amount">  <input name="variants[stock][{$variant_id}]" type="text" value="{if !empty($variant->infinity) || (isset($variant->stock) && $variant->stock == '')}∞{elseif isset($variant->stock)}{$variant->stock|escape}{/if}" />
					<select name="variants[unit][{$variant_id}]">
						{if !empty($settings->units)}
							<option value="{$settings->units|escape}"{if !empty($variant->unit) && $variant->unit == $settings->units} selected{/if}>{$settings->units|escape}</option>
						{/if}
						{if !empty($settings->units_list)}
							{$units_list = ","|explode:($settings->units_list|replace:' ':'')}
							{foreach $units_list as $un}
								<option value="{$un|escape}"{if !empty($variant->unit) && $variant->unit == $un} selected{/if}>{$un|escape}</option>
							{/foreach}
						{/if}
					</select>
				</li>
				<li class="variant_download">
					{if !empty($variant->attachment)}
						<span class=attachment_name>{$variant->attachment|truncate:25:'...':false:true}</span>
						<a href='#' class=remove_attachment><img src='design/images/bullet_delete.png'  title="{$tr->del_digital|escape}"></a>
						<a href='#' class="add_attachment" style='display:none;'><img src="design/images/cd_add.png" title="{$tr->add_digital|escape}" /></a>
					{else}
						<a href='#' class="add_attachment"><img src="design/images/cd_add.png"  title="{$tr->add_digital|escape}" /></a>
					{/if}
					<div class="browse_attachment" style='display:none;'>
						<input type='file' name="attachment[{$variant_id}]" />
						<input type='hidden' name="delete_attachment[{$variant_id}]" />
					</div>
				</li>
				
			</ul>
			{/foreach}		
			</div>
			<ul id=new_variant style='display:none;'>
				<li class="variant_move"><div class="move_zone"></div></li>
				<li class="variant_name"><input name="variants[id][]" type="hidden" value="" /><input maxlength="255" name="variants[name][]" type="text" value="" /><a class="del_variant" href=""><img src="design/images/cross-circle-frame.png" alt="" /></a></li>
				<li class="variant_name2"><input maxlength="25" name="variants[name1][]" type="text" value="" /></li>
				<li class="variant_name2"><input maxlength="25" name="variants[name2][]" type="text" value="" /></li>
				<li class="variant_sku"><input maxlength="125" name="variants[sku][]" type="text" value="" /></li>
				<li class="variant_price"><input  name="variants[price][]" type="text" value="" /></li>
				<li class="variant_discount"><input name="variants[compare_price][]" type="text" value="" /></li>
				<li class="discount" {if $settings->variant_discount == '0'}style="display:none;"{/if}>  
					<input class="discount_num" min=0 name="variants[discount][]" type="number" value="" />
					<input class="datetime" name="variants[discount_date][]" type="text" value="" autocomplete="off" />
				</li>
				<li class="variant_currency"><select name="variants[currency_id][]"><option value="0">* {$currency->sign}</option>{foreach $currencies as $c}<option value="{$c->id}">{$c->sign}</option>{/foreach}</select></li>
				<li class="variant_amount"><input name="variants[stock][]" type="text" value="∞" />
					<select name="variants[unit][]">
						{if !empty($settings->units)}
							<option value="{$settings->units|escape}">{$settings->units|escape}</option>
						{/if}
						{if !empty($settings->units_list)}
							{$units_list = ","|explode:($settings->units_list|replace:' ':'')}
							{foreach $units_list as $un}
								<option value="{$un|escape}">{$un|escape}</option>
							{/foreach}
						{/if}
					</select>
				</li>
				<li class="variant_download">
					<a href='#' class=add_attachment><img src="design/images/cd_add.png" alt="" /></a>
					<div class=browse_attachment style='display:none;'>
						<input type=file name=attachment[]>
						<input type=hidden name=delete_attachment[]>
					</div>
				</li>
			</ul>
		
			<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
			<span class="add" id="add_variant"><i class="dash_link">{$tr->add_variant|escape}</i></span>
			<p style="font-size: 13px; margin: 15px 0 15px 15px; font-weight:700;">{$tr->variant_helper}</p>
	 	</div>
		<!-- Варианты товара (The End)--> 
		
	 	<!-- Левая колонка свойств товара -->
		<div id="column_left">
				
			<!-- Параметры страницы -->
			<div class="block layer">
				<h2>{$tr->page_parameters|escape}</h2>
				<ul>
					<li><label class=property style="width: 82px;">{$tr->url|escape} {if !empty($product->url)}<a href="../products/{$product->url}" title="{$tr->open_on_page|escape}" target="_blank"><img style="margin-left:5px;vertical-align:middle;" src="design/images/world_link.png" /></a>{/if}</label><div class="page_url"> /products/</div><input style="width: 434px;" name="url" class="page_url" type="text" value="{if !empty($product->url)}{$product->url|escape}{/if}" /></li>
					<li><label class=property style="width: 82px;">{$tr->meta_title|escape}</label><input maxlength="250" id="text-count1" style="width: 500px;" name="meta_title" class="fivecms_inp" type="text" value="{if !empty($product->meta_title)}{$product->meta_title|escape}{/if}" /><span style="margin-left: 5px;" id="count1"></span></li>
					<li><label class=property style="width: 82px;">{$tr->keywords|escape}</label><input maxlength="250" id="text-count2" style="width: 500px;" name="meta_keywords" class="fivecms_inp" type="text" value="{if !empty($product->meta_keywords)}{$product->meta_keywords|escape}{/if}" /><span style="margin-left: 5px;" id="count2"></span></li>
					<li><label class=property style="width: 82px;">{$tr->meta_description|escape}</label><textarea maxlength="250" id="text-count3" style="width: 500px; height: 62px;" name="meta_description" class="fivecms_inp" />{if !empty($product->meta_description)}{$product->meta_description|escape}{/if}</textarea><span style="margin-left: 5px;" id="count3"></span></li>
				</ul>
			</div>
			
			<div class="block layer" style="padding:9px 0 0 0;">
				<ul>
					<li><label class="property" style="width: 103px;">Ref-{$tr->link|lower} <a target="_blank" href="http://5cms.ru/blog/ref-sell" title="{$tr->ref_url_help}" class="bluelink">(?)</a></label><input placeholder="{$tr->example}: http://site.ru" style="width: 479px;" name="ref_url" class="ref_url" type="text" value="{if !empty($product->ref_url)}{$product->ref_url|escape}{/if}" /></li>
				</ul>	
			</div>
			
			<div class="layer" style="padding:9px 0 13px 0;">
				<div style="display:inline-block;">
					<label class=property style="margin:3px 10px 0 0px;width:102px;">{$tr->rating|escape} (0-5)</label><input style="width: 50px;" name="rating" class="fivecms_inp" type="number" min="0" max="5" step="0.1" value="{if !empty($product->rating)}{$product->rating|escape}{/if}" />
				</div>
				<div style="display:inline-block;">	
					<label class=property style="margin:3px 10px 0 10px;width:70px;">{$tr->votes|escape}</label><input style="width: 50px;" name="votes" class="fivecms_inp" type="number" min="0" step="1" value="{if !empty($product->votes)}{$product->votes|escape}{/if}" />
				</div>
				
				{if !empty($product->external_id)}<div class="external_id">Product_External_ID (1C) <span title="Внешний ID, передаваемый при обмене с 1C" style="cursor:help;border-bottom:0;" class="bluelink">(?)</span>: {$product->external_id|escape}</div>{/if}
					
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
	
			<!-- Параметры страницы (The End)-->
			
			<!-- Свойства товара -->
		
			<div class="block layer" {if !$categories}style='display:none;'{/if}>
				<h2>{$tr->product_features|escape}</h2>
				<p style="margin-bottom:10px;font-size:13px;">{$tr->features_delimiter}</p>
				<ul class="prop_ul">
					{foreach $features as $feature}
						{assign var=feature_id value=$feature->id}
						<li feature_id={$feature_id}>
							<label class=property>{$feature->name} {if $feature->id == $settings->feature_weight || $feature->id == $settings->feature_volume}<span class="dec_delimiter">(через ".")</span>{/if}</label>
							<input {if $feature->id == $settings->feature_weight || $feature->id == $settings->feature_volume}placeholder="{$tr->example|escape}: 0.14"{/if} class="fivecms_inp" type="text" name=options[{$feature_id}] value="{if !empty($options.$feature_id->value)}{$options.$feature_id->value|escape}{/if}" />
						</li>
					{/foreach}
				</ul>
				<!-- Новые свойства -->
				<ul class=new_features>
					<li id=new_feature><label class=property><input type=text name=new_features_names[]></label><input class="fivecms_inp" type="text" name=new_features_values[] /></li>
				</ul>
				<span class="add"><i class="dash_link" id="add_new_feature">{$tr->add_new_feature|escape}</i></span>
				<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />			
			</div>
			<!-- Свойства товара (The End)-->
			<h2>Видео</h2>
			<textarea maxlength="250" id="text-count3" style="width: 100%; height: 62px;" name="video" class="fivecms_inp" />{if !empty($product->video)}{$product->video}{/if}</textarea>
		</div>
		<!-- Левая колонка свойств товара (The End)-->


		
		<!-- Правая колонка свойств товара -->	
		<div id="column_right" style="float:right;">
			
			<!-- Изображения товара -->	
			<div class="block layer images">
				<h2>{$tr->images|escape} ({$tr->max|escape} 800x600px)</h2>
	
				<p class="colorhelp" style="margin-bottom: 10px; font-size: 11px; font-style: italic;">{$tr->image_color_help}</p>
				
					{math assign='random' equation='rand(10,10000)'}
	
					<ul>
						{foreach from=$product_images item=image}
						<li>
							<a href='#' class="delete"><img src='design/images/cross-circle-frame.png'></a>
							<span style="line-height: 100px; width: 100px; vertical-align: middle; display: table-cell; text-align: center;"><a href="{$image->filename|resize:1024:768:w}?{$random}" class="zoom" data-rel="group"><img src="{$image->filename|resize:100:100}?{$random}" alt="" /></a></span>
	
							<input type="text" class="curr" name="imagecolors[]" value="{$image->color}" placeholder="Цвет" style="width:80px;margin-top:5px;position:absolute;bottom:5px;left:8px;">
							<input type=hidden name='images[]' value='{$image->id}'>
						</li>
						{/foreach}
					</ul>
	
				<div id=dropZone>
					<div id=dropMessage>{$tr->drop_files_here|escape}</div>
					<input type="file" name="dropped_images[]" multiple class="dropInput">
				</div>
				<div><strong>{$tr->upload|escape}:</strong></div>
				<div id="add_image"></div>
	
				<span class="upload_image"><i class="dash_link" id="upload_image">{$tr->locally|escape}</i></span> {$tr->or|escape} <span class=add_image_url><i class="dash_link" id="add_image_url">{$tr->from_internet|escape}</i></span>
				
			</div>
			
			<div id="relatedblock" class="block layer">
				<h2>{$tr->related_prods|escape}</h2>
				<div id=list class="sortable related_products">
					{foreach from=$related_products item=related_product}
					<div class="row">
						<div class="move cell">
							<div class="move_zone"></div>
						</div>
						<div class="image cell">
						<input type=hidden name=related_products[] value='{$related_product->id}'>
						<a href="{url id=$related_product->id}">
						<img class=product_icon src='{if !empty($related_product->images[0])}{$related_product->images[0]->filename|resize:100:100}{else}/js/nophoto.png{/if}'>
						</a>
						</div>
						<div class="name cell">
							<a href="{url id=$related_product->id}">{$related_product->name}</a>
							{if $related_product->variants}
	           			    	{foreach $related_product->variants as $v}
	          				       <p class="rel-var">>&nbsp; {if $v->name}{$v->name} -{/if} {$v->price} {$currency->sign} [{$v->stock} {if $v->unit}{$v->unit}{else}{$settings->units}{/if}]</p>
	          		      		{/foreach}
	            			{/if}
						</div>
						<div class="icons cell">
						<a href='#' class="delete"></a>
						</div>
						<div class="clear"></div>
					</div>
					{/foreach}
					<div id="new_related_product" class="row" style='display:none;'>
						<div class="move cell">
							<div class="move_zone"></div>
						</div>
						<div class="image cell">
						<input type=hidden name=related_products[] value=''>
						<img class=product_icon src=''>
						</div>
						<div class="name cell">
						<a class="related_product_name" href=""></a>
						</div>
						<div class="icons cell">
						<a href='#' class="delete"></a>
						</div>
						<div class="clear"></div>
					</div>
				</div>
				<input type=text name=related id='related_products' class="input_autocomplete" placeholder='{$tr->choose_prod_add|escape}'>
			</div>
			
			
			<div class="block layer">
				<h2>{$tr->attached_files|escape}</h2>
				<p style="font-size:12px;margin-bottom:10px;">{$tr->allowed_extentions|escape}: pdf, txt, doc, docx, xls, xlsx, odt, ods, odp, gif, jpg, png, psd, cdr, ai, zip, rar, gzip</p>
				<p style="font-size:12px;margin-bottom:10px;">{$tr->attached_files_help}</p>
				{if !empty($cms_files) && $cms_files|count>0}
					<div id="list" class="sortable files_products">
						{foreach $cms_files as $file}
						<div class="row">
							<div class="move cell">
								<div class="move_zone"></div>
							</div>
							<div class="name cell">
								<input style="width: 250px;" placeholder="{$tr->filename_on_website|escape}" type="text" name='files[name][]' value='{$file->name}'>
							</div>					
							<div class="name cell" style="max-width: 280px;padding-top:0;">
								<input type=hidden name='files[id][]' value='{$file->id}'>
								<a style="word-wrap:break-word;font-size: 13px;" target="_blank" href="../{$config->cms_files_dir}{$file->filename}">
									{$file->filename}
									<span style="white-space:nowrap;">({assign var=fn value="`$config->cms_files_dir``$file->filename`"}{(filesize($fn)/1024/1024)|round:2} Mb)</span>	
								</a>
							</div>
							<div class="icons cell" style="min-width:30px;max-width:30px;">
								<a href='#' class="delete"></a>
							</div>
							<div class="clear"></div>
						</div>
						{/foreach}
					</div>
				{else}
					<p style="font-size:12px;">{$tr->no_files|escape}</p>
				{/if}<br/>
				<input class='upload_file' name=files[] type=file multiple  accept='pdf/txt/doc/docx/xls/xlsx/odt/ods/odp/gif/jpg/png/psd/cdr/ai/zip/rar/gzip'>	
			</div>
	
			<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
			
		</div>
		<!-- Правая колонка свойств товара (The End)--> 
	
	<span>
	
		<!-- Описание товара -->
		<div class="block layer">
			<div class="tabs">
				<div class="tab_item"><a href="#tab1" title="{$tr->short_description|escape}">{$tr->short_description|escape}</a></div>	
				<div class="tab_item"><a href="#tab2" title="{$tr->full_description|escape}">{$tr->full_description|escape}</a></div>
				<span class="helper">(<a class="helperlink" href="#helper">{$tr->standart|escape}</a>)</span>							
			</div>
		
			<div class="tab_container">
				<div id="tab1" class="tab_content">
					<textarea name="annotation" class="editor_small">{if !empty($product->annotation)}{$product->annotation|escape}{/if}</textarea>
				</div>
				<div id="tab2" class="tab_content">
					<textarea style="height:260px;" name="body" class="editor_small">{if !empty($product->body)}{$product->body|escape}{/if}</textarea>
				</div>	
			</div>
		</div>
		<!-- Описание товара (The End)-->
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
	
	</span>
		
	</form>
	<!-- Основная форма (The End) -->

</div>

<script>
	$("a.zoom").fancybox({ 'hideOnContentClick' : true });
	$(".sizechoose").click(function() { 
		$('#variants_block').toggleClass('clothes');
		$('.images input.curr, .colorhelp').slideToggle('normal');
	});
	   
	// Удаление файлов товара
	$(".files_products a.delete").live('click', function() {
		 $(this).closest("div.row").fadeOut(200, function() { $(this).remove(); });
		 return false;
	});
	
	// Tabs
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
<link rel="stylesheet" type="text/css" href="../../js/jquery/datetime/jquery.datetimepicker.css"/>
<script src="../../js/jquery/datetime/jquery.datetimepicker.full.min.js"></script>
<script>
	$('.datetime').datetimepicker({ lang:'ru', format:'d.m.Y H:i' });
	$.datetimepicker.setLocale('ru');
</script>
<style>
#product .block label.property { width:190px;padding-right:10px; }
</style>
