{* Вкладки *}
{capture name=tabs}
	{if in_array('discountgroup', $manager->permissions)}<li><a href="index.php?module=DiscountGroupAdmin">{$tr->discounts|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=CouponsAdmin">{$tr->coupons|escape}</a></li>
{/capture}

{* Title *}
{$meta_title = $tr->coupons scope=root}

<div class="headerseparator" style="margin-bottom:10px;">		
{* Заголовок *}
<div id="header">
	{if $coupons_count}
	<h1>{$tr->coupons_count|escape}: {$coupons_count}</h1>
	{else}
	<h1>{$tr->no_content|escape}</h1>
	{/if}
	<a class="add" href="{url module=CouponAdmin return=$smarty.server.REQUEST_URI}">{$tr->add|escape}</a>
</div>
{* Поиск *}
{if !empty($coupons) || !empty($keyword)}
<form method="get">
	<div id="search">
		<input type="hidden" name="module" value='CouponsAdmin'>
		<input class="search" type="text" name="keyword" value="{if !empty($keyword)}{$keyword|escape}{/if}" />
		<input class="search_button" type="submit" value=""/>
	</div>
</form>
{/if}
</div>

{if $coupons}
<div id="main_list" style="max-width: 780px;">
	
	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->

	<form id="form_list" method="post">
	<input type="hidden" name="session_id" value="{$smarty.session.id}">
	
		<div id="list">
			{foreach $coupons as $coupon}
			<div class="{if $coupon->valid}green{/if} row">
		 		<div class="checkbox cell">
					<input type="checkbox" name="check[]" value="{$coupon->id}"/>				
				</div>
				<div class="coupon_name cell">			 	
	 				<a href="{url module=CouponAdmin id=$coupon->id return=$smarty.server.REQUEST_URI}">{$coupon->code}</a>
				</div>
				<div class="coupon_discount cell">			 	
	 				{$tr->discount|escape} {$coupon->value*1} {if $coupon->type=='absolute'}{$currency->sign}{else}%{/if}<br>
	 				{if $coupon->min_order_price>0}
	 					<div class="detail">
	 						{$tr->for_orders_from|escape} {$coupon->min_order_price|escape} {$currency->sign}
	 					</div>
	 				{/if}
				</div>
				<div class="coupon_details cell">			 	
					{if $coupon->single}
	 				<div class="detail" style="text-transform:uppercase;">
	 					{$tr->single_time|escape}
	 				</div>
	 				{/if}
	 				{if $coupon->usages>0}
	 				<div class="detail">
	 					{$tr->used|escape} {$coupon->usages|escape} {$coupon->usages|plural:$tr->times_plural:$tr->times:$tr->times}
	 				</div>
	 				{/if}
	 				{if $coupon->expire}
	 				<div class="detail">
	 				{if $smarty.now|date_format:'%Y%m%d' <= $coupon->expire|date_format:'%Y%m%d'}
	 					{$tr->expires|escape} {$coupon->expire|date}
	 				{else}
	 					{$tr->expired|escape} {$coupon->expire|date}
	 				{/if}
	 				</div>
	 				{/if}
				</div>
				<div class="icons cell" style="width:40px; min-width:40px;">
					<a href='#' class=delete></a>
				</div>
				<div class="name cell" style='white-space:nowrap;'>
					
	 				
				</div>
				<div class="clear"></div>
			</div>
			{/foreach}
		</div>
		
	
		<div id="action">
		<label id="check_all" class="dash_link">{$tr->choose_all|escape}</label>
	
		<span id="select">
		<select name="action">
			<option value="delete">{$tr->delete|escape}</option>
		</select>
		</span>
	
		<input id="apply_action" class="button_green" type="submit" value="{$tr->save|escape}">
		
		</div>
				
	</form>	

	<!-- Листалка страниц -->
	{include file='pagination.tpl'}	
	<!-- Листалка страниц (The End) -->
	
</div>
{/if}

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
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
		
	// Подтверждение удаления
	$("form").submit(function() {
		if($('#list input[type="checkbox"][name*="check"]:checked').length>0)
			if($('select[name="action"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
				return false;	
	});
});

</script>
{/literal}



