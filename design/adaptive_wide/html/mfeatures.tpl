<!-- incl. mfeatures -->
<form method="get" action="{url page=null}">
	{*  variants  *}
	{if !empty($features_variants)}
		<div class="feature_name">
			Вариант:  
		</div>
		<div class="feature_values" data-f="variant">
			<ul>
				{foreach $features_variants as $o}
				<li>
					<label>
						<span class="chbox">
							<input type="checkbox" name="v[]" value="{$o}" {if !empty($smarty.get.v) && $o|in_array:$smarty.get.v} checked{/if} />
						</span>
						<span>{$o|escape}</span>
					</label>
				</li>
				{/foreach}
			</ul>
		</div>
	{/if}
	{if !empty($features_variants1)}
		<div class="feature_name">
			Размер:  
		</div>
		<div class="feature_values" data-f="size">
			<ul>
				{foreach $features_variants1 as $o}
				<li>
					<label>
						<span class="chbox">
							<input type="checkbox" name="v1[]" value="{$o}" {if !empty($smarty.get.v1) && $o|in_array:$smarty.get.v1} checked{/if} />
						</span>
						<span>{$o|escape}</span>
					</label>
				</li>
				{/foreach}
			</ul>
		</div>
	{/if}
	{if !empty($features_variants2)}
		<div class="feature_name">
			Цвет:  
		</div>
		<div class="feature_values" data-f="color">
			<ul>
				{foreach $features_variants2 as $o}
				<li>
					<label>
						<span class="chbox">
							<input type="checkbox" name="v2[]" value="{$o}" {if !empty($smarty.get.v2) && $o|in_array:$smarty.get.v2} checked{/if} />
						</span>
						<span>{$o|escape}</span>
					</label>
				</li>
				{/foreach}
			</ul>
		</div>
	{/if}

	{*  variants end *}

	{* Brands *}
	{if !empty($category->brands) && $category->brands|count>1 && empty($brand)}
		<div class="feature_name">
			Бренд:  
		</div>
		<div class="feature_values" data-f="brand">
			<ul>
				{foreach name=brands item=b from=$category->brands}
				<li>
					<label>
						<span class="chbox">
							<input type="checkbox" name="b[]" value="{$b->id}" {if !empty($smarty.get.b) && $b->id|in_array:$smarty.get.b} checked{/if} />
						</span>
						<span>{$b->name|escape}</span>
					</label>
				</li>
				{/foreach}
			</ul>
		</div>
	{/if}
	{* Brands end *}

	{* Features *}	
	{if !empty($features)}
			{foreach $features as $f}
				<div class="feature_name" data-feature="{$f->id}">
					{$f->name}: 
				</div>
				<div class="feature_values" data-f="{$f->id}">
					{if $f->in_filter==2}
						{$f_min="min[`$f->id`]"}
						{$f_max="max[`$f->id`]"} 
						<select onchange="clickerdmin(this)">
						<option label="от" value="{url params=[$f_min=>null]}"></option>
						{foreach $f->options as $o}
							<option value="{url params=[$f_min=>$o->value]}" {if !empty($smarty.get.min.{$f->id}) && $smarty.get.min.{$f->id} == $o->value}selected{/if}>{$o->value|escape}</option>
						{/foreach}
						</select>
					
						 - 
						<select onchange="clickerdmax(this)">
						<option label="до" value="{url params=[$f_max=>null]}"></option>
						{foreach $f->options as $o}
							<option value="{url params=[$f_max=>$o->value]}" {if !empty($smarty.get.max.{$f->id}) && $smarty.get.max.{$f->id} == $o->value}selected{/if}>{$o->value|escape}</option>
						{/foreach}
						</select>	
					
						<input class="diapmin diaps" type="hidden" name="{$f_min}" value="{if !empty($smarty.get.min.{$f->id})}{$smarty.get.min.{$f->id}}{/if}" {if empty($smarty.get.min.{$f->id})}disabled{/if}/>
						<input class="diapmax diaps" type="hidden" name="{$f_max}" value="{if !empty($smarty.get.max.{$f->id})}{$smarty.get.max.{$f->id}}{/if}" {if empty($smarty.get.max.{$f->id})}disabled{/if}/>
					
						<script>
							function clickerdmin(that) {
								var pick = that.options[that.selectedIndex].text;
								if(pick) {
									$(that).closest(".feature_values").find(".diapmin").val(pick).prop('disabled', false);
								} else {
									$(that).closest(".feature_values").find(".diapmin").val(pick).prop('disabled', true);
								} 
								ajax_filter_m(that);
							};
							function clickerdmax(that) {
								var pick = that.options[that.selectedIndex].text;
								if(pick) {
									$(that).closest(".feature_values").find(".diapmax").val(pick).prop('disabled', false);
								} else {
									$(that).closest(".feature_values").find(".diapmax").val(pick).prop('disabled', true);
								} 
								ajax_filter_m(that);
							};
						</script>
					{else}
						<ul>
							{foreach $f->options as $k=>$o}
							<li>
								<label>
									<span class="chbox"><input type="checkbox" name="{$f->id}[]" {if !empty($filter_features.{$f->id}) && in_array($o->value,$filter_features.{$f->id})}checked="checked"{/if} value="{$o->value|escape}" /></span>
									<span>{$o->value|escape}</span>
								</label>
							</li>
							{/foreach}
						</ul>
					{/if}
				</div>
			{/foreach}
	{/if}
	{* Features end *}

	{* priceslider*}
	{if $minCost<$maxCost}
		<script>
			minCost={$minCost};
			maxCost={$maxCost};
			minCurr={$minCurr};
			maxCurr={$maxCurr};
		
			{literal}
			$(document).ready(function(){
				if(minCurr>=0 && maxCurr>0){
					$("#slider").slider({min:minCost,max:maxCost,values:[minCurr,maxCurr],range:true,stop:function(event,ui){
					var mncurr = $("#slider").slider("values",0);
					var mxcurr = $("#slider").slider("values",1);
					$("input#minCurrm").val(mncurr);$("input#maxCurrm").val(mxcurr);
					ajax_filter_m();
				},slide:function(event,ui){$("input#minCurrm").val(ui.values[0]);$("input#maxCurrm").val(ui.values[1]);}});$("input#minCurrm").change(function(){var value1=$("input#minCurrm").val();var value2=$("input#maxCurrm").val();if(parseInt(value1)>parseInt(value2)){value1=value2;$("input#minCurrm").val(value1);}$("#slider").slider("values",0,value1);});$("input#maxCurrm").change(function(){var value1=$("input#minCurrm").val();var value2=$("input#maxCurrm").val();if(value2>maxCost){value2=maxCost;$("input#maxCurrm").val(maxCost)}if(parseInt(value1)>parseInt(value2)){value2=value1;$("input#maxCurrm").val(value2);}$("#slider").slider("values",1,value2);});$('input.curr').keypress(function(event){var key,keyChar;if(!event)var event=window.event;if(event.keyCode)key=event.keyCode;else if(event.which)key=event.which;if(key==null||key==0||key==8||key==13||key==9||key==46||key==37||key==39)return true;keyChar=String.fromCharCode(key);if(!/\d/.test(keyChar))return false;});
				}
			});
			{/literal}
		</script>

		<div class="mpriceslider">
			<div class="formCost">
				<span class="pr-cost">Цена:</span><input type="text" name="minCurr" id="minCurrm" onchange="ajax_filter_m();" value="{$minCurr}"/>
				<label for="maxCurr">-</label> <input type="text" name="maxCurr" id="maxCurrm" onchange="ajax_filter_m();" value="{$maxCurr}" />
			</div>
			<div class="sliderCont">
				<div id="slider"></div>
			</div>
			<div class="sliderButton">
				<input type="submit" value="Показать{if $total_products_num} ({$total_products_num}){/if}" class="buttonblue">
			</div>
		</div>
	
	{else}
		<div class="mpriceslider">
			<div class="sliderButton">
				<input type="submit" value="Показать{if $total_products_num > 0} ({$total_products_num}){/if}" class="buttonblue">
			</div>
		</div>
	{/if}
	
	<a href="{strtok($smarty.server.REQUEST_URI,'?')}" class="clear_filter">Сбросить фильтр</a>

	{if !empty($keyword)}<div style="display:none;"><input type="checkbox" name="keyword" value="{$keyword}" checked="checked"/></div>{/if}
	{* priceslider end*}
	
	<div style="display:none;">
		{if $total_products_num > 0}<input class="prods_num_flag buttonblue" type="submit" value="Показать{if $total_products_num} ({$total_products_num}){/if}">{/if}
	</div>
</form>
<!-- incl. mfeatures @ -->


