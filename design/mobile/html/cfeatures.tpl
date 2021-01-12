<div id="features" class="features">
	{* Features *}
		<form method="get" action="{url page=null}">
		    <div class="features-block separator">
				{if !empty($features_variants)}
					<div class="feature_column">
						<div class="feat-block">
							<div class="hidetitle" href="javascript://" onclick="hideShow1(this);return false;">
							<svg viewBox="0 0 20 20" >
							    <path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"/>
							    <path d="M0-.25h24v24H0z" fill="none"/>
							</svg>
							<a class="hidetitle1" href="javascript://" onclick="hideShow1(this);return false;">Вариант</a>
						</div>
			            <div class="feature_values">
		                <ul>
		                    {foreach $features_variants as $o}
		                    <li>
		                        <label>
		                            <div class="chbox">
										<input type="checkbox" name="v[]" value="{$o}"{if !empty($smarty.get.v) && $o|in_array:$smarty.get.v} checked{/if} />
									</div>
									<span>{$o|escape}</span>
		                        </label>
		                    </li>
		                    {/foreach}
		                </ul>
		            </div>
						</div>
					</div>
				{/if}
					
				{if !empty($features_variants1)}
					<div class="feature_column">
						<div class="feat-block">
							<div class="hidetitle" onclick="hideShow1(this);return false;">
							<svg viewBox="0 0 20 20" >
							    <path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"/>
							    <path d="M0-.25h24v24H0z" fill="none"/>
							</svg>
							<a class="hidetitle1" name="" onclick="hideShow1(this);return false;">Размер</a>
						</div>
			            <div class="feature_values">
		                <ul>
		                    {foreach $features_variants1 as $o}
		                    <li>
		                        <label>
		                            <div class="chbox">
										<input type="checkbox" name="v1[]" value="{$o}"{if !empty($smarty.get.v1) && $o|in_array:$smarty.get.v1} checked{/if} />
									</div>
									<span>{$o|escape}</span>
		                        </label>
		                    </li>
		                    {/foreach}
		                </ul>
		            </div>
						</div>
					</div>
				{/if}
					
				{if !empty($features_variants2)}
					<div class="feature_column">
						<div class="feat-block">
							<div class="hidetitle" onclick="hideShow1(this);return false;">
							<svg viewBox="0 0 20 20" >
							    <path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"/>
							    <path d="M0-.25h24v24H0z" fill="none"/>
							</svg>
							<a class="hidetitle1" name="" onclick="hideShow1(this);return false;">Цвет</a>
						</div>
			            <div class="feature_values">
		                <ul>
		                    {foreach $features_variants2 as $o}
		                    <li>
		                        <label>
		                            <div class="chbox">
										<input type="checkbox" name="v2[]" value="{$o}"{if !empty($smarty.get.v2) && $o|in_array:$smarty.get.v2} checked{/if} />
									</div>
									<span>{$o|escape}</span>
		                        </label>
		                    </li>
		                    {/foreach}
		                </ul>
		            </div>
						</div>
					</div>
				{/if}

				{if !empty($category->brands) && $category->brands|count>1 && empty($brand)}
					<div class="feature_column">
						<div class="feat-block">
							<div class="hidetitle" href="javascript://" onclick="hideShow1(this);return false;">
							<svg viewBox="0 0 20 20" >
							    <path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"/>
							    <path d="M0-.25h24v24H0z" fill="none"/>
							</svg>
							<a class="hidetitle1" href="javascript://" onclick="hideShow1(this);return false;">Бренд</a>
						</div>
			            <div class="feature_values">
		                <ul>
		                    {foreach name=brands item=b from=$category->brands}
		                    <li>
		                        <label>
		                            <div class="chbox">
										<input type="checkbox" name="b[]" value="{$b->id}" {if !empty($smarty.get.b) && $b->id|in_array:$smarty.get.b} checked{/if} />
									</div>
									<span>{$b->name|escape}</span>
		                        </label>
		                    </li>
		                    {/foreach}
		                </ul>
		            </div>
						</div>
					</div>
				{/if}

			    {foreach $features as $f}
					<div class="feature_column">
						<div class="feat-block">
							<div class="hidetitle" href="javascript://" onclick="hideShow1(this);return false;">
							<svg viewBox="0 0 20 20" >
							    <path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"/>
							    <path d="M0-.25h24v24H0z" fill="none"/>
							</svg>
							<a class="hidetitle1" href="javascript://" onclick="hideShow1(this);return false;">{$f->name}</a>
							</div>
				            <div class="feature_values">
	
								{if $f->in_filter==2}
									{$f_min="min[`$f->id`]"}
									{$f_max="max[`$f->id`]"} 
									<select {if !empty($smarty.get.min.{$f->id}) || !empty($smarty.get.max.{$f->id})}id="choosenf"{/if} onchange="clickerdiapmin(this);">
									<option value="{url params=[$f_min=>null]}"></option>
									{$i=0}
									{foreach $f->options as $o}
										{$i=$i+1}{if $i==1}{$omin=$o->value}{/if}
										<option value="{url params=[$f_min=>$o->value]}" {if !empty($smarty.get.min.{$f->id}) && $smarty.get.min.{$f->id} == $o->value}selected{/if}>{$o->value|escape}</option>
									{/foreach}
									</select>
									 - 
									<select onchange="clickerdiapmax(this)">
									<option value="{url params=[$f_max=>null]}"></option>
									{foreach $f->options as $o}
									<option value="{url params=[$f_max=>$o->value]}" {if !empty($smarty.get.max.{$f->id}) && $smarty.get.max.{$f->id} == $o->value}selected{/if}>{$o->value|escape}</option>
									{/foreach}
									</select>	
									<input class="diapmin" id="min{$f->id}" type="hidden" name="{$f_min}" checked="checked" value="{if !empty($smarty.get.min.{$f->id})}{$smarty.get.min.{$f->id}}{/if}" {if empty($smarty.get.min.{$f->id})}disabled{/if}/>
									<input class="diapmax" id="max{$f->id}" type="hidden" name="{$f_max}" checked="checked" value="{if !empty($smarty.get.max.{$f->id})}{$smarty.get.max.{$f->id}}{/if}" {if empty($smarty.get.max.{$f->id})}disabled{/if}/>
				
								{else}
				
					                <ul>
					                    {foreach $f->options as $k=>$o}
					                    <li>
					                        <label>
					                            <div class="chbox"><input type="checkbox" name="{$f->id}[]" {if !empty($filter_features.{$f->id}) && in_array($o->value,$filter_features.{$f->id})}checked="checked"{/if} value="{$o->value|escape}" /></div><span>{$o->value|escape}</span>
					                        </label>
					                    </li>
					                    {/foreach}
					                </ul>
								{/if}
				            </div>
						</div>
					</div>
			    {/foreach}
			</div>

			<div class="product-filter">
			   <div class="sort">
					<span class="pr-cost">Сортировать по:</span>
			      	<select onchange="clicker(this)" id="selectPrductSort" class="inputbox">
						<option value="{url sort=position page=null}" {if $sort=='position'}selected{/if}>порядку</option>
						<option value="{url sort=priceup page=null}" {if $sort=='priceup'}selected{/if}>цене &#8593;</option>
						<option value="{url sort=pricedown page=null}" {if $sort=='pricedown'}selected{/if}>цене &#8595;</option>
						<option value="{url sort=name page=null}" {if $sort=='name'}selected{/if}>названию</option>
						<option value="{url sort=date page=null}" {if $sort=='date'}selected{/if}>дате</option>
						<option value="{url sort=stock page=null}" {if $sort=='stock'}selected{/if}>остатку</option>
						<option value="{url sort=views page=null}" {if $sort=='views'}selected{/if}>популярности</option>
						<option value="{url sort=rating page=null}" {if $sort=='rating'}selected{/if}>рейтингу</option>
					</select>	
			    </div>
			</div>

			{* price slider *}
			{if $minCost<$maxCost}
			
				<div class="price-slider">	
					<div class="mpriceslider">
						<div class="formCost">
							<span class="pr-cost">Цена: </span><span class="frommincurr" for="minCurr">от</span> <input class="curr" type="number" name="minCurr" id="minCurr" value="{$minCurr}"/>
							<span class="tomaxcurr" for="maxCurr">до</span> <input class="curr" type="number" name="maxCurr"  id="maxCurr" value="{$maxCurr}"/>
						</div>
					
						<div class="separator sliderpadd">			
							<div id="line">
								<div id="rele"></div>
								<div id="reletwo"></div>
							</div>
						</div>
					</div>
				</div>
	
				<script type="text/javascript">
					var currentPos={$minCurr};
					var minCount={$minCost};
					var currentPostwo={$maxCurr};
					var maxCount={$maxCost};
					var Count={$maxCost - $minCost};
				</script>	
			{/if}
			{* price slider end *}
			
			{if !empty($keyword)}<div style="display:none;"><input type="checkbox" name="keyword" value="{$keyword}" checked="checked"/></div>{/if}

			<div class="sliderButton" {if $minCost<$maxCost}style="padding-top:0;"{/if}>
				<input type="submit" value="Применить" class="buttonblue">
				<a href="{strtok($smarty.server.REQUEST_URI,'?')}" class="flright buttonblue">Сбросить</a>
			</div>

		</form>
	{* Features end *}
</div>
