{*{include file='tinymce_init.tpl'}*}

{capture name=tabs}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=ThemeAdmin">{$tr->theme|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=TemplatesAdmin">{$tr->templates|escape}</a></li>{/if}
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=StylesAdmin">CSS</a></li>{/if}	
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
								<option value='0' {if $settings->colortheme == '0'}selected{/if}>Standart</option>
								<option value='16' {if $settings->colortheme == '16'}selected{/if}>Lite+синий</option>
								<option value='15' {if $settings->colortheme == '15'}selected{/if}>Lite+желтый</option>
								<option value='14' {if $settings->colortheme == '14'}selected{/if}>Белый+Standart</option>
								<option value='1' {if $settings->colortheme == '1'}selected{/if}>Белый+серый</option>
								<option value='9' {if $settings->colortheme == '9'}selected{/if}>Белый+черный</option>
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
		</form>
		<!-- Основная форма (The End) -->
	</div>

	<div class="colorthemehelp separator" style="display:none;">
		{$tr->gamma_helper}
	</div>
	
	<div class="preview separator">

		<img src="design/images/colors/0.jpg" style="display:none;" class="0" />
		<img src="design/images/colors/1.jpg" style="display:none;" class="1" />
		<img src="design/images/colors/3.jpg" style="display:none;" class="3" />
		<img src="design/images/colors/4.jpg" style="display:none;" class="4" />
		<img src="design/images/colors/5.jpg" style="display:none;" class="5" />
		<img src="design/images/colors/6.jpg" style="display:none;" class="6" />
		<img src="design/images/colors/7.jpg" style="display:none;" class="7" />
		<img src="design/images/colors/8.jpg" style="display:none;" class="8" />
		<img src="design/images/colors/9.jpg" style="display:none;" class="9" />
		<img src="design/images/colors/10.jpg" style="display:none;" class="10" />
		<img src="design/images/colors/11.jpg" style="display:none;" class="11" />
		<img src="design/images/colors/12.jpg" style="display:none;" class="12" />
		<img src="design/images/colors/13.jpg" style="display:none;" class="13" />
		<img src="design/images/colors/14.jpg" style="display:none;" class="14" />
		<img src="design/images/colors/15.jpg" style="display:none;" class="15" />
		<img src="design/images/colors/16.jpg" style="display:none;" class="16" />
	</div>
</div>

<script>
		$(".colortheme").change(function() {
  			cl = $(this).find('option:selected').val();

			$('.colorthemehelp').hide();
			if (cl == 2) $('.colorthemehelp').show();

			cl = '.'+cl;
			$('.preview img').hide();
			$(cl).show();
			
		}); 

		cl = $('.colortheme option:selected').val();

		$('.colorthemehelp').hide();
		if (cl == 2) $('.colorthemehelp').show();

		cl = '.'+cl;
		$('.preview img').hide();
		$(cl).show();
</script>