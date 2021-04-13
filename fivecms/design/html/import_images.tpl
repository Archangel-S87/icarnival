{capture name=tabs}
	<li><a href="index.php?module=ImportAdmin">{$tr->import_csv|escape}</a></li>
	<li class="active"><a href="index.php?module=ImportImagesAdmin">{$tr->check_images_sh|escape}</a></li>
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=ImportYmlAdmin">{$tr->import_xml|escape}</a></li>{/if}
	{if in_array('export', $manager->permissions)}<li><a href="index.php?module=ExportAdmin">{$tr->export_csv|escape}</a></li>{/if}
	{if in_array('backup', $manager->permissions)}<li><a href="index.php?module=BackupAdmin">{$tr->backup|escape}</a></li>{/if}
	{if in_array('multichanges', $manager->permissions)}<li><a href="index.php?module=MultichangesAdmin">{$tr->packet|escape}</a></li>{/if}
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=OnecAdmin">1C</a></li>{/if}
{/capture}
{$meta_title = $tr->check_images|escape scope=root}

<script src="{$config->root_url}/fivecms/design/js/piecon/piecon.js"></script>

<style>
	.ui-progressbar-value { background-color:#b4defc; background-image: url(design/images/progress.gif); background-position:left; border-color: #009ae2;}
	#progressbar{ clear: both; height:29px;}
	#result{ clear: both; width:100%;}
	#product .block label.property{ width:350px; }
	#product .block li input[type=text]{ width:300px;margin-left:10px; }
	#product .block li { max-width:100%; width:100%;}
</style>

<h1>{$tr->check_images}</h1>
{if !empty($images_num)}
	<script>
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
				 url: "ajax/import_images.php",
					data: {from:from, step:{/literal}{$images_num|escape}{literal}},
					dataType: 'json',
					success: function(data){
						Piecon.setProgress(Math.round(100*data.from/data.end));
						$("#progressbar").progressbar({ value: 100*data.from/data.end });
				
						if(data != false && data.from <= data.end)
						{
							do_import(data.from);
						}
						else
						{
							Piecon.setProgress(100);
							$("#progressbar").hide('fast');
							in_process = false;
							$(".check_started").hide();
							$(".check_ended").show();
						}
					},
					error: function(xhr, status, errorThrown) {
						alert(errorThrown+'\n'+xhr.responseText);
					}  				
			});
	
		} 
	{/literal}
	</script>

	<div id='progressbar'></div>
	<ul id='import_result'></ul>
	
	<div class="check_started" style="font-weight:700;">{$tr->check_images_help2}</div>
	<div class="check_ended" style="display:none;font-weight:700;">{$tr->check_ended}</div>
	
{else}
	<div class="block">	
		<form method=post id=product enctype="multipart/form-data">
			<input type=hidden name="session_id" value="{$smarty.session.id}">
			<label style="margin-right:10px;">{$tr->check_images_num} ({$tr->example|lower}: 5)</label>
			<input style="width:40px;margin-right:10px;" name="images_num" class="images_num" type="number" step="1" min="1" value="{$images_num|escape}" />
			<input style="margin-bottom:10px;" class="button_green" type="submit" name="" value="{$tr->start}" />
			<p style="font-style:italic;">{$tr->check_images_help}</p>
		</form>
	</div>
{/if}

