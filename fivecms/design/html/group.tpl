{* Вкладки *}
{capture name=tabs}
	{if in_array('users', $manager->permissions)}<li><a href="index.php?module=UsersAdmin">{$tr->buyers|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=GroupsAdmin">{$tr->users_groups|escape}</a></li>		
	{if in_array('mailer', $manager->permissions)}<li><a href="index.php?module=MailerAdmin">{$tr->mailer|escape}</a></li>{/if}
{/capture}

{if isset($group->id)}
	{if isset($group->name)}
		{$meta_title = $group->name scope=root}
	{else}
		{$meta_title = "" scope=root}
	{/if}
{else}
	{$meta_title = $tr->new_post|escape scope=root}
{/if}

{* On document load *}
{literal}
<script src="design/js/jquery/jquery-ui.min.js"></script>

<script type="text/javascript" src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
<style>
.autocomplete-w1 { background:url(img/shadow.png) no-repeat bottom right; position:absolute; top:0px; left:0px; margin:6px 0 0 6px; /* IE6 fix: */ _background:none; _margin:1px 0 0 0; }
.autocomplete { border:1px solid #999; background:#FFF; cursor:default; text-align:left; overflow-x:auto; min-width: 300px; overflow-y: auto; margin:-6px 6px 6px -6px; /* IE6 specific: */ _height:350px;  _margin:0; _overflow-x:hidden; }
.autocomplete .selected { background:#F0F0F0; }
.autocomplete div { padding:2px 5px; white-space:nowrap; }
.autocomplete strong { font-weight:normal; color:#3399FF; }
</style>

{/literal}

<div id="onecolumn" class="grouppage">

	{if isset($message_success)}
	<!-- Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success|escape}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	{if isset($message_error)}
	<!-- Системное сообщение -->
	<div class="message message_error">
		<span class="text">{$message_error}</span>
		<a class="button" href="">{$tr->return|escape}</a>
	</div>
	<!-- Системное сообщение (The End)-->
	{/if}
	
	
	<!-- Основная форма -->
	<form method=post id=product enctype="multipart/form-data">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
		<div id="name">
			<input placeholder="{$tr->enter_s_name|escape}" class="name" name=name type="text" value="{if isset($group->name)}{$group->name|escape}{/if}" required /> 
			<input name=id type="hidden" value="{if isset($group->id)}{$group->id|escape}{/if}"/> 
		</div> 
	
		<!-- Левая колонка  -->
		<div id="column_left">
				
			<!-- Параметры страницы -->
			<div class="block">
				<ul>
					<li><label style="width: 70px;" class=property>{$tr->discount|escape}</label><input style="width: 50px;" name="discount" class="fivecms_inp" type="text" value="{if isset($group->discount)}{$group->discount|escape}{/if}" />%</li>
				</ul>
			</div>
			<!-- Параметры страницы (The End)-->
					
		</div>
		<!-- Левая колонка  (The End)--> 
		
		
		<input class="button_green button_save" type="submit" name="" value="{$tr->save|escape}" />
		
	</form>
	<!-- Основная форма (The End) -->

</div>
