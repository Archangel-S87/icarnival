{capture name=tabs}
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=ImportAdmin">{$tr->import_csv|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=ImportYmlAdmin">{$tr->import_xml|escape}</a></li>
	{if in_array('export', $manager->permissions)}<li><a href="index.php?module=ExportAdmin">{$tr->export_csv|escape}</a></li>{/if}
	{if in_array('backup', $manager->permissions)}<li><a href="index.php?module=BackupAdmin">{$tr->backup|escape}</a></li>{/if}
	{if in_array('multichanges', $manager->permissions)}<li><a href="index.php?module=MultichangesAdmin">{$tr->packet|escape}</a></li>{/if}
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=OnecAdmin">1C</a></li>{/if}	
{/capture}
{$meta_title = $tr->import_xml|escape scope=root}

<script src="{$config->root_url}/fivecms/design/js/piecon/piecon.js"></script>
<script>
{if isset($filename_csv) && empty($convert_only)}
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
  					//~ for(var key in data.items)
  					//~ {
    					//~ $('ul#import_result').prepend('<li><span class=count>'+count+'</span> <span title='+data.items[key].status+' class="status '+data.items[key].status+'"></span> <a target=_blank href="index.php?module=ProductAdmin&id='+data.items[key].product.id+'">'+data.items[key].product.name+'</a> '+data.items[key].variant.name+'</li>');
    					//~ count++;
    				//~ }

    				Piecon.setProgress(Math.round(100*data.from/data.totalsize * 100) / 100);
   					$("#progressbar").progressbar({ value: 100*data.from/data.totalsize });
   					$("ul#import_result").text('{/literal}{$tr->in_progress|escape}: ' + Math.round(data.from / 1024) + ' {$tr->from|escape} {literal}' + Math.round(data.totalsize / 1024) + ' kb');
  				
    				if(data != false && !data.end)
    				{
						$(".importwarning").show();
    					do_import(data.from);
    				}
    				else
    				{
    					Piecon.setProgress(100);
    					$("#progressbar").hide();
						$(".importwarning").hide();
    					$("ul#import_result").append(' <p style="margin:15px 0;font-weight:700;">{/literal}{$tr->import|escape} {$tr->finished|escape}{literal}!</p>');
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
	.importwarning { font-weight:700;margin:15px 0;display:none;}
</style>

{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">
	{if $message_error == 'no_permission'}{$tr->set_permissions|escape} {$import_files_dir}
	{elseif $message_error == 'convert_error'}{$tr->error_utf|escape}
	{elseif $message_error == 'locale_error'}{$tr->dont_set_locale|escape} {$locale}, {$tr->import_could_work_incorrect|escape}
	{elseif $message_error == 'upload_error'}{$tr->upload_error|escape}
	{elseif $message_error == 'download_error'}{$tr->download_error|escape}
	{elseif $message_error == 'convert_error'}{$tr->convert_error|escape}
	{else}{$message_error}{/if}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

{if isset($message_error) && $message_error == 'no_permission'}
{else}
    {if isset($filename_yml)}
		<div class="block layer" style="margin-bottom:15px;">
					{if $filename_yml}{$tr->filename|escape} YML: <a href="files/import/{$filename_yml|escape}" target="_blank"><strong>{$filename_yml|escape}</strong></a>{/if} 
					{if isset($filename_yml_size)}{$tr->filesize|escape} YML: {$filename_yml_size|escape}{/if}
					{if isset($filename_csv)}{$tr->filename|escape} CSV: <a href="files/import/{$filename_csv|escape}" target="_blank"><strong>{$filename_csv|escape}</strong></a>{/if}
					{if isset($filename_csv_size)}{$tr->filesize|escape} CSV: {$filename_csv_size|escape}{/if}
		</div>            
    {if isset($filename_csv)}
		<div class="block layer">
					<h2>{$tr->import|escape} <a href="files/import/{$filename_csv|escape}" target="_blank">{$filename_csv|escape}</a></h2>
					<div id='progressbar'></div>
					<p class="importwarning">{$tr->dont_close_import_window|escape}!</p>
					<ul id='import_result'></ul>
		</div>        
    {/if}
            
	{if isset($yml_params)}
		{$tr->format_yml}
		
		<form method=post enctype="multipart/form-data">
			<input type=hidden name="session_id" value="{$smarty.session.id}">
			<input type=hidden name="start_import_yml" value="1">

            {*блок для отображения полей файла*}
				<div id="list">
					<div class="row">
						<div style="width:50%" class="cell">{$tr->parameter_name|escape} YML</div>
						<div style="width:50%" class="cell">{$tr->parameter_name|escape}</div>
						<div class="clear"></div>
					</div>
					{foreach $yml_params as $pkey=>$pvalue}
						<div class="row">
							<div style="width:50%" class="cell">{$pkey}</div>
							<div style="width:50%" class="cell">
								<select name="yml_params[{$pkey}]">
									<optgroup label="{$tr->add_skip_parameter|escape}">
										<option value="{$pkey}">{$tr->add_as_new_parameter|escape}</option>
										<option {if $pkey=="#url#" || $pkey=="currencyId" || $pkey=="market_category" || $pkey=="store" || $pkey=="pickup" || $pkey=="delivery" || $pkey=="sales_notes" || $pkey=="manufacturer_warranty" || $pkey=="seller_warranty" || $pkey=="delivery-options" || $pkey=="local_delivery_cost" || $pkey=="typePrefix" || $pkey=="country_of_origin" || $pkey=="model" || $pkey=="offer_id"}selected{/if} value="">{$tr->skip|escape}</option>
									</optgroup>
									{if $pkey!="#url#" && $pkey!="currencyId"}
									<optgroup label="{$tr->main_parameters|escape}">
										{foreach $columns as $k=>$f}
										<option value="{$k}" {if isset($columns_compared[$pkey]) && $columns_compared[$pkey] == $k} selected{/if}>{$f}</option>
										{/foreach}
									</optgroup>
									<optgroup label="{$tr->existing_parameters|escape}">
										{foreach $features as $f}
										<option value="{$f}" {if $pkey == $f}selected{elseif $pkey == "param_`$f`"}selected{/if}>{$f}</option>
										{/foreach}
									</optgroup>
									{/if}
									</select>
							</div>  
							<div class="clear"></div>
						</div>
					{/foreach}
					
				</div>
			{if $yml_currencies}
				<div class="block" style="margin:15px 0 15px 0;">
					<label>{$tr->curr_from_yml|escape}</label>
					<select name="yml_import_currency">
						{foreach $yml_currencies as $k=>$c}
						<option value="{$c['id']}">{$c['id']} ({$c['rate']})</option>
						{/foreach}
					</select>
				</div>
			{/if}
				<div class="block">
					<label>{$tr->progress_parameters|escape}</label>
					<select name="convert_only">
						<option value="0">{$tr->import|escape} YML</option>
						<option value="1">{$tr->only_yml_csv|escape}</option>
					</select>
					<button type="submit" class="button_green" style="margin-left:30px;">{$tr->save|escape}</button>
				</div>
		</form>
		{/if}
    {/if}
    
	{if !isset($filename_yml_size)}
		<div class="block">
		<h1>{$tr->products_import|escape} ({$tr->ym_standart|escape}) YML</h1>
		</div>
		<form method=post id=product enctype="multipart/form-data">
			<input type=hidden name="session_id" value="{$smarty.session.id}">
			<div class="block layer" style="margin-top:25px;">	
				<h2>{$tr->load_local|escape}</h2>
				<input name="file" class="import_file" type="file" value="" />
				<p style="margin-top:10px;">
					{$tr->allowed_extentions|escape}: .xml
					({$tr->max_file_size|escape} - {if $config->max_upload_filesize>1024*1024}{$config->max_upload_filesize/1024/1024|round:'2'} Mb{else}{$config->max_upload_filesize/1024|round:'2'} Kb{/if})
				</p>
			</div>
			<div class="block layer" style="margin-top:25px;">
				<h2>{$tr->load_server|escape}</h2>	
				<label>{$tr->enter_url|escape}</label>
				<input style="width:500px;" name="file_url" type="text" value=""/>
				<p style="margin-top:10px;">
						{$tr->allowed_extentions}: .xml, .xml.gz, .php
						({$tr->max_file_size|escape} - {if $config->max_upload_filesize>1024*1024}{$config->max_upload_filesize/1024/1024|round:'2'} Mb{else}{$config->max_upload_filesize/1024|round:'2'} Kb{/if})
				</p>
				<input style="clear:both; display:table; margin-top:20px;" type="submit" class="button_green" name="" value="{$tr->upload|escape}"/>
				<div style="max-width:800px;">
					<p style="margin-top:20px;">
						{$tr->import_help}
					</p>
					<ul class="stars" style="margin-top:20px;">
						<li style="border:0;">{$tr->delete_all_products}</li>
					</ul>
					
					<a class="button_green green" href="index.php?module=ImportImagesAdmin" style="text-decoration:none;font-size:14px;display:table;margin-bottom:20px;">{$tr->check_images}</a>
					
				</div>
			</div>
		</form>

	{elseif isset($filename_yml_size) && !isset($filename_csv_size) && !isset($yml_params)}
		<div class="block layer">
			<div class="row">
                <form method="post" enctype="multipart/form-data">
					<input type=hidden name="session_id" value="{$smarty.session.id}">
					<input type=hidden name="file_fields" value="{$filename_yml}" />
					<button type="submit" class="button_green">{$tr->read_parameters|escape}</button>
                </form>
			</div>
		</div>
	{/if}

{/if}

<script>
{literal}
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();
{/literal}
</script>
