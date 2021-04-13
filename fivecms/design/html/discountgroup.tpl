{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main|escape}</a></li>{/if}
	{if in_array('currency', $manager->permissions)}<li><a href="index.php?module=CurrencyAdmin">{$tr->currencies|escape}</a></li>{/if}
	{if in_array('delivery', $manager->permissions)}<li><a href="index.php?module=DeliveriesAdmin">{$tr->delivery|escape}</a></li>{/if}
	{if in_array('payment', $manager->permissions)}<li><a href="index.php?module=PaymentMethodsAdmin">{$tr->payment|escape}</a></li>{/if}
	{if in_array('managers', $manager->permissions)}<li><a href="index.php?module=ManagersAdmin">{$tr->managers|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=DiscountGroupAdmin">{$tr->discounts|escape}</a></li>
{/capture}

{$meta_title = $tr->discounts scope=root}

{* On document load *}
{literal}
<script>
$(function() {

	// Сортировка списка
	// Сортировка вариантов
	$("#discounts_block").sortable({ items: 'ul.sortable' , axis: 'y',  cancel: '#header', handle: '.move_zone' });

	// Добавление 
	var curr = $('#new_discountgroup').clone(true);
	$('#new_discountgroup').remove().removeAttr('id');
	$('a#add_discountgroup').click(function() {
		$(curr).clone(true).appendTo('#discounts').fadeIn('slow').find("input[name*=discount][name*=name][name*=count_from][name*=count_to").focus();
		return false;		
	});	 

	// Скрыт/Видим
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest("ul");
		var id          = line.find('input[name*="discountgroup[id]"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'discountgroup', 'id': id, 'values': {'enabled': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				icon.removeClass('loading_icon');
				if(state)
					line.removeClass('invisible');
				else
					line.addClass('invisible');				
			},
			dataType: 'json'
		});	
		return false;	
	});
        $("a.delete").click(function() {
		$('input[type="hidden"][name="action_d"]').val('delete');
		$('input[type="hidden"][name="action_id_d"]').val($(this).closest("ul").find('input[type="hidden"][name*="discountgroup[id]"]').val());
		$(this).closest("form").submit();
	});    
	// Запоминаем id первого
	var base_discountgroup_id = $('input[name*="discountgroup[id]"]').val();
	
	$("form").submit(function() {
		if($('input[type="hidden"][name="action_d"]').val()=='delete' && !confirm('{/literal}{$tr->confirm_delete|escape}{literal}'))
			return false;	
		});

});

</script>
{/literal}

<div id="onecolumn" class="discountpage">			
 
	<form method=post id="product">
		<input type="hidden" name="session_id" value="{$smarty.session.id}">
		
		<h2>{$tr->discounts|escape}:</h2>
		
		<div id="discounts_block" style="padding-bottom:0;">
			<div class="discountchooser">
	                <input type="radio" id="check_discount" name="check_discount" value="99" {if $enablediscounts==99}checked{/if}> {$tr->enablediscounts99}<br />
	                <input type="radio" id="check_discount" name="check_discount" value="1" {if $enablediscounts==1}checked{/if}> {$tr->enablediscounts1}<br />
	                <input type="radio" id="check_discount" name="check_discount" value="2" {if $enablediscounts==2}checked{/if}> {$tr->enablediscounts2}<br />
					<input type="radio" id="check_discount" name="check_discount" value="5" {if $enablediscounts==5}checked{/if}> {$tr->enablediscounts5}<br />
	                <input type="radio" id="check_discount" name="check_discount" value="3" {if $enablediscounts==3}checked{/if}> {$tr->enablediscounts3}<br />
					<input type="radio" id="check_discount" name="check_discount" value="4" {if $enablediscounts==4}checked{/if}> {$tr->enablediscounts4}
					<p style="margin-top:10px;">{$tr->discount_helper}</p>
	        </div>
	        
	        <input style="margin-top:10px;" id='apply_action' class="button_green" type=submit value="{$tr->save|escape}">
	        
	        <div class="block layer" style="margin:10px 0 0px 0;padding:0;">   
	        	<a style="display:inline-block;margin:15px 10px 9px 0;" class="bigbutton" href="index.php?module=CouponsAdmin">{$tr->coupons|escape}</a>   
	        	<a style="display:inline-block;margin-bottom:9px;" class="bigbutton" href="index.php?module=MobsetAdmin">{$tr->mob_discount|escape}</a> 
	        </div>
	        
	        <div class="block layer" style="margin:10px 0 0px 0;padding:10px 0;">   
	        	<h2 style="display:inline-block;">{$tr->variant_discount|escape}</h2>   
				<select name="variant_discount" class="fivecms_inp" style="margin-left:15px;">
					<option value='0' {if $settings->variant_discount == '0'}selected{/if}>{$tr->disabled_a|escape}</option>
					<option value='1' {if $settings->variant_discount == '1'}selected{/if}>{$tr->enabled_a|escape}</option>
				</select>
				
				<a style="display:inline-block;margin:0 0 6px 15px;" class="bigbutton" href="index.php?module=MultichangesAdmin">{$tr->pack_discount|escape}</a> 
				
	        </div>
	        
			<div class="block layer" id="header" style="margin-bottom:0px;">
				<h2>{$tr->enablediscounts2} ({$currency->sign}):</h2>
				<a class="add" id="add_discountgroup" href="#">{$tr->add|escape}</a>
			</div>
	
			<ul id="header">
				<li class="move"></li>
				<li class="name">{$tr->name|escape}</li>
	            <li class="count_from">{$tr->amount|escape} {$tr->from|escape}</li>
	            <li class="count_to">{$tr->amount|escape} {$tr->to|escape}</li>	
				<li class="sign">{$tr->discount|escape} %</li>
	            <li class="icons"></li>	
			</ul>
	
			<div id="discounts">
	
				{foreach from=$discountgroups item=c}
				<ul class="sortable {if !$c->enabled}invisible{/if}">
					<li class="name">
						<input name="discountgroup[id][{$c->id}]" type="hidden" value="{$c->id|escape}" /><input name="discountgroup[name][{$c->id}]" type="" value="{$c->name|escape}" />
					</li>
					<li class="count">                              
						<div class="count_from"><input name="discountgroup[count_from][{$c->id}]" type="number" min="0" step="1" value="{$c->count_from|escape}" /></div>
						<div class="count_to"><input name="discountgroup[count_to][{$c->id}]" type="number" min="1" step="1" value="{$c->count_to|escape}" /></div>
								  
					</li> 
					<li class="sign">		<input name="discountgroup[discount][{$c->id}]" type="number" min="1" max="100" step="1"  value="{$c->discount|escape}" /></li>
			
					<li class="icons">                            						
						<a class="delete" href="#" title="{$tr->delete|escape}"></a>
					</li>
				</ul>
				{/foreach}		
				
				<ul id="new_discountgroup" style='display:none;'>
					<li class="name"><input name="discountgroup[id][]" type="hidden" value="" /><input name="discountgroup[name][]" type="" value="" /></li>
					<li class="count">                              
						<div class="count_from"><input name="discountgroup[count_from][]" type="number" min="0" step="1" value="" /></div>
						<div class="count_to"><input name="discountgroup[count_to][]" type="number" min="1" step="1" value="" /></div>                              
					</li>
					<li class="sign">		<input name="discountgroup[discount][]" type="number" min="1" max="100" step="1" value="" /></li>
					<li class="icons"></li>
				</ul>
			</div>
		</div>

		<!-- Накопительная скидка -->
		<div class="block layer">
			<h2>{$tr->enablediscounts5} ({$currency->sign}):</h2>
			<ul>
				<li class="tdiscleft">
					<table id="tdiscount">
						<tr>
							<td><p class="discttl">{$tr->amount|escape}</p></td>
							<td><p class="discttl">%</p></td>
						</tr>
						{foreach $td as $k => $v}
						<tr>
							<td><input name="td[0][]" class="fivecms_inp" type="number" min="1" step="1"  value="{$v.0}" /></td>
							<td><input name="td[1][]" class="fivecms_inp" type="number" min="1" max="100" step="1" value="{$v.1}" /></td>
						</tr>
						{/foreach}
						<tr>
							<td><input name="td[0][]" class="fivecms_inp" type="number" min="1" step="1" value="" /></td>
							<td><input name="td[1][]" class="fivecms_inp" type="number" min="1" max="100" step="1" value="" /></td>
						</tr>
						<tr>
							<td><input name="td[0][]" class="fivecms_inp" type="number" min="1" step="1" value="" /></td>
							<td><input name="td[1][]" class="fivecms_inp" type="number" min="1" max="100" step="1" value="" /></td>
						</tr>
						<tr>
							<td><input name="td[0][]" class="fivecms_inp" type="number" min="1" step="1" value="" /></td>
							<td><input name="td[1][]" class="fivecms_inp" type="number" min="1" max="100" step="1" value="" /></td>
						</tr>
						<tr>
							<td><input name="td[0][]" class="fivecms_inp" type="number" min="1" step="1" value="" /></td>
							<td><input name="td[1][]" class="fivecms_inp" type="number" min="1" max="100" step="1" value="" /></td>
						</tr>
					</table>
				</li>
			</ul>
		</div>
		<!-- Накопительная скидка (The End)-->

	    <div class="block layer">
	      <h2>{$tr->point_rub|escape} {$currency->sign}):</h2>
	      <ul>
	        <li><label class=property style="padding-right:10px;">{$tr->points_order_amount|escape}</label><input style="width:60px;" name="bonus_order" class="fivecms_inp" type="number" min="0" max="100" step="1" value="{$settings->bonus_order|escape}" /> %</li>
	        <li><label class=property style="padding-right:10px;">{$tr->points_limit|escape}</label><input style="width:60px;" name="bonus_limit" class="fivecms_inp" type="number" min="0" max="100" step="1" value="{$settings->bonus_limit|escape}" /> %</li>
	        <li><label class=property style="padding-right:10px;">{$tr->bonus_link|escape}</label><input placeholder="{$tr->example|escape}: bonus" style="max-width:320px;width:320px;" name="bonus_link" class="fivecms_inp" type="text" value="{$settings->bonus_link|escape}" /></li>
	      </ul>
	    </div> 
	    
	    {* referral program *}
	    <div class="block layer">
	      <h2>{$tr->ref_title|escape}:</h2>
	      <ul>
	        <li><label class=property style="padding-right:10px;">{$tr->points_order_amount|escape}</label><input style="width:60px;" name="ref_order" class="fivecms_inp" type="number" min="0" max="100" step="1" value="{$settings->ref_order|escape}" /> %</li>
	        <li><label class=property style="padding-right:10px;">{$tr->ref_cookie|escape}</label><input style="max-width: 50px;" name="ref_cookie" class="fivecms_inp" min="1" step="1" type="number" value="{$settings->ref_cookie|escape}" /> {$tr->ref_days|escape}</li>
	        <li><label class=property style="padding-right:10px;">{$tr->ref_link|escape}</label><input placeholder="{$tr->example|escape}: partners" style="max-width:320px;width:320px;" name="ref_link" class="fivecms_inp" type="text" value="{$settings->ref_link|escape}" /></li>
	      </ul>
	    </div> 
	    {* referral program @ *}

		<div id="action">
			<input type=hidden name=recalculate value='0'>
			<input type=hidden name=action_d value=''>
			<input type=hidden name=action_id_d value=''>
			<input id='apply_action' class="button_green" type=submit value="{$tr->save|escape}">
		</div>
	</form>
</div>
