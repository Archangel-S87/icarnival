<!-- incl. backcall -->
<!--noindex-->
<div style="display:none;">
	<div id="btf_form">
		<div class="btf_form">
			<input id="btf_url" type="hidden" value="{$config->root_url}{$smarty.server.REQUEST_URI}">
			<div class="backcall-title">Заказать обратный звонок</div>
				<div style="margin: 4px 0;">* Контактное лицо:</div>
				<div><input id="btf_name" class="text" type="text" maxlength="255" value="{if isset($comment->name)}{$comment->name}{elseif isset($user->name)}{$user->name}{/if}"/></div>
				<div style="margin: 4px 0;">* Ваш телефон:</div>
				<div><input id="btf_phone" class="text" type="text" maxlength="255" value="{if isset($phone)}{$phone}{elseif isset($user->phone)}{$user->phone}{/if}" /></div>
				<div style="margin: 4px 0;">* Ваш Email:</div>
				<div><input id="btf_email" class="text" style="font-size:16px;" type="email" maxlength="255" value="{if isset($comment->email)}{$comment->email}{elseif isset($user->email)}{$user->email}{/if}"/></div>
				<div style="margin: 4px 0;">Тема для обсуждения:</div>
				<div><textarea id="btf_theme" class="text" style="width:100%;max-width:100%;" name="text" maxlength="512" rows="3"></textarea></div>
				{include file='conf.tpl'}
				<input class="buttonred hideablebutton" id="a1c" type="button" value="Отправить" />
				{include file='antibot.tpl'}
		</div>
		<div id="btf_result"></div>
	</div>	
</div>
<!--/noindex-->
<!-- incl. backcall @ -->		