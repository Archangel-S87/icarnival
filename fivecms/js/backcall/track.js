$(function(){
	$("#tbackform").click(function(){
		$("#tf_form").css('display', 'block');	
		$.fancybox({ 'href'	: '#tf_form', scrolling : 'no' });
	});
	$(".tf_submit").click(function(){
		$.ajax({
			type: "GET",
			url: "../ajax/systrack.php",
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