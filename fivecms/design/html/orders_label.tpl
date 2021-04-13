{* Вкладки *}
{capture name=tabs}
	{if in_array('orders', $manager->permissions)}
		<li {if isset($status) && $status===0}class="active"{/if}><a href="{url module=OrdersAdmin status=0 keyword=null id=null page=null label=null}">{$tr->new_pl|escape}</a></li>
		<li {if isset($status) && $status==4}class="active"{/if}><a href="{url module=OrdersAdmin status=4 keyword=null id=null page=null label=null}">{$tr->status_in_processing|escape}</a></li>
		<li {if isset($status) && $status==1}class="active"{/if}><a href="{url module=OrdersAdmin status=1 keyword=null id=null page=null label=null}">{$tr->status_accepted_pl|escape}</a></li>
		<li {if isset($status) && $status==2}class="active"{/if}><a href="{url module=OrdersAdmin status=2 keyword=null id=null page=null label=null}">{$tr->status_completed_pl|escape}</a></li>
		<li {if isset($status) && $status==3}class="active"{/if}><a href="{url module=OrdersAdmin status=3 keyword=null id=null page=null label=null}">{$tr->status_canceled_pl|escape}</a></li>
		{if isset($keyword)}
		<li class="active"><a href="{url module=OrdersAdmin keyword=$keyword id=null label=null}">{$tr->search|escape}</a></li>
		{/if}
	{/if}
	<li class="active"><a href="{url module=OrdersLabelsAdmin keyword=null id=null page=null label=null}">{$tr->labels|escape}</a></li>
{/capture}

{if isset($label->id) && isset($label->name)}
	{$meta_title = $label->name scope=root}
{else}
	{$meta_title = $tr->new_post|escape scope=root}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

{* On document load *}
{literal}
<link rel="stylesheet" media="screen" type="text/css" href="design/js/colorpicker/css/colorpicker.css" />
<script type="text/javascript" src="design/js/colorpicker/js/colorpicker.js"></script>

<script>
$(function() {
	$('#color_icon, #color_link').ColorPicker({
		color: $('#color_input').val(),
		onShow: function (colpkr) {
			$(colpkr).fadeIn(500);
			return false;
		},
		onHide: function (colpkr) {
			$(colpkr).fadeOut(500);
			return false;
		},
		onChange: function (hsb, hex, rgb) {
			$('#color_icon').css('backgroundColor', '#' + hex);
			$('#color_input').val(hex);
			$('#color_input').ColorPickerHide();
		}
	});
});
</script>


{/literal}

<div id="onecolumn" class="orderlabelpage">
	
	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success == 'added'}{$tr->added|escape}{elseif $message_success == 'updated'}{$tr->updated|escape}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
		<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input placeholder="{$tr->enter_s_name|escape}..." required class="name" name="name" type="text" value="{if isset($label->name)}{$label->name|escape}{/if}"/> 
			<input name=id type="hidden" value="{if isset($label->id)}{$label->id|escape}{/if}"/> 
			<div class="checkbox">
				<span id="color_icon" style="background-color:#{$label->color};" class="order_label_big"></span>
				<input id="color_input" name="color" class="fivecms_inp" type="hidden" value="{$label->color|escape}" />
			</div>
		</div> 
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Основная форма (The End) -->

</div>