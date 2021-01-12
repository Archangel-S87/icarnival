{include file='tinymce_init.tpl'}
{capture name=tabs}
	<li class="active"><a href="index.php?module=PromoAdmin">{$tr->seo|escape}</a></li>
	{if in_array('products', $manager->permissions)}
		<li><a href="index.php?module=MetadataPagesAdmin">{$tr->md_redirect|escape}</a></li>
		<li><a href="index.php?module=LinksAdmin">{$tr->metadata_filter|escape}</a></li>
	{/if}
	{if in_array('promo', $manager->permissions)}<li><a href="index.php?module=RobotsAdmin">robots.txt</a></li>{/if}
{/capture}
 
{$meta_title=$tr->seo|escape scope=root}

<div id="onecolumn" class="promopage">

	{if isset($message_success)}
		<!-- Системное сообщение -->
		<div class="message message_success">
			<span class="text">{if $message_success == 'saved'}{$tr->updated|escape}{/if}</span>
			{if isset($smarty.get.return)}
			<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
			{/if}
		</div>
		<!-- Системное сообщение (The End)-->
	{/if}
	
	<div class="border_box" style="padding:10px;">
		<form method=post id=product enctype="multipart/form-data">
			<input type=hidden name="session_id" value="{$smarty.session.id}">
					
			<div class="block promofields">
				<ul>
					<h2 style="margin-top:0px;">{$tr->counters|escape}:</h2>
					<div style="margin-top:10px;"><span><label class=property1><strong>{$tr->metrika_counter|escape}</strong> {literal}{$settings->counters}{/literal}</label></span>
						<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more|escape}</a>
						<div id="hideCont">
							<br />
							<p>{$tr->metrika_helper}</p>
							<input name="counters" class="fivecms_inp" type="text" value="{$settings->counters}" placeholder="{$tr->example|escape} 45716004"/>
							<span style="margin-left:15px;" class="helper">{$tr->targets_help}</span>
						</div>
					</div>
	
					<div style="margin-top:10px;"><span><label class=property1><strong>{$tr->analytics_counter|escape}</strong> {literal}{$settings->analytics}{/literal}</label></span>
						<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more|escape}</a>
						<div id="hideCont">
							<br />
							<p>{$tr->analytics_helper}</p>
							<input name="analytics" class="fivecms_inp" type="text" value="{$settings->analytics}" placeholder="{$tr->example|escape} UA-105877147-1"/>
							<span style="margin-left:15px;" class="helper">{$tr->targets_help}</span>
						</div>
					</div>
					
					<h2 style="margin-top:15px;">{$tr->include_scripts|escape}:</h2>
					<div style="margin-top:10px;"><span><label class=property1><strong>{$tr->script|escape} {$tr->in|lower|escape} head</strong> {literal}{$settings->script_header}{/literal}</label></span>
						<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more|escape}</a>
						<div id="hideCont">
							<br />
							<textarea name="script_header" style="width:600px;height:100px;">{$settings->script_header}</textarea>
						</div>
					</div>
					<div style="margin-top:10px;"><span><label class=property1><strong>{$tr->script|escape} {$tr->in|lower|escape} footer</strong> {literal}{$settings->script_footer}{/literal}</label></span>
						<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more|escape}</a>
						<div id="hideCont">
							<br />
							<textarea name="script_footer" style="width:600px;height:100px;">{$settings->script_footer}</textarea>
						</div>
					</div>
					
					<h2 style="margin-top:15px;">link rel="canonical":</h2>
					<ul style="margin-bottom:10px;">
						<li><label style="font-size:14px;margin-right:10px;width:450px;font-weight:400;" class="property">{$tr->filter_canonical|escape}</label>
							<select name="filtercan" class="fivecms_inp" style="width: 157px;">
								<option value='0' {if $settings->filtercan == '0'}selected{/if}>{$tr->noncanonical|escape}</option>
								<option value='1' {if $settings->filtercan == '1'}selected{/if}>{$tr->canonical|escape}</option>
							</select>
						</li>
					</ul>
					{$tr->page_meta_help}
					<p>[$meta_title] <input style="width:350px;text-align:center;" name="seo_description" class="fivecms_inp" type="text" value="{$settings->seo_description|escape}" placeholder="{$tr->example|escape}: {$tr->on|escape}"/>  ✩ {$settings->site_name|escape} ✩</p>
					<p style="margin-top:15px;">{$tr->prod_meta_help}</p>
				</ul>
			</div>
			<input style="margin: 0 0 20px 0; float:left;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
		</form>
		<!-- Основная форма (The End) -->
		
		{$tr->promo_adv}
	
	</div>

</div>