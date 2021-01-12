<link href="js/backcall/mail.css" rel="stylesheet" type="text/css" media="screen"/>
<script src="js/backcall/mail.js"></script>
<div class="element_A" id="element_A">
		<div id="btf_form">
				<div class="btf_form">
					
					<input id="btf_url" type="hidden" value="1">
					<input id="btf_mail" type="hidden" value="{$order->email|escape}" />
					<input id="btf_mail_from" type="hidden" value="{$settings->order_email|escape}" />
					<input id="btf_sub" type="hidden" value="Заказ №{$order->id}" />

					<h2>{$tr->send_message|escape}</h2>
					
					<div>
						<textarea id="btf_theme" class="text" name="text" rows="13" /></textarea>
					</div>
					<div>
						<input class="btf_submit button" id="a1c" type="button" value="{$tr->send|escape}" />
					</div>
						
				</div>
				<div id="btf_result"></div>
		</div>
</div>
			