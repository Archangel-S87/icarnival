<!-- incl. conf -->
<!--noindex-->
<div class="confcheck">
	<svg style="display:none;" class="uncheckedconf" onClick="$(this).parent().find('.checkedconf').show();$(this).hide();$(this).parent().siblings('.hideablebutton').fadeIn();">
		<use xlink:href='#uncheckedconf' />
	</svg>
	<svg class="checkedconf" onClick="$(this).parent().find('.uncheckedconf').show();$(this).hide();$(this).parent().siblings('.hideablebutton').fadeOut();">
		<use xlink:href='#checkedconf' />
	</svg>
	<div class="policywrapper">
		<div class="labeltxt">Настоящим подтверждаю, что я ознакомлен и согласен с <span onclick="window.open('/policy','_blank');" class="personaldata">условиями</span> политики конфиденциальности.
		{*<span class="showpolicy" onClick="$(this).parents().next('.confpolicy').show();$(this).next('.hidepolicy').show();$(this).hide();">Узнать больше</span>
		<span style="display:none;" class="hidepolicy" onClick="$('.confpolicy, .hidepolicy').hide();$('.showpolicy').show();">Скрыть</span>*}
	</div>
	</div>
	{*<div class="confpolicy" style="display:none;">
		Настоящим я даю разрешение, в целях совершения покупки и информирования меня по товарам и услугам сайта, обрабатывать - собирать, записывать, систематизировать, накапливать, хранить, уточнять (обновлять, изменять), извлекать, использовать, передавать (в том числе поручать обработку другим лицам), обезличивать, блокировать, удалять, уничтожать - мои персональные данные: фамилию, имя, отчество, почтовый адрес, номер телефона, адрес электронной почты.  Согласие может быть отозвано мною в любой момент путем направления письменного уведомления на email или посредством формы обратной связи.
	</div>*}
</div>
<!--/noindex-->
<!-- incl. conf @ -->