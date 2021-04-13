<!-- incl. stadn -->
<!--noindex-->
<div id="stadn" style="display:none; background-color:{$settings->stadcolor}">
	<div class="stad-left"><img alt="Заказ" src="design/{$settings->theme|escape}/images/stad.png" /></div>
	<div class="stad-right">
		<div class="stad-title">
			{if $settings->b11manage == 0}
				Новый заказ на сайте
			{elseif $settings->b11manage == 1}
				Новая покупка на сайте
			{/if}
		</div>
		<div class="stad-body"><span class="stad-name">Игорь</span> {if $settings->b14manage == 1}из <span class="stad-city">Москвы</span>{/if} только что 
			{if $settings->b11manage == 0}
				оформил<span class="w-end"></span> заказ на <span class="stad-sum">{3981|convert}</span> {$currency->sign}
			{elseif $settings->b11manage == 1}
				заказал<span class="w-end"></span> <span class="stad-prod"></span>
			{/if}
		</div>		
	</div>
</div>

<script>
setInterval(function(){
	stadto = {$settings->stadto|convert|replace:' ':''};
	stadfrom = {$settings->stadfrom|convert|replace:' ':''};
	randsum = Math.random()*stadto;
	sum = (Math.round(randsum/{$settings->stad_round})*{$settings->stad_round}+stadfrom);
	$(".stad-sum").text(sum);

	{if $settings->b13manage == 0}
		var namesArr = ['Александр','Алексей','Анатолий','Максим','Михаил','Андрей','Антон','Артем','Алексей','Борис','Андрей','Вадим','Василий','Андрей','Виктор','Сергей','Владимир','Вячеслав','Геннадий','Сергей','Георгий','Григорий','Денис','Дмитрий','Евгений','Игорь','Илья','Кирилл','Андрей','Константин','Максим','Михаил','Алексей','Николай','Олег','Павел','Роман','Сергей','Руслан','Семен','Сергей','Максим','Михаил','Юрий','Алексей'];
		var getRandomNames = Math.floor( (Math.random() * namesArr.length) + 0);
		var getName = namesArr[getRandomNames];
		$(".stad-name").text(getName);
		$(".w-end").text("");
	{elseif $settings->b13manage == 1}
		var namesArr = ['Александра','Алена','Анастасия','Анна','Вероника','Виктория','Галина','Дарья','Диана','Ольга','Евгения','Ольга','Екатерина','Елена','Инна','Ирина','Ольга','Карина','Кристина','Ксения','Любовь','Людмила','Марина','Мария','Надежда','Наталья','Нина','Оксана','Ольга','Полина','Светлана','Татьяна','Юлия'];
		var getRandomNames = Math.floor( (Math.random() * namesArr.length) + 0);
		var getName = namesArr[getRandomNames];
		$(".stad-name").text(getName);
		$(".w-end").text("а");
	{elseif $settings->b13manage == 2}
		if ( randsum & 1 ) {
			var namesArr = ['Александр','Алексей','Анатолий','Максим','Михаил','Андрей','Антон','Артем','Алексей','Борис','Андрей','Вадим','Василий','Андрей','Виктор','Сергей','Владимир','Вячеслав','Геннадий','Сергей','Георгий','Григорий','Денис','Дмитрий','Евгений','Игорь','Илья','Кирилл','Андрей','Константин','Максим','Михаил','Алексей','Николай','Олег','Павел','Роман','Сергей','Руслан','Семен','Сергей','Максим','Михаил','Юрий','Алексей'];
			var getRandomNames = Math.floor( (Math.random() * namesArr.length) + 0);
			var getName = namesArr[getRandomNames];
			$(".stad-name").text(getName);
			$(".w-end").text("");
		} else {
			var namesArr = ['Александра','Алена','Анастасия','Анна','Вероника','Виктория','Галина','Дарья','Диана','Ольга','Евгения','Ольга','Екатерина','Елена','Инна','Ирина','Ольга','Карина','Кристина','Ксения','Любовь','Людмила','Марина','Мария','Надежда','Наталья','Нина','Оксана','Ольга','Полина','Светлана','Татьяна','Юлия'];
			var getRandomNames = Math.floor( (Math.random() * namesArr.length) + 0);
			var getName = namesArr[getRandomNames];
			$(".stad-name").text(getName);
			$(".w-end").text("а");
		}
	{/if}

	{if $settings->b11manage == 1}
		{if $settings->b12manage == 0}
			{* available sort (or remove): position, name, date, rating, rand *}
			{get_products var=stad_products featured=1 limit=30}
		{elseif $settings->b12manage == 1}
			{get_products var=stad_products discounted=1 limit=30}
		{elseif $settings->b12manage == 2}
			{get_products var=stad_products is_new=1 limit=30}
		{/if}
		var prodArr = [{foreach $stad_products as $product}'<a href="products/{$product->url}">{$product->name|escape}</a>',{/foreach}];
		var getRandomProd = Math.floor( (Math.random() * prodArr.length) + 0);
		var getProd = prodArr[getRandomProd];
		$(".stad-prod").html(getProd);
	{/if}

	{if $settings->b14manage == 1}
		var cityArr = ['Москвы','СПб','Архангельска','Астрахани','Барнаула','Белгорода','Благовещенска','Брянска','Новгорода','Владивостока','Владимира','Волгограда','Вологды','Воронежа','Екатеринбурга','Иваново','Ижевска','Иркутска','Казани','Калининграда','Москвы','СПб','Калуги','Кемерово','Кирова','Костромы','Москвы','СПб','Краснодара','Красноярска','Кургана','Курска','Липецка','Мурманска','Новокузнецка','Новосибирска','Омска','Орла','Оренбурга','Пензы','Перми','Петрозаводска','Пскова','Ростова','Рязани','Самары','Москвы','СПб','Саратова','Смоленска','Ставрополя','Сыктывкара','Тамбова','Твери','Москвы','СПб','Тольятти','Томска','Тулы','Тюмени','Ульяновска','Хабаровска','Чебоксар','Челябинска','Череповца','Якутска','Ярославля','Москвы','СПб','Архангельска','Белгорода','Новокузнецка','Новосибирска','Владимира','Волгограда','Омска','Орла','Перми','Ростова','Саратова','Ижевска','Москвы','СПб','Иркутска','Калуги','Сыктывкара','Тольятти','Томска','Тулы','Тюмени','Москвы','СПб','Костромы','Краснодара','Ульяновска','Уфы','Курска','Челябинска'];
		var getRandomCity = Math.floor( (Math.random() * cityArr.length) + 0);
		var getCity = cityArr[getRandomCity];
		$(".stad-city").text(getCity);
	{/if}

	$("#stadn").fadeIn(2000);
	setTimeout(function(){
		$("#stadn").fadeOut(2000);
	}, 7000);
}, {$settings->stadtime}*1000)
</script>
<!--/noindex-->
<!-- incl. stadn @ -->
