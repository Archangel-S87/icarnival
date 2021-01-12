{* Вкладки *}
{capture name=tabs}
	{*{if in_array('users', $manager->permissions)}<li><a href="index.php?module=UsersAdmin">{$tr->buyers|escape}</a></li>{/if}
	{if in_array('groups', $manager->permissions)}<li><a href="index.php?module=GroupsAdmin">{$tr->users_groups|escape}</a></li>{/if}
	{if in_array('coupons', $manager->permissions)}<li><a href="index.php?module=CouponsAdmin">{$tr->coupons|escape}</a></li>{/if}*}
    {if in_array('mailer', $manager->permissions)}<li><a href="index.php?module=MailerAdmin">{$tr->mailer|escape}</a></li>{/if}
    <li><a href="index.php?module=MailListAdmin">{$tr->subscribers_list|escape}</a></li>
    <li class="active"><a href="index.php?module=ExportSubscribersAdmin">{$tr->subscribers_export|escape}</a></li>
{/capture}
{$meta_title = $tr->subscribers_export|escape scope=root}

<script src="{$config->root_url}/fivecms/design/js/piecon/piecon.js"></script>
<script>
	var in_process=false;
	var group_id='{if isset($group_id)}{$group_id|escape}{/if}';
	var keyword='{if isset($keyword)}{$keyword|escape}{/if}';
	var sort='{if isset($sort)}{$sort|escape}{/if}';

	{literal}	
	var in_process=false;

	$(function() {

		// On document load
		$('input#start').click(function() {
 
			Piecon.setOptions({fallback: 'force'});
			Piecon.setProgress(0);
			$("#progressbar").progressbar({ value: 0 });
		
			$("#start").hide('fast');
			do_export();
	
		});
  
		function do_export(page)
		{
			page = typeof(page) != 'undefined' ? page : 1;

			$.ajax({
					url: "ajax/export_subscribers.php",
					data: {page:page, group_id:group_id, keyword:keyword, sort:sort},
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
						Piecon.setProgress(100);
						$("#progressbar").hide('fast');
						window.location.href = '/fivecms/files/export_users/subscribers.csv';

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
	<h1>{$tr->subscribers_export|escape}</h1>
	{if isset($message_error) && $message_error == 'no_permission'}
	{else}
	<div id='progressbar'></div>
	<input class="button_green" id="start" type="button" name="" value="{$tr->to_export|escape}" />
	{/if}
</div>
 
