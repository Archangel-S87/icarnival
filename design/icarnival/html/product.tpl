{* Канонический адрес страницы *}
{$canonical="/products/{$product->url}" scope=root}

				  <div class="section__head">
                <div class="section__title color--pink" data-product="{$product->id}">{$product->name|escape}</div>
              </div>
              <div class="section__options"> 
                <div class="breadcrumbs list--unstyled">
                  <li><a href="./">Главная</a></li>
							{if $category}
							{foreach $category->path as $cat}
							<li><a href="catalog/{$cat->url}">{$cat->name|escape}</a></li>
							{/foreach}  
							{if $brand}
							<li><a href="catalog/{$cat->url}/{$brand->url}">{$brand->name|escape}</a></li>
							{/if}
							{elseif $brand}
							<li><a href="brands/{$brand->url}">{$brand->name|escape}</a></li>
							{/if}
							<li>{$product->name|escape}</li>
                </div>
              </div>
              <div class="row">
                <div class="col-md-5">
                  <div class="margin--bottom-md-30">
                {if !empty($product->featured)}<div class="product__badge-bg product__badge-bg--green">Хит</div>
                {elseif !empty($product->is_new)}<div class="product__badge-bg product__badge-bg--pink">Новинка</div>{/if}
                <div class="image">
                {*<span class="product__badge product__badge--pink">нет в наличии</span>*}
                {if !empty($product->variant->compare_price)}<div class="product__badge product__badge--purple">распродажа</div>{/if}                   
                    <div class="product__single-thumb jsProductSingleThumb slick-preloader">                   
				{foreach $product->images as $i=>$image}
                      <div class="item">
                      <a class="zoom" href="{$image->filename|resize:2000:3000:w}" title="{$product->name|escape}" data-fancybox="{if !empty($image->color)}{$image->color}{else}gallery{/if}">
                      <img src="{$image->filename|resize:800:600:w}" alt="{$product->name|escape}">
                      </a>
                      </div>				
				{/foreach}                    
                    </div>
                    </div>
                    <div class="product__single-thumb-nav jsProductSingleThumbNav slick-preloader">
				{foreach $product->images as $i=>$image}
                      <div class="item"><img src="{$image->filename|resize:800:600:w}" alt="{$product->name|escape}"></div>				
				{/foreach} 
                    </div>
                  </div>
                </div>
                <div class="col-md-7">
                <form class="variants" action="cart">
                  <p><b>Артикул: <span class="color--pink sku">{if $product->variant->sku}{$product->variant->sku}{else}Не указан{/if}</span></b></p>
                  {if $product->variants|count > 0} 
                  <div class="row row--x-indent-10 align-items-center margin--bottom-25 row--y-indent-10">
				{if $product->vproperties}
					{$cntname1 = 0}	
					<span class="pricelist" style="display:none;">
						{foreach $product->variants as $v}
							<span class="c{$v->id}" data-sku="{if $v->sku}{$v->sku}{else}Не указан{/if}" data-unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}">{$v->price|convert}</span>
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
					<input class="vhidden" name="variant" value="" type="hidden"  />
					<div>
                    <div {if $cntname1 == 0}style="display:none;"{/if}>
                    <div class="col-item"><b>Размер: </b></div>
                    <div class="col-item">					
						<select {if $cntname1 == 0}class="p0" style="display:none;"{else}class="p0 product__select showselect"{/if}>
							{foreach $product->vproperties[0] as $pname => $pclass}
								<option {if $cntname1 == 0}label="size"{/if} value="{$pclass}" class="{$pclass}">{$pname}</option>
							{/foreach}
						</select>
                    </div>
                    </div>
                    <div {if $cntname2 == 0}style="display:none;"{/if}>
                    <div class="col-item"><b>Цвет: </b></div>
                    <div class="col-item">                    	
						<select {if $cntname2 == 0}class="p1" style="display:none;"{else}class="p1 product__select showselect"{/if}>
							{foreach $product->vproperties[1] as $pname => $pclass}
								<option value="{$pclass}" class="{$pclass}">{$pname}</option>
							{/foreach}
						</select>
                    </div>
                    </div>	
						{if $cntname2 == 0 || $cntname1 == 0}
							{if !empty($smarty.cookies.view) && $smarty.cookies.view == 'table' && $mod == 'ProductsView'}<div style="display: table; height: 27px;"></div>{/if}
						{/if}
					</div>
				{else}
                    <div class="col-item"{if $product->variants|count==1 && !$product->variant->name} style="display:none;"{/if}><b>Размер: </b></div>
                    <div class="col-item"{if $product->variants|count==1 && !$product->variant->name} style="display:none;"{/if}>				
					<select name="variant" {if $product->variants|count==1 && !$product->variant->name}class="b1c_option product__select" style="display:none;"{else}class="b1c_option product__select showselect"{/if}>
						{foreach $product->variants as $v}
							<option value="{$v->id}" data-sku="{if $v->sku}{$v->sku}{else}Не указан{/if}" data-unit="{if $v->unit}{$v->unit}{else}{$settings->units}{/if}" {if $v->compare_price > 0}data-cprice="{$v->compare_price|convert}"{/if} data-varprice="{$v->price|convert}">
										{$v->name}&nbsp;
							</option>
						{/foreach}
					</select>
                    </div>
				{/if}                  

                  </div>
                  <div class="row row--x-indent-10 margin--bottom-25 align-items-center row--y-indent-10">
                    <div class="col-item"><b>Цена:</b></div>
                    <div class="col-item">
                      <div class="product__price align--right">
						<span class="compare_price">{if $product->variant->compare_price > 0}{$product->variant->compare_price|convert}{/if}</span>
						<span class="price">{$product->variant->price|convert}</span><span class="currency">₽{if $settings->b9manage}/<span class="unit">{if $product->variant->unit}{$product->variant->unit}{else}{$settings->units}{/if}</span>{/if}</span>
                      </div>
                    </div>
                    <div class="col-item"><img src="design/{$settings->theme|escape}/images/pays.png" alt=""></div>
                  </div>
                  <div class="row row--x-indent-15 margin--bottom-25 align-items-center row--y-indent-10">
                    <div class="col-item">
                    <button style=" border: 0;" class="btn btn--size-60 btn--pink txt--upperacse btn--pink-shadow" {if $settings->trigger_id}onmousedown="try { rrApi.addToBasket({$product->variant->id}) } catch(e) {}"{/if} type="submit"><span class="btn__icon"><i class="icon-shopping-cart"></i></span><span>В Корзину</span></button>
                    </div>
                    <div class="col-item">
                      <div class="row row--x-indent-5 justify-content-end row--y-indent-4">
                        {*<div class="col-item"><a class="product__action product__action--size-lg product__action--green product__action--size-24" href=""><i class="icon-info"></i></a></div>*}
                        <div class="col-item"><a class="product__action product__action--size-lg product__action--orange" href=""><i class="icon-analytics"></i></a></div>
                      </div>
                    </div>
                  </div>
 			{else}
				<div class="notinstocksep" style="display: table;">Нет в наличии</div>

			{/if}
			</form>
                
			{if $product->body}
                  <p><b class="txt--upperacse lend">Описание</b></p>
                  {$product->body}
			{/if}
		
			{if $product->features}
				<p><b class="txt--upperacse lend">Характеристики</b></p>
				<ul class="features">
				{foreach $product->features as $f}
				<li>
					<label class="featurename"><span>{$f->name}</span></label>
					<label class="lfeature">{$f->value}</label>
				</li>
				{/foreach}
				</ul>

			{/if}
                </div>
              </div>		
			{if $cms_files}
			<div id="tab4" class="tab_content">
				<ul class="stars">
				{foreach $cms_files as $file}
					<li>
						<a href="{$config->cms_files_dir}{$file->filename}" download="{$file->filename}">
							{if $file->name}{$file->name}{else}{$file->filename}{/if}
						</a>
					</li>
				{/foreach}
				</ul>
			</div>
			{/if}
			{if $settings->youtube_product == 1}
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

				<div id="comments" class="row">
					<div class="comments-left {*col-md-6*}">
					<p><b class="txt--upperacse lend">Отзывы к "{$product->name|escape}":</b></p>
					
						{if $comments}
						{* Список с комментариями *}
				
						<ul class="comment_list">
							{foreach $comments as $comment}
							<li>
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
					<form class="comment_form {*col-md-6*}" method="post">
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
							Введите E-Mail
							{elseif $error == 'wrong_name'}
							В поле 'Имя' может использоваться только кириллица	
							{/if}
						</div>
						{/if}
						<textarea class="comment_textarea" id="comment_text" name="text" data-format=".+" data-notice="Введите комментарий">{if !empty($comment_text)}{$comment_text|escape}{/if}</textarea><br>
						<div>
						<label for="comment_name">Имя</label>
						<input class="input_name" type="text" id="comment_name" name="name" value="{if !empty($comment_name)}{$comment_name|escape}{/if}" data-format=".+" data-notice="Введите имя"/><br>
			
						<label for="comment_email">E-Mail</label>
						<input class="input_name" type="email" id="comment_email" name="email" value="{if !empty($comment_email)}{$comment_email|escape}{/if}" data-format=".+" data-notice="Введите E-Mail"/><br>
					
						{include file='conf.tpl'}
						<input class="button hideablebutton" type="submit" name="comment" value="Отправить" />
					
						{include file='antibot.tpl'}
					
						</div>
					</form>
					{* Форма отправления комментария @ *}
	
				</div>
               
                
                


	{$count_stock = 0}
	{foreach $product->variants as $pv}
		{$count_stock = $count_stock + $pv->stock}
	{/foreach}
	{if $count_stock > 0}
		{$notinstock=0}
	{else}
		{$notinstock=1}
	{/if}
	
	{if isset($product->rating) && $product->rating|floatval > 0}
		{$rating = $product->rating}
	{else}
		{$rating = $settings->prods_rating|floatval}
	{/if}
	
	{$votes = $settings->prods_votes|intval + $product->votes}
	{$views = $settings->prods_views|intval + $product->views}

		{* schema *}
		{if $product->annotation}{$descr = $product->annotation|strip_tags:true}{elseif $product->body}{$descr = $product->body|strip_tags:true}{elseif !empty($seo_description)}{$descr = $seo_description}{elseif $meta_description}{$descr = $meta_description|escape}{else}{$descr = $product->name|escape}{/if}
		<div itemscope itemtype="http://schema.org/Product">
			<meta content="{$product->name|escape}" itemprop="name">
			<meta content="{$descr|replace:'"':''}" itemprop="description">
			<meta content="{if $product->image}{$product->image->filename|resize:800:600:w}{else}{$config->root_url}/js/nophoto.png{/if}" itemprop="image">
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
		{* schema @ *}	'

{* related products *}
{if !empty($related_products)}
              <div class="section">
                <div class="section__head">
                  <div class="section__title color--pink align--center">С этим товаром часто покупают</div>
                </div>
                <div class="jsProductSlider3 slick-preloader slick--slide-indent-15 product--slider-settings slick--arrow slick--arrow-orange">
		{foreach $related_products as $product}
			<div class="product__slide">
				{include file='products_item.tpl'}
			</div>
		{/foreach}                  
                </div>
              </div>	
{/if}
{* related products @ *}

			{* same products *}
			{get_products var=same_products category_id=$category->id limit=6}
			{if $same_products}
              <div class="section">
                <div class="section__head">
                  <div class="section__title color--pink align--center">Той же категории</div>
                </div>
                <div class="jsProductSlider3 slick-preloader slick--slide-indent-15 product--slider-settings slick--arrow slick--arrow-orange">
					{foreach $same_products as $product}
						<div class="product__slide">
							{include file='products_item.tpl'}
						</div>
					{/foreach}                  
			                </div>
			              </div>	
			{/if}

			{* same products *}
			{get_products var=brand_products brand_id=$brand->id limit=6}
			{if $brand_products}
              <div class="section">
                <div class="section__head">
                  <div class="section__title color--pink align--center">Того же бренда</div>
                </div>
                <div class="jsProductSlider3 slick-preloader slick--slide-indent-15 product--slider-settings slick--arrow slick--arrow-orange">
					{foreach $brand_products as $product}
						<div class="product__slide">
							{include file='products_item.tpl'}
						</div>
					{/foreach}                  
			                </div>
			              </div>	
			{/if}


{* featured products *}
{* available sort (or remove): position, name, date, views, rating, rand *}
{get_products var=featured_products featured=1 category_id=$category->id sort=rand limit=4}
{if !empty($featured_products)}
              <div class="section">
                <div class="section__head">
                  <div class="section__title color--pink align--center">Вас также могут заинтересовать</div>
                </div>
                <div class="jsProductSlider3 slick-preloader slick--slide-indent-15 product--slider-settings slick--arrow slick--arrow-orange">
		{foreach $featured_products as $product}
			<div class="product__slide">
				{include file='products_item.tpl'}
			</div>
		{/foreach}                  
                </div>
              </div>	
{/if}
{* featured @ *}



