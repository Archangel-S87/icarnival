
<link href="design/css/slides.css" rel="stylesheet" type="text/css" />
{capture name=tabs}
	{if in_array('comments', $manager->permissions)}<li><a href="index.php?module=CommentsAdmin">{$tr->comments|escape}</a></li>{/if}
	{if in_array('feedbacks', $manager->permissions)}<li><a href="index.php?module=FeedbacksAdmin">{$tr->feedback|escape}</a></li>{/if}
	<li><a href="index.php?module=FormsAdmin">{$tr->forms|escape}</a></li>
	<li class="active">
		{if !empty($form->name)}
			<a href="index.php?module=FormAdmin&id={$form->id}">{$form->name|escape}</a>
		{else}
			<a href="index.php?module=FormsAdmin">{$tr->new_post|escape}</a>
		{/if}
	</li>
	{if in_array('design', $manager->permissions)}<li><a href="index.php?module=MailTemplatesAdmin">{$tr->mail_templates|escape}</a></li>{/if}
{/capture}

{if !empty($form->name)}
{$meta_title = $form->name|escape scope=root}
{else}
{$meta_title = $tr->new_post|escape scope=root}
{/if}

<div id="onecolumn" class="formpage">

	{if isset($message_success)}
	<!-- System message | Системное сообщение -->
	<div class="message message_success">
		<span class="text">{if $message_success=='added'}{$tr->added|escape}{elseif $message_success=='updated'}{$tr->updated|escape}{else}{$message_success}{/if}</span>
		{if isset($smarty.get.return)}
		<a class="button" href="{$smarty.get.return}">{$tr->return|escape}</a>
		{/if}
	</div>
	<!-- System message | Системное сообщение (The End)-->
	{/if}
	<p style="margin-bottom:10px;">{$tr->form_help}</p>
	<!-- Main form | Основная форма -->
	<form method=post  enctype="multipart/form-data">
		
		<input type=hidden name="session_id" value="{$smarty.session.id}">
		{if !isset($form->description)}<h1>{$tr->step|escape} 1:</h1>	{/if}
		<ul class="form_list">

			<li>
				<label>{$tr->form_name|escape}:</label>
				<input placeholder="{$tr->enter_s_name|escape}" class="name" name=name type="text" value="{if !empty($form->name)}{$form->name|escape}{/if}" required /> 
				<input name=id type="hidden" value="{if !empty($form->id)}{$form->id|escape}{/if}"/> 
			</li>
			<li>
				<label>{$tr->form_url|escape}:</label>
				<input placeholder="{$tr->form_url_placeholder|escape} /blog/test " name="url" class="page_url" type="text" value="{if !empty($form->url)}{$form->url}{/if}" />
				<p style="margin-top:5px;font-size:13px;">{$tr->form_url_main|escape}</p>
			</li>
			<li>
				<label>{$tr->form_button|escape}:</label>
				<input placeholder="{$tr->example|escape}: {$tr->send|escape}" class="name" name="button" type="text" value="{if !empty($form->button)}{$form->button|escape}{/if}" required /> 
			</li>
		</ul>
		
		{if !isset($form->description)}
		<h2>{$tr->form_add_fields|escape}:</h2>
		<div class="add_mailing bigbutton green">{$tr->form_base_fields|escape}</div>
		
		<div class="fields_set">
			<select name="field_type">
				<option value="input">{$tr->form_input|escape}</option>
				<option value="textarea">{$tr->form_textarea|escape}</option>
				<option value="select">{$tr->form_select|escape}</option>
			</select>
			<input class="field_name" placeholder="{$tr->form_field_example|escape}" name="field_name" />
			<select name="field_required">
				<option value="0">{$tr->non_required|escape}</option>
				<option value="1">{$tr->required|escape}</option>
			</select>
			<div style="display:inline-block;margin-left:15px;" class="add_field bigbutton grey">{$tr->add|escape}</div>
		</div>
		{/if}
		
		<div class="block_left">
			{if !isset($form->description)}<h1 class="hideform">{$tr->step|escape} 2:</h1>{/if}
			<div style="margin-top:20px;" class="add_form_code bigbutton green hideform">{$tr->form_get_save|escape}</div>
		
			{if !empty($form->description)}
				<h2 class="button_title">{$tr->form_button_code|escape}:</h2>
				<p style="margin-bottom:10px;">{$tr->form_copy|escape}:</p>

				{'<div data-id="form'|cat:{$form->id}|cat:'" class="showform buttonred">'|cat:{$tr->to_show|escape}|cat:'</div>'|escape}
				<br />{$tr->or|escape}<br />
				{'<span data-id="form'|cat:{$form->id}|cat:'" class="showform buttonred">'|cat:{$tr->to_show|escape}|cat:'</span>'|escape}
				
				{$tr->form_button_help}
			{/if}
		
			<ul style="clear:both;" class="{if !isset($form->description)}hideform2{/if}">	
				<li>
					<label style="display:table;clear:both;margin:20px 0 10px 0;font-size:13px;">{$tr->form_code_help}:</label>
					<textarea style="width:100%;outline:none;" name="description" class="form_description">{if !empty($form->description)}{$form->description|escape}{/if}</textarea>
				</li>
			</ul>
		
			<input style="margin:20px 0 20px 0;" class="button_green form_save {if !isset($form->description)}hideform2{/if}" type="submit" name="" value="{$tr->save|escape}" />

		</div>
	</form>
	<!-- Main form | Основная форма (The End) -->
	
	<div class="block_right">
		<div class="model_form"></div>
		<div class="delete_form"></div>
	</div>
	
	{if !empty($form->description)}
	<div class="block_right">
		<div id="form1" class="user_form">
			<div class="user_form_main">
				<div class="form-title">{$form->name|escape}</div>
				<div class="readform">
					{$form->description}
				</div>
			</div>
			<div class="form_result"></div>
		</div>
	</div>
	{/if}

</div>

<script type="text/javascript">
		$(document).on('focus', '.field_name', function () {
			$('.add_field').removeClass('grey').addClass('green');
			$('.field_name').removeClass('required');
		});
		
		$(document).on('blur', '.field_name', function () {
			if($('.field_name').val().length == 0){
				$('.add_field').removeClass('green').addClass('grey');
				$('.field_name').addClass('required');
			}
		});
		
		$(document).on('click', '.add_mailing', function () {
			var f_name = '<input name="f-name" data-placeholder="* {$tr->person_name|escape}" placeholder="* {$tr->person_name|escape}" type="text" maxlength="255" required />'; 
			var f_email = '<input name="f-email" data-placeholder="* Email" placeholder="* Email" type="email" maxlength="255" required />';
			$('.model_form').append(f_name,f_email);
			$('.delete_form').append('<div class="del_mailing" style="line-height:64px;"><svg><use xlink:href="#delete_button" /></svg></div>');//id
			$('.add_mailing').hide();
			
			$('.hideform').show();
		});
		
		var f_id = 0;
		$(document).on('click', '.add_field', function () {
			var name_length = $('.field_name').val().length;
			if(name_length > 0){
				f_id ++;
			
				var field_type = $('.fields_set select[name="field_type"]').val();
				var field_name = $('.fields_set input[name="field_name"]').val();
				if($('.fields_set select[name="field_required"]').val() > 0)
					var field_required = "required";
				else
					var field_required = "";
				
				if(field_type == 'input'){
					var f_sample='<input name="f'+f_id+'" data-placeholder="'+field_name+'" placeholder="'+field_name+'" type="text" maxlength="255" '+field_required+'/>';
					$('.delete_form').append('<div class="del_but" style="line-height:27px;" id="delf'+f_id+'"><svg id="f'+f_id+'"><use xlink:href="#delete_button" /></svg></div>');	
				}
				if(field_type == 'textarea'){
					var f_sample='<textarea name="f'+f_id+'" data-placeholder="'+field_name+'" placeholder="'+field_name+'" maxlength="1024" '+field_required+' rows="3"></textarea>';	
					$('.delete_form').append('<div class="del_but" style="line-height:61px;" id="delf'+f_id+'"><svg id="f'+f_id+'"><use xlink:href="#delete_button" /></svg></div>');	
				}	
				if(field_type == 'select'){
					var f_sample='<label data-sel="f'+f_id+'">'+field_name+'</label><select name="f'+f_id+'" data-placeholder="'+field_name+'"><option value="один">один</option><option value="два">два</option><option value="три">три</option></select>';
					$('.delete_form').append('<div class="del_but" style="line-height:56px;" id="delf'+f_id+'"><svg id="f'+f_id+'"><use xlink:href="#delete_button" /></svg></div>');	
				}
				
				$('.model_form').append(f_sample);

				$('.hideform').show();
			} else {
				$('.field_name').addClass('required');
			}
			
		});
		$(document).on('click', '.del_but svg', function () {
			var del_id = $(this).attr('id');
			var del_but = '#del'+del_id;
			$(del_but).remove();
			$('[name="'+del_id+'"], [data-sel="'+del_id+'"]').remove();
			
			if($('.model_form').html() == null || $('.model_form').html().length == 0)
				$('.hideform').hide();
		});
		$(document).on('click', '.del_mailing svg', function () {
			$('.del_mailing').remove();
			$('[name="f-name"], [name="f-email"]').remove();
			$('.add_mailing').show();

			if($('.model_form').html() == null || $('.model_form').html().length == 0)
				$('.hideform').hide();
		});

		$(document).on('click', '.add_form_code', function () {
				$('.hideform2').show();
				var get_html = '';
				get_html = $('.model_form').html();
				$('textarea.form_description').html(get_html);
				$('.form_save').click();
		});
</script>

<style>
	{literal}
		/*input:required:invalid {border:2px solid red;}*/
		.block_left{width:445px;float:left;margin-top:20px;}
		.block_right{width:400px;float:right;margin-top:20px;}
		.field_name{width:275px;}
		.form_list li{margin:10px 0;}
		.form_list li label {
		  font-weight: 700;
		  max-width: 211px;
		  width:211px;
		  display: inline-block;
		  line-height: 17px;
		  vertical-align:middle;
		}
		.form_list li input {display:inline-block; width:300px;  vertical-align:middle;}
		#middle h1{float:none !important;clear:both;}
		#middle h2{clear:both;}
		.model_form {width:300px;min-height:10px;height:10px;display:table;margin:15px 0 15px 0;float:left;}
		.delete_form {width:50px;min-height:10px;height:10px;display:table;margin:15px 0 15px 10px;float:left;}
		input[name='f-name'],input[name='f-email']{clear:both;display:block;}
		.model_form input, .model_form textarea, .model_form label, .model_form select{margin-bottom:10px;clear:both;display:block;width:300px;}
		.model_form label{height:16px;}
		.delete_form div{margin-bottom:10px;clear:both;display:block;width:50px;}
		.required{border:2px solid red;}
		.grey{background-color:#d8d6d6;color:#333333;}
		.grey:hover{color:#ffffff;}
		.delete_form svg{width:24px;height:24px;vertical-align:middle;cursor:pointer;}
		.bigbutton{clear:both;}
		#middle .hideform, #middle .hideform2{display:none;}
		.bigbutton.hideform {width:320px;text-align:center;}
		.form_description {height:100px;}
		.button_title{margin-top:15px;}
		
		.buttonred {
		  background-color: #eb5858;
		  border: 0px solid #eb5858;
		  -moz-border-radius: 6px;
		  -webkit-border-radius: 6px;
		  border-radius: 6px;
		  border: 0px solid #EB1C24;
		  display: inline-block;
		  font-size: 16px;
		  font-weight: 700;
		  padding: 8px 12px 8px;
		  text-decoration: none;
		  cursor: pointer;
		  color: #FFFFFF;
		  text-transform: uppercase;
		  -moz-appearance: none;
 		  -webkit-appearance: none;
		}
		.bluelink {
		  cursor: pointer;
		  border-bottom: 1px dashed #0D679A;
		  text-decoration: none;
		  color: #0D679A;
		}
		.showform{display:inline-block;}
		
		
		/* form handler */
		.user_form{width:250px;}
		.form-title{text-transform:uppercase;font-weight:700;font-size:16px;margin:9px 0 3px 0;}
		.readform label{margin:0px 0 5px 0;display:block;}
		.readform .required{border:2px dashed #ed6363;}
		.user_form .buttonred {margin-top:17px;float:right;padding:8px 16px;}
		.form_result{display:table;width:100%;}
		.form_result .form_success, .form_result .form_error{display:table;padding:10px 10px;width:100%;border-radius:5px;font-weight:700;}
		.form_result .form_success{margin-bottom:0px;color:#333333;}
		.form_result .form_error{margin-top:10px;background-color:#e61212;color:#ffffff;} 
		.readform input, .readform textarea {font-size:15px;margin:10px 0 5px 0;width:100%;}
		.readform select {font-size:15px;height:auto;}
		
		
	{/literal}
</style>
