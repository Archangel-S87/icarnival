{*{include file='tinymce_init.tpl'}*}

{capture name=tabs}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ThemeAdmin">{$tr->theme|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=TemplatesAdmin">{$tr->templates|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=StylesAdmin">{$tr->styles|escape}</a></li>{/if}	
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ScriptsAdmin">JS</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ImagesAdmin">{$tr->images|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=ColorAdmin">{$tr->gamma|escape}</a></li>
	{if in_array('slides', $manager->permissions)}<li><a href="index.php?module=SlidesAdmin">{$tr->slider|escape}</a></li>{/if}
{/capture}
 
{$meta_title = $tr->gamma scope=root}

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
				<div id="managestad" class="block">
					<h2>{$tr->choose_gamma|escape}</h2>
					<ul>
						<li>
							<select name="colortheme" class="colortheme fivecms_inp" style="width: 140px;">
								<option value='16' {if $settings->colortheme == '16'}selected{/if}>Lite+darkblue</option>
								<option value='15' {if $settings->colortheme == '15'}selected{/if}>Lite+yellow</option>
								<option value='17' {if $settings->colortheme == '17'}selected{/if}>Lite+grey</option>
								<option value='18' {if $settings->colortheme == '18'}selected{/if}>Lite+black</option>
								<option value='19' {if $settings->colortheme == '19'}selected{/if}>Lite+dark</option>
								<option value='22' {if $settings->colortheme == '22'}selected{/if}>Lite+softred</option>
								<option value='23' {if $settings->colortheme == '23'}selected{/if}>Lite+red</option>
								<option value='24' {if $settings->colortheme == '24'}selected{/if}>Lite+blue</option>
								<option value='20' {if $settings->colortheme == '20'}selected{/if}>Lite+softgreen</option>
								<option value='21' {if $settings->colortheme == '21'}selected{/if}>Lite+green</option>
								<option value='25' {if $settings->colortheme == '25'}selected{/if}>Lite+orange</option>
								<option value='14' {if $settings->colortheme == '14'}selected{/if}>White+Standart</option>
								<option value='1' {if $settings->colortheme == '1'}selected{/if}>White+grey</option>
								<option value='9' {if $settings->colortheme == '9'}selected{/if}>White+black</option>
								<option value='0' {if $settings->colortheme == '0'}selected{/if}>Standart</option>
								<option value='3' {if $settings->colortheme == '3'}selected{/if}>Standart sand</option>
								<option value='4' {if $settings->colortheme == '4'}selected{/if}>Standart softgreen</option>
								<option value='5' {if $settings->colortheme == '5'}selected{/if}>Standart softred</option>
								<option value='6' {if $settings->colortheme == '6'}selected{/if}>Standart lilac</option>
								<option value='7' {if $settings->colortheme == '7'}selected{/if}>Standart blue</option>
								<option value='8' {if $settings->colortheme == '8'}selected{/if}>Standart orange</option>
								<option value='10' {if $settings->colortheme == '10'}selected{/if}>Standart dark</option>
								<option value='11' {if $settings->colortheme == '11'}selected{/if}>Standart combined</option>
								<option value='12' {if $settings->colortheme == '12'}selected{/if}>Standart green</option>
								<option value='13' {if $settings->colortheme == '13'}selected{/if}>Standart red</option>
							</select>
						</li>
					</ul>
				</div>
			</div>
			<input style="margin: 0px 0 20px 0; float:left;" class="button_green button_save" type="submit" name="save" value="{$tr->save|escape}" />
			<div style="display:table;clear:both;">{$tr->color_help}</div>
		</form>
		<!-- Основная форма (The End) -->
	</div>
	
	<div class="preview separator">
		<img src="design/images/colors/{$settings->colortheme}.jpg" class="{$settings->colortheme}" />
	</div>
</div>

<script>
	$(".colortheme").change(function() {
  		var cl = $(this).find('option:selected').val();
  		var img = '<img src="design/images/colors/'+cl+'.jpg" class="'+cl+'" />';
		$('.preview').html(img);
	}); 
</script>