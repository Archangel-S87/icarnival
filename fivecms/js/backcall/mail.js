$(function(){
	$("#backform").click(function(){
		$("#btf_form").css('display', 'block');	
		$.fancybox({ 'href'	: '#btf_form', scrolling : 'no' });
	});
	$(".btf_submit").click(function(){
		$.ajax({
			type: "GET",
			url: "../ajax/sysbackcall.php",
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