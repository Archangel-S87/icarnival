{if !empty($cart->total_weight)}
    {$total_weight = $cart->total_weight}
{/if}

<div id="ecom-widget" style="display: none; height: 80%; width: 80%; padding: 0;"></div>

<script src="https://widget.pochta.ru/map/widget/widget.js"></script>
<script>
    $(window).load(function () {

        let fancy;

        $(document).on('click', '#li_delivery_4 .show_map', function () {
            fancy = $.fancybox.open({
                src: '#ecom-widget',
                type: 'inline',
                opts: {
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
            $('#li_delivery_4 .show_map').removeClass('look_here');
        }

    });
</script>

{* calc (3) *}
<div>
    <div class="deliveryinfo" style="margin-top:10px;"></div>
    <input name="postrf" type="hidden" id="postrf"/>
</div>
{* calc (3) end *}
