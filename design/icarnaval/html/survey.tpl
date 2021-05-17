{$canonical="/survey/{$survey->url}" scope=root}

<link rel="stylesheet" type="text/css" href="/design/{$settings->theme|escape}/css/survey.css?v={filemtime("design/{$settings->theme|escape}/css/survey.css")}"/>

<h1 data-survey="{$survey->id}">{$survey->name|escape}</h1>
<div class="poll">
		<div class="page-pg">
			{if $survey->annotation || $survey->points > 0}
				<div class="article_text">
					{if $survey->points > 0 && $survey->is_actual}<div class="bonus">+ {$survey->points} {$survey->points|plural:'балл':'баллов':'балла'}</div>{/if}
					{$survey->annotation}
				</div>
			{/if}
			{if $survey->text}
				<div class="morearticle">Подробнее</div>
				<div class="article_text" style="display:none;">
					{$survey->text}
					<div class="hidearticle">Свернуть</div>
				</div>
			{/if}
		</div>
	
		{if !$survey->is_actual}
			{if $survey->vote_type != 4}
				{include file="pollresults.tpl"}
			{else}
				{if $user}<div class="page-pg already_voted">Вы уже принимали участие</div>{/if}
			{/if}
		{else}
			{if !$survey->fields}
				<p>Задание в процессе наполнения</p>
			{else}
				{if $survey->vote_type == 1}
					{include file="layout_radio_vote.tpl"}
				{elseif $survey->vote_type == 2}
					{include file="layout_checkbox_vote.tpl"}
				{elseif $survey->vote_type == 3}
					{include file="layout_starts_vote.tpl"}
				{elseif $survey->vote_type == 4}
					{include file="layout_code_vote.tpl"}
				{/if}
			{/if}

			<div style="display:none;">
				<div id="success_vote" class="poll_popup">
					<div class="vote_mtitle">Голосование завершено</div>
					<div class="vote_mbody">Благодарим за участие! {if $survey->points > 0}Вам начислено {$survey->points} баллов, общий счет составляет {$user->balance|round} баллов.{/if}</div>
					<div class="okbutton">OK</div>
				</div>
				<div id="error_vote" class="poll_popup">
					<div class="vote_mtitle">Увы что-то пошло не так :(</div>
					<div class="vote_mbody">Попробуйте через пару минут</div>
					<div class="okbutton">OK</div>
				</div>
				<div id="success_code" class="poll_popup">
					<div class="vote_mtitle">Ваш промокод активирован</div>
					<div class="vote_mbody">Благодарим за участие! Вам начислено {$survey->points} баллов, общий счет составляет {$user->balance|round} баллов.</div>
					<div class="okbutton">OK</div>
				</div>
				<div id="error_code" class="poll_popup">
					<div class="vote_mtitle">Ошибка!</div>
					<div class="vote_mbody">Проверьте правильность ввода промокода</div>
					<div class="okbutton">OK</div>
				</div>
			</div>
	
			{if isset($error)}
				<script>
					$(window).on('load', function() { 
						$(document).ready(function(){ 
							$.fancybox({ 
						            'href' : '#{$error}',
									'hideOnContentClick' : false,
									'hideOnOverlayClick' : false,
									'enableEscapeButton' : false,
									'showCloseButton' : false,
									'padding' : 0,
									'scrolling' : 'no'
					        });
							$('.okbutton').click(function() {
								{if $error == 'error_code'}window.location='/survey/{$survey->url}';{else}{if $survey->vote_type != 4}window.location='/survey/{$survey->url}';{else}window.location='/surveys';{/if}{/if}
							});	
						});
					})
				</script>
			{/if}
		{/if}
</div>

<div style="display:none;">
	<div id="none_userid" class="poll_popup" style="width:270px;">
		<div class="vote_mtitle">Вы не авторизованы</div>
		<div class="twobutton">
			<div class="leftbutton" onclick="window.location='/user/login?goto=auth'">Логин</div>
			<div class="rightbutton" onclick="window.location='/user/register?goto=signup'">Регистрация</div>
		</div>
	</div>
</div>
<script>
		$(window).on('load', function() {
			$(document).ready(function(){
					$('.morearticle, .hidearticle').click(function() {
							$('.article_text, .morearticle').slideToggle('normal');
					});
					{if empty($user->id)}
							{literal}
								$.fancybox({
					             	'href' : '#none_userid',
									'hideOnContentClick' : false,
									'hideOnOverlayClick' : false,
									'enableEscapeButton' : false,
									'showCloseButton' : false,
									'padding' : 0,
									'scrolling' : 'no'
				             	});
								return false;
							{/literal}
					{/if}
			});
		})
</script>

