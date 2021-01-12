		       var rrPartnerId = "{$settings->trigger_id}"; {literal}      
		       var rrApi = {}; 
		       var rrApiOnReady = rrApiOnReady || [];
		       rrApi.addToBasket = rrApi.order = rrApi.categoryView = rrApi.view = 
		           rrApi.recomMouseDown = rrApi.recomAddToCart = function() {};
		       (function(d) {
		           var ref = d.getElementsByTagName('script')[0];
		           var apiJs, apiJsId = 'rrApi-jssdk';
		           if (d.getElementById(apiJsId)) return;
		           apiJs = d.createElement('script');
		           apiJs.id = apiJsId;
		           apiJs.async = true;
		           apiJs.src = "//cdn.retailrocket.ru/content/javascript/tracking.js";
		           ref.parentNode.insertBefore(apiJs, ref);
		       }(document));
			{/literal}
			{if $module == 'ProductsView' && !$keyword}
				{literal}
					(window["rrApiOnReady"] = window["rrApiOnReady"] || []).push(function() {
			        	try { rrApi.categoryView({/literal}{$category->id}{literal}); } catch(e) {}
			   		})
				{/literal}
			{/if}
			{if $module == 'ProductView'}
				{literal}
					(window["rrApiOnReady"] = window["rrApiOnReady"] || []).push(function() {
						try{ rrApi.view({/literal}{$product->variant->id}{literal}); } catch(e) {}
					})
				{/literal}
			{/if}
			{if $module == 'OrderView'}
				{literal}
					(window["rrApiOnReady"] = window["rrApiOnReady"] || []).push(function() {
				        try {
				            rrApi.order({
				                transaction: {/literal}{$order->id}{literal},
				                items: [
				                {/literal}{foreach from=$purchases item=purchase name=good}{literal}
				                    { 
				                        id: {/literal}{$purchase->variant_id}{literal},
				                        qnt: {/literal}{$purchase->amount}{literal},
				                        price: {/literal}{$purchase->price}{literal}
				                    }
				               {/literal}{if !$smarty.foreach.good.last}{literal},{/literal}{/if}
				               {/foreach}{literal}
				                ]
				            });
				        } catch(e) {}
				    })
				{/literal}
			{/if}
				{literal}
					$( "input[name=email], input[type=email]" ).blur(function() {
					  var regex = /^([a-zA-Z0-9_.+-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$/;if(regex.test(this.value)) { try {rrApi.setEmail(this.value);}catch(e){}}
					});
				{/literal}
			{if $keyword}
					rrApiOnReady.push(
					    function() {
					        try { 
					            rrApi.search("{$keyword}"); 
					        }
					        catch(e) {}
					     }
					);
			{/if}
