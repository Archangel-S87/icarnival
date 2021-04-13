{$postcalc = json_decode($delivery->option1)}

<div style="display: none;">
    <div id="postcalc">
        <div id="postcalc_header" class="cart-blue">
            <h2>Почта России</h2>
        </div>
        <div id="postcalc_form_block">
            {if !$postcalc->hide_from}
                <label for="from">Откуда:
                    <input id="from" type="text" value="{$postcalc->default_from}" disabled>
                </label>
            {/if}
            <label for="to">Куда:
                <input id="to" type="text" placeholder="Адрес или индекс почтового отделения">
            </label>
        </div>
        <div id="postcalc_action_block">
            <button type="button" class="buttonred blue">Расчёт стоимости</button>
        </div>
        <div id="postcalc_result_block"></div>
    </div>
</div>

<script>
    $(window).load(function () {
        $('#li_delivery_122').on('click', '.show_map', function () {
            $.fancybox({
                href: '#postcalc',
                scrolling: 'no',
                modal: false,
                onComplete: show_window,
                onClosed: close_window
            });
        });

        function close_window() {
            $('html').css({
                'overflow': '',
                'padding-right': ''
            });
            $('#fancybox-overlay, #fancybox-wrap').css('z-index', '');
            $("#postcalc #to").autocomplete('dispose');
        }

        function show_window() {
            $('html').css({
                'overflow': 'hidden',
                'padding-right': '20px'
            });
            $('#fancybox-overlay, #fancybox-wrap').css('z-index', '999');

            $("#postcalc #to").autocomplete({
                serviceUrl:'/Postcalc/AjaxPostcalc.php',
                params: {
                    delivery_id: '{$delivery->id}',
                    action: 'autocomplete'
                },
                minChars: 0,
                noCache: false,
                onSelect: function (suggestion) {
                    $(this).val(suggestion.value);
                    return suggestion.index;
                },
                formatResult: function (suggestions) {
                    return suggestions.value;
                }
            });
        }
    });
</script>

<style>
    #postcalc {
        min-width: 540px;
    }
    #postcalc label {
        margin: 5px 0;
        display: block;
    }
    #postcalc_action_block {
        margin: 10px 0;
    }
</style>
