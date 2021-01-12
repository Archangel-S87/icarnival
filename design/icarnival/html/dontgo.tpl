<!-- incl. dontgo -->
<!--noindex-->
	<div style="display: none;">
		<div id="dontgo">
			<div class="box1">	
				<img class="korobka" src="design/{$settings->theme|escape}/images/korobka.png" alt=" ">
				<img class="arrows" src="design/{$settings->theme|escape}/images/arrows.png" alt=" ">
			</div>			
			<div class="box2">
				<p class="call1">А как же подарки?</p>
				<p>Нам очень жаль, что Вы покидаете наш магазин!</p>
				<p class="call3">У нас для Вас остался подарок!</p>
				<p class="call3">Хотите его получить?!</p>
				<p class="call1">Жмите кнопку!</p>
				<div onclick="window.location='/present'" class="buttonred">Хочу Подарок!</div>
			</div>
		</div>
	</div>
	<script>
	$(document).ready(function() { 
		$('.menu').hover(function() { 
			$(document).mouseout(function(e) { 
				if(!readCookie("dontgo") && e.pageY - $(document).scrollTop() <= 5)
				{ 
					$.fancybox({ 'href'			: '#dontgo',	scrolling : 'no'});
					createCookie('dontgo', '1', '365'); 
				}
			});
		});
	});
	</script>
<!--/noindex-->	
<!-- incl. dontgo @ -->