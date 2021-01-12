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
<script id="ISDEKscript" type="text/javascript" src="https://widget.cdek.ru/widget/widjet.js"></script>
<script>
$(window).load(function(){
	var ourWidjet = new ISDEKWidjet ({
		popup: true,
		{if $delivery->option1}
		defaultCity: '{$delivery->option1}', //какой город отображается по умолчанию
		{else}
		defaultCity: 'auto', // определяется автоматом
		{/if}
		cityFrom: '{$delivery->option2}', // из какого города будет идти доставка
		country: '{$delivery->option3}', // можно выбрать страну
		//hidedress: false,
		//hidecash: false,
		//hidedelt: false,
		{if $delivery->option4}apikey: '{$delivery->option4|escape}',{/if}
		path: 'https://widget.cdek.ru/widget/scripts/',
		servicepath: '{$config->root_url}/service.php',
		//onReady: onReady,
		onChoose: onChoose,
		onChooseProfile: onChooseProfile
	});
	function onReady() {
		//console.log('ready');
	}
	function onChoose(wat) {
		serviceMess(
			'Выбран пункт выдачи заказа ' + wat.id + "\n<br/>" +
			'адрес ПВЗ ' + wat.PVZ.Address + "\n<br/>" +
			'срок ' + wat.term + " дн.\n<br/>" +
			'тариф ' + wat.tarif + "\n<br/>" +
			'код города ' + wat.city + "\n<br/>" +
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
			'Выбрана доставка курьером в город ' + wat.cityName + "\n<br/>" +
			'код города ' + wat.city + "\n<br/>" +
			'тариф ' + wat.tarif + "\n<br/>" +
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
					  
	$(document).on('click', '#li_delivery_114 .show_map', function () {
		ourWidjet.cargo.reset();
		ourWidjet.cargo.add({
			length: {$side|round},
			width: {$side|round},
			height: {$side|round},
			weight: {$cart->total_weight}
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