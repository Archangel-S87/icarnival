<script defer src="https://points.boxberry.ru/js/boxberry.js"></script>
{if !empty($cart->total_weight)}
	{$total_weight = $cart->total_weight}
{/if}
<script>
	$(window).load(function(){
	 try{
		$(document).on('click', '#li_delivery_121 .show_map', function () {
		boxberry.open(callback_function,'{$delivery->option1}','{$delivery->option2}','{$delivery->option3}', {$cart->total_price|noformat}, {$total_weight*1000}, {if $delivery->option4 == 1}{$cart->total_price|noformat}{else}0{/if}, {$side|round}, {$side|round}, {$side|round});
		});
		$(document).on('click', '.boxberry_container_close, .boxberry_overlay', function () {
			$('.boxberry_container, .boxberry_overlay').hide();
		});
		function callback_function(result){ 
			// calc (1)
			{if $delivery->free_from > 0 && $cart->total_price >= $delivery->free_from}
				$('#boxberry').val('0');
			{else}
				document.getElementById('not-null-delivery-price-121').innerHTML = (result.price*curr_convert).toFixed({$currency->cents});
				document.getElementById('boxberry').value = result.price.toFixed({$currency->cents});
			{/if}
			// calc (1) end
			document.getElementById('city').innerHTML = ' | Город ПВЗ: ' + result.name;
			document.getElementById('code_pvz').innerHTML = 'Код ПВЗ: ' + result.id;
			document.getElementById('address').innerHTML = ' | Адрес ПВЗ: ' + result.address;
			document.getElementById('workschedule').innerHTML = ' | Время работы: ' + result.workschedule;
			document.getElementById('phone').innerHTML = ' | Телефон ПВЗ: ' + result.phone;
			document.getElementById('period').innerHTML = ' | Срок доставки: ' + result.period;
			if (result.prepaid=='Yes') { 
				alert('Отделение работает только по предоплате!'); 
			} 
			// calc (2)
			$('#deliveries_121').click();
			$('#calc_info').html( $("#li_delivery_121 .deliveryinfo").text() );
			// calc (2) end
			$('.boxberry_container').hide();
		}
	 } catch(e) {} 
	});
</script>
{* calc (3) *}
<div>
	<div class="deliveryinfo" style="margin-top:10px;">
		<span id="code_pvz"></span>
		<span id="city"></span>
		<span id="address"></span>
		<span id="phone"></span>
		<span id="workschedule"></span>
		<span id="period"></span>
	</div>
	<input name="boxberry" type="hidden" id="boxberry" />
</div>
{* calc (3) end *}