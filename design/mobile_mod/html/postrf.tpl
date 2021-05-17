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
{if !empty($cart->total_weight)}
	{$total_weight = $cart->total_weight}
{/if}

<div id="ecom-widget" style="display: none; height: 80%; width: 100%; padding: 0;"></div>

<script src="https://widget.pochta.ru/map/widget/widget.js"></script>
<script>
	$(window).load(function() {

		let fancy;

		$(document).on('click', '#li_delivery_4 .show_map', function () {
			fancy = $.fancybox.open({
				src: '#ecom-widget',
				type: 'inline',
				opts: {
					smallBtn: false,
					afterShow: function (instance, current) {
						ecomStartWidget({
							id: {$delivery->option1},
							weight: {$total_weight * 1000},
							sumoc: {$cart->total_price|noformat},
							callbackFunction: postrf,
							containerId: 'ecom-widget'
						});
					}
				}
			});
		});

		function postrf(data) {
			const paramsContainer = document.querySelector('.map__params'),
					postrf = $('#postrf');

			let postrf_info = '',
					postrf_price = '';

			for (let key in data) {
				const postrf_val = typeof data[key] === 'object' ? JSON.stringify(data[key]) : data[key];

				if (postrf_val != null) {
					switch (String(key)) {
						case 'cashOfDelivery':
							postrf_price = parseInt(data[key]) / 100;
							break;
						case 'indexTo':
							postrf_info = 'Индекс: ' + postrf_val;
							break;
						case 'regionTo':
							postrf_info += ' | Регион: ' + postrf_val;
							break;
						case 'areaTo':
							postrf_info += ' | Район: ' + postrf_val;
							break;
						case 'cityTo':
							postrf_info += ' | Город: ' + postrf_val;
							break;
						case 'addressTo':
							postrf_info += ' | Адрес: ' + postrf_val;
							break;
						case 'mailType':
							postrf_info += ' | Тип доставки: ' + postrf_val;
							break;
					}
				}
			}

			// calc (1)
			{if $delivery->free_from > 0 && $cart->total_price >= $delivery->free_from}
			postrf.val('0');
			{else}
			$('#not-null-delivery-price-4').html((postrf_price * curr_convert).toFixed({$currency->cents}));
			postrf.val(postrf_price.toFixed({$currency->cents}));
			{/if}
			// calc (1) end

			$('#li_delivery_4 .deliveryinfo').text(postrf_info);

			// calc (2)
			$('#deliveries_4').click();
			$('#calc_info').html($("#li_delivery_4 .deliveryinfo").text());
			// calc (2) end

			fancy.close();
		}

	});
</script>

{* calc (3) *}
<div>
	<div class="deliveryinfo" style="margin-top:10px;"></div>
	<input name="postrf" type="hidden" id="postrf" />
</div>
{* calc (3) end *}
