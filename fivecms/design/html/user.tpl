{* Вкладки *}
{capture name=tabs}
	<li class="active"><a href="index.php?module=UsersAdmin">{$tr->buyers|escape}</a></li>
	{if in_array('groups', $manager->permissions)}<li><a href="index.php?module=GroupsAdmin">{$tr->users_groups|escape}</a></li>{/if}
	{if in_array('mailer', $manager->permissions)}<li><a href="index.php?module=MailerAdmin">{$tr->mailer|escape}</a></li>{/if}
{/capture}
{if !empty($user->id)}
	{$meta_title = $user->name|escape scope=root}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

<div id="onecolumn" class="userpage">

	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success=='updated'}{$tr->updated|escape}{else}{$message_success|escape}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span class="text">{if $message_error=='login_exists'}{$tr->login_exists}
		{elseif $message_error=='empty_name'}{$tr->empty_name}
		{elseif $message_error=='empty_email'}{$tr->empty_email}
		{elseif $message_error=='wrong_change_balance'}{$tr->wrong_withdrawal_amount}
		{else}{$message_error|escape}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	<!-- Основная форма -->
	<form method=post id=product>
	<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input class="name" name=name type="text" value="{$user->name|escape}" required /> 
			<input name=id type="hidden" value="{$user->id|escape}"/> 
			<div class="checkbox">
				<input name="enabled" value='1' type="checkbox" id="active_checkbox" {if $user->enabled}checked{/if}/> <label for="active_checkbox">{$tr->active|escape}</label>
			</div>
		</div> 
		
		<div id=column_left>
			<!-- Левая колонка -->
	
				<!-- Параметры страницы -->
				<div class="block">
					<ul>
						{if $groups}
						<li>
							<label style="width: 57px;" class=property>{$tr->group}</label>
							<select name="group_id">
								<option value='0'>{$tr->no|capitalize}</option>
								{foreach from=$groups item=g}
									<option value='{$g->id}' {if $user->group_id == $g->id}selected{/if}>{$g->name|escape} ({$g->discount|escape}%)</option>
								{/foreach}
							</select>
						</li>
						{/if}
						<li style="overflow:visible;">
							<label style="width: 57px;" class=property>Email</label>
							<input style="width: 290px;" name="email" class="fivecms_inp" type="text" value="{$user->email|escape}" />
							{include file='send_user_message.tpl'}
							<input style="margin-left: 10px;" id="backform" type="button" class="button_green" value="{$tr->send_message}" />
						</li>
						{if $user->balance != 0}
						<li style="height:28px;">
							<label style="width: 170px;" class="property">{$tr->accrued_points} {$tr->on} </label>
							{*<input style="width:80px;" name="balance" class="fivecms_inp" type="number" value="{$user->balance|convert|replace:' ':''}" />*}
							<div style="margin-top:2px;">{$user->balance|convert} {$currency->sign}</div>
						</li>
						<li style="height:28px;">
							<label style="width: 175px;" class="property">{$tr->withdrawal_amount} </label>
							- <input style="width:70px;" name="change_balance" class="fivecms_inp" type="number" min="0" max="{$user->balance|round}" />
						</li>
						{/if}
						<li><label style="width: 140px;" class=property>{$tr->phone} </label><input style="width:290px;" name="phone" class="fivecms_inp" type="text" value="{$user->phone|escape}" /></li>
						<li><label style="width: 140px;" class=property>{$tr->register_date}</label><input style="width: 100px;" name="email" class="fivecms_inp" type="text" disabled value="{$user->created|date}" /></li>
						<li><label style="width: 140px;" class=property>IP</label><input style="width: 100px;" name="email" class="fivecms_inp" type="text" disabled value="{$user->last_ip|escape}" /></li>
						<li><label style="width: 140px;" class=property>{if !empty($user->partner_id)}<a class="bluelink" href="index.php?module=UserAdmin&id={$user->partner_id}" target="_blank">{$tr->referer}</a>{else}{$tr->referer}{/if}</label><input style="width: 100px;" disabled name="partner_id" class="fivecms_inp" type="text" value="{$user->partner_id}" /></li>
						<li><label style="width: 140px;" class=property>Грузополучатель</label><textarea style="width: 400px;" name="consignee">{$user->consignee|escape}</textarea></li>
						<li><label style="width: 140px;" class=property>Плательщик</label><textarea style="width: 400px;" name="payer">{$user->payer|escape}</textarea></li>
						<li style="overflow:visible;width:610px;">
							<p style="font-weight:700;margin:15px 0;">{$tr->user_info}:</p>
							<textarea name="comment" class="editor_small">{$user->comment|escape}</textarea>
						</li>
					</ul>
				</div>
	
				<!-- Параметры страницы (The End)-->			
			
			<input style="float: left; margin-bottom: 20px;" class="button_green button_save" type="submit" name="user_info" value="{$tr->save|escape}" />
		</div>
			
		<!-- Левая колонка (The End)--> 
		
	</form>
	<!-- Основная форма (The End) -->
	 
	<div class="block" id=column_right>
		{if $user->tdiscount}<p><strong>{$tr->enablediscounts5}:</strong> {$user->tdiscount}%</p>{/if}
		{if $user->order_payd > 0}<p style="margin-top:15px;"><strong>{$tr->sum_paid_orders}:</strong> {$user->order_payd|convert:$currency->id}&nbsp;{$currency->sign}</p>{/if}
		{if !empty($user->withdrawal)}
			<div class="withdrawal">
				<p class="withdrawal_title">{$tr->total_withdrawal_amount}:</p>
				<ul>{$user->withdrawal}</ul>
			</div>
		{/if}
	</div>	
	
	{if $settings->ref_cookie > 0}
	<div class="block" id="column_left" style="margin-top:15px;">
		<h2 class="referrals_title">{$tr->ref_visits}: {$user->ref_views}</h2>
	</div>
	{/if}
	
	{if $referrals}
	<div class="block" id="column_left" style="width: 575px; margin-top:15px;">
		<h2 class="referrals_title">{$tr->referals}:</h2>
		<div class="referrals">
			<div class="ref_item">
				<div class="ref_id">ID</div>
				<div class="ref_date">{$tr->register_date}</div>
				<div class="ref_ballov">{$tr->payments}</div>
				<div class="ref_profit">{$tr->profit}</div>
			</div>
			{foreach $referrals as $ref}
			<div class="ref_item">
				<div class="ref_id"><a class="bluelink" href="index.php?module=UserAdmin&id={$ref->id}" target="_blank">{$ref->id}</a></div>
				<div class="ref_date">{$ref->created}</div>
				<div class="ref_ballov">{$ref->order_payd|convert} {$currency->sign}</div>
				<div class="ref_profit">{($ref->order_payd/100*$settings->ref_order)|convert} {$currency->sign}</div>
			</div>
			{/foreach}
		</div>
	</div>
	{/if}
	
	{if $orders}
	<div class="block" id="column_left" style="width: 575px; margin-top:15px;">
		<form id="list" method="post" style="display: table;">
			<input type="hidden" name="session_id" value="{$smarty.session.id}">
			<h2>{$tr->all} {$tr->orders}</h2>
	
			<div>		
				{foreach $orders as $order}
				<div class="{if $order->paid}green{/if} row">
					<div class="checkbox cell">
						<input type="checkbox" name="check[]" value="{$order->id}" />				
					</div>
					<div class="order_date cell">
						{$order->date|date} {$order->date|time}
					</div>
					<div class="name cell">
						<a href="index.php?module=OrderAdmin&id={$order->id}">{$tr->order} №{$order->id}</a>
					</div>
					<div class="name cell">
						{$order->total_price|convert:$currency->id}&nbsp;{$currency->sign}
					</div>
					<div class="icons cell" style="width: 20px;">
						{if $order->paid}
							<img src='design/images/cash_stack.png' alt='{$tr->paid}' title='{$tr->paid}'>
						{else}
							<img src='design/images/cash_stack_gray.png' alt='{$tr->not_paid}' title='{$tr->not_paid}'>				
						{/if}	
					</div>
					<div class="icons cell" style="width: 20px;">
						<a href='#' title='{$tr->delete}' class=delete></a>		 	
					</div>
					<div class="clear"></div>
				</div>
				{/foreach}
			</div>
	
			<div id="action">
				<label id='check_all' class='dash_link'>{$tr->choose_all|escape}</label>
				<span id=select>
				<select name="action">
					<option value="delete">{$tr->delete}</option>
				</select>
				</span>
				<input style="padding:10px;font-size:14px;margin-left:20px;" id="apply_action" class="button_green" name="user_orders" type="submit" value="{$tr->apply_checked}">
			</div>
		</form>
	</div>
	{/if}
	
	{if $surveys_categories}
		<div class="block" id="user_surveys">
			<h2>{$tr->surveys}:</h2>
			{if $surveys_categories}
				<div class="surveys_categories">
					{if $surveys_categories|count > 1}<a href="index.php?module=UserAdmin&id={$user->id}">{$tr->all}</a> | {/if}
					{foreach $surveys_categories as $cat}
						<a href="{url category_id=$cat->id}">{$cat->name|escape}</a>{if !$cat@last} | {/if}
					{/foreach}
				</div>
			{/if}

			{if $surveys}
			<div id="list" class="border_box">		
				{foreach $surveys as $survey}
				<div class="row color_{$survey->poll_type}">
					<div class="order_date cell">
						{$vote_info = $survey->vote_info|first}
						{$vote_info->ts|date} <br />{$vote_info->ts|time}
					</div>
					<div class="cell survey_name">
						<a href="index.php?module=SurveyAdmin&id={$survey->id}">{$survey->name|escape}</a>
						<br>
						<div class="vote_value">
							{if $survey->vote_type == 1}
							<svg fill="#FFFFFF" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
							    <path d="M0 0h24v24H0z" fill="none"/>
							    <path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
							</svg>
							{elseif $survey->vote_type == 2}
							<svg fill="#FFFFFF" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
							    <path d="M0 0h24v24H0z" fill="none"/>
							    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
							</svg>
							{elseif $survey->vote_type == 3}
							<svg fill="#FFFFFF" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
							    <path d="M0 0h24v24H0z" fill="none"/>
							    <path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zm4.24 16L12 15.45 7.77 18l1.12-4.81-3.73-3.23 4.92-.42L12 5l1.92 4.53 4.92.42-3.73 3.23L16.23 18z"/>
							</svg>
							{elseif $survey->vote_type == 4}
							<svg fill="#FFFFFF" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
							    <path d="M20 6h-2.18c.11-.31.18-.65.18-1 0-1.66-1.34-3-3-3-1.05 0-1.96.54-2.5 1.35l-.5.67-.5-.68C10.96 2.54 10.05 2 9 2 7.34 2 6 3.34 6 5c0 .35.07.69.18 1H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2zm-5-2c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zM9 4c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm11 15H4v-2h16v2zm0-5H4V8h5.08L7 10.83 8.62 12 11 8.76l1-1.36 1 1.36L15.38 12 17 10.83 14.92 8H20v6z"/>
							    <path d="M0 0h24v24H0z" fill="none"/>
							</svg>
							{/if}
							{foreach $survey->vote_info as $vote}
								<span>{$vote->name|escape}{if !$vote@last},{/if}</span>
							{/foreach}
						</div>
					</div>
					<div class="cell vote_points"> 
						{$survey->points} {$tr->points|lower}
					</div>
					<div class="clear"></div>
				</div>
				{/foreach}
			</div>
			{/if}
		</div>
	{/if}

</div>

{* On document load *}
{literal}

<script>
$(function() {

	// Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();

	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Удалить 
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest(".row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form#list").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form#list").submit();
	});

	// Подтверждение удаления
	$("#list").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_deletion|escape}{literal}'))
			return false;	
	});
});

</script>
{/literal}
