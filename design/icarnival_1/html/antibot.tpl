<div class="check_block">		
	<input class="check_inp" type="checkbox" name="btfalse" {if isset($btfalse)}checked{/if} />
	<input class="check_inp" type="checkbox" name="bttrue" />
	<div class="check_bt" onClick="$(this).parent().find('input[name=bttrue]').prop('checked', true);$(this).addClass('checked');">
		<svg class="uncheckedconf">
			<use xlink:href='#uncheckedconf' />
		</svg>
		<svg class="checkedconf" style="display:none;">
			<use xlink:href='#antibotchecked' />
		</svg>
		<div class="not_bt">Я нe рoбoт</div>
	</div>
</div>
