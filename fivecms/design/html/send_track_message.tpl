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
			
<script>
{literal}
$(function(){
	$("#tbackform").click(function(){
		$("#tf_form").css('display', 'block');	
		$.fancybox({ 'href'	: '#tf_form', scrolling : 'no' });
	});
	$(".tf_submit").click(function(){
		$.ajax({
			type: "GET",
			url: "ajax/track.php",
			data: {tf_mail: $('.order_details input[name=email]').val(), 
					tf_name: $("#tf_name").val(), 
					tf_track: $("#tf_track").val(), 
					tf_delivery: $("#tf_delivery").val(), 
					tf_mail_from: $("#tf_mail_from").val(), 
					tf_sub: $("#tf_sub").val(), 
					tf_theme: $("#tf_theme").val()
					}, 
			success: function(result){
				if(result == 'tf_error'){
					$("#tf_result").html('<div class="tf_error">Ошибка: заполните все поля.</div>');
					setTimeout( function(){$(".tf_error").slideUp("slow");}, 2000);
				}else{
					$("#tf_result").html('<div class="tf_success">Сообщение успешно отправлено.</div>');
					$("#tf_form").find('.tf_form').css('display', 'none');
					setTimeout(function(){
						$.fancybox.close();
					;},5000);
				}
			}
		});
	});
});
{/literal}
</script>