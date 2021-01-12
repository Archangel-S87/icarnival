<!-- incl. 1click -->
<a href="#oneclick" class="various oneclick">купить в 1 клик</a>
<div style="display: none;">                          
	<div id="oneclick" class="window">
		<div class="title">{$product->name|escape|rtrim}</div>
		<ul>
			<li><input placeholder="* ФИО" class="onename" value="{if !empty($comment_name)}{$comment_name|escape}{/if}" type="text" /></li>
			<li><input placeholder="* Email" name="email" class="onemail" value="{if !empty($user->email)}{$user->email|escape}{/if}" type="text" /></li>
			<li><input placeholder="* Телефон" class="onephone" value="{if !empty($phone)}{$phone|escape}{elseif !empty($user->phone)}{$user->phone|escape}{/if}" type="text" /></li>
		</ul>

		<div id="btf_result"></div>
		{include file='conf.tpl'}
		<button type="submit" name="enter" value="1" class="oneclickbuy buttonred hideablebutton" style="margin-right: 0px;" {if $settings->counters || $settings->analytics}onclick="{if $settings->counters}yaCounter{$settings->counters}.reachGoal('cart'); {/if}{if $settings->analytics}ga ('send', 'event', 'cart', 'order_button');{/if} return true;"{/if}>Заказать</button>
	</div>
</div>
<!-- incl. 1click @ -->
