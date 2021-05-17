{if !empty($cart->total_weight)}
	{$total_weight = $cart->total_weight}
{/if}	
<div id="ecom-widget">
  <script src="https://widget.pochta.ru/map/widget/widget.js"></script>
  <script>
  $(window).load(function(){
	  $(document).on('click', '#li_delivery_4 .show_map', function () {
	  
	    $('#ecom-widget').css("height","500px");
	  
		ecomStartWidget({ 
		  id: {$delivery->option1},
		  weight: {$total_weight*1000},
		  sumoc: {$cart->total_price|noformat},
		  callbackFunction: postrf,
		  containerId: 'ecom-widget' 
		});
	
		function postrf(data) { 
			const paramsContainer = document.querySelector('.map__params');

			for (const key in data) { 
				postrf_val = typeof data[key] === 'object' ? JSON.stringify(data[key]) : data[key];

				var postrf_info;
			
				if(postrf_val != "null"){
					if(String(key) == "cashOfDelivery"){
						var postrf_price = parseInt(data[key])/100;
					}else if(String(key) == "indexTo"){
						postrf_info = 'Индекс: '+postrf_val;
					}else if(String(key) == "regionTo"){
						postrf_info += ' | Регион: '+postrf_val;
					}else if(String(key) == "areaTo"){
						postrf_info += ' | Район: '+postrf_val;
					}else if(String(key) == "cityTo"){
						postrf_info += ' | Город: '+postrf_val;
					}else if(String(key) == "addressTo"){
						postrf_info += ' | Адрес: '+postrf_val;
					}else if(String(key) == "mailType"){
						postrf_info += ' | Тип доставки: '+postrf_val;	
					}
				}
			}
	  
			// calc (1)
			{if $delivery->free_from > 0 && $cart->total_price >= $delivery->free_from}
				$('#postrf').val('0');
			{else}
			   $('#not-null-delivery-price-4').html( (postrf_price*curr_convert).toFixed({$currency->cents}) );
			   $('#postrf').val(postrf_price.toFixed({$currency->cents}));
			{/if}   
			// calc (1) end 

			$('#li_delivery_4 .deliveryinfo').text(postrf_info);

			// calc (2)
			   $('#deliveries_4').click();
			   $('#calc_info').html( $("#li_delivery_4 .deliveryinfo").text() );
			// calc (2) end
	  
		}
	  });
  });  
  </script>
</div>

{* calc (3) *}
<div>
	<div class="deliveryinfo" style="margin-top:10px;"></div>
	<input name="postrf" type="hidden" id="postrf" />
</div>
{* calc (3) end *}