<!-- incl. 1click -->
<!--noindex-->
<a href="#oneclick" class="various oneclick">купить в 1 клик</a>
<div style="display: none;">                          
	<div id="oneclick" class="window">
	        <div class="title font">{$product->name|escape|rtrim}</div>
	        <ul>
				<li><span>* Ваше имя:</span><input class="onename" value="{if isset($comment_name)}{$comment_name|escape}{/if}" type="text" /></li>
				<li><span>* Email:</span><input name="email" class="onemail" value="{if isset($user->email)}{$user->email|escape}{/if}" type="text" /></li>
				<li><span>* Телефон:</span><input name="onephone" class="onephone2" value="{if isset($phone)}{$phone}{elseif isset($user->phone)}{$user->phone}{/if}" type="text" /></li>
	        </ul>
			<div id="oneclick_result"></div>
			{include file='conf.tpl'}
	        <button style="font-size:17px;padding: 8px 40px;margin-right: 0px;" type="submit" {if $settings->counters || $settings->analytics}onclick="yaCounter{$settings->counters}.reachGoal('cart'); ga ('send', 'event', 'cart', 'order_button'); return true;"{/if} name="enter" value="1" class="oneclickbuy buttonred hideablebutton" >Купить!</button>
	</div>
</div>
{literal}
    <script>
        $(function() {
                $(".various").fancybox({
					'hideOnContentClick' : false,
					'hideOnOverlayClick' : false
                });
                $('.oneclickbuy').click(function() {
                        if($('.variants').find('input[name=variant]:checked').length>0) variant = $('.variants input[name=variant]:checked').val();
						if($('.variants').find('select[name=variant]').length>0) variant = $('.variants').find('select').val();
                        if($('.variants').find('input.1clk').length>0) variant = $('.variants input.1clk').val();
						if($('.variants').find('input[name=amount]').length>0) amount = $('.variants input[name=amount]').val();
                        if( !$('.onename').val() || !$('.onephone2').val() || !$('.onemail').val() ) { 
                                $("#oneclick_result").html('<div class="btf_error">Заполните все поля!</div>');
								setTimeout( function(){$(".btf_error").slideUp("slow");}, 2000);
                                return false;
                        }
						$.ajax({
							type: "GET",
							url: "ajax/oneclick.php",
                            data: {amount: amount, variant: variant, name: $('.onename').val(), email: $('.onemail').val(), phone: $('.onephone2').val() },
                            dataType: 'json', 
							success: function(result){
								if(result > 0){
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
                        $("#oneclick").html("<div class='title'>Спасибо за заказ!</div><p>В ближайшее время с вами свяжется наш менеджер!</p><button type='submit' class='button' onclick='$.fancybox.close();return false;'>Закрыть!</button>");
                        return false;
                });
        });
    </script>
{/literal}
<!--/noindex-->
<!-- incl. 1click @-->
