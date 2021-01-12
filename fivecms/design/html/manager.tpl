{* Вкладки *}
{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main|escape}</a></li>{/if}
	{if in_array('currency', $manager->permissions)}<li><a href="index.php?module=CurrencyAdmin">{$tr->currencies|escape}</a></li>{/if}
	{if in_array('delivery', $manager->permissions)}<li><a href="index.php?module=DeliveriesAdmin">{$tr->delivery|escape}</a></li>{/if}
	{if in_array('payment', $manager->permissions)}<li><a href="index.php?module=PaymentMethodsAdmin">{$tr->payment|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=ManagersAdmin">{$tr->managers|escape}</a></li>
	{if in_array('discountgroup', $manager->permissions)}<li><a href="index.php?module=DiscountGroupAdmin">{$tr->discounts|escape}</a></li>{/if}
{/capture}

{if !empty($m->login)}
	{$meta_title = $m->login scope=root}
{else}
	{$meta_title = $tr->new_post scope=root}
{/if}

<script>
{literal}
$(function() {
	// Выделить все
	$("#check_all").click(function() {
		$('input[type="checkbox"][name*="permissions"]:not(:disabled)').attr('checked', $('input[type="checkbox"][name*="permissions"]:not(:disabled):not(:checked)').length>0);
	});

	{/literal}{if !empty($m->login)}$('#password_input').hide();{/if}{literal}
	$('#change_password').click(function() {
		$('#password_input').show();
	});
		
});
{/literal}
</script>

<div id="onecolumn" class="managerpage">

	{if isset($message_success)}
	<div class="message message_success">
		<span class="text">{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success|escape}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	{/if}
	
	{if isset($message_error)}
	<div class="message message_error">
		<span class="text">
		{if $message_error=='login_exists'}{$tr->manager_login_exists|escape}
		{elseif $message_error=='empty_login'}{$tr->enter_login|escape}
		{elseif $message_error=='not_writable'}{$tr->set_permissions|escape} /fivecms/.passwd
		{else}{$message_error|escape}{/if}
		</span>
		<a class="button" href="">{$tr->return|escape}</a>
	</div>
	{/if}
	
	<form method=post id=product enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<label style="display:inline-block;width:70px;">{$tr->login|escape}:</label>
			<input style="width:300px;margin-bottom:10px;" class="name" name="login" type="text" value="{if !empty($m->login)}{$m->login|escape}{/if}" maxlength="32"/> 
			<input name="old_login" type="hidden" value="{if !empty($m->login)}{$m->login|escape}{/if}"/>
			<br />
			<label style="display:inline-block;width:70px;" >{$tr->password|escape}:</label>
			{if !empty($m->login)}<a class="dash_link" id="change_password" style="text-transform:lowercase;">{$tr->change|escape}</a><br />{/if}
			<input style="margin-top:10px;width:300px;" id="password_input" class="name" name="password" type="password" value=""/> 
		</div> 
	
		<div id="column_left">
			
			<h2>{$tr->access_rights|escape}: </h2>
			<div class="block"><label id="check_all" class="dash_link">{$tr->choose_all}</label></div>
	
			<div class="block">
				<ul>
				
					{$perms = [
						'products'   =>$tr->products,
						'categories' =>$tr->categories,
						'brands'     =>$tr->brands,
						'features'   =>$tr->features,
						'orders'     =>$tr->orders,
						'labels'     =>$tr->orders_labels,
						'users'      =>$tr->buyers,
						'groups'     =>$tr->users_groups,
						'coupons'    =>$tr->coupons,
						'pages'      =>$tr->pages_services,
						'menus'		 =>$tr->pages_menu,
						'blog'       =>$tr->blog,
						'articles_categories'       =>$tr->articles_categories,
						'articles'       =>$tr->articles,
						'comments'   =>$tr->comments,
						'feedbacks'  =>$tr->feedback,
						'import'     =>$tr->import,
						'export'     =>$tr->export,
						'backup'     =>$tr->backup,
						'stats'      =>$tr->stats,
						'design'     =>$tr->design,
						'settings'   =>$tr->settings,
						'currency'   =>$tr->currencies,
						'delivery'   =>$tr->delivery,
						'payment'    =>$tr->payment,
						'managers'   =>$tr->managers,
						'slides'     =>$tr->slider,
						'discountgroup'   =>$tr->discounts,
						'multichanges'   =>$tr->packet,
						'surveys_categories'  =>$tr->surveys_categories,
						'surveys'    =>$tr->surveys,
						'trigger'    =>$tr->trigger,
						'promo'      =>$tr->seo,
						'maillist'	 =>$tr->subscribers_list,
        				'mailer'	 =>$tr->local_mailer,
				        'mailuser'	 =>$tr->edit_subscribers,
				        'license'	 =>$tr->license
					]}
					
					{foreach $perms as $p=>$name}
					<li><label class=property for="{$p}">{$name}</label>
					<input id="{$p}" name="permissions[]" class="fivecms_inp" type="checkbox" value="{$p}"
					{if !empty($m->permissions) && in_array($p, $m->permissions)}checked{/if} {if !empty($m->login) && $m->login == $manager->login}disabled{/if}/></li>
					{/foreach}
					
				</ul>
				
			</div>
			<!-- Параметры (The End)-->
			
		</div>
		<!-- Левая колонка (The End)--> 
		
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Основная форма (The End) -->
</div>

