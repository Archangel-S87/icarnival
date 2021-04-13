{capture name=tabs}
	{*{if in_array('users', $manager->permissions)}<li><a href="index.php?module=UsersAdmin">{$tr->buyers|escape}</a></li>{/if}
	{if in_array('groups', $manager->permissions)}<li><a href="index.php?module=GroupsAdmin">{$tr->users_groups|escape}</a></li>{/if}
	{if in_array('coupons', $manager->permissions)}<li><a href="index.php?module=CouponsAdmin">{$tr->coupons|escape}</a></li>{/if}*}
    {if in_array('mailer', $manager->permissions)}<li><a href="index.php?module=MailerAdmin">{$tr->mailer|escape}</a></li>{/if}
    {if in_array('maillist', $manager->permissions)}<li><a href="index.php?module=MailListAdmin">{$tr->subscribers_list|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=ImportSubscribersAdmin">{$tr->subscribers_import|escape}</a></li>
{/capture}
{$meta_title = $tr->subscribers_import|escape scope=root}

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
 			 url: "ajax/import_subscribers.php",
 			 	data: {from:from},
 			 	dataType: 'json',
  				success: function(data){
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
    					$("#final").show();
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
</style>

{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">
	{if $message_error == 'no_permission'}{$tr->set_permissions|escape} {$import_files_dir}
	{elseif $message_error == 'convert_error'}{$tr->error_utf|escape}
	{elseif $message_error == 'locale_error'}{$tr->dont_set_locale|escape} {$locale}, {$tr->import_could_work_incorrect|escape}
	{else}{$message_error}{/if}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

{if isset($message_error) && $message_error == 'no_permission'}
{else}
	
	{if isset($filename)}
	<div>
		<h1>{$tr->import|escape} {$filename|escape}</h1>
	</div>
	<div id='progressbar'></div>
	<div id='final' style="display:none;clear:both;font-size:15px;">{$tr->import|escape} {$tr->finished|escape}</div>
	<ul id='import_result'></ul>
	{else}
	
		<h1>{$tr->subscribers_import|escape}</h1>

		<div class="block">	
		<form method=post id=product enctype="multipart/form-data">
			<input type=hidden name="session_id" value="{$smarty.session.id}">
			<input name="file" class="import_file" type="file" value="" />
			<input style="margin-left:10px;" class="button_green" type="submit" name="" value="{$tr->upload|escape}" />
			<p>
				({$tr->max_file_size|escape} &mdash; {if $config->max_upload_filesize>1024*1024}{$config->max_upload_filesize/1024/1024|round:'2'} Mb{else}{$config->max_upload_filesize/1024|round:'2'} Kb{/if})
			</p>

		</form>
		</div>		
	
		<div id="list" class="block block_help">
			{$tr->import_subscribers_help}
		</div>		
	
	{/if}

{/if}

