<!-- incl. cfeatures -->
<div class="site-aside__col" id="cfeatures">
<form method="get" action="{url page=null}">
                  <div class="site-aside__title jsFilterToggleSectionBtn">Фильтр товаров<i class="icon-down-arrow"></i></div>
                  <div class="site-aside__content">
                    <div class="jsFilterToggleSection">
		{*  price slider  *}
		{if $minCost<$maxCost}
			{*<div class="mpriceslider">
					<div class="formCost">
						<span class="pr-cost">Цена:</span><input type="text" name="minCurr" id="minCurr" onchange="ajax_filter();" value="{$minCurr}"/>
						<label for="maxCurr">-</label> <input type="text" name="maxCurr" id="maxCurr" onchange="ajax_filter();" value="{$maxCurr}"/>
					</div>
					<div class="sliderCont">
						<div id="cslider"></div>
					</div>
					<div class="sliderButton">
						<input type="submit" value="Показать{if $total_products_num} ({$total_products_num}){/if}" class="buttonblue">
					</div><a href="{strtok($smarty.server.REQUEST_URI,'?')}" class="clear_filter">Сбросить фильтр</a>
			</div>*}

                   
                      <div class="site-aside__col-sub">
                        <div class="site-aside__title-sub">Цена</div>
                        <div class="row row--x-indent-5">
                          <div class="col-6">
                            <div class="row row--x-indent-5 flex-nowrap align-items-center">
                              <div class="col-item color--gray">от</div>
                              <div class="flex-grow-1">
                                <input class="form__input form__input--size-40 form__input--bordered" {*id="input-with-keypress-0"*} type="text" name="minCurr" id="minCurr"  value="{$minCurr}">
                              </div>
                            </div>
                          </div>
                          <div class="col-6">
                            <div class="row row--x-indent-5 flex-nowrap align-items-center">
                              <div class="col-item color--gray">до</div>
                              <div class="flex-grow-1">
                                <input class="form__input form__input--size-40 form__input--bordered" {*id="input-with-keypress-1"*} type="text" name="maxCurr" id="maxCurr"  value="{$maxCurr}">
                              </div>
                            </div>
                          </div>
                        </div>
                        <div id="steps-slider"></div>
                      </div>
		{/if}                       
		{if !empty($category->brands) && $category->brands|count>1 && empty($brand)}
			{* Brands *}                    
                      <div class="site-aside__col-sub">
                        <div class="site-aside__title-sub">Бренд</div>
                        <div class="colums-2">
							                    {foreach name=brands item=b from=$category->brands}
                                        <div class="form__checbox form__checkbox-group">
                                          <input class="form__checkbox-input" type="checkbox" name="b[]" value="{$b->id}" {if !empty($smarty.get.b) && $b->id|in_array:$smarty.get.b} checked{/if}  id="b_{$b->id}">
                                          <label class="form__checkbox-label" for="b_{$b->id}">{$b->name|escape}</label>
                                        </div>
							                    {/foreach}                        
                        </div>
                      </div>
			{* Brands end *}
		{/if}
	{if !empty($features_variants)}
                      <div class="site-aside__title-sub">Вариант</div>
                      <div class="colums-2">
                                      {foreach $features_variants as $k=>$o}
                                      <div class="form__checbox form__checkbox-group">
                                        <input class="form__checkbox-input" type="checkbox"  name="v[]" value="{$o}"{if !empty($smarty.get.v) && $o|in_array:$smarty.get.v} checked{/if} id="v_{$k}">
                                        <label class="form__checkbox-label" for="v_{$k}">{$o|escape}</label>
                                      </div>
                                      {/foreach}

                      </div>	
	{/if}
	{if !empty($features_variants)}
                      <div class="site-aside__title-sub">Размер</div>
                      <div class="colums-2">
                                      {foreach $features_variants1 as $k=>$o}
                                      <div class="form__checbox form__checkbox-group">
                                        <input class="form__checkbox-input" type="checkbox"  name="v1[]" value="{$o}"{if !empty($smarty.get.v1) && $o|in_array:$smarty.get.v1} checked{/if} id="v1_{$k}">
                                        <label class="form__checkbox-label" for="v1_{$k}">{$o|escape}</label>
                                      </div>
                                      {/foreach}

                      </div>	
	{/if}
	{if !empty($features_variants2)}
                      <div class="site-aside__title-sub">Цвет</div>
                      <div class="colums-2">
                                      {foreach $features_variants2 as $k=>$o}
                                      <div class="form__checbox form__checkbox-group">
                                        <input class="form__checkbox-input" type="checkbox"  name="v2[]" value="{$o}"{if !empty($smarty.get.v2) && $o|in_array:$smarty.get.v2} checked{/if} id="v2_{$k}">
                                        <label class="form__checkbox-label" for="v2_{$k}">{$o|escape}</label>
                                      </div>
                                      {/foreach}

                      </div>	
	{/if} 
		                        
	{* Features *}
	{if !empty($features)}
        {foreach $features as $f}
                      <div class="site-aside__title-sub">{$f->name}</div>
                      
						{if $f->in_filter==2}
							<div class="colums-3">						
							{$f_min="min[`$f->id`]"}
							{$f_max="max[`$f->id`]"} 
							<select class="form_select" {if !empty($smarty.get.min.{$f->id}) || !empty($smarty.get.max.{$f->id})}id="choosenf"{/if} onchange="clickerdiapmin(this);">
							<option label="от" value="{url params=[$f_min=>null]}"></option>
							{$i=0}
							{foreach $f->options as $o}
								{$i=$i+1}{if $i==1}{$omin=$o->value}{/if}
								<option value="{url params=[$f_min=>$o->value]}" {if !empty($smarty.get.min.{$f->id}) && $smarty.get.min.{$f->id} == $o->value}selected{/if}>{$o->value|escape}</option>
							{/foreach}
							</select> - <select class="form_select" onchange="clickerdiapmax(this)">
							<option label="до" value="{url params=[$f_max=>null]}"></option>
							{foreach $f->options as $o}
							<option value="{url params=[$f_max=>$o->value]}" {if !empty($smarty.get.max.{$f->id}) && $smarty.get.max.{$f->id} == $o->value}selected{/if}>{$o->value|escape}</option>
							{/foreach}
							</select>	
							<input class="diapmin diaps" type="hidden" name="{$f_min}" value="{if !empty($smarty.get.min.{$f->id})}{$smarty.get.min.{$f->id}}{/if}" {if empty($smarty.get.min.{$f->id})}disabled{/if}/>
							<input class="diapmax diaps" type="hidden" name="{$f_max}" value="{if !empty($smarty.get.max.{$f->id})}{$smarty.get.max.{$f->id}}{/if}" {if empty($smarty.get.max.{$f->id})}disabled{/if}/>
                      </div> 						
						{else}
							<div class="colums-2">
			                    {foreach $f->options as $k=>$o}
                                      <div class="form__checbox form__checkbox-group">
                                        <input class="form__checkbox-input" type="checkbox" name="{$f->id}[]" {if !empty($filter_features.{$f->id}) && in_array($o->value,$filter_features.{$f->id})}checked="checked"{/if} value="{$o->value|escape} id="{$f->id}_{$k}">
                                        <label class="form__checkbox-label" for="{$f->id}_{$k}">{$o->value|escape}</label>
                                      </div>
			                    {/foreach}
                      </div>
                      <div style="clear: both;"></div> 
						{/if}                      
       
        {/foreach}
	{/if}                      
					<div class="sliderButton">
						<input type="submit" value="Применить" class="btn btn--size-md btn--border-pink txt--upperacse is--active">
					</div>                      
                <a href="{strtok($smarty.server.REQUEST_URI,'?')}" class="clear_filter">Сбросить фильтр</a>      
                    </div>
                  </div>
                </div>
{if !empty($keyword)}<div style="display:none;"><input type="checkbox" name="keyword" value="{$keyword}" checked="checked"/></div>{/if}
</form>






	<div class="price-brands">		

		

		
		{if !empty($keyword)}<div style="display:none;"><input type="checkbox" name="keyword" value="{$keyword}" checked="checked"/></div>{/if}
		{*  price slider end  *}
	</div>
{* Features end *}

