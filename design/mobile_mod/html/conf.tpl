<!-- incl. conf -->
<!--noindex-->
<div class="confcheck">
	<svg style="display:none;" class="uncheckedconf" onClick="$(this).parent().find('.checkedconf').show();$(this).hide();$(this).parent().siblings('.hideablebutton').fadeIn();" fill="#000000" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
    <path d="M19 5v14H5V5h14m0-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/>
    <path d="M0 0h24v24H0z" fill="none"/>
	</svg>
	<svg class="checkedconf" onClick="$(this).parent().find('.uncheckedconf').show();$(this).hide();$(this).parent().siblings('.hideablebutton').fadeOut();" fill="#000000" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
	    <path d="M0 0h24v24H0z" fill="none"/>
	    <path d="M19 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.11 0 2-.9 2-2V5c0-1.1-.89-2-2-2zm-9 14l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
	</svg>
	<div class="policywrapper">
		<div class="labeltxt">Настоящим подтверждаю, что я ознакомлен и согласен с условиями <a href="policy">политики конфиденциальности</a>.
			<span class="showpolicy" onClick="$(this).parents().next('.confpolicy').show();$(this).next('.hidepolicy').show();$(this).hide();">Узнать больше</span>
			<span style="display:none;" class="hidepolicy" onClick="$('.confpolicy, .hidepolicy').hide();$('.showpolicy').show();">Скрыть</span>
		</div>
	</div>
	<div class="confpolicy" style="display:none;">
		Настоящим я даю разрешение, в целях совершения покупки и информирования меня по товарам и услугам сайта, обрабатывать - собирать, записывать, систематизировать, накапливать, хранить, уточнять (обновлять, изменять), извлекать, использовать, передавать (в том числе поручать обработку другим лицам), обезличивать, блокировать, удалять, уничтожать - мои персональные данные: фамилию, имя, отчество, почтовый адрес, номера домашнего и мобильного телефонов, адрес электронной почты.  Согласие может быть отозвано мною в любой момент путем направления письменного уведомления посредством формы обратной связи.
	</div>
</div>
<!--/noindex-->
<!-- incl. conf @ -->