{* Канонический адрес страницы *}
{$canonical="/products/{$product->url}" scope=root}
{* product seo title *}
	{if !empty($category->name)}{$ctg = " | "|cat:$category->name}{else}{$ctg = ''}{/if}
	{if !empty($brand->name)}{$brnd = " | "|cat:$brand->name}{else}{$brnd = ''}{/if}
	{if empty($meta_title) && !empty($product->name)}
		{$seo_title=$product->name|cat:$ctg|cat:$brnd scope=root}
	{/if}
{* product seo description *}
	{if !empty($category)}{$first_category = $category->path|first}{/if}
	{if !empty($category->seo_one)}
		{$seo_one = $category->seo_one}
	{elseif !empty($first_category->seo_one)}
		{$seo_one = $first_category->seo_one}
	{else}
		{$seo_one = ''}
	{/if}
	{if !empty($category->seo_two)}
		{$seo_two = $category->seo_two}
	{elseif !empty($first_category->seo_two)}
		{$seo_two = $first_category->seo_two}
	{else}
		{$seo_two = ''}
	{/if}
	{if !empty($category->seo_type)}
		{$seo_type = $category->seo_type}
	{elseif !empty($first_category->seo_type)}
		{$seo_type = $first_category->seo_type}
	{else}
		{$seo_type = 0}
	{/if}	

	{if $seo_type == 2 && !empty($product->variant->price)}
		{$seo_description = $seo_one|cat:$product->name|cat:" ✩ за "|cat:($product->variant->price|convert|strip:'')|cat:" "|cat:$currency->sign|cat:$seo_two scope=root}
	{else}
		{$seo_description = $seo_one|cat:$product->name|cat:$seo_two scope=root}
	{/if}

<h1 data-product="{$product->id}">{$product->name|escape}</h1>

<div class="product">
	{* Product images | Фото товара *}
		<div class="blockimg">	
			<div class="labelsblock">
			{if !empty($product->featured)}<div class="hit">Хит</div>{/if}
			{if !empty($product->is_new)}<div class="new">Новинка</div>{/if}
			{if !empty($product->variant->compare_price)}<div class="lowprice">- {100-($product->variant->price*100/$product->variant->compare_price)|round}%</div>{/if}
		</div>
		{* Большое фото *}
		<div class="imagebig" id="lenss">
			<div class="big_middle">
				{if $product->image}
					{if $product->images|count==1}
					<a href="{$product->image->filename|resize:1024:768:w}" class="zoom cloud-zoom" id="zoom1" title="{$product->name|escape}" data-rel="{if !empty($product->image->color)}{$product->image->color}{else}gallery{/if}">
					{/if}
						<div onClick="$('.imagesmall a:visible:first').click();" class="image"><img src="{$product->image->filename|resize:1024:768:w}" alt="{$product->name|escape}" title="{$product->name|escape}" class="imglenss" /></div>
					{if $product->images|count==1}</a>{/if}	
				{else}
					<div class="image">
						<svg fill="#dadada" style="width:50%;height:50%;" viewBox="0 0 24 24">
							<use xlink:href='#no_photo' />
						</svg>
					</div>
				{/if}
			</div>
		</div> 
		{* Большое фото @ *}
		{* Миниатюры *}
		{if $product->images|count>1}
			<div class="images">
				{foreach $product->images as $i=>$image}
					<div class="{if !$image->color}imgvisible{/if} cloud-zoom-gallery imagesmall" data-imcolor="{$image->color}" data-sm="{$image->filename|resize:1024:768:w}">
						<a class="zoom" href="{$image->filename|resize:1024:768:w}" title="{$product->name|escape}" data-rel="{if !empty($image->color)}{$image->color}{else}gallery{/if}">
							<img src="{$image->filename|resize:100:100}" alt="{$product->name|escape}" title="{$product->name|escape}"/>
						</a>
					</div>
				{/foreach}
			</div>
		{/if}
		{* Миниатюры @ *}
	</div>
	{* Product images | Фото товара @ *}
	
	{$notinstock=1}
	{foreach $product->variants as $pv}
		{if $pv->stock > 0}
			{$notinstock=0}
			{break}
		{/if}
	{/foreach}
	
	{if isset($product->rating) && $product->rating|floatval > 0}
		{$rating = $product->rating}
	{else}
		{$rating = $settings->prods_rating|floatval}
	{/if}
	
	{$votes = $settings->prods_votes|intval + $product->votes}

	{* Описание товара *}
	<div class="description border_wrapper">
	
		{* schema *}
		{if $product->annotation}{$descr = $product->annotation|strip_tags:true}{elseif $product->body}{$descr = $product->body|strip_tags:true}{elseif !empty($seo_description)}{$descr = $seo_description|escape}{elseif $meta_description}{$descr = $meta_description|escape}{else}{$descr = $product->name|escape}{/if}
		<div itemscope itemtype="http://schema.org/Product">
			<meta content="{$product->name|escape}" itemprop="name">
			<meta content="{$descr|replace:'"':''}" itemprop="description">
			<meta content="{if $product->image}{$product->image->filename|resize:1024:768:w}{else}{$config->root_url}/js/nophoto.png{/if}" itemprop="image">
			{if !empty($product->variant->price)}
			<div itemprop="offers" itemscope itemtype="http://schema.org/Offer"> 
				<meta content="{$product->variant->price|convert|strip:''}" itemprop="price">
				<meta content="{$currency->code|escape|replace:'RUR':'RUB'}" itemprop="priceCurrency">
				<link itemprop="url" href="{$config->root_url}/products/{$product->url}"/>
				{if $product->variant->stock == 0}
					<meta content="OutOfStock" itemprop="availability">
				{else}
					<meta content="InStock" itemprop="availability">
				{/if}
			</div>
			{/if}
			{if !empty($product->variant->sku)}<meta content="{$product->variant->sku}" itemprop="sku">{/if}
			{if !empty($votes) && !empty($rating)}
			<div itemprop="aggregateRating" itemscope itemtype="http://schema.org/AggregateRating">
				<meta itemprop="ratingValue" content="{$rating}">
				<meta itemprop="ratingCount" content="{$votes}">
				<meta itemprop="worstRating" content="1">
				<meta itemprop="bestRating" content="5">
			</div>
			{/if}
			{if !empty($brand->name)}
			<div itemprop="brand" itemscope itemtype="http://schema.org/Brand">
				<meta itemprop="name" content="{$brand->name|escape}">
			</div>
			{/if}
		</div>
		{* schema @ *}	
	
		{* rating *}
		<div class="testRater" id="product_{$product->id}">
			<div class="statVal">
				<span class="rater">
					<span class="rater-starsOff" style="width:115px;">
						<span class="rater-starsOn" style="width:{$rating*115/5|string_format:'%.0f'}px"></span>
					</span>
					<span class="test-text">
						<span class="rater-rating">{$rating|string_format:"%.1f"}</span>&#160;(голосов <span class="rater-rateCount">{$votes|string_format:"%.0f"}</span>)
					</span>
				</span>
			</div>
		</div>
		{* rating @ *}

		{if $settings->showsku == 1}<p class="sku">{if !empty($product->variant->sku)}Артикул: {$product->variant->sku}{/if}</p>{/if}
		{if $settings->showstock == 1}<span class="stockblock">На складе: <span class="stock">{if !empty($notinstock)}нет в наличии{elseif $product->variant->stock < $settings->max_order_amount}{$product->variant->stock}{else}много{/if}</span></span>{/if}
	
		{* Выбор варианта товара *}
		<form class="variants" action="/cart">
			<div class="bm_good">	
				{if $product->vproperties}
						<script>
						{literal}
							$(window).load(function(){
								// Смена цвета изображения
								try{
									chpr(elem);
								} catch(e) {window.location.replace(window.location);}
								$(".p0").change(function(){chpr(this)});
								$(".p1").change(function(){chpr(this)});
								function chpr(el){
									elem=$(el).closest('.variants')
										$('.images .cloud-zoom-gallery').attr('style','display:none;');
										var color_label="'"+$('#bigimagep1 :selected').text()+"'";
										var color_label_clean=$('#bigimagep1 :selected').text();
										$('[data-imcolor='+color_label+']').attr('style','display:block;').attr('id','showcolor');
										sm=$('[data-imcolor='+color_label+'] ').attr('data-sm');
										if(color_label_clean !== '')
											$('.product .big_middle a').attr('data-rel',color_label_clean);
										$('.product .big_middle img').attr('src',sm);
								}
							})
						{/literal}
						</script>
						{$cntname1 = 0}	
						<span class="pricelist" style="display:none;">
							{foreach $product->variants as $v}
								{$ballov = ($v->price * $settings->bonus_order/100)|convert|replace:' ':''|round}
								<span class="c{$v->id}" data-stock="{if $v->stock < $settings->max_order_amount}{$v->stock}{else}много{/if}" data-unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}" data-sku="{if $v->sku}Артикул: {$v->sku}{/if}" data-bonus="{$ballov} {$ballov|plural:'балл':'баллов':'балла'}">{$v->price|convert}</span>
								{if $v->name1}{$cntname1 = 1}{/if}
							{/foreach}
						</span>
					
						{$cntname2 = 0}
						<span class="pricelist2" style="display:none;">
							{foreach $product->variants as $v}
								{if $v->compare_price > 0}<span class="c{$v->id}">{$v->compare_price|convert}</span>{/if}
								{if $v->name2}{$cntname2 = $cntname2 + 1}{/if}
							{/foreach}
						</span>
						{* Здесь variant_id *}
						<input class="vhidden 1clk" name="variant" value="" type="hidden" />

						<div style="display: table; margin-bottom: 15px;">
							<select name="variant1" class="p0"{if $cntname1 == 0} style="display:none;"{/if}>
								{foreach $product->vproperties[0] as $pname => $pclass}
									{assign var="size" value="c"|explode:$pclass}
									<option {if $cntname1 == 0}label="size"{/if} value="{$pclass}" class="{$pclass}" 
										{foreach $size as $sz}{if $product->variant->id == $sz|intval}selected{/if}{/foreach}
									>{$pname}</option>
								{/foreach}
							</select>
							<select name="variant2" id="bigimagep1" class="p1"{if $cntname2 == 0} style="display:none;"{/if}>
								{foreach $product->vproperties[1] as $pname => $pclass}
									{assign var="color" value="c"|explode:$pclass}
									<option value="{$pclass}" class="{$pclass}"
										{foreach $color as $cl}{if $product->variant->id == $cl|intval}selected{/if}{/foreach}
									>{$pname}</option>
								{/foreach}
							</select>
						</div>
						<div class="colorpriceseparator">
							{if empty($notinstock)}
							<div id="amount">
								<input type="button" class="minus" value="-" />
								<input type="text" class="amount" name="amount" data-max="{$settings->max_order_amount|escape}" value="1" size="2"/>
								<input type="button" class="plus" value="+" />
							</div>
							{/if}
							<span class="compare_price"></span>
							<span class="price"></span>
							<span class="currency">
								{$currency->sign|escape}
								{if $settings->b9manage}/<span class="unit">{if $product->variant->unit}{$product->variant->unit}{else}{$settings->units}{/if}</span>{/if}
							</span>
				{else}
						{if $product->variants|count==1  && !$product->variant->name}{else}<span class="b1c_caption" style="display: none;"> </span>{/if}

						<select class="b1c_option" name="variant" {if $product->variants|count==1  && !$product->variant->name}style='display:none;'{/if}>
							{foreach $product->variants as $v}
								{$ballov = ($v->price * $settings->bonus_order/100)|convert|replace:' ':''|round}
								<option {if $product->variant->id==$v->id}selected{/if} data-stock="{if $v->stock < $settings->max_order_amount}{$v->stock}{else}много{/if}" data-unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}" data-sku="{if $v->sku}Артикул: {$v->sku}{/if}" data-bonus="{$ballov} {$ballov|plural:'балл':'баллов':'балла'}" value="{$v->id}" {if $v->compare_price > 0}data-cprice="{$v->compare_price|convert}"{/if} data-varprice="{$v->price|convert}" {if $v->stock == 0}disabled{/if}>
									{$v->name|escape}&nbsp;
								</option>
							{/foreach}
						</select>
					
						<div class="price noncolor">
							{if empty($notinstock)}
							<div id="amount">
								<input type="button" class="minus" value="-" />
								<input type="text" class="amount" name="amount" data-max="{$settings->max_order_amount|escape}" value="1" size="2"/>
								<input type="button" class="plus" value="+" />
							</div>
							{/if}
							<span class="compare_price">{if $product->variant->compare_price}{$product->variant->compare_price|convert}{/if}</span>
							<span class="price">{$product->variant->price|convert}</span>
							<span class="currency">
								{$currency->sign|escape}{if $settings->b9manage}/<span class="unit">{if $product->variant->unit}{$product->variant->unit}{else}{$settings->units}{/if}</span>{/if}
							</span>
				{/if}
							{if $settings->bonus_limit && $settings->bonus_order}{$ballov = ($product->variant->price * $settings->bonus_order/100)|convert|replace:' ':''|round}<span class="bonus">+ <span class="bonusnum">{$ballov} {$ballov|plural:'балл':'баллов':'балла'}</span></span>{/if}
						</div>
				{if empty($notinstock)}	
					<input onmousedown="try { rrApi.addToBasket({$product->variant->id}) } catch(e) {}" style="float: left;" {if !empty($product->ref_url)}onClick="window.open('{$product->ref_url|escape}', '_blank');return false;"{/if} type="submit" class="buttonred" value="{$settings->to_cart_name|escape}" data-result-text="добавлено" />
					{if !empty($settings->show1click) && empty($product->ref_url)}{include file='1click.tpl'}{/if}
				{/if}	
					
				{include file='wishcomp.tpl'}
			</div>
		</form>
		<script>
			// Максимальное кол-аво не более разрешенного
			$(window).load(function() {
				stock=parseInt($('.productview select[name=variant]').find('option:selected').attr('data-stock'));
				if( !$.isNumeric(stock) ){ stock = {$settings->max_order_amount|escape}; }
				$('.variants .amount').attr('data-max',stock);
				
				if(stock == 0){
					$('.variants .amount').val(0);
				}
			});
			$(document).on('change','.productview select[name=variant]',function(){ 
				stock=parseInt($(this).find('option:selected').attr('data-stock'));
				if( !$.isNumeric(stock) ) 
					stock = {$settings->max_order_amount|escape};
	
				$('.variants .amount').attr('data-max',stock);
	
				oldamount = parseInt($('.variants .amount').val());

				if(oldamount > stock) 
					$('.variants .amount').val(stock);
				else if(stock != 0)
					$('.variants .amount').val(1);
				else if(stock == 0)	
					$('.variants .amount').val(0);
			});
		</script>
		{* Выбор варианта товара (The End) *}
		
		{if !empty($brand->name)}<div class="annot-brand"><span>Производитель:</span> <a class="bluelink" style="font-weight:700;" href="brands/{$brand->url}">{$brand->name|escape}</a></div>{/if}
			
		{if $product->annotation}
			<div class="annot">
				{$product->annotation}
			</div>
		{/if}
		{* Share *}
		<div class="annot-brand share_wrapper">
			<div class="share_title">Поделиться:</div> 
			<div class="share">
				<div class="vk sprite" onClick='window.open("https://vk.com/share.php?url={$config->root_url|urlencode}/products/{$product->url|urlencode}&title={$product->name|urlencode}&noparse=false");'></div>
				<div class="facebook sprite" onClick='window.open("https://www.facebook.com/sharer.php?u={$config->root_url|urlencode}/products/{$product->url|urlencode}");'></div>
				<div class="twitter sprite" onClick='window.open("https://twitter.com/share?text={$product->name|urlencode}&url={$config->root_url|urlencode}/products/{$product->url|urlencode}&hashtags={$product->meta_keywords|replace:' ':''|urlencode}");'></div>
				 <div class="gplus sprite"  onClick='window.open("https://plus.google.com/share?url={$config->root_url|urlencode}/products/{$product->url|urlencode}");'></div>
				 <div class="ok sprite"  onClick='window.open("https://connect.ok.ru/offer?url={$config->root_url|urlencode}/products/{$product->url|urlencode}&title={$product->name|urlencode}&imageUrl={if $product->image}{$product->image->filename|resize:1024:768:w}{else}{$config->root_url}/js/nophoto.png{/if}");'></div>
			</div>
		</div>
		{* Share @ *}

	</div>
	
	<div class="container">

		<ul class="tabs">
			{if !empty($product->body)}<li><a href="#tab1" title="Описание">Описание</a></li>{/if}
			{if !empty($product->features)}<li><a href="#tab2" title="Характеристики">Характеристики</a></li>{/if}
			{if !empty($cms_files)}<li><a href="#tab4" title="Файлы">Файлы</a></li>{/if}
			<li class="coments_tab"><a href="#tab3" title="Отзывы">Отзывы{if $comments} ({$comments|count}){/if}</a></li>
			{if !empty($settings->youtube_product)}<li class="find_video" onClick="findVideo('{$product->name|escape}');"><a href="#tab5" title="Видео">Видео</a></li>{/if}
			{if !empty($settings->del_pay)}<li><a href="#tab6" title="Оплата и доставка">Оплата и доставка</a></li>{/if}
		</ul>

		<div class="tab_container">
			
			{if !empty($product->body)}
			<div id="tab1" class="tab_content">
				{$product->body}
			</div>
			{/if}
		
			{if !empty($product->features)}
			<div id="tab2" class="tab_content">
				<ul class="features">
				{foreach $product->features as $f}
				<li>
					<label class="featurename"><span>{$f->name|escape}</span></label>
					<label class="lfeature">{$f->value|escape}</label>
				</li>
				{/foreach}
				</ul>
			</div>
			{/if}
		
			{if !empty($cms_files)}
			<div id="tab4" class="tab_content">
				<ul class="stars">
				{foreach $cms_files as $file}
					<li>
						{if $file->filename|substr:0:4 == 'http'}
							{$filename = $file->filename}
						{else}
							{$filename = $config->cms_files_dir|cat:$file->filename}	
						{/if}
						<a href="{$filename}" download="{$filename}">
							{if $file->name}{$file->name|escape}{else}{$file->filename}{/if}
						</a>
					</li>
				{/foreach}
				</ul>
			</div>
			{/if}

			<div id="tab3" class="tab_content">
				<div id="comments">
					<div class="comments-left">
						<h3>Отзывы к "{$product->name|escape}":</h3>
					
						{if $comments}
						{* Список с комментариями *}
				
						<ul class="comment_list">
							{foreach $comments as $comment}
							<li>
								<div class="comment_header">	
									{$comment->name|escape} <i>{$comment->date|date}, {$comment->date|time}</i>
									{if !$comment->approved}ожидает модерации</b>{/if}
								</div>
						
								<div class="comment_body">{if !empty($settings->allow_comment_tags)}{$comment->text|escape|nl2br|bbcode}{else}{$comment->text|escape|nl2br}{/if}</div>
								{if $comment->otvet}
									<div class="comment_admint">Администрация:</div>
									<div class="comment_admin">
										{$comment->otvet}
									</div>
								{/if}
						
							</li>
							{/foreach}
						</ul>
					
						{$comments_on_page = 5}
						{if $comments|count > $comments_on_page}	
							<script type="text/javascript" src="js/pagination/pagination.js"></script>
							<script>var show_per_page = {$comments_on_page};</script>
							<input type='hidden' id='current_page' />
							<input type='hidden' id='show_per_page' />	
							<div id="page_navigation" class="pagination"></div>
						{/if}
					
						{* Список с комментариями (The End) *}
						{else}
							<p>Пока нет комментариев</p>
						{/if}
					</div>
					{* Форма отправления комментария *}	
					<form class="comment_form" method="post">
						<div class="comm-title">Написать комментарий</div>
						{if !empty($error)}
						<div class="message_error">
							{if $error=='captcha'}
							Не пройдена проверка на бота
							{elseif $error=='empty_name'}
							Введите имя
							{elseif $error=='empty_comment'}
							Введите комментарий
							{elseif $error=='empty_email'}
							Введите Email
							{elseif $error == 'wrong_name'}
							В поле 'Имя' может использоваться только кириллица
							{elseif $error == 'wrong_email'}
							Некорректный Email
							{/if}
						</div>
						{/if}
						
						{if !empty($settings->allow_comment_tags)}<div class="comment_help">{$settings->comment_tags}</div>{/if}
						
						<textarea class="comment_textarea" id="comment_text" name="text" data-format=".+" data-notice="Введите комментарий">{if !empty($comment_text)}{$comment_text|escape}{/if}</textarea><br />
						<div>
						<label for="comment_name">Имя</label>
						<input class="input_name" type="text" id="comment_name" name="name" value="{if !empty($comment_name)}{$comment_name|escape}{/if}" data-format=".+" data-notice="Введите имя"/><br />
			
						<label for="comment_email">E-Mail</label>
						<input class="input_name" type="email" id="comment_email" name="email" value="{if !empty($comment_email)}{$comment_email|escape}{/if}" data-format=".+" data-notice="Введите Email"/><br />
					
						{include file='conf.tpl'}
						<input class="button hideablebutton" type="submit" name="comment" value="Отправить" />
					
						{include file='antibot.tpl'}
					
						</div>
					</form>
					{* Форма отправления комментария @ *}
	
				</div>
			</div>
		
			{if !empty($settings->youtube_product)}
			{* Youtube *}
			<div id="tab5" class="tab_content">
				<p class="video_founded" style="margin-bottom:20px;">Видео-обзоры "{$product->name|escape}", подобранные <strong>автоматически</strong>:</p>
				<p class="video_not_founded" style="display:none;margin-bottom:10px;">Видео-обзоров для "{$product->name|escape}" не найдено</p>
				<ul class="inline" id="results"></ul>
			</div>
			<script type="text/javascript">
				var vidResults = 2; // кол-во видео
				function findVideo(searchText){ 
						var searchText;
						$.get(
						"https://www.googleapis.com/youtube/v3/search",{ 
							part: 'id',
							q: searchText,
							maxResults: vidResults,
							//order: 'relevance',
							key: '{$settings->youtube_key}'
							},
							function(data){ 
								$('.youtube_tab').show();
								var output;
								$.each(data.items, function(i, item){ 
									//console.log(item);
									videoId = item.id.videoId;
									output = '<li style=\"margin:10px 0 30px 0;\"><iframe class=\"superembed-force\" frameborder="0" allowfullscreen height="236" width="420" src=\"//www.youtube.com/embed/'+videoId+'\"></iframe></li>';
									$('#results').append(output);
								})
								if(output){ 
									$.getScript("/js/superembed.min.js");
								} else {
									$('.video_not_founded').show();
									$('.video_founded').hide();
								}
							}
						);
						$('.find_video').removeAttr('onClick');
				};
			</script>
			{* Youtube @ *}
			{/if}
			
			{if !empty($settings->del_pay)}
			<div id="tab6" class="tab_content">
				{include file='del_pay.tpl'}
			</div>
			{/if}
		</div>
	</div>

	{* Соседние товары *}
	{if !empty($prev_product) || !empty($next_product)}
	<div id="back_forward">
		{if !empty($prev_product)}
			<span class="prev_page_link">&laquo; <a class="prev_page_link" href="products/{$prev_product->url}" title="{$prev_product->name|escape}">{$prev_product->name|escape|truncate:40:"...":true}</a></span>
		{/if}
		{if !empty($next_product)}
			<span class="next_page_link"><a class="next_page_link" href="products/{$next_product->url}" title="{$next_product->name|escape}">{$next_product->name|escape|truncate:40:"...":true}</a> &raquo;</span>
		{/if}
	</div>
	{/if}
</div>

{* Связанные / Похожие товары *}
{if !empty($notinstock)}
	{* Похожие товары *}
	{get_products var=related_products category_id=$category->id sort=rand limit=5}
	{$related_title="Похожие товары"}
{elseif !empty($related_ids)}
	{* Связанные товары *}
	{get_products var=related_products id=$related_ids}
	{$related_title="С этим товаром часто покупают"}
{/if}	

{if !empty($related_products)}
	<div class="mainproduct blue">{$related_title}</div>
	<ul class="related relcontent tiny_products">
		{foreach $related_products as $related_product}
			{include file='products_related.tpl'}
		{/foreach}
	</ul>
{/if}
{* Связанные / Похожие товары @ *}

{* Лидеры продаж *}
{* available sort (or remove): position, name, date, rating, rand *}
{if !empty($category->id)}
	{get_products var=featured_products featured=1 category_id=$category->id sort=rand limit=4}
{else}
	{get_products var=featured_products featured=1 sort=rand limit=4}
{/if}
{if !empty($featured_products)}
	<div class="mainproduct blue">Вас также могут заинтересовать</div>
	<div id="hitcontent" class="tiny_products hoverable">
		{foreach $featured_products as $product}
			<div class="product_wrap">
				{include file='products_item.tpl'}
			</div>
		{/foreach}
	</div>
{/if}
{* Лидеры продаж @ *}

{* Связанные статьи *}
{get_object_articles var=last_articles type='product' id=$product->id limit=3 visible=1 sort='date'}
{if !empty($last_articles)}
	<div class="mainproduct blog_also">Рекомендуем прочесть</div>
	<div class="blogposts">
	{include file='articlesline_body.tpl'}
	</div>    
{/if}
{* Связанные статьи @ *}

<script>
	$(document).ready(function() { 
		$(".tab_content").hide();
		{if !empty($error)}
			$("ul.tabs li.coments_tab").addClass("active").show();
			$("#tab3").show();
		{else}
			$("ul.tabs li:first").addClass("active").show();
			$(".tab_content:first").show();
		{/if}
		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();
			var activeTab = $(this).find("a").attr("href");
			$(activeTab).fadeIn();
			return false;
		});
	});
</script>
<script>
$(document).ready(function() { 
	$('.minus').click(function () { 
		var $input = $(this).parent().find('.amount');
		
		var count = parseInt($input.val()) - 1;
		count = count < 1 ? 1 : count;
		if( !$.isNumeric(count) ){ count = 1; }
		
		maxamount = parseInt($('#amount .amount').attr('data-max'));
		if( !$.isNumeric(maxamount) ){ maxamount = {$settings->max_order_amount|escape}; $('#amount .amount').attr('data-max',maxamount);}
		if(count < maxamount)
			$input.val(count);
		else
			$input.val(maxamount);
		
		$input.change();
		return false;
	});
	$('.plus').click(function () { 
		var $input = $(this).parent().find('.amount');
		oldamount = parseInt($input.val());
		if( !$.isNumeric(oldamount) ){ oldamount = 1; }
		
		maxamount = parseInt($('#amount .amount').attr('data-max'));
		if( !$.isNumeric(maxamount) ){ maxamount = {$settings->max_order_amount|escape}; $('#amount .amount').attr('data-max',maxamount);}
		
		if(oldamount < maxamount)
			$input.val(oldamount + 1);
		else
			$input.val(maxamount);
		$input.change();
		return false;
	});
	
	// Проверяем кол-во
	$(document).on('keyup','.description .amount',function(){
        amount = parseInt($('.description .amount').val());
        max_order_amount = parseInt($('.description .amount').attr('data-max'));
    	if(!$.isNumeric(max_order_amount))
            max_order_amount = {$settings->max_order_amount|escape};
    	if(!$.isNumeric(amount)){	
            amount = 1;
            $('.description .amount').val(amount);
        }	
		if(amount > max_order_amount)
			$('.description .amount').val(max_order_amount);
	});
});		
</script>
