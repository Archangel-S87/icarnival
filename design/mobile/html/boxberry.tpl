<a class="show_map" href="javascript://">
	<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="34px" height="34px" viewBox="0 0 24 24" enable-background="new 0 0 24 24" xml:space="preserve">
	<g id="Bounding_Boxes">
		<path fill="none" d="M0,0h24v24H0V0z"/>
	</g>
	<g id="Duotone">
		<g id="ui_x5F_spec_x5F_header_copy_2">
		</g>
		<g>
			<polygon opacity="0.3" points="5,18.31 8,17.15 8,5.45 5,6.46 		"/>
			<polygon opacity="0.3" points="16,18.55 19,17.54 19,5.69 16,6.86 		"/>
			<path d="M20.5,3l-0.16,0.03L15,5.1L9,3L3.36,4.9C3.15,4.97,3,5.15,3,5.38V20.5C3,20.78,3.22,21,3.5,21l0.16-0.03L9,18.9l6,2.1
				l5.64-1.9c0.21-0.07,0.36-0.25,0.36-0.48V3.5C21,3.22,20.78,3,20.5,3z M8,17.15l-3,1.16V6.46l3-1.01V17.15z M14,18.53l-4-1.4V5.47
				l4,1.4V18.53z M19,17.54l-3,1.01V6.86l3-1.16V17.54z"/>
		</g>
	</g>
	</svg>
	<div>Выбрать на карте</div>
</a>
<script defer type="text/javascript" src="https://points.boxberry.ru/js/boxberry.js"></script>
{if !empty($cart->total_weight)}
	{$total_weight = $cart->total_weight}
{/if}
<script type="text/javascript">
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
					document.getElementById('boxberry').value = result.price;
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
<div class="deliveryinfo_wrapper">
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