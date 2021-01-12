{capture name=tabs}
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=ImportAdmin">{$tr->import_csv|escape}</a></li>{/if}
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=ImportYmlAdmin">{$tr->import_xml|escape}</a></li>{/if}
	{if in_array('export', $manager->permissions)}<li><a href="index.php?module=ExportAdmin">{$tr->export_csv|escape}</a></li>{/if}
	{if in_array('backup', $manager->permissions)}<li><a href="index.php?module=BackupAdmin">{$tr->backup|escape}</a></li>{/if}
	<li class="active"><a href="index.php?module=MultichangesAdmin">{$tr->packet|escape}</a></li>
	{if in_array('import', $manager->permissions)}<li><a href="index.php?module=OnecAdmin">1C</a></li>{/if}
{/capture}
{$meta_title= $tr->packet|escape scope=root}
<style>
label{ font-weight:700; };
</style>

{if isset($message_error)}
<!-- Системное сообщение -->
<div class="message message_error">
	<span>
	{if $message_error == 'brand_error'}{$tr->no_brand|escape} 
	{elseif $message_error == 'percent_error'}{$tr->no_procent|escape} 
	{elseif $message_error == 'non_numeric'}{$tr->number_required|escape}
	{elseif $message_error == 'non_integer'}{$tr->integer_required|escape}
	{else}{$message_error}{/if}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{elseif isset($message_success)}
<!-- Системное сообщение -->
<div class="message message_success">
	<span>
	{$message_success}
	</span>
</div>
<!-- Системное сообщение (The End)-->
{/if}

<div style="width:700px;">
	
	<ul class="stars" style="clear:both;margin-bottom:5px;"><li>{$tr->multichanges_help}</li></ul>

	<div class="block" style="padding-top:10px;">	
		<form method=post id=product enctype="multipart/form-data">
			
			<input type=hidden name="session_id" value="{$smarty.session.id}">

			<div style="padding:10px 15px 10px 10px;border:1px solid #dadada;border-radius:10px;display:table;background-color:#ffffff;margin-bottom:10px;">
				<h3 style="text-transform:uppercase;margin-bottom:15px;">{$tr->products_filter|escape}:</h3>
				
				<label style="margin-right:10px;">{$tr->category|escape}</label>
				
				<select style="margin-right:0;" name="category_id" ID="category_id">
							<option value='0'>{$tr->not_set|escape}</option>
							{function name=category_select level=0}
								{foreach from=$cats item=cat}
									<option value='{$cat->id}' {if $cat->id ==$category_id}selected{/if}>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$cat->name}</option>
									{if !empty($cat->subcategories)}
										{category_select cats=$cat->subcategories level=$level+1}
									{/if}
								{/foreach}
							{/function}
							{category_select cats=$categories}
				</select>
				
				<div class="allow_children" style="margin-top:10px;width:auto;">
					<label style="display:inline-block;width:240px;">{$tr->allow_children|escape}</label>
					<select style="width:auto;min-width:initial;" name="allow_children">
						<option value="0" {if $allow_children == 0}selected{/if}>{$tr->yes|escape}</option>
						<option value="1" {if $allow_children == 1}selected{/if}>{$tr->no|escape}</option>
					</select>
				</div>
				
				<div style="clear:both;margin-bottom:10px;"></div>
				<label style="margin-right:10px;">{$tr->brand|escape}</label>
				<select style="width:200px;" name="brand_id" ID="brand_id">
					<option value='0'>{$tr->not_set|escape}</option>
					{foreach from=$brands item=brand}
					<option value='{$brand->id}' brand_name='{$brand->name|escape}' {if $brand->id ==$brand_id}selected{/if}>{$brand->name|escape}</option>
					{/foreach}
				</select>
				
				<div style="clear:both;margin-bottom:10px;"></div>
				<label style="margin-right:10px;">{$tr->where_stock|escape}:</label>
				<select name="stock_case" style="width:auto;">
					<option value="0"{if $stock_case==0} selected{/if}>{$tr->any|escape}</option>
					<option value="1"{if $stock_case==1} selected{/if}>0</option>
					<option value="2"{if $stock_case==2} selected{/if}>&infin;</option>
					<option value="3"{if $stock_case==3} selected{/if}><0</option>
					<option value="4"{if $stock_case==4} selected{/if}>>0</option>
				</select>
			</div>

			<div style="clear:both"></div>
			<h1>{$tr->pack_price|escape}:</h1>
			<div style="clear:both"></div>
			<label>{$tr->procent_change|escape} &nbsp;</label>
			<input style="width:40px;" name="percent" type="number" value="{$percent}" /> %<br /><br />
			
			<div id="product_categories">
				<label style="width:100px;">{$tr->round|escape}</label>
				<div>
					<select name="round" style="width:auto;">
						<option value="none"> {$tr->dont_round}</option>
						<option value="-3"{if $round==-3} selected{/if}>{$tr->to_thousands}</option>
						<option value="-2"{if $round==-2} selected{/if}>{$tr->to_hundreds}</option>
						<option value="-1"{if $round==-1} selected{/if}>{$tr->to_tens}</option>
						<option value="cel"{if $round=='cel'} selected{/if}>{$tr->to_integer}</option>
						<option value="1"{if $round==1} selected{/if}>1 {$tr->decimal_place}</option>
						<option value="2"{if $round==2} selected{/if}>2 {$tr->decimal_place}</option>
					</select>
				</div>
			</div>
			
			<div id="product_categories">
				<label style="width:100px;">{$tr->old_price_change|escape}</label>
				<div>
					<select name="old_price_mode" style="width:auto;">
						<option value="0"{if $old_price_mode==0} selected{/if}>{$tr->old_price_mode_prop|escape}</option>
						<option value="2"{if $old_price_mode==2} selected{/if}>{$tr->old_price_mode_eq|escape}</option>
						<option value="1"{if $old_price_mode==1} selected{/if}>{$tr->dont_change|escape}</option>
						<option value="3"{if $old_price_mode==3} selected{/if}>{$tr->zeroize|escape}</option>
					</select>
				</div>
			</div>
			
			<div style="clear:both;border-top:2px dashed #bfbaba;padding-top:10px;width:375px;"></div>
			<h1>{$tr->pack_stock|escape}:</h1>
			<div style="clear:both"></div>
			<label style="margin-right:10px;">{$tr->change_stock|escape}?</label>
			<select name="change_stock" style="width:auto;">
				<option value="0"{if $change_stock==0} selected{/if}>{$tr->no|escape}</option>
				<option value="1"{if $change_stock==1} selected{/if}>{$tr->yes|escape}</option>
			</select>
			<div style="clear:both;margin-top:10px;"></div>
			<label>{$tr->set_stock|escape} =&nbsp;</label>
			<input style="width:60px;" name="stock" type="text" value="{$stock}" />
			<p>* {$tr->help_stock|escape}</p>
			<div style="clear:both; padding-bottom:10px;"></div>
			
			{if $settings->variant_discount == '1'}
			<div style="display:table;width:375px;border-top:2px dashed #bfbaba;padding:10px 0;" class="product_categories product_discount">
				<h1>{$tr->pack_discount|escape}:</h1>
			
				<label style="display:inline-block;width:232px;">{$tr->variant_discount|escape}:</label>
				<input style="width:40px;" min=0 class="discount_num" name="discount" type="number" value="{$discount}" /> %
				<br /><br />
				<label style="display:inline-block;width:200px;">{$tr->discount_date|escape}:</label>
				<input class="datetime" name="discount_date" type="text" value="{if !empty($discount_date)}{$discount_date|date} {$discount_date|time}{/if}" autocomplete="off" />
			
				<link rel="stylesheet" type="text/css" href="../../js/jquery/datetime/jquery.datetimepicker.css"/>
				<script src="../../js/jquery/datetime/jquery.datetimepicker.full.min.js"></script>
				<script>
					$('.datetime').datetimepicker({ lang:'ru', format:'d.m.Y H:i' });
					$.datetimepicker.setLocale('ru');
				</script>
			</div>
			{/if}
			
			<input style="margin:20px 0 10px 0;" class="button_green" type="submit" name="sent" value="{$tr->save|escape}" />

		</form>
	</div>		
</div>
