{capture name=tabs}
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=ImportAdmin">{$tr->import_csv|escape}</a></li>{/if}
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=ImportYmlAdmin">{$tr->import_xml|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=ExportAdmin">{$tr->export_csv|escape}</a></li>
	{if in_array('backup', $manager->permissions)}<li><a href="index.php?module=BackupAdmin">{$tr->backup|escape}</a></li>{/if}
	{if in_array('multichanges', $manager->permissions)}<li><a href="index.php?module=MultichangesAdmin">{$tr->packet|escape}</a></li>{/if}	
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=OnecAdmin">1C</a></li>{/if}
{/capture}
{$meta_title = $tr->products_export|escape scope=root}

<script src="{$config->root_url}/fivecms/design/js/piecon/piecon.js"></script>
<script>
{literal}
	
var in_process=false;

$(function() {
	// On document load
	$('input#start').click(function() {
 		Piecon.setOptions({fallback: 'force'});
 		Piecon.setProgress(0);
    	$("#progressbar").progressbar({ value: 0 });
    	$("#start").hide('fast');
    	$("#product_categories").hide('fast');
		do_export();
	});
  
	function do_export(page)
	{
		page = typeof(page) != 'undefined' ? page : 1;
		category_id = $('select[name="category_id"]').find('option:selected').val();
		brand_id = $('select[name="brand_id"]').find('option:selected').val();
		encoding = $('select[name="encoding"]').find('option:selected').val();
		
		if(encoding == '1251')
			$ajax_url = 'ajax/export.php';
		else if(encoding == 'utf8')
			$ajax_url = 'ajax/export_utf8.php';
			
		$.ajax({
 			 url: $ajax_url,
 			 	data: {page:page, category_id:category_id, brand_id:brand_id},
 			 	dataType: 'json',
  				success: function(data){
    				if(data && !data.end)
    				{
    					Piecon.setProgress(Math.round(100*data.page/data.totalpages));
    					$("#progressbar").progressbar({ value: 100*data.page/data.totalpages });
    					do_export(data.page*1+1);
    				}
    				else
    				{	
	    				if(data && data.end)
	    				{
	    					Piecon.setProgress(100);
	    					$("#progressbar").hide('fast');
	    					window.location.href = '/fivecms/files/export/export.csv';
	    					$('.file_ready').show();
    					}
    				}
  				},
				error:function(xhr, status, errorThrown) {
					alert(errorThrown+'\n'+xhr.responseText);
        		}  				
		});
	} 
});
{/literal}
</script>

<style>
	.ui-progressbar-value { background-image: url(design/images/progress.gif); background-position:left; border-color: #009ae2;}
	#progressbar{ clear: both; height:29px; }
	#result{ clear: both; width:100%;}
	#download{ display:none;  clear: both; }
</style>


{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">
	{if $message_error == 'no_permission'}{$tr->no_permission|escape} {$export_files_dir}
	{else}{$message_error}{/if}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

<div>
	<h1>{$tr->products_export|escape}</h1>
	
	<div class="message message_success file_ready" style="display:none;">
		<span class="text">
			{$tr->file_ready|escape}
		</span>
	</div>

	{if isset($message_error) && $message_error == 'no_permission'}
		{* ToDo *}
	{else}
	<div id='progressbar'></div>
	<div id="product_categories">
		<div class="export_cats" {if !isset($categories)}style='display:none;'{/if}>
			<label style="width:78px;">{$tr->category|escape}</label>
			<div>
				<ul>
					<li>
						<select name="category_id">
							<option value='0'>{$tr->all_categories|escape}</option>
							{function name=category_select level=0}
								{foreach from=$categories item=category}
									<option value='{$category->id}'>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$category->name|escape}</option>
									{if isset($category->subcategories)}	
										{category_select categories=$category->subcategories  level=$level+1}
									{/if}
								{/foreach}
							{/function}
							{category_select categories=$categories}
						</select>
					</li>	
				</ul>
			</div>
		</div>
		<div class="separator" style="margin-top:10px;width:100%;"></div>
		<div class="export_brands" {if !isset($brands)}style='display:none;'{/if}>
			<label style="width:78px;">{$tr->brand|escape}</label>
			<div>
				<ul>
					<li>
						<select name="brand_id">
								<option value="0">{$tr->not_set|escape}</option>
							{foreach from=$brands item=brand}
								<option value="{$brand->id}">{$brand->name|escape}</option>
							{/foreach}
						</select>
					</li>	
				</ul>	
			</div>
		</div>
		<div class="separator" style="margin-top:10px;width:100%;"></div>
		<label style="width:78px;">{$tr->encoding|escape}</label>
		<div>
			<ul>
				<li>
					<select name="encoding">
						<option value='1251'>Win-1251 (Excel)</option>
						<option value='utf8'>UTF-8</option>
					</select>
				</li>	
			</ul>
		</div>
	</div>
	<div class="separator" style="margin-top:10px;width:100%;"></div>
	<input class="button_green" id="start" type="button" name="" value="{$tr->to_export|escape}" />	
	{/if}
</div>
 
<style>
#product_categories div{ margin:0;width:auto; }
</style>