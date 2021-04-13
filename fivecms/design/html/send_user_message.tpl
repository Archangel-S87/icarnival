<link href="design/css/mail.css" rel="stylesheet" type="text/css" media="screen"/>

<div class="element_A" id="element_A">
	<div id="btf_form">
		<div class="btf_form">
			<input id="btf_url" type="hidden" value="1">
			<input id="btf_mail" type="hidden" value="{$user->email|escape}" />
			<input id="btf_mail_from" type="hidden" value="{$settings->order_email|escape}" />
			<input id="btf_sub" type="hidden" value="{$settings->site_name|escape}" />
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
			
<script>
{literal}			
$(function(){
	$("#backform").click(function(){
		$("#btf_form").css('display', 'block');	
		$.fancybox({ 'href'	: '#btf_form', scrolling : 'no' });
	});
	$(".btf_submit").click(function(){
		$.ajax({
			type: "GET",
			url: "ajax/mail.php",
			data: {btf_mail: $('input[name=email]').val(), 
					btf_name: $("#btf_name").val(),
					btf_mail_from: $("#btf_mail_from").val(), 
					btf_sub: $("#btf_sub").val(), 
					btf_theme: $("#btf_theme").val()}, 
			success: function(result){
				if(result == 'btf_error'){
					$("#btf_result").html('<div class="btf_error">Ошибка: заполните все поля.</div>');
					setTimeout( function(){$(".btf_error").slideUp("slow");}, 2000);
				}else{
					$("#btf_result").html('<div class="btf_success">Сообщение успешно отправлено.</div>');
					$("#btf_form").find('.btf_form').css('display', 'none');
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
