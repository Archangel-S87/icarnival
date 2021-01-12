{* Вкладки *}
{capture name=tabs}
	{if in_array('discountgroup', $manager->permissions)}<li><a href="index.php?module=DiscountGroupAdmin">{$tr->discounts|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=CouponsAdmin">{$tr->coupons|escape}</a></li>
{/capture}

{if !empty($coupon->code)}
	{$meta_title = $coupon->code scope=root}
{else}
	{$meta_title = $tr->new_post scope=root}
{/if}

{if $admin_lang == 'ru'}
	<script src="design/js/jquery/datepicker/jquery.ui.datepicker-ru.js"></script>
{else}
	<script src="design/js/jquery/datepicker/jquery.ui.datepicker-en.js"></script>
{/if}
<script>
$(function() { 
	$('input[name="expire"]').datepicker({ 
		regional:'{$admin_lang}'
	});
	$('input[name="end"]').datepicker({ 
		regional:'{$admin_lang}'
	});
	// On change date
	$('input[name="expire"]').focus(function() { 
    	$('input[name="expires"]').attr('checked', true);
	});
});
</script>

<div id="onecolumn" class="couponpage">

	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success == 'added'}{$tr->added|escape}{elseif $message_success == 'updated'}{$tr->updated|escape}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span class="text">
			{if $message_error == 'code_exists'}{$tr->exists|escape}{/if}
			{if $message_error == 'code_empty'}{$tr->enter_coupon_code|escape}{/if}
		</span>
		<a class="button" href="">{$tr->return|escape}</a>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input placeholder="{$tr->enter_coupon_code|escape}" class="name" name="code" type="text" value="{if !empty($coupon->code)}{$coupon->code|escape}{/if}" required/>
			<input name="id" class="name" type="hidden" value="{if !empty($coupon->id)}{$coupon->id|escape}{/if}"/>		
		</div> 
	
		<!-- Левая колонка свойств товара -->
		<div id="column_left"  style="width: 460px;">
				
			<div class="block layer">
				<ul>
					<li style="width: 450px;">
						<label class=property>{$tr->discount|escape}</label><input name="value" class="coupon_value" type="text" value="{if !empty($coupon->value)}{$coupon->value|escape}{/if}" />
						<select class="coupon_type" name="type">
							<option value="percentage" {if !empty($coupon->type) && $coupon->type == 'percentage'}selected{/if}>%</option>
							<option value="absolute" {if !empty($coupon->type) && $coupon->type == 'absolute'}selected{/if}>{$currency->sign}</option>
						</select>
					</li>
					<li style="width: 450px;">
						<label class=property>{$tr->for_orders_from|escape}</label>
						<input class="coupon_value" type="text" name="min_order_price" value="{if !empty($coupon->min_order_price)}{$coupon->min_order_price|escape}{/if}"> {$currency->sign}		
					</li>
					<li style="width: 450px;">
						<label class=property for="single"></label>
						<input type="checkbox" name="single" id="single" value="1" {if !empty($coupon->single) && $coupon->single == 1}checked{/if}> <label for="single">{$tr->single_time|escape}</label>					
					</li>
				</ul>
			</div>
				
		</div>
		<!-- Левая колонка свойств товара (The End)--> 
		
		<!-- Правая колонка свойств товара -->	
		<div id="column_right">
	
			<div class="block layer">
				<ul>
					<li><label class="property"  style="width: 100px;"><input type=checkbox name="expires" value="1" {if isset($coupon->expire)}checked{/if}>{$tr->expires|escape}</label><input style="width: 150px;" type=text name=expire value='{if isset($coupon->expire)}{$coupon->expire|date}{/if}'></li>
				</ul>
			</div>
			
		</div>
		<!-- Правая колонка свойств товара (The End)--> 
		
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Основная форма (The End) -->

</div>

