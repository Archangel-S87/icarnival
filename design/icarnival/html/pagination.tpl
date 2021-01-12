{* Постраничный вывод *}

{if $total_pages_num>1}        
<!-- incl. pagination -->
              <ul class="pagination list--unstyled justify-content-center row no-gutters">	
	{* Количество выводимых ссылок на страницы *}
	{$visible_pages = 19}

	{* По умолчанию начинаем вывод со страницы 1 *}
	{$page_from = 1}
	
	{* Если выбранная пользователем страница дальше середины "окна" - начинаем вывод уже не с первой *}
	{if $current_page_num > floor($visible_pages/2)}
		{$page_from = max(1, $current_page_num-floor($visible_pages/2)-1)}
	{/if}	
	
	{* Если выбранная пользователем страница близка к концу навигации - начинаем с "конца-окно" *}
	{if $current_page_num > $total_pages_num-ceil($visible_pages/2)}
		{$page_from = max(1, $total_pages_num-$visible_pages-1)}
	{/if}
	
	{* До какой страницы выводить - выводим всё окно, но не более ощего количества страниц *}
	{$page_to = min($page_from+$visible_pages, $total_pages_num-1)}

	{if $current_page_num==2}<li><a class="prev_page_link" href="{url page=null}"><i class="icon-left-arrow"></i></a></li>{/if}
	{if $current_page_num>2}<li><a class="prev_page_link" href="{url page=$current_page_num-1}"><i class="icon-left-arrow"></i></a></li>{/if}

	{* Ссылка на 1 страницу отображается всегда *}
	<li><a {if $current_page_num==1}class="is--active"{/if} href="{url page=null}">1</a></li>
	
	{* Выводим страницы нашего "окна" *}	
	{section name=pages loop=$page_to start=$page_from}
		{* Номер текущей выводимой страницы *}	
		{$p = $smarty.section.pages.index+1}	
		{* Для крайних страниц "окна" выводим троеточие, если окно не возле границы навигации *}	
		{if ($p == $page_from+1 && $p!=2) || ($p == $page_to && $p != $total_pages_num-1)}	
		<li><a {if $p==$current_page_num}class="is--active"{/if} href="{url page=$p}">...</a></li>
		{else}
		<li><a {if $p==$current_page_num}class="is--active"{/if} href="{url page=$p}">{$p}</a></li>
		{/if}
	{/section}

	{* Ссылка на последнююю страницу отображается всегда *}
	<li><a {if $current_page_num==$total_pages_num}class="is--active"{/if}  href="{url page=$total_pages_num}">{$total_pages_num}</a></li>
	
	{*<a href="{url page=all}">все сразу</a>*}

	{if $current_page_num<$total_pages_num}<li><a class="next_page_link" href="{url page=$current_page_num+1}"><i class="icon-right-arrow"></i></a></li>{/if}
	
</ul>
<!-- incl. pagination @ -->
{else}
<br><br>
{/if}
