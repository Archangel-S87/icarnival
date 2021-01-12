<!-- incl. msubscribe -->
<!--noindex-->
<div class="box-heading">Новостная рассылка</div>
<div class="box-content">
		<div id="msubscribe">
			<form id="subscribe" action="/user/login?subscribe" method="post" class="mailing">
				<input data-format=".+" class="mailing_name" type="text" name="mailing_name" size="255" placeholder="Имя" />
				<input data-format=".+" class="mailing_email" type="email" name="mailing_email" size="255" placeholder="Ваш E-mail" />
				<div class="confcheck msubscribe" style="display:none;">
						<svg style="display:none;" class="uncheckedconf" onClick="$('.msubscribe .checkedconf').show();$(this).hide();$(this).parent().siblings('.hideablebutton').fadeIn();">
							<use xlink:href='#uncheckedconf' />
						</svg>
						<svg class="checkedconf" onClick="$('.msubscribe .uncheckedconf').show();$(this).hide();$(this).parent().siblings('.hideablebutton').fadeOut();">
							<use xlink:href='#checkedconf' />
						</svg>
						<div class="policywrapper">
							<div class="labeltxt">Настоящим подтверждаю, что я ознакомлен и согласен с <span onclick="window.open('/policy','_blank');" class="personaldata">условиями</span> политики конфиденциальности.
							</div>
						</div>
				</div>
				<div class="hidedab" style="display:none">
					{include file='antibot.tpl'}
				</div>
				<input class="button hideablebutton" type="submit" value="Подписаться" />
			</form>
		</div>
</div>
<script>
$(document).ready(function() { 
 	$("#subscribe").submit(function(event){ 
	    if(!$("#subscribe .hideablebutton").is(":visible")) { 
	    	return false;
	    }
	});
	$("#subscribe .mailing_name, #subscribe .mailing_email").click(function() { 
		$("#subscribe .confcheck, #subscribe .hidedab").show();
	});
});
</script>
<!--/noindex-->
<!-- incl. msubscribe @ -->
