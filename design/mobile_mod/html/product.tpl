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
	
<div class="product">
	<div style="position:relative;">
		<div class="labelsblock blockimg">
			{if !empty($product->featured)}
				<svg class="hit"><use xlink:href='#hit' /></svg>
			{/if}
			{if !empty($product->is_new)}
				<svg class="new"><use xlink:href='#new' /></svg>
			{/if}
			{if !empty($product->variant->compare_price)}
				<svg class="lowprice"><use xlink:href='#lowprice' /></svg>
			{/if}
		</div>
		<div id="swipeimg" class="slider">
			{if !empty($product->images)}
				{foreach $product->images as $i=>$image}
					<div imcolor="{$image->color}" {if $image->color}class="blockwrapp" {else}class="showanyway" style="visibility:visible;"{/if}>
						<a href="{$image->filename|resize:960:1440:w}" data-fancybox="images" class="imgwrapper zoom">
							<img alt="{$product->name|escape}" title="{$product->name|escape}" class="blockimage" src="{$image->filename|resize:480:720}" />
						</a>
					</div>
				{/foreach}
			{else}
				<div class="showanyway" style="visibility:visible;">
					<div class="imgwrapper">
						<svg class="nophoto"><use xlink:href='#no_photo' /></svg>
					</div>
				</div>
			{/if}
		</div>
		{if !empty($product->images) && $product->images|count>1}
		<div class="directionNav">
			<span onClick="Swipeslider.Prev();" class="prev"></span><span onClick="Swipeslider.Next();" class="next"></span>
		</div>
		{/if}
		<style>
			.fancybox-custom-image-container .fancybox-content {
				padding: 0;
			}
			.fancybox-custom-image-container .blockimage {
				max-width: 100% !important;
				display: block !important;
			}
		</style>
	</div>

	{* Описание товара *}
	<div class="description">
		{$notinstock=1}
		{foreach $product->variants as $pv}
			{if $pv->stock > 0}
				{$notinstock=0}
				{break}
			{/if}
		{/foreach}

			{* Выбор варианта товара *}
			<form class="variants" action="/cart">
				<div class="bm_good">	
					{if $product->vproperties}
						{$cntname1 = 0}	
						<span class="pricelist" style="display:none;">
							{foreach $product->variants as $v}
								{$ballov = ($v->price * $settings->bonus_order/100)|convert|replace:' ':''|round}
								<span class="c{$v->id}" v_stock="{if $v->stock < $settings->max_order_amount}{$v->stock}{else}много{/if}" v_unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}" v_sku="{if $v->sku}Арт.: {$v->sku}{/if}" v_bonus="{$ballov} {$ballov|plural:'балл':'баллов':'балла'}">{$v->price|convert}</span>
								{if $v->name1}{$cntname1 = 1}{/if}
							{/foreach}
						</span>
	
						{$cntname2 = 0}
						<span class="pricelist2" style="display:none;">
							{foreach $product->variants as $v}
								{if $v->compare_price > 0}<span class="c{$v->id}">{$v->compare_price|convert}</span>{/if}
								{if $v->name2}{$cntname2 = 1}{/if}
							{/foreach}
						</span>
	
						<input id="vhidden" class="1clk vhidden" name="variant" value="" type="hidden" />

						<div class="variantsblock">
							<select name="variant1" class="p0"{if $cntname1 == 0} style="display:none;"{/if}>
								{foreach $product->vproperties[0] as $pname => $pclass}
									{assign var="size" value="c"|explode:$pclass}
									<option v_size="{$pname}" value="{$pclass}" class="{$pclass}" 
										{foreach $size as $sz}{if $product->variant->id == $sz|intval}selected{/if}{/foreach}
									>{$pname}</option>
								{/foreach}
							</select>
			
							<select name="variant2" id="bigimagep1" class="p1"{if $cntname2 == 0} style="display:none;"{/if}>
								{foreach $product->vproperties[1] as $pname => $pclass}
									{assign var="color" value="c"|explode:$pclass}
									<span><option v_color="{$pname}" value="{$pclass}" class="{$pclass}" 
										{foreach $color as $cl}{if $product->variant->id == $cl|intval}selected{/if}{/foreach}
									>{$pname}</option></span>
								{/foreach}
							</select>
						</div>
	
						<div class="amount-price">
							{if empty($notinstock)}
							<div id="amount">
								<input type="button" class="minus" value="−" />
								<input type="number" class="amount" name="amount" value="1" size="2" data-max="{$settings->max_order_amount|escape}" />
								<input type="button" class="plus" value="+" />
								<span class="umnozh">X</span>
							</div>
							{/if}
							<div class="price-block {if !$product->variant->compare_price > 0}pricebig{/if}">
								{if $product->variant->compare_price > 0}
									<div ID="priceold" class="compare_price"></div>
								{/if}
								<span ID="price" class="price"></span>
								<span class="currency">{$currency->sign|escape}</span>
							</div>
						</div>
					{else}
						<div id="noncolor" class="variantsblock" {if $product->variants|count==1  && !$product->variant->name}style='display:none;'{/if}>
							{if $product->variants|count==1  && !$product->variant->name}{else}<span class="b1c_caption" style="display: none;"> </span>{/if}
							<select class="b1c_option" name="variant">
								{foreach $product->variants as $v}
									{$ballov = ($v->price * $settings->bonus_order/100)|convert|replace:' ':''|round}
									<option v_name="{$v->name}" v_price="{$v->price|convert} {$currency->sign|escape}" v_stock="{if $v->stock < $settings->max_order_amount}{$v->stock}{else}много{/if}" v_unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}" v_sku="{if $v->sku}Арт.: {$v->sku}{/if}" v_bonus="{$ballov} {$ballov|plural:'балл':'баллов':'балла'}" value="{$v->id}" {if $v->compare_price > 0}compare_price="{$v->compare_price|convert}"{/if} price="{$v->price|convert}" click="{$v->name}" {if $product->variant->id==$v->id}selected{/if} {if $v->stock == 0}disabled{/if}>
										{$v->name}&nbsp;
									</option>
								{/foreach}
							</select>
						</div>
										
						<div class="price" style="display:table; float:left; width:100%;">
							{if empty($notinstock)}
							<div id="amount">
								<input type="button" class="minus" value="−" />
								<input type="number" class="amount" name="amount" value="1" size="2" data-max="{$settings->max_order_amount|escape}"/>
								<input type="button" class="plus" value="+" />
								<span class="umnozh">X</span>
							</div>
							{/if}
							<script>
								$(window).load(function() {
									stock=parseInt($('.productview select[name=variant]').find('option:selected').attr('v_stock'));
									if( !$.isNumeric(stock) ){ stock = {$settings->max_order_amount|escape}; }
									$('.variants .amount').attr('data-max',stock);
									if(stock == 0)	
										$('.variants .amount').val(0);
								});
								$('.productview select[name=variant]').change(function(){
									stock=parseInt($(this).find('option:selected').attr('v_stock'));
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

							<div class="price-block {if !$product->variant->compare_price > 0}pricebig{/if}">
								{if $product->variant->compare_price > 0}
									<div class="compare_price">{$product->variant->compare_price|convert}</div>
								{/if}
								<span class="price">{$product->variant->price|convert}</span>
								<span class="currency">{$currency->sign|escape}</span>
							</div>
						</div>
					{/if}
					<script>
						$(window).load(function() {		
							// Проверяем кол-во
                        	$(document).on('change','.description .amount',function(){
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

					{if $product->on_request}
						<div class="on-request">Под заказ</div>
					{/if}

					{if $product->out_of}
						<div class="out-of"> Снято с производства</div>
					{/if}

					<div class="separator" style="margin-bottom:15px;">
						{if $settings->b9manage}<div style="float:right;font-size:13px;margin:0px 0 15px 0;">Цена указана за <span class="unit">{if $product->variant->unit}{$product->variant->unit}{else}{$settings->units}{/if}</span></div>{/if}

						<div class="separator skustock">
							<div class="skustockleft">
								{if $settings->showsku == 1}<p class="sku">{if !empty($product->variant->sku)}Арт.: {$product->variant->sku}{/if}</p>{/if}
								{if $settings->showstock == 1}<div class="stockblock">На складе: <span class="stock">{if !empty($notinstock)}нет в наличии{elseif $product->variant->stock < $settings->max_order_amount}{$product->variant->stock}{else}много{/if}</span></div>{/if}
							</div>
							{if $settings->bonus_limit && $settings->bonus_order}{$ballov = ($product->variant->price * $settings->bonus_order/100)|convert|replace:' ':''|round}<span class="bonus">+ <span class="bonusnum">{$ballov} {$ballov|plural:'балл':'баллов':'балла'}</span></span>{/if}
						</div>
					</div>
					{if empty($notinstock)}
					<div class="buttonsblock">
						<input style="float: left;" {if !empty($product->ref_url)}onClick="window.open('{$product->ref_url|escape}', '_blank');return false;"{/if} type="submit" class="buttonred" value="{$settings->to_cart_name|escape}" data-result-text="добавлено" />
						{if !empty($settings->show1click) && empty($product->ref_url)}{include file='1click.tpl'}{/if}
					</div>
					{/if}
				</div>
			</form>
			{* Выбор варианта товара (The End) *}

			{* rating *}
			{if isset($product->rating) && $product->rating > 0}
				{$rating = $product->rating}
			{else}
				{$rating = $settings->prods_rating|floatval}
			{/if}	
			{$votes = $settings->prods_votes|intval + $product->votes}
			<div class="separator">
				<div class="testRater" id="product_{$product->id}">
					<div class="statVal">
						<span class="rater">
							<span class="rater-starsOff" style="width:115px;">
								<span class="rater-starsOn" style="width:{$rating*115/5|string_format:"%.0f"}px"></span>
							</span>
							<span class="test-text">
								<span class="rater-rating">{$rating|string_format:"%.1f"}</span>&#160;(голосов <span class="rater-rateCount">{$votes|string_format:"%.0f"}</span>)
							</span>
						</span>
					</div>
				</div>
				{* rating (The End) *}
				{include file='wishcomp.tpl'}
			</div>

	
	</div>
	
	<div class="separator brand-sku-category">
		{if !empty($product->delivery_time)}<p class="product-brand">Срок поставки: <span style="color: #1B6F9F;">{$product->delivery_time|escape}</span></p>{/if}
		{if !empty($category)}<p class="catname">Категория: <a title="{$category->name|escape}" href="catalog/{$category->url|escape}">{if !empty($category->menu)}{$category->menu|escape}{else}{$category->name|escape}{/if}</a></p>{/if}
	</div>
	
	{* Tabs *}
	<div class="container">
	
		<ul class="tabs">
			{if !empty($product->annotation)}<li class="anchor" data-anchor=".tab_container"><a href="#tab0" title="Аннотация">Аннотация</a></li>{/if}
			{if !empty($product->body)}<li class="anchor" data-anchor=".tab_container"><a href="#tab1" title="Описание">Описание</a></li>{/if}
			{if !empty($product->features)}<li class="anchor" data-anchor=".tab_container"><a href="#tab2" title="Характеристики">Характеристики</a></li>{/if}
			{if !empty($cms_files)}<li class="anchor" data-anchor=".tab_container"><a href="#tab4" title="Файлы">Файлы</a></li>{/if}
			{if empty($settings->hidecomment)}<li><a href="#tab3">Отзывы{if !empty($comments)} ({$comments|count}){/if}</a></li>{/if}
			{if !empty($settings->del_pay)}<li><a href="#tab6">Варианты оплаты и доставки</a></li>{/if}
			
			{if !empty($notinstock)}
				{get_products var=related_products category_id=$category->id sort=rand limit=5}
				{$related_title="Похожие товары"}
			{elseif !empty($related_ids)}
				{get_products var=related_products id=$related_ids}
				{$related_title="Похожие товары"}
			{/if}	
			{if !empty($related_title)}<li><a href="#tab7">{$related_title}</a></li>{/if}

			{* Товары из этой категории *}
			{if $product->categories}
				{get_products var=category_products category_id=array_keys($product->categories) sort=rand limit=10}
			{/if}
			{if !empty($category_products)}<li><a href="#tab9">Из этой категории</a></li>{/if}

			{* Товары того же бренда *}
			{if $product->brand_id}
				{get_products var=brands_products brand_id=$product->brand_id sort=rand limit=10}
			{/if}
			{if !empty($brands_products)}<li><a href="#tab8">Товары того же бренда</a></li>{/if}
		</ul>
	
		<div class="tab_container">
		
			{if !empty($product->annotation)}
				<div id="tab0" class="tab_content">
					<div class="page-pg">{$product->annotation}</div>
				</div>
			{/if}
	
			{if !empty($product->body)}
				<div id="tab1" class="tab_content">
					<div class="page-pg">{$product->body}</div>
				</div>
			{/if}

			<!--noindex-->
			{if !empty($product->features)}
				<div id="tab2" class="tab_content">
					<ul class="features">
					{foreach $product->features as $f}
					<li>
						<label>{$f->name}</label>
						<label class="lfeature">{$f->value}</label>
					</li>
					{/foreach}
					</ul>
				</div>
			{/if}
			
			{if !empty($cms_files)}
				<div id="tab4" class="tab_content">
					<div class="page-pg">
						<ul class="stars">
						{foreach $cms_files as $file}
							<li>
								{if $file->filename|substr:0:4 == 'http'}
									{$filename = $file->filename}
								{else}
									{$filename = $config->cms_files_dir|cat:$file->filename}	
								{/if}
								<a href="{$filename}" {if empty($mobile_app)}download="{$filename}"{/if}>
									{if $file->name}{$file->name|escape}{else}{$file->filename}{/if}
								</a>
							</li>
						{/foreach}
						</ul>
					</div>
				</div>
			{/if}
	
			{if empty($settings->hidecomment)}
				<div id="tab3" class="tab_content">
					<div id="comments">
						{if !empty($comments)}
							<ul class="comment_list">
								{foreach $comments as $comment}
								<li>
									<a name="comment_{$comment->id}"></a>
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
							{if $comments|count >10}	
								<input type='hidden' id='current_page' />
								<input type='hidden' id='show_per_page' />	
								<div id="page_navigation" class="pagination"></div>
							{/if}
						{else}
						<p class="page-pg">
							Пока нет комментариев
						</p>
						{/if}
						
						<form class="comment_form" method="post">
							<h2>Написать комментарий</h2>
							{if isset($error)}
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
								<input style="margin-top:7px;" placeholder="* Имя" class="input_name" type="text" id="comment_name" name="name" value="{if !empty($comment_name)}{$comment_name}{/if}" data-format=".+" data-notice="Введите имя"/><br />
	
								<input style="margin-top:10px;" placeholder="* Email" class="input_email" type="email" id="comment_email" name="email" value="{if !empty($comment_email)}{$comment_email}{/if}" data-format="email" data-notice="Введите Email"/>
			
								<div class="captcha-block">
									{include file='antibot.tpl'}
								</div>
								{include file='conf.tpl'}
								<input class="button hideablebutton" type="submit" name="comment" value="Отправить" />
							</div>
						</form>
					</div>
				</div>
			{/if}
			
			{if !empty($settings->del_pay)}
				<div id="tab6" class="tab_content page-pg">
					{include file='del_pay.tpl'}
				</div>
			{/if}
			
			{if !empty($related_products)}
				<div id="tab7" class="tab_content">
					<ul class="tiny_products">
						{foreach $related_products as $product}
							{include file='products_item.tpl'}
						{/foreach}
					</ul>
				</div>
			{/if}

			{if !empty($brands_products)}
				<div id="tab8" class="tab_content">
					<ul class="tiny_products">
						{foreach $brands_products as $product}
							{include file='products_item.tpl'}
						{/foreach}
					</ul>
				</div>
			{/if}

			{if !empty($category_products)}
				<div id="tab9" class="tab_content">
					<ul class="tiny_products">
						{foreach $category_products as $product}
							{include file='products_item.tpl'}
						{/foreach}
					</ul>
				</div>
			{/if}
			<!--/noindex-->

		</div>
	</div>
	{* Tabs end *}

</div>
