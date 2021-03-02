{* Шаблон страницы зарегистрированного пользователя *}
{$meta_title = "Личный кабинет" scope=root}
{$page_name = "Личный кабинет" scope=root}
<h1>Личный кабинет</h1>

{if isset($error)}
	<div class="message_error">
		{if $error == 'empty_name'}Введите имя
		{elseif $error == 'empty_email'}Введите email
		{elseif $error == 'empty_phone'}Введите Телефон
		{elseif $error == 'empty_password'}Введите пароль
		{elseif $error == 'user_exists'}Пользователь с таким email уже зарегистрирован
		{else}{$error}{/if}
	</div>
{/if}
<div class="user_form_block">	
	<form style="display:table;" class="form" method="post">
		<label>ФИО</label>
		<input data-format=".+" data-notice="Введите имя" value="{if isset($name)}{$name|escape}{/if}" name="name" maxlength="255" type="text" required/>
	 
		<label>Email</label>
		<input data-format="email" data-notice="Введите email" value="{if isset($email)}{$email|escape}{/if}" name="email" maxlength="255" type="email" required/>
	
		<label>Телефон</label>
		<input placeholder="Напр: +7 (981) 123-4567" data-format=".+" data-notice="Введите Телефон" value="{if isset($phone)}{$phone|escape}{/if}" name="phone" maxlength="255" type="tel" required/>
		
		<label class="ch_passw"><a href='#' onclick="$('#password').show();return false;">Изменить пароль</a></label>
		<input placeholder="Введите новый пароль" id="password" value="" name="password" type="password" style="display:none; margin-bottom: 10px;"/>
		<input id="logininput" type="submit" class="button" value="Сохранить">
	</form>
	
	{if $cart->total_products>0}
	<div class="balance_block">
		<a href="cart" class="buttonred green cart_here">Перейти в корзину</a>
	</div>
	{/if}
</div>
{if !empty($user->comment)}
	<div class="mainproduct blue">Информация для пользователя:</div>
	<div class="user_comment">{$user->comment}</user>
{/if}

{if $orders}
	<div class="mainproduct blue">Ваши заказы:</div>
	<ul id="orders_history">
		{foreach name=orders item=order from=$orders}
			<li>
				{$order->date|date} {if $order->status != 3}<a href='order/{$order->url}'>Заказ №{$order->id}</a>{else}Заказ №{$order->id}{/if}
				{if $order->paid == 1}оплачен,{/if}
				({if $order->status == 0}ждет обработки
				{elseif $order->status == 4}в обработке
				{elseif $order->status == 1}выполняется
				{elseif $order->status == 2}выполнен
				{elseif $order->status == 3}отменен
				{elseif $order->status == 5}в пути
				{/if})
			</li>
		{/foreach}
	</ul>
{/if}

{if $user->order_payd>0}
	<div class="discountsblock"><p>Всего заказов оплачено на сумму: {$user->order_payd|convert} {$currency->sign|escape}</p></div>
{/if}

{if ($user->discount && in_array($settings->enable_groupdiscount, array(1,3,4))) || ($user->tdiscount && in_array($settings->enable_groupdiscount, array('5','4'))) || $user->balance>0}
	<div class="mainproduct blue">Скидки{if $settings->bonus_limit && $user->balance > 0} и бонусы{/if}:</div>
	<div class="discountsblock">
		{if $user->discount && in_array($settings->enable_groupdiscount, array(1,3,4))}<p>Постоянная скидка: {$user->discount}%</p>{/if}
		{if $user->tdiscount && in_array($settings->enable_groupdiscount, array(5,4))}<p>Накопительная скидка: {$user->tdiscount}%</p>{/if}
		{if $user->balance>0}
			<div class="hasbonuses">Всего накоплено баллов на: {$user->balance|round|convert}&nbsp;{$currency->sign}</div>
		{/if}
		{if $settings->bonus_link}<p class="about_bonus"><a class="bluelink" href="{$settings->bonus_link|escape}">Описание бонусной программы</a></p>{/if}
	</div>	
{/if}

{if !empty($settings->ref_order)}
	<div class="mainproduct ref_link_title">Ваша партнерская ссылка:</div>
	<div class="ref_link"><span>{$config->root_url}/?appid={$user->id}</span></div>
	<p>Также партнерская ссылка может указывать на любую страницу сайта:</p>
	<p>Например: {$config->root_url}/blog?appid={$user->id}</p>
	<p class="ref_you_get">Вы получаете <span class="ref_procent">{$settings->ref_order|escape}%</span> от платежей ваших рефералов</p>
	{if $settings->ref_link}<p class="about_ref"><a class="bluelink" href="{$settings->ref_link|escape}">Описание реферальной программы</a></p>{/if}
	<div class="withdrawal_title">Переходов по реферальным ссылкам: <span style="font-size:16px;color:#8ba76b;padding-left:5px;">{$user->ref_views}</span>
	</div>
{/if}

{if !empty($settings->ref_order) && $referrals}
	<div class="referrals_title">Привлеченные клиенты:</div>
	<div class="referrals">
		<div class="ref_item">
			<div class="ref_id">ID</div>
			<div class="ref_date">Регистрация</div>
			<div class="ref_ballov">Платежи</div>
			<div class="ref_profit">Прибыль</div>
		</div>
		{foreach $referrals as $ref}
		<div class="ref_item">
			<div class="ref_id">{$ref->id}</div>
			<div class="ref_date">{$ref->created}</div>
			<div class="ref_ballov">{$ref->order_payd|convert} {$currency->sign}</div>
			<div class="ref_profit">{($ref->order_payd/100*$settings->ref_order)|convert} {$currency->sign}</div>
		</div>
		{/foreach}
	</div>
{/if}

{if !empty($user->withdrawal)}
	<div class="withdrawal">
		<div class="withdrawal_title">Всего баллов выведено:</div>
		<ul>{$user->withdrawal}</ul>
	</div>
{/if}
