{include file='tinymce_init.tpl'}
{capture name=tabs}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SettingsAdmin">{$tr->settings_main|escape}</a></li>{/if}
	{if in_array('settings', $manager->permissions)}<li><a href="index.php?module=SetCatAdmin">{$tr->settings_cat|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=SetModAdmin">{$tr->settings_modules|escape}</a></li>
{/capture}
 
{$meta_title = $tr->settings_modules|escape scope=root}

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
				
				<!-- Блоки -->
				<div id="mainpage" class="block layer">
					<h2>{$tr->main_page|escape} ({$tr->desktop_design|escape})</h2>

					<a class="bigbutton" style="margin-bottom:20px;" href="index.php?module=SlidesAdmin">{$tr->slider|escape}</a>
					
					<a class="bigbutton" style="margin-bottom:20px;" href="index.php?module=ThreeBannersAdmin">{$tr->banners|escape} {$tr->close_slider|escape}</a>
					
					<ul>
						<li><label class="property"">{$tr->main_cat_num}</label>
							<input style="max-width:38px;font-size:14px;" name="main_cat_num" class="fivecms_inp" type="number" value="{$settings->main_cat_num}" min="0" step="1"/>
							&nbsp;{$tr->if_null_hide}
						</li>
						<li><label style="width:300px;" class="property">{$tr->main_cat_columns}</label>
							<select name="main_cat_columns" class="fivecms_inp" style="width: 100px;">
								<option value='5' {if $settings->main_cat_columns == '5'}selected{/if}>5</option>
								<option value='4' {if $settings->main_cat_columns == '4'}selected{/if}>4</option>
								<option value='3' {if $settings->main_cat_columns == '3'}selected{/if}>3</option>
							</select>
						</li>
					</ul>	
					
					<ul>
						<li><label style="width:300px;" class="property">{$tr->carousel|escape} "{$tr->hits|escape}"</label>
							<select name="mainhits" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->mainhits == '0'}selected{/if}>{$tr->hide|lower}</option>
								<option value='1' {if $settings->mainhits == '1'}selected{/if}>{$tr->show|lower}</option>
							</select>
							<select name="position_carousel[mainhits]" class="fivecms_inp" style="width: 100px;">
								<option value='1' {if $settings->position_carousel['mainhits'] == 1}selected{/if}>1</option>
								<option value='2' {if $settings->position_carousel['mainhits'] == 2}selected{/if}>2</option>
								<option value='3' {if $settings->position_carousel['mainhits'] == 3}selected{/if}>3</option>
							</select>
						</li>
						<li><label style="width:300px;" class="property">{$tr->carousel|escape} "{$tr->novelties|escape}"</label>
							<select name="mainnew" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->mainnew == '0'}selected{/if}>{$tr->hide|lower}</option>
								<option value='1' {if $settings->mainnew == '1'}selected{/if}>{$tr->show|lower}</option>
							</select>
							<select name="position_carousel[mainnew]" class="fivecms_inp" style="width: 100px;">
								<option value='1' {if $settings->position_carousel['mainnew'] == 1}selected{/if}>1</option>
								<option value='2' {if $settings->position_carousel['mainnew'] == 2}selected{/if}>2</option>
								<option value='3' {if $settings->position_carousel['mainnew'] == 3}selected{/if}>3</option>
							</select>
						</li>
						<li><label style="width:300px;" class="property">{$tr->carousel|escape} "{$tr->with_old_price|escape}"</label>
							<select name="mainsale" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->mainsale == '0'}selected{/if}>{$tr->hide|lower}</option>
								<option value='1' {if $settings->mainsale == '1'}selected{/if}>{$tr->show|lower}</option>
							</select>
							<select name="position_carousel[mainsale]" class="fivecms_inp" style="width: 100px;">
								<option value='1' {if $settings->position_carousel['mainsale'] == 1}selected{/if}>1</option>
								<option value='2' {if $settings->position_carousel['mainsale'] == 2}selected{/if}>2</option>
								<option value='3' {if $settings->position_carousel['mainsale'] == 3}selected{/if}>3</option>
							</select>
						</li>						
					</ul>
					
					<div><span><label class="property" style="width:300px;"><span style="text-transform:uppercase;font-weight:700;">{$tr->wide_banner|escape}</span></label></span>
					<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more}</a>
					<div id="hideCont" style="border-bottom: 2px dashed #cfcfcf;">
						
						<div id="widebanner" class="block layer" style="border-top:0;display:table;margin-bottom:10px;">
							<label class="switch switch-default " style="padding:0;">
								<input class="switch-input fn_ajax_action" name="widebannervis" value="1" type="checkbox" {if $settings->widebannervis}checked=""{/if}>
								<span class="switch-label"></span>
								<span class="switch-handle"></span>
							</label>
							<ul style="display: block; width: 600px; float: left; margin: 0 0 0 10px;">
								<li>{$tr->slide_width|escape} 1480px</li>
								<li><label class="property" style="max-width:70px;margin-bottom:5px;">{$tr->link|escape}:</label>
									<input placeholder="{$tr->example} /test" name="widebanner" class="fivecms_inp" type="text" value="{$settings->widebanner|escape}" style="width:94% !important;"  />
								</li>
								<li style="width: 600px;">
									<label class="property">{$tr->upload} {$tr->file|lower}</label>
									<input name="bannerwide_file" class="fivecms_inp" type="file" />
									{$img_not_root_url=$config->threebanners_images_dir|cat:$settings->widebanner_file|escape}
									{$img_url=$config->root_url|cat:'/'|cat:$img_not_root_url}
									{if file_exists($img_not_root_url)}
										{assign var="info" value=$img_url|getimagesize}
										{if !empty($info.0) && $info.0 > 0}	
											<img src="{$img_url}" style="max-width:100%;margin-top:10px;"/>
											<div class="tip">
												{$tr->image_size}: {$info.0}px x {$info.1}px
											</div>
										{/if}
									{/if}	
								</li>
							</ul>
						</div>
						
					</div>
					</div>
					
					<ul style="margin-top:10px;">
						<li><label style="width:300px;" class="property">{$tr->show_blog_main}</label>
							<select name="main_blog" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->main_blog == '0'}selected{/if}>{$tr->yes}</option>
								<option value='1' {if $settings->main_blog == '1'}selected{/if}>{$tr->no}</option>
							</select>
						</li>
					</ul>
					
					<a class="bigbutton" style="margin-bottom:20px;" href="index.php?module=ThreeBannersAdmin#bottom_banners">{$tr->banners} {$tr->under_blog}</a>

					<ul>
						<li><label style="width:300px;" class="property">{$tr->show_articles_main}</label>
							<select name="main_articles" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->main_articles == '0'}selected{/if}>{$tr->yes}</option>
								<option value='1' {if $settings->main_articles == '1'}selected{/if}>{$tr->no}</option>
							</select>
							<input style="margin: 0; float:right;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
						</li>
					</ul>

				</div>
				<!-- Блоки (The End)-->

				<!-- Блоки -->
				<div id="managemodules" class="block layer">
					<h2>{$tr->settings_modules}</h2>
					
					<div id="actionblock" style="display:inline-block;background-color:#f6f6f6;margin:0 0 15px 0; border: 2px dashed #dadada;border-radius:10px;padding:12px 15px;font-size:13px;">
						<h2>{$tr->promo_timer} <a style="border:0;" class="bluelink" href="http://5cms.ru/blog/action" target="_blank">(?)</a></h2>
						<div>
							<label class="property" style="width:30px;">{$tr->to}</label>
							<input id="action_end_date_id" name="action_end_date" type="text" value="{$settings->action_end_date}">&nbsp;
							<select style="min-width:35px;" name="action_end_date_hours" id="action_end_date_hours_id" value="{$settings->action_end_date_hours}">
							</select> {$tr->hours}
							<select style="min-width:35px;" name="action_end_date_minutes" id="action_end_date_minutes_id" value="{$settings->action_end_date_minutes}">
							</select> {$tr->minutes}
							<script src="design/js/jquery/datepicker/jquery.ui.datepicker-ru.js"></script>
							<script>
								function getElementByIdFromCashe(id) {
									if (!document.elementsByIdCashe) {
										document.elementsByIdCashe = {};
									}
									if (!document.elementsByIdCashe[id]) {
										var element = document.getElementById(id);
										if (element) {
											document.elementsByIdCashe[id] = element;
										}
									}
									return document.elementsByIdCashe[id];
								}
						
								$(function() {
									$('input[name="action_end_date"]').datepicker({
										regional:'ru'
									});
							
									var hoursSelect = getElementByIdFromCashe('action_end_date_hours_id');
									var selectValue = hoursSelect.getAttribute('value');
									var option;
									for (var i = 0; i < 24; i++) {
										option = document.createElement("OPTION");
										option.value = option.text = (i < 10) ? ('0' + i) : ('' + i);
										hoursSelect.options.add(option);
										if (option.value == selectValue) {
											option.selected = true;
										}
									}
									var minutesSelect = getElementByIdFromCashe('action_end_date_minutes_id');
									selectValue = minutesSelect.getAttribute('value');
									for (var i = 1; i < 60; i++) {
										option = document.createElement("OPTION");
										option.value = option.text = (i < 10) ? ('0' + i) : ('' + i);
										minutesSelect.options.add(option);
										if (option.value == selectValue) {
											option.selected = true;
										}
									}
								});
							</script>
						</div>
						<div style="margin-top:5px;">
							{$tr->show|lower} <input name="action_end_date_checked" type="radio" value="on" {($settings->action_end_date_checked == 'on') ? 'checked' : ''}>
							{$tr->hide|lower} <input name="action_end_date_checked" type="radio" value="off" {($settings->action_end_date_checked == 'off') ? 'checked' : ''}>
						</div>
				
						<div style="margin-top: 5px;"><span><label class="property" style="width:70px;">{$tr->description}</label></span>
						<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more|escape}</a><div id="hideCont" style="margin: 20px 0;">
							<textarea name="action_description" id="action_description" class="editor_small" style="height: 350px;">{$settings->action_description}</textarea>
						</div>
						</div>
					</div>
					
					<ul>
						<li><label class="property">{$tr->filter} {$tr->in_left_column}</label>
							<select name="b2manage" class="fivecms_inp" style="width: 100px;">
								<option value='0' {if $settings->b2manage == '0'}selected{/if}>{$tr->hide|lower}</option>
								<option value='1' {if $settings->b2manage == '1'}selected{/if}>{$tr->show|lower}</option>
							</select>
						</li>
						<li><label class="property">{$tr->filter} {$tr->in_prods_cat}</label>
							<select name="b3manage" class="fivecms_inp">
								<option value='0' {if $settings->b3manage == '0'}selected{/if}>{$tr->hide|lower}</option>
								<option value='1' {if $settings->b3manage == '1'}selected{/if}>{$tr->show|lower}</option>
							</select>
						</li>
						<li><label class="property">{$tr->blog_posts} {$tr->in_left_column}</label>
							<select name="hide_blog" class="fivecms_inp">
								<option value='0' {if $settings->hide_blog == '0'}selected{/if}>{$tr->show|lower}</option>
								<option value='1' {if $settings->hide_blog == '1'}selected{/if}>{$tr->hide|lower}</option>
							</select>
						</li>
						<li><label class="property">{$tr->novelties} {$tr->in_left_column}</label>
							<select name="b1manage" class="fivecms_inp">
								<option value='0' {if $settings->b1manage == '0'}selected{/if}>{$tr->hide|lower}</option>
								<option value='1' {if $settings->b1manage == '1'}selected{/if}>{$tr->show|lower}</option>
							</select>
						</li>
						<li><label class="property">{$tr->last_pl} {$tr->comments|lower} {$tr->in_left_column}</label>
							<select name="b4manage" class="fivecms_inp">
								<option value='0' {if $settings->b4manage == '0'}selected{/if}>{$tr->hide|lower}</option>
								<option value='1' {if $settings->b4manage == '1'}selected{/if}>{$tr->show|lower}</option>
							</select>
						</li>
						<li><label class="property">{$tr->currencies} {$tr->in_left_column}</label>
							<select name="b5manage" class="fivecms_inp">
								<option value='0' {if $settings->b5manage == '0'}selected{/if}>{$tr->hide|lower}</option>
								<option value='1' {if $settings->b5manage == '1'}selected{/if}>{$tr->show|lower}</option>
							</select>
						</li>
						<li><label class="property">{$tr->widget} "{$tr->dont_go}?" <a class="bluelink" href="http://5cms.ru/blog/dontgo" target="_blank">(?)</a></label>
							<select name="b6manage" class="fivecms_inp" style="margin-right:10px;">
								<option value='0' {if $settings->b6manage == '0'}selected{/if}>{$tr->hide|lower}</option>
								<option value='1' {if $settings->b6manage == '1'}selected{/if}>{$tr->show|lower}</option>
							</select>
							<span>{$tr->dont_go_helper} <a href="index.php?module=PageAdmin&menu_id=18&id=43">"/present"</a></span>
						</li>
						<li><label class="property">{$tr->floating_header}</label>
							<select name="b7manage" class="fivecms_inp">
								<option value='0' {if $settings->b7manage == '0'}selected{/if}>{$tr->yes}</option>
								<option value='1' {if $settings->b7manage == '1'}selected{/if}>{$tr->no}</option>
							</select>
						</li>
						<li><label class="property">{$tr->show_nav_cat}</label>
							<select name="show_nav_cat" class="fivecms_inp">
								<option value='0' {if $settings->show_nav_cat == '0'}selected{/if}>{$tr->hide|lower}</option>
								<option value='1' {if $settings->show_nav_cat == '1'}selected{/if}>{$tr->show|lower}</option>
							</select>
						</li>
						<li><label class="property">{$tr->popup_cart}</label>
							<select name="popup_cart" class="fivecms_inp">
								<option value='1' {if $settings->popup_cart == '1'}selected{/if}>{$tr->yes}</option>
								<option value='0' {if $settings->popup_cart == '0'}selected{/if}>{$tr->no}</option>
							</select>
						</li>
						<li><label class="property">{$tr->new_orders_notify} <a class="bluelink" href="http://5cms.ru/blog/new-orders-notify" target="_blank">(?)</a></label>
							<select name="b8manage" class="fivecms_inp">
								<option value='0' {if $settings->b8manage == '0'}selected{/if}>{$tr->hide|lower}</option>
								<option value='1' {if $settings->b8manage == '1'}selected{/if}>{$tr->show|lower}</option>
							</select>
						</li>
						<li><label class="property">{$tr->allow_attachment}</label>
							<select name="attachment" class="fivecms_inp">
								<option value='0' {if $settings->attachment == '0'}selected{/if}>{$tr->no}</option>
								<option value='1' {if $settings->attachment == '1'}selected{/if}>{$tr->yes}</option>
							</select>
						</li>
						<li><label class="property"">{$tr->max_attach_file_size}:</label>
							<input style="max-width:50px;font-size:14px;" name="maxattachment" class="fivecms_inp" type="number" value="{$settings->maxattachment|escape}" min="0" step="1"/> Mb ({$tr->in_server_sett} {if $config->max_upload_filesize>1024*1024}{$config->max_upload_filesize/1024/1024|round:'2'} Mb{else}{$config->max_upload_filesize/1024|round:'2'} Kb{/if})
						</li>
						<li><label class="property">{$tr->soc_auth}</label>
							<select name="ulogin" class="fivecms_inp">
								<option value='0' {if $settings->ulogin == '0'}selected{/if}>{$tr->hide|lower}</option>
								<option value='1' {if $settings->ulogin == '1'}selected{/if}>{$tr->show|lower}</option>
							</select>
						</li>
						<li><label class="property">{$tr->cart_tabs}</label>
							<select name="cart_tabs" class="fivecms_inp">
								<option value='0' {if $settings->cart_tabs == '0'}selected{/if}>{$tr->yes}</option>
								<option value='1' {if $settings->cart_tabs == '1'}selected{/if}>{$tr->no}</option>
							</select>
						</li>
						<li><label class="property">{$tr->allow_comment_tags}</label>
							<select name="allow_comment_tags" class="fivecms_inp">
								<option value='0' {if $settings->allow_comment_tags == '0'}selected{/if}>{$tr->no}</option>
								<option value='1' {if $settings->allow_comment_tags == '1'}selected{/if}>{$tr->yes}</option>
							</select>
						</li>
						<li><label class="property"">{$tr->comment_tags}:</label>
							<input placeholder="{$tr->example}: [b][/b],[i][/i],[u][/u],[s][/s],[img]url[/img],[color=#dadada]text[/color]" style="max-width:450px;font-size:14px;" name="comment_tags" class="fivecms_inp" type="text" value="{$settings->comment_tags|escape}" />
						</li>
						<li><label class="property">{$tr->allow_views}</label>
							<select name="allow_views" class="fivecms_inp">
								<option value='0' {if $settings->allow_views == '0'}selected{/if}>{$tr->no}</option>
								<option value='1' {if $settings->allow_views == '1'}selected{/if}>{$tr->yes}</option>
							</select>
						</li>
					</ul>
					<a style="float:left;" class="bigbutton" href="index.php?module=StadAdmin">{$tr->widget} "{$tr->stad}"</a>
					<input style="margin: 5px 0 20px 0; float:right;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
				</div>
				<!-- Блоки (The End)-->
				
				<!-- AntiSpam -->
				<div id="addfields" class="block layer" style="overflow: visible !important;">
					<h2>{$tr->spam_protect}</h2>
					<ul>
						<li><label style="width:380px;" class="property">{$tr->block_session}</label>
							<select name="spam_ip" class="fivecms_inp">
								<option value='0' {if $settings->spam_ip == '0'}selected{/if}>{$tr->no}</option>
								<option value='1' {if $settings->spam_ip == '1'}selected{/if}>{$tr->yes}</option>
							</select>
						</li>
						<li><label style="width:380px;" class="property">{$tr->block_noncyr}</label>
							<select name="spam_cyr" class="fivecms_inp">
								<option value='0' {if $settings->spam_cyr == '0'}selected{/if}>{$tr->no}</option>
								<option value='1' {if $settings->spam_cyr == '1'}selected{/if}>{$tr->yes}</option>
							</select>
						</li>
						<li><label style="width:380px;" class="property">{$tr->block_long_name}</label>
							<input style="max-width:50px;font-size:14px;" name="spam_symbols" class="fivecms_inp" type="number" value="{$settings->spam_symbols}" step="1" /> {$tr->symbols}
						</li>
					</ul>
				</div>
				<!-- AntiSpam @ -->
				
				<!-- Addfields start -->
				<div id="addfields" class="block layer" style="overflow: visible !important;">
					<h2>{$tr->ad_unit} {$tr->in_left_column}</h2>
					<div>
						<ul>
							<li><label class="property" style="width:100px;">{$tr->name}:</label><input name="addf3name" class="fivecms_inp" type="text" value="{$settings->addf3name|escape}" /></li>
						</ul>
						<textarea style="width:100%;height:200px;margin: 15px 0;" name="addfield3" id="action_description1" class="editor_small">{$settings->addfield3}</textarea>
						<p style="margin-top:10px;">* {$tr->if_empty_hide}</p>	
					</div>	
				</div>
				<!-- Addfields (The End)-->
				
				<!-- рекламные блоки внизу start -->
				<div id="advertfields" class="block layer" style="overflow: visible !important;">
					<h2>{$tr->motivate_ads}</h2>
							
					<div><label class="property" style="width:230px;"><strong>{$tr->ad_unit} ({$tr->blog_posts|lower})</strong></label>
						<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more}</a>
						<div style="margin: 10px 0 20px;" id="hideCont">
							<ul class="stars"><li><a class="helperlink bluelink" href="#help_adv">{$tr->standart}</a></li></ul>
							<textarea style='width:100%;height:150px;margin: 15px 0;' name="advertblog" id="advertblog" class="editor_small">{$settings->advertblog}</textarea>
							<p style="margin-top:10px;">* {$tr->if_empty_hide}</p>	
						</div>      		
					</div>	
					
					<div><label class="property" style="width:230px;"><strong>{$tr->ad_unit} ({$tr->articles|lower})</strong></label>
						<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more}</a>
						<div style="margin: 10px 0 20px;" id="hideCont">
							<ul class="stars"><li><a class="helperlink bluelink" href="#help_adv">{$tr->standart}</a></li></ul>
							<textarea style='width:100%;height:150px;margin: 15px 0;' name="advertarticle" id="advertarticle" class="editor_small">{$settings->advertarticle}</textarea>
							<p style="margin-top:10px;">* {$tr->if_empty_hide}</p>	
						</div>      		
					</div>	
					
					<div><label class="property" style="width:230px;"><strong>{$tr->ad_unit} ({$tr->services|lower})</strong></label>
						<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more}</a>
						<div style="margin: 10px 0 20px;" id="hideCont">
							<ul class="stars"><li><a class="helperlink bluelink" href="#help_adv">{$tr->standart}</a></li></ul>
							<textarea style='width:100%;height:150px;margin: 15px 0;' name="advertservice" id="advertservice" class="editor_small">{$settings->advertservice}</textarea>
							<p style="margin-top:10px;">* {$tr->if_empty_hide}</p>	
						</div>      		
					</div>	
					
					<div><label class="property" style="width:230px;"><strong>{$tr->ad_unit} ({$tr->page_text|lower})</strong></label>
						<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more}</a>
						<div style="margin: 10px 0 20px;" id="hideCont">
							<ul class="stars"><li><a class="helperlink bluelink" href="#help_adv">{$tr->standart}</a></li></ul>
							<textarea style='width:100%;height:150px;margin: 15px 0;' name="advertpage" id="advertpage" class="editor_small">{$settings->advertpage}</textarea>
							<p style="margin-top:10px;">* {$tr->if_empty_hide}</p>	
						</div>      		
					</div>	
					
				</div>
				<!-- рекламные блоки внизу (The End)-->

				<a class="bigbutton" href="index.php?module=SocialAdmin" style="margin-bottom:20px;">{$tr->social}</a>
				
				<div id="cookwarning" class="block layer">
					<h2>{$tr->collect_cookies_warn}</h2>
					<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more}</a>
					<div id="hideCont">
						<ul style="margin-top:10px;margin-bottom:10px;">
							<li>
								<select name="cookshow" class="fivecms_inp" style="width: 100px;">
									<option value='0' {if $settings->cookshow == '0'}selected{/if}>{$tr->show}</option>
									<option value='1' {if $settings->cookshow == '1'}selected{/if}>{$tr->hide}</option>
								</select>
							</li>
						</ul>
						<textarea style="width:96%;height:50px;" name="cookwarn">{$settings->cookwarn}</textarea>
					</div>
				</div>
				
				<div id="consultant" class="block layer">
					<h2>{$tr->chat} RedHelper</h2>
					<a class="hideBtn" href="javascript://" onclick="hideShow(this);return false;">{$tr->more}</a>
					<div id="hideCont">
						<ul>
							<li style="overflow:visible;">
								<label class="property" style="overflow:visible;">{$tr->redhelper}:</label>
								<input style="width:300px !important;" name="consultant" class="fivecms_inp" type="text" value="{$settings->consultant|escape}" /></li>
						</ul>
					</div>
				</div>
				
			</div>
			<input style="margin: 10px 0 20px 0; float:left;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
		</form>
		<!-- Основная форма (The End) -->

	</div>

</div>
<div style="display:none;">
	<div id="help_adv">
		{$tr->help_adv}
	</div>
</div>

{literal}
<style>
	#product .block label.property{width:300px;}
</style>
<script>
	// Показать
	$(".switch-input").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".switch-input");
		var name        = line.attr('name');
		var state       = line.is(':checked')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'post',
			url: 'ajax/update_object.php',
			data: {'object': 'settings', 'name': name, 'values': state, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				icon.removeClass('loading_icon');
			},
			dataType: 'json'
		});	
		return true;	
	});
</script>
{/literal}
