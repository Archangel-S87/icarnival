{$wrapper = '' scope=root} 		  
 		  <div class="section__head">
          <div class="section__title color--pink" data-product="{$product->id}">{$product->name|escape}</div>
        </div>
        <div class="row modal__row">
                <div class="col-md-5">
                  <div class="margin--bottom-md-30">
                {if !empty($product->featured)}<div class="product__badge-bg product__badge-bg--green">Хит</div>
                {elseif !empty($product->is_new)}<div class="product__badge-bg product__badge-bg--pink">Новинка</div>{/if}
                <div class="image">
                {*<span class="product__badge product__badge--pink">нет в наличии</span>*}
                {if !empty($product->variant->compare_price)}<div class="product__badge product__badge--purple">распродажа</div>{/if}                   
                    <div class="product__single-thumb jsProductSingleThumb slick-preloader">                   
				{foreach $product->images as $i=>$image}
                      <div class="item"><img src="{$image->filename|resize:800:600:w}" alt="{$product->name|escape}"></div>				
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
        <div class="modal__bg gradient--pink-orange"></div>
				  
<script>
$(function() {


	(function singleProductThumbSlider (){
		var sliderFor = $('.jsProductSingleThumb'),
			sliderNav = $('.jsProductSingleThumbNav');

		sliderFor.slick({
			slidesToShow: 1,
			slidesToScroll: 1,
			arrows: false,
			fade: true,
			asNavFor: '.jsProductSingleThumbNav'
		});
		sliderNav.slick({
			slidesToShow: 4,
			slidesToScroll: 1,
			asNavFor: '.jsProductSingleThumb',
			dots: false,
			arrows: false,
			nav: false,
			focusOnSelect: true,

			responsive: [
			    {
			      	breakpoint: 1200,
			      	settings: {
			        	slidesToShow: 3,
			        	slidesToScroll: 1
			      	}
			    },
			    {
			      	breakpoint: 767,
			      	settings: {
			        	slidesToShow: 4,
			      	}
			    },
			    {
			      	breakpoint: 567,
			      	settings: {
			        	slidesToShow: 3,
			      	}
			    }
			]
		});

	})();
	});
</script>
