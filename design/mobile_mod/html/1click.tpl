<!-- incl. 1click -->
<a href="#oneclick" class="various oneclick">купить в 1 клик</a>
<div style="display: none;">                          
	<div id="oneclick" class="window">
		<div class="title">{$product->name|escape|rtrim}</div>
		<ul>
			<li><input placeholder="* ФИО" class="onename" value="{if !empty($comment_name)}{$comment_name|escape}{/if}" type="text" /></li>
			<li><input placeholder="* Email" name="email" class="onemail" value="{if !empty($user->email)}{$user->email|escape}{/if}" type="email" /></li>
			<li><input placeholder="* Телефон" class="onephone" value="{if !empty($phone)}{$phone|escape}{elseif !empty($user->phone)}{$user->phone|escape}{/if}" type="text" /></li>
		</ul>

		<div id="btf_result"></div>
		{include file='conf.tpl'}
		<button type="submit" name="enter" value="1" class="oneclickbuy buttonred hideablebutton" style="margin-right: 0px;" {if $settings->counters || $settings->analytics}onclick="{if $settings->counters}ym({$settings->counters},'reachGoal','cart'); {/if}{if $settings->analytics}ga ('send', 'event', 'cart', 'order_button');{/if} return true;"{/if}>Заказать</button>
	</div>
</div>

<script>
{literal}
$(function() {
	$('.oneclickbuy').click(function() {
        if($('.variants').find('input[name=variant]:checked').length>0) variant = $('.variants input[name=variant]:checked').val();
		if($('.variants').find('select[name=variant]').length>0) variant = $('.variants').find('select').val();
        if($('.variants').find('input.1clk').length>0) variant = $('.variants input.1clk').val();
		if($('.variants').find('input[name=amount]').length>0) amount = $('.variants input[name=amount]').val();  
		
		function error1clickForm(text){ 
			$("#btf_result").html('<div class="btf_error">'+text+'</div>');
			setTimeout( function(){$(".btf_error").slideUp("slow");}, 4000);
		}
		if( !$('.onename').val() || !$('.onephone').val() || !$('input.onemail').val() ) { 
            error1clickForm('Заполните все поля со *');
            return false;
        }
        
        // Проверяем минимальную сумму заказа
        var total_amount = 1;
        if(amount > 1)
            total_amount = amount;                        	
        var total_price = parseInt( $('.description span.price').text().replace(' ', '') ) * total_amount;
        var min_order_amount = {/literal}{if !empty($settings->minorder)}{$settings->minorder}{else}0{/if}{literal};
		if(total_price > 0 && total_price < min_order_amount) { 
            error1clickForm('Минимальная сумма заказа '+min_order_amount+'{/literal} {$currency->sign}{literal}');
        	return false;
        }
        
		$.ajax({
			type: "GET",
			url: "/ajax/oneclick.php",
            data: {amount: amount, variant: variant, name: $('.onename').val(), email: $('.onemail').val(), phone: $('input.onephone').val() },
			success: function(result){
				if(result=='wrong_name') {
					error1clickForm('В имени можно использовать только кириллицу!');
				} else if(result=='wrong_email') {
					error1clickForm('Некорректный Email!');
				} else if(result=='wrong_phone') {
					error1clickForm('Некорректный телефон!');		
				} else if(result=='captcha') {
					error1clickForm('Не пройдена проверка на бота!');			
				} else if(result > 0) {
					$("#oneclick").html("<div class='title'>Спасибо за заказ!</div><p>В ближайшее время с вами свяжется наш менеджер!</p><button type='submit' class='buttonred' onclick='$.fancybox.close();return false;'>Закрыть!</button>");
					var price = parseInt( $('.description span.price').text().replace(' ', '') );
					(window["rrApiOnReady"] = window["rrApiOnReady"] || []).push(function() {
						try {
							rrApi.order({
								transaction: result,
								items: [
									{ id: variant, qnt: amount, price: price}
								]
							});
						} catch(e) {}
					})
				}
			}
		});
        
        return false;
    });
});
{/literal}
</script>
<!-- incl. 1click @ -->
