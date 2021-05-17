<script defer id="ISDEKscript" type="text/javascript" src="https://widget.cdek.ru/widget/widjet.js"></script>
<script>
	$(window).load(function(){
		try{
			ourWidjet = new ISDEKWidjet ({
				popup: true,
				{if $delivery->option1}
				defaultCity: '{$delivery->option1|escape}', //какой город отображается по умолчанию
				{else}
				defaultCity: 'auto', // определяется автоматом
				{/if}
				cityFrom: '{$delivery->option2|escape}', // из какого города будет идти доставка
				country: '{$delivery->option3|escape}', // можно выбрать страну
				//hidedress: false,
				//hidecash: false,
				//hidedelt: false,
				path: 'https://widget.cdek.ru/widget/scripts/',
				servicepath: '{$config->root_url}/service.php',
				{if $delivery->option4}apikey: '{$delivery->option4|escape}',{/if}
				//onReady: onReady,
				onChoose: onChoose,
				onChooseProfile: onChooseProfile
			});
			function onReady() {
				//console.log('ready');
			}
			function onChoose(wat) {
				serviceMess(
					'Выбран пункт выдачи заказа ' + wat.id + " | " +
					'адрес ПВЗ ' + wat.PVZ.Address + " | " +
					'срок ' + wat.term + " дн. | " +
					'тариф ' + wat.tarif + " | " +
					'код города ' + wat.city + " | " +
					'город ' + wat.cityName
				);
				// calc (1.1)
				if(wat.price != null) {
					{if $delivery->free_from > 0 && $cart->total_price >= $delivery->free_from}
						$('#cdek').val('0');
					{else}
						$('#not-null-delivery-price-114').html((wat.price*curr_convert).toFixed({$currency->cents}));
						$('#cdek').val(wat.price);
					{/if}
				}
				// calc (1.1) end
			}
			function onChooseProfile(wat) {
				serviceMess(
					'Выбрана доставка курьером в город ' + wat.cityName + " | " +
					'код города ' + wat.city + " | " +
					'тариф ' + wat.tarif + " | " +
					'срок ' + wat.term + ' дн.'
				);
				// calc (1.2) end
				if(wat.price != null) {
					{if $delivery->free_from > 0 && $cart->total_price >= $delivery->free_from}
						$('#cdek').val('0');
					{else}
						$('#not-null-delivery-price-114').html((wat.price*curr_convert).toFixed({$currency->cents}));
						$('#cdek').val(wat.price);
					{/if}
				}
				// calc (1.2) end
			}
			serviceMess = function (text) {
				$('#li_delivery_114 .deliveryinfo').html(text);
				// calc (2)
				$('#deliveries_114').click();
				$('#calc_info').html(text);
				// calc (2) end
			}

		} catch(e) {} 
	
		// Инициализация виджета по клику на "выбрать на карте"
		{if !empty($cart->total_weight)}
			{$total_weight = $cart->total_weight}
		{/if}	
		
		$(document).on('click', '#li_delivery_114 .show_map', function () {
			ourWidjet.cargo.reset();
			ourWidjet.cargo.add({
				length: {$side|round},
				width: {$side|round},
				height: {$side|round},
				weight: {$total_weight}
			});
			ourWidjet.open();
		});
		
		// Проверка доступности СДЭК
		/*if(cdekReady == 0){
			{if $delivery->free_from > 0 && $cart->total_price >= $delivery->free_from}
				$('#cdek').val('0');
			{else}
				$('#not-null-delivery-price-114').html(({$delivery->option5|escape}*curr_convert).toFixed({$currency->cents}));
				$('#cdek').val('{$delivery->option5|escape}');
			{/if}
			$('#calc_info').html('Сервер СДЭК недоступен');
			$('#li_delivery_114 .show_map').hide();
		}*/
		
		$(document).on('click', '.CDEK-widget__popup__close-btn', function () {
			ourWidjet.close();
			return false;
		});
	});
</script>
									
{* calc (3)*}
<div class="deliveryinfo_wrapper" style="margin-top:10px;">
	<div class="deliveryinfo"></div>
	<input name="cdek" type="hidden" id="cdek" />
</div>
{* calc (3) end *}
