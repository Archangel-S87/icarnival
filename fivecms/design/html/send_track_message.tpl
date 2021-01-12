<script src="js/backcall/track.js"></script>
<div class="element_A" id="element_A">
	<div id="tf_form">
		<div class="tf_form">
			<input id="tf_track" type="hidden" value="{$tr->your|escape} {$tr->track_code|lower|escape}: {$order->track|escape}">
			<input id="tf_delivery" type="hidden" value="{$tr->delivery|escape}: {$delivery->name|replace:'"':'``'}">
			<input id="tf_mail" type="hidden" value="{$order->email|escape}" />
			<input id="tf_mail_from" type="hidden" value="{$settings->order_email|escape}" />
			<input id="tf_sub" type="hidden" value="{$tr->order|escape} №{$order->id} {$tr->track_code|lower|escape}" />

			<h2>{$tr->send_track_code|escape}</h2>
			<div>
				<p style="padding: 0 0 10px;">{$tr->your|escape} {$tr->track_code|lower|escape}: {$order->track|escape}</p>
				<p style="padding: 0 0 10px;">{$tr->delivery|escape}: {$delivery->name}</p>
			</div>
			<div>
				<textarea id="tf_theme" class="text" name="text" rows="13" /></textarea>
			</div>
			<div>
			<input class="tf_submit button" id="a1c" type="button" value="{$tr->send|escape}" />
			</div>
		</div>
		<div id="tf_result"></div>
	</div>
</div>
			