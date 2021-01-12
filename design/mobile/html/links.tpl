{* Список спец ссылок *}

{$canonical="/pages" scope=root}

{include file='pagination.tpl'}
<div class="page-pg" itemprop="description">
	<ul id="specpages">
		{foreach $links as $link}
		<li>
			<a data-link="{$link->id}" href="pages/{$link->url}">{$link->name|escape}</a>
		</li>
		{/foreach}
	</ul>
</div>
{include file='pagination.tpl'}