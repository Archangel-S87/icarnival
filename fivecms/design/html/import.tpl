{capture name=tabs}
	<li class="active"><a href="index.php?module=ImportAdmin">{$tr->import_csv|escape}</a></li>
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=ImportYmlAdmin">{$tr->import_xml|escape}</a></li>{/if}
	{if in_array('export', $manager->permissions)}<li><a href="index.php?module=ExportAdmin">{$tr->export_csv|escape}</a></li>{/if}
	{if in_array('backup', $manager->permissions)}<li><a href="index.php?module=BackupAdmin">{$tr->backup|escape}</a></li>{/if}
	{if in_array('multichanges', $manager->permissions)}<li><a href="index.php?module=MultichangesAdmin">{$tr->packet|escape}</a></li>{/if}
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=OnecAdmin">1C</a></li>{/if}
{/capture}
{$meta_title = $tr->import_csv|escape scope=root}

<script src="{$config->root_url}/fivecms/design/js/piecon/piecon.js"></script>
<script>
{if isset($filename)}
{literal}
	
	var in_process=false;
	var count=1;

	// On document load
	$(function(){
 		Piecon.setOptions({fallback: 'force'});
 		Piecon.setProgress(0);
    	$("#progressbar").progressbar({ value: 1 });
		in_process=true;
		do_import();	    
	});
  
	function do_import(from)
	{
		from = typeof(from) != 'undefined' ? from : 0;
		$.ajax({
 			 url: "ajax/import.php",
 			 	data: {from:from},
 			 	dataType: 'json',
  				success: function(data){
  					for(var key in data.items)
  					{
    					$('ul#import_result').prepend('<li><span class=count>'+count+'</span> <span title='+data.items[key].status+' class="status '+data.items[key].status+'"></span> <a target=_blank href="index.php?module=ProductAdmin&id='+data.items[key].product.id+'">'+data.items[key].product.name+'</a> '+data.items[key].variant.name+'</li>');
    					count++;
    				}

    				Piecon.setProgress(Math.round(100*data.from/data.totalsize));
   					$("#progressbar").progressbar({ value: 100*data.from/data.totalsize });
  				
    				if(data != false && !data.end)
    				{
    					do_import(data.from);
    				}
    				else
    				{
    					Piecon.setProgress(100);
    					$("#progressbar").hide('fast');
    					in_process = false;
    				}
  				},
				error: function(xhr, status, errorThrown) {
					alert(errorThrown+'\n'+xhr.responseText);
        		}  				
		});
	
	} 
{/literal}
{/if}
</script>

<style>
	.ui-progressbar-value { background-color:#b4defc; background-image: url(design/images/progress.gif); background-position:left; border-color: #009ae2;}
	#progressbar{ clear: both; height:29px;}
	#result{ clear: both; width:100%;}
	#product .block label.property{ width:350px; }
	#product .block li input[type=text]{ width:300px;margin-left:10px; }
	#product .block li { max-width:100%; width:100%;}
</style>

{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">
	{if $message_error == 'no_permission'}{$tr->set_permissions|escape} {$import_files_dir}
	{elseif $message_error == 'convert_error'}{$tr->error_utf|escape}
	{elseif $message_error == 'locale_error'}{$tr->dont_set_locale|escape} {$locale}, {$tr->import_could_work_incorrect|escape}
	{elseif $message_error == 'upload_error'}{$tr->upload_error|escape}
	{else}{$message_error}{/if}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}
{if isset($message_success)}
<!-- Системное сообщение -->
<div class="message message_success">
	<span class="text">
	{if $message_success == 'saved'}{$tr->added|escape}{/if}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

{if isset($message_error) && $message_error == 'no_permission'}
	{* todo *}
{else}
	
	{if isset($filename)}
	<div>
		<h1>{$tr->import|escape} {$filename|escape}</h1>
	</div>
	<div id='progressbar'></div>
	<ul id='import_result'></ul>
	{else}
	
		<h1>{$tr->products_import|escape}</h1>

		<div class="block">	
		<form method=post id=product enctype="multipart/form-data">
			<input type=hidden name="session_id" value="{$smarty.session.id}">
			<input name="file" class="import_file" type="file" value="" />
			<input style="margin-bottom:10px;" class="button_green" type="submit" name="" value="{$tr->upload|escape} CSV {$tr->file|escape} {$tr->and_start_import|escape}" />
			<p>
				({$tr->max_file_size|escape} &mdash; {if $config->max_upload_filesize>1024*1024}{$config->max_upload_filesize/1024/1024|round:'2'} Mb{else}{$config->max_upload_filesize/1024|round:'2'} Kb{/if})
			</p>
		</form>
		</div>		
		
		<div id="product" style="margin-top:15px;">
			<div class="block layer">
				<form method=post id=product enctype="multipart/form-data">
					<input type=hidden name="session_id" value="{$smarty.session.id}">
					<h2>{$tr->common_import_settings|escape}:</h2>
					<ul>
						<li><label style="width:260px;" class=property>{$tr->update_products|escape}</label>
							<select name="update_products" class="fivecms_inp" style="width: auto;">
								<option value='0' {if $settings->update_products == '0'}selected{/if}>{$tr->update_whole_product|escape}</option>
								<option value='1' {if $settings->update_products == '1'}selected{/if}>{$tr->update_only_variant|escape}</option>
							</select>
						</li>
						<li><label style="width:260px;" class=property>{$tr->update_only|escape}</label>	
							<select name="update_only" class="fivecms_inp" style="width: auto;">
								<option value='0' {if $settings->update_only == '0'}selected{/if}>{$tr->no|escape}</option>
								<option value='1' {if $settings->update_only == '1'}selected{/if}>{$tr->yes|escape}</option>
							</select>
						</li>
						<li>
							<label style="width:160px;" class=property>{$tr->change_price_on|escape}</label>
							<input name="import_price" step="1" style="max-width:50px;" class="fivecms_inp" type="number" value="{$settings->import_price|escape}" /> %
						</li>
					</ul>
					
					<input style="margin:-5px 0 20px 0;" class="button_green" type="submit" name="settings" value="{$tr->save|escape} {$tr->settings|escape}" />
			
					<h2>{$tr->simple_import_title}</h2>
					{$tr->simple_import_help}
					<ul class="d_properties">
						<li><label class=property>{$tr->product_name|escape}</label><input name="d_name" class="fivecms_inp" type="text" value="{$settings->d_name|escape}" /></li>
						<li><label class=property>{$tr->category|escape}</label><input name="d_category" class="fivecms_inp" type="text" value="{$settings->d_category|escape}" /></li>
						<p style="margin-bottom:8px;">{$tr->cat_delimiter_help}</p>
						<li style="margin-left:10px;"><label class=property>{$tr->cat_delimiter|escape}</label><input placeholder="{$tr->example|escape} #" name="category_delimiter" class="fivecms_inp" type="text" value="{$settings->category_delimiter}" /></li>
						<li style="margin-left:10px;"><label class=property>{$tr->sub_cat_delimiter|escape}</label><input placeholder="{$tr->example|escape} /" name="subcategory_delimiter" class="fivecms_inp" type="text" value="{$settings->subcategory_delimiter}" /></li>
						<li><label class=property>{$tr->brand|escape}</label><input name="d_brand" class="fivecms_inp" type="text" value="{$settings->d_brand|escape}" /></li>
						<li><label class=property>{$tr->price|escape}</label><input name="d_price" class="fivecms_inp" type="text" value="{$settings->d_price|escape}" /></li>
						<li><label class=property>{$tr->sku|capitalize|escape}</label><input name="d_sku" class="fivecms_inp" type="text" value="{$settings->d_sku|escape}" /></li>
						<li><label class=property>{$tr->product_short_description|escape}</label><input name="d_annotation" class="fivecms_inp" type="text" value="{$settings->d_annotation|escape}" /></li>
						<li><label class=property>{$tr->product_full_description|escape}</label><input name="d_description" class="fivecms_inp" type="text" value="{$settings->d_description|escape}" /></li>
						<li><label class=property>{$tr->product_images|escape}</label><input name="d_images" class="fivecms_inp" type="text" value="{$settings->d_images|escape}" /></li>
						<li><label class=property>{$tr->product_variant|escape} ({$tr->optionally|escape})</label><input name="d_variant" class="fivecms_inp" type="text" value="{$settings->d_variant|escape}" /></li>
						<li><label class=property>{$tr->size|escape} ({$tr->optionally|escape}) {$tr->only_for_clothes|escape}</label><input name="d_variant1" class="fivecms_inp" type="text" value="{$settings->d_variant1|escape}" /></li>
						<li><label class=property>{$tr->color|escape} ({$tr->optionally|escape}) {$tr->only_for_clothes|escape}</label><input name="d_variant2" class="fivecms_inp" type="text" value="{$settings->d_variant2|escape}" /></li>
						<li><label class=property>{$tr->stock_available|escape} ({$tr->optionally|escape})</label><input name="d_stock" class="fivecms_inp" type="text" value="{$settings->d_stock|escape}" /></li>
						<li><label class=property>{$tr->unit|escape} ({$tr->optionally|escape})</label><input name="d_unit" class="fivecms_inp" type="text" value="{$settings->d_unit|escape}" /></li>
						<li><label class=property>{$tr->currenty_id_admin|escape} ({$tr->optionally|escape})</label><input name="d_currency_id" class="fivecms_inp" type="text" value="{$settings->d_currency_id|escape}" /></li>
						<li><label class=property>{$tr->meta_title|escape} ({$tr->optionally|escape})</label><input name="d_meta_title" class="fivecms_inp" type="text" value="{$settings->d_meta_title|escape}" /></li>
						<li><label class=property>{$tr->meta_description|escape} ({$tr->optionally|escape})</label><input name="d_meta_description" class="fivecms_inp" type="text" value="{$settings->d_meta_description|escape}" /></li>
					</ul>
					<input class="button_green" type="submit" name="settings" value="{$tr->save|escape} {$tr->settings|escape}" />
				</form>
			</div>
		</div>
		
		<div id="list" class="block block_help">
			{$tr->help_import_csv}
			<p class="helper">
				{$tr->delete_all_products}
			</p>
		</div>		
	
	{/if}

{/if}
{literal}
<style>
.d_properties label{width:290px !important;}
</style>
{/literal}

