<script type="text/javascript" src="https://widget.shiptor.ru/embed/widget.js"></script>

<div id="shiptor_widget" class="_shiptor_widget" 
	{if $cart->total_weight > 0}data-weight="{$cart->total_weight}"{/if} 
	data-mode="inline" 
	data-price= "{$cart->total_price|noformat}" 
	{if $side > 0}data-dimensions= '{ "length":{$side|round}, "width":{$side|round}, "height":{$side|round} }'{/if} 
	{if $delivery->option1}data-kladrFrom= "{$delivery->option1}"{/if} 
	{if $delivery->option2}data-pk= "{$delivery->option2}"{/if} 
	data-cod= "{$delivery->option3}" 
	data-closeText= "Сохранить" 
	{if !empty($delivery->option4)}data-courier= "{$delivery->option4}" {/if}
	{if $delivery->free_from > 0 && $cart->total_price >= $delivery->free_from}data-markup= "-100%" {/if}
	{* наценка data-markup= "10%" или data-markup= "50" *}
	></div>
<script>
	var elemShiptorWidget = document.querySelector("#shiptor_widget");
	var shiptor_city = '';
	var shiptor_pvz_address = '';
	var shiptor_pvz_id = '';
	var shiptor_pvz_shipping_method = '';

	elemShiptorWidget.addEventListener("onLocationSelect", function(ae){ 
		shiptor_city = ae.detail.city.city;
	});

	elemShiptorWidget.addEventListener("onWidgetSuccess", function(ce){ 
		if(Boolean(ce.detail.method)){
			var shiptor_price = parseInt(ce.detail.method.cost.total.sum);
			var shiptor_days = ' | '+ce.detail.method.days;
			var shiptor_name = ' | '+ce.detail.method.method.name;
		}	
		if(Boolean(ce.detail.pvz)){	
			shiptor_pvz_address = ' '+ce.detail.pvz.address;
			shiptor_pvz_id = ' | pvz_id: '+ce.detail.pvz.id;
			shiptor_pvz_shipping_method = ' | pvz_shipping_method: '+ce.detail.pvz.shipping_method;
		}
		// calc (1)
		{if $delivery->free_from > 0 && $cart->total_price >= $delivery->free_from}
			$('#shiptor').val('0');
		{else}
		   $('#not-null-delivery-price-3').html( (shiptor_price*curr_convert).toFixed(0) );
		   $('#shiptor').val(shiptor_price);
		{/if}   
		// calc (1) end

		$('#li_delivery_3 .deliveryinfo').text( shiptor_city+shiptor_days+shiptor_name+shiptor_pvz_address+shiptor_pvz_id+shiptor_pvz_shipping_method );

		// calc (2)
		   $('#deliveries_3').click();
		   $('#calc_info').html( $("#li_delivery_3 .deliveryinfo").text() );
		// calc (2) end
	});
</script>
{* calc (3) *}
<div class="deliveryinfo_wrapper">
	<div class="deliveryinfo" style="margin-top:10px;"></div>
	<input name="shiptor" type="hidden" id="shiptor" />
</div>
{* calc (3) end *}