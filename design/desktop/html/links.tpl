{* Список спец ссылок *}

{$canonical="/pages" scope=root}

<!-- Заголовок /-->
<h1>Спец ссылки</h1>
{include file='pagination.tpl'}
<span class="page-pg" itemprop="description">
<!-- Статьи /-->
<ul id="specpages">
	{foreach $links as $link}
	<li>
		<a data-link="{$link->id}" href="pages/{$link->url}">{$link->name|escape}</a>
	</li>
	{/foreach}
</ul>
<!-- Статьи #End /-->    
</span>
{include file='pagination.tpl'}