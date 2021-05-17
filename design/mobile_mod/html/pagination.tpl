
{if $total_pages_num>1}


<!-- Листалка страниц -->
<div class="pagination separator">
	
	{$visible_pages = 3}

	{$page_from = 1}
	
	{if $current_page_num > floor($visible_pages/2)}
		{$page_from = max(1, $current_page_num-floor($visible_pages/2)-1)}
	{/if}	
	
	{if $current_page_num > $total_pages_num-ceil($visible_pages/2)}
		{$page_from = max(1, $total_pages_num-$visible_pages-1)}
	{/if}
	
	{$page_to = min($page_from+$visible_pages, $total_pages_num-1)}

	<a data-page="1" {if $current_page_num==1}class="selected"{/if} href="{url page=null}">1</a>
	
	{section name=pages loop=$page_to start=$page_from}
		{$p = $smarty.section.pages.index+1}	
		{if ($p == $page_from+1 && $p!=2) || ($p == $page_to && $p != $total_pages_num-1)}	
		<a data-page="{$p}" {if $p==$current_page_num}class="selected"{/if} href="{url page=$p}">...</a>
		{else}
		<a data-page="{$p}" {if $p==$current_page_num}class="selected"{/if} href="{url page=$p}">{$p}</a>
		{/if}
	{/section}

	<a data-page="{$total_pages_num}" {if $current_page_num==$total_pages_num}class="selected"{/if}  href="{url page=$total_pages_num}">{$total_pages_num}</a>
	
	{*<a class="all" href="{url page=all}">все сразу</a>*}
	{if $current_page_num==2}<a class="prev_page_link" href="{url page=null}"><span class="v-middle"/>&laquo;</span></a>{/if}
	{if $current_page_num>2}<a class="prev_page_link" href="{url page=$current_page_num-1}"><span class="v-middle"/>&laquo;</span></a>{/if}
	{if $current_page_num<$total_pages_num}<a class="next_page_link" href="{url page=$current_page_num+1}"><span class="v-middle"/>&raquo;</span></a>{/if}
	
</div>

{/if}
