{if $currencies|count>1}
<!-- incl. mcurrencies -->
<!--noindex-->
	<script>
	{literal}
		$(function() {
			$('select[name=currency_id]').change(function() {
				$(this).closest('form[name=currency]').submit();
			});
		});
	{/literal}
	</script>	

	<div class="box">
		<div class="box-heading">Валюта</div>
		<div class="box-content">
			<div class="box-category">
				<div id="curr_choose">
					<form name="currency" method="get">
					<select name="currency_id">
							{foreach from=$currencies item=c}
							<option value="{$c->id}" {if $c->id==$currency->id}selected{/if}>
							{$c->code|escape}
							</option>
							{/foreach}
					</select>
					</form>
				</div>
				<div id="curr_plate">
				{foreach from=$currencies item=c}
					{if $c@first}
					{$basecurr=$c->code}
					{else}
					<div class="rate_line">{$c->rate_from|round:1|escape} {$c->code|escape} = {$c->rate_to|round:1|escape} {$basecurr}</div>
					{/if}
				{/foreach}
				</div>
			
			</div>
		</div>
	</div>
<!--/noindex-->
<!-- incl. mcurrencies @ -->	
{/if}


