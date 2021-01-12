{capture name=tabs}
		<li class="active"><a href="index.php?module=WarningAdmin">{$tr->license|escape}</a></li>
{/capture}
{$meta_title = $tr->license|escape scope=root}

<div id="column_left">
	<div class="block" style="text-align:justify;">
		<h2 style='color:red;'>{$tr->license_invalid|escape}</h2>
		{$tr->license_warning}
	</div>
</div>
