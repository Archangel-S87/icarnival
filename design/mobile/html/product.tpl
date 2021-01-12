{* Канонический адрес страницы *}
{$canonical="/products/{$product->url}" scope=root}
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
					<div imcolor="{$image->color}" {if $image->color}class="blockwrapp"{else}class="showanyway" style="visibility:visible;"{/if}>
						<div class="imgwrapper">
							<img alt="{$product->name|escape}" title="{$product->name|escape}" class="blockimage" src="{$image->filename|resize:800:600:w}" />
						</div>
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
		{if $product->images|count>1}
		<div class="directionNav">
			<span onClick="Swipeslider.Prev();" class="prev"></span><span onClick="Swipeslider.Next();" class="next"></span>
		</div>
		{/if}
	</div>

	{* Описание товара *}
	<div class="description">
		{$count_stock = 0}
		{foreach $product->variants as $pv}
			{$count_stock = $count_stock + $pv->stock}
		{/foreach}
		{if $count_stock > 0}
			{$notinstock=0}
		{else}
			{$notinstock=1}
		{/if}
		{if $notinstock == 0}
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
	
						<input id="vhidden" class="1clk" name="variant" value="" type="hidden" />

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
							<div id="amount">
								<input type="button" class="minus" value="−" />
								<input type="number" class="amount" name="amount" value="1" size="2" data-max="{$settings->max_order_amount|escape}" />
								<input type="button" class="plus" value="+" />
								<span class="umnozh">X</span>
							</div>
					
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
									<option v_name="{$v->name}" v_price="{$v->price|convert} {$currency->sign|escape}" v_stock="{if $v->stock < $settings->max_order_amount}{$v->stock}{else}много{/if}" v_unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}" v_sku="{if $v->sku}Арт.: {$v->sku}{/if}" v_bonus="{$ballov} {$ballov|plural:'балл':'баллов':'балла'}" value="{$v->id}" {if $v->compare_price > 0}compare_price="{$v->compare_price|convert}"{/if} price="{$v->price|convert}" click="{$v->name}" {if $product->variant->id==$v->id}selected{/if}>
										{$v->name}&nbsp;
									</option>
								{/foreach}
							</select>
						</div>
										
						<div class="price" style="display:table; float:left; width:100%;">
							<div id="amount">
								<input type="button" class="minus" value="−" />
								<input type="number" class="amount" name="amount" value="1" size="2" data-max="{$settings->max_order_amount|escape}"/>
								<input type="button" class="plus" value="+" />
								<span class="umnozh">X</span>
							</div>

							<div class="price-block {if !$product->variant->compare_price > 0}pricebig{/if}">
						
								{if $product->variant->compare_price > 0}
									<div class="compare_price">{$product->variant->compare_price|convert}</div>
								{/if}
								<span class="price">{$product->variant->price|convert}</span>
								<span class="currency">{$currency->sign|escape}</span>
							</div>
						</div>
					{/if}

					<div class="separator" style="margin-bottom:15px;">
						{if $settings->b9manage}<div style="float:right;font-size:13px;margin:0px 0 15px 0;">Цена указана за <span class="unit">{if $product->variant->unit}{$product->variant->unit}{else}{$settings->units}{/if}</span></div>{/if}

						<div class="separator skustock">
							<div class="skustockleft">
								{if $settings->showsku == 1}<p class="sku">{if $product->variant->sku}Арт.: {$product->variant->sku}{/if}</p>{/if}
								{if $settings->showstock == 1}<div class="stockblock">На складе: <span class="stock">{if $product->variant->stock < $settings->max_order_amount}{$product->variant->stock}{else}много{/if}</span></div>{/if}
							</div>
							{if $settings->bonus_limit && $settings->bonus_order}{$ballov = ($product->variant->price * $settings->bonus_order/100)|convert|replace:' ':''|round}<span class="bonus">+ <span class="bonusnum">{$ballov} {$ballov|plural:'балл':'баллов':'балла'}</span></span>{/if}
						</div>
					</div>
			
					<div class="buttonsblock">
						<input style="float: left;" type="submit" class="buttonred" value="в корзину" data-result-text="добавлено" />
						{include file='1click.tpl'}
					</div>

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
			{$views = $settings->prods_views|intval + $product->views}
			<div class="separator">
				<div class="testRater" id="product_{$product->id}">
					<div class="statVal">
						<span class="rater">
							<span class="rater-starsOff" style="width:115px;">
								<span class="rater-starsOn" style="width:{$rating*115/5|string_format:"%.0f"}px"></span>
							</span>
							<span class="test-text">
								<span class="rater-rating">{$rating|string_format:"%.1f"}</span>&#160;(голосов <span class="rater-rateCount">{$votes|string_format:"%.0f"}</span> / просмотров {$views})
							</span>
						</span>
					</div>
				</div>
				{* rating (The End) *}
				{include file='wishcomp.tpl'}
			</div>
	
		{else}
			{if $settings->showsku == 1 && !empty($product->variant->sku)}
				<p class="page-pg sku">Арт.: {$product->variant->sku}</p>
			{/if}
			<p class="page-pg not_in_stock_label">Нет в наличии</p>
			<div class="separator" style="margin-bottom:10px;">
				{include file='wishcomp.tpl'}
			</div>
			<input name="variant" v_name="" v_price="" style="display:none;"/>
		{/if}
	
	</div>
	
	<div class="separator brand-sku-category">
		{if !empty($brand)}<p class="product-brand">Производитель: <a title="{$brand->name|escape}" href="/brands/{$brand->url}">{$brand->name|escape}</a></p>{/if}
		{if !empty($category)}<p class="catname">Категория: <a title="{$category->name|escape}" href="catalog/{$category->url|escape}">{$category->name|escape}</a></p>{/if}
	</div>
	
	{* Tabs *}
	<div class="container">
	
		<ul class="tabs">
			{if $product->annotation}<li class="anchor" data-anchor=".tab_container"><a href="#tab0" title="Аннотация">Аннотация</a></li>{/if}
			{if $product->body}<li class="anchor" data-anchor=".tab_container"><a href="#tab1" title="Описание">Описание</a></li>{/if}
			{if $product->features}<li class="anchor" data-anchor=".tab_container"><a href="#tab2" title="Характеристики">Характеристики</a></li>{/if}
			{if $cms_files}<li class="anchor" data-anchor=".tab_container"><a href="#tab4" title="Файлы">Файлы</a></li>{/if}
			{if $settings->hidecomment == 0}<li><a href="#tab3" title='Отзывы'>Отзывы{if $comments} ({$comments|count}){/if}</a></li>{/if}
		</ul>
	
		<div class="tab_container">
		
			{if $product->annotation}
				<div id="tab0" class="tab_content">
					<div class="page-pg">{$product->annotation}</div>
				</div>
			{/if}
	
			{if $product->body}
				<div id="tab1" class="tab_content">
					<div class="page-pg">{$product->body}</div>
				</div>
			{/if}
	
			{if $product->features}
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
			
			{if $cms_files}
				<div id="tab4" class="tab_content">
					<div class="page-pg">
						<ul class="stars">
						{foreach $cms_files as $file}
							<li>
								<a href="{$config->cms_files_dir}{$file->filename}">
									{if $file->name}{$file->name}{else}{$file->filename}{/if}
								</a>
							</li>
						{/foreach}
						</ul>
					</div>
				</div>
			{/if}
	
			{if $settings->hidecomment == 0}
				<div id="tab3" class="tab_content">
					<div id="comments">
						{if $comments}
							<ul class="comment_list">
								{foreach $comments as $comment}
								<li>
									<a name="comment_{$comment->id}"></a>
									<div class="comment_header">	
										{$comment->name|escape} <i>{$comment->date|date}, {$comment->date|time}</i>
										{if !$comment->approved}ожидает модерации</b>{/if}
									</div>
									<div class="comment_body">{$comment->text|escape|nl2br}</div>
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
								Введите E-Mail
								{elseif $error == 'wrong_name'}
								В поле 'Имя' может использоваться только кириллица	
								{/if}
							</div>
							{/if}
							<textarea class="comment_textarea" id="comment_text" name="text" data-format=".+" data-notice="Введите комментарий">{if !empty($comment_text)}{$comment_text|escape}{/if}</textarea><br />
							<div>
								<input style="margin-top:7px;" placeholder="* ФИО" class="input_name" type="text" id="comment_name" name="name" value="{if !empty($comment_name)}{$comment_name}{/if}" data-format=".+" data-notice="Введите ФИО"/><br />
	
								<input style="margin-top:10px;" placeholder="* E-mail" class="input_email" type="email" id="comment_email" name="email" value="{if !empty($comment_email)}{$comment_email}{/if}" data-format="email" data-notice="Введите E-Mail"/>
			
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
		</div>
	</div>
	{* Tabs end *}

</div>
