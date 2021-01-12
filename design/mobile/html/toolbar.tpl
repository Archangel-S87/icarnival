<!-- incl. toolbar -->
<div id="menutop">
	<div id="menutopbody">
		<div id="catalog" onclick="hideShowMenu(this);return false;">
			<svg height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
				<path d="M0 0h24v24H0z" fill="none"/>
				<path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z"/>
			</svg>
		</div>
		<div id="menutoptitle">
			{$settings->site_name|escape}
		</div>
		{if $settings->purpose == 0 || in_array($module, array('CartView', 'OrderView', 'ProductView', 'ProductsView'))}
			<div id="cart_informer" onclick="window.location='cart'">
				{include file='cart_informer.tpl'}
			</div>
		{/if}
		<div id="searchblock" onclick="hideShowSearch(this);return false;">
			<svg class="hideloupe" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
				<path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
				<path d="M0 0h24v24H0z" fill="none"/>
			</svg>
			<svg style="display:none" class="hidecross" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
				<path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
				<path d="M0 0h24v24H0z" fill="none"/>
			</svg>
		</div>
	</div>
</div>

<div id="searchtop" style="display:none;">
	<div id="searchtopbody">
		<div id="search">
			{if $module == 'BlogView'}
				<form action="blog">
					{*<input class="button_search" value="" type="submit"/>*}
					<input class="input_search" type="text" name="keyword" value="{if isset($keyword)}{$keyword|escape}{/if}" placeholder="Поиск в блоге" autocomplete="off"/>
				</form>
			{elseif $module == 'ArticlesView'}
				<form action="articles">
					<input class="input_search" type="text" name="keyword" value="{if isset($keyword)}{$keyword|escape}{/if}" placeholder="Поиск в статьях" autocomplete="off"/>
				</form>
			{elseif $module == 'ServicesView'}
				<form action="services">
					<input class="input_search" type="search" name="keyword" value="{if isset($keyword)}{$keyword|escape}{/if}" placeholder="Поиск в услугах" autocomplete="off"/>
				</form>
			{else}
				{if $settings->purpose == 0 || in_array($module, array('ProductView', 'ProductsView', 'CartView', 'OrderView', 'BrowsedView', 'CompareView', 'WishlistView'))}
					<form action="products">
						<input class="input_search newsearch" type="search" name="keyword" value="{if isset($keyword)}{$keyword|escape}{/if}" placeholder="Поиск товара" autocomplete="off"/>
					</form>
				{elseif $settings->purpose == 1}
					<form action="services">
						<input class="input_search" type="search" name="keyword" value="{if isset($keyword)}{$keyword|escape}{/if}" placeholder="Поиск в услугах" autocomplete="off"/>
					</form>
				{/if}
			{/if}
		</div>
	</div>
</div>

<div id="catalogtop">
	<div id="logo">
		<img onclick="window.location='/'" src="files/logo/logo.png?v={filemtime('files/logo/logo.png')}" title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}" />
	</div>
	<div id="catalogtopbody">
		{if $module == 'ArticlesView'}
			{include file='marticlescat.tpl'}
			{if !empty($categories)}
			<ul class="dropdown-menu svg">
				<li>
					<svg height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
					    <path d="M0 0h24v24H0z" fill="none"/>
					    <path d="M20 13H4c-.55 0-1 .45-1 1v6c0 .55.45 1 1 1h16c.55 0 1-.45 1-1v-6c0-.55-.45-1-1-1zM7 19c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zM20 3H4c-.55 0-1 .45-1 1v6c0 .55.45 1 1 1h16c.55 0 1-.45 1-1V4c0-.55-.45-1-1-1zM7 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z"/>
					</svg>
					<a href="{if $settings->purpose == 0}catalog{else}services{/if}" title="Каталог">Каталог</a>
				</li>
			</ul>
			{/if}
		{elseif $module == 'ServicesView'}
			{include file='mservicescat.tpl'}
			{if !empty($categories) && $settings->purpose == 0}
			<ul class="dropdown-menu svg">
				<li>
					<svg height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
					    <path d="M0 0h24v24H0z" fill="none"/>
					    <path d="M20 13H4c-.55 0-1 .45-1 1v6c0 .55.45 1 1 1h16c.55 0 1-.45 1-1v-6c0-.55-.45-1-1-1zM7 19c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zM20 3H4c-.55 0-1 .45-1 1v6c0 .55.45 1 1 1h16c.55 0 1-.45 1-1V4c0-.55-.45-1-1-1zM7 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z"/>
					</svg>
					<a href="catalog" title="Каталог">Каталог</a>
				</li>
			</ul>
			{/if}
		{elseif $module == 'BlogView' && !empty($blog_categories)}
			{include file='mblog_cat.tpl'}
			{if !empty($categories)}
			<ul class="dropdown-menu svg">
				<li>
					<svg height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
					    <path d="M0 0h24v24H0z" fill="none"/>
					    <path d="M20 13H4c-.55 0-1 .45-1 1v6c0 .55.45 1 1 1h16c.55 0 1-.45 1-1v-6c0-.55-.45-1-1-1zM7 19c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zM20 3H4c-.55 0-1 .45-1 1v6c0 .55.45 1 1 1h16c.55 0 1-.45 1-1V4c0-.55-.45-1-1-1zM7 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z"/>
					</svg>
					<a href="{if $settings->purpose == 0}catalog{else}services{/if}" title="Каталог">Каталог</a>
				</li>
			</ul>
			{/if}
		{elseif $settings->purpose == 0 || in_array($module, array('ProductView', 'ProductsView', 'CartView', 'OrderView', 'BrowsedView', 'CompareView', 'WishlistView'))}
			{include file='mcatalog.tpl'}
			{if !empty($settings->show_brands)}
			<ul class="dropdown-menu svg">
				<li {if isset($page->url) && $page->url == "brands"}class="selected"{/if}>				
					<svg class="compareempty" viewBox="0 0 24 24"><use xlink:href='#brands' /></svg>
					<a href="brands" title="Бренды">Бренды</a>
				</li>
			</ul>
			{/if}
		{elseif $settings->purpose == 1}
			{include file='mservicescat.tpl'}
		{/if}
		{if $menus[17]->enabled}
		<ul class="dropdown-menu svg">
			<li {if isset($page->url) && $page->url == "m-info"}class="selected"{/if}>				
				<svg height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
				    <path d="M0 0h24v24H0z" fill="none"/>
				    <path d="M11 17h2v-6h-2v6zm1-15C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zM11 9h2V7h-2v2z"/>
				</svg>
				<a href="m-info" title="{$menus[17]->name|escape}">{$menus[17]->name|escape}</a>
			</li>
		</ul>
		{/if}
		{get_pages var="pag" menu_id=1}
		{if $pag}
			<ul class="dropdown-menu svg">
				{foreach $pag as $p}
					<li {if isset($page->id) && $page->id == $p->id}class="selected"{/if}>
						<svg class="nophoto"><use xlink:href='#arrow_tool' /></svg>
						<a href="{$p->url}" title="{$p->name|escape}">{$p->name|escape}</a>
					</li>
				{/foreach}
			</ul>
		{/if}
		{if $settings->purpose == 0 || in_array($module, array('ProductView', 'ProductsView', 'CartView', 'OrderView', 'BrowsedView', 'CompareView', 'WishlistView'))}
		<ul class="dropdown-menu svg">
			<li>
				<svg class="nophoto"><use xlink:href='#arrow_tool' /></svg>
				<a href="wishlist" title="Избранное">Избранное</a>
			</li>
			<li>
				<svg class="nophoto"><use xlink:href='#arrow_tool' /></svg>
				<a href="compare" title="Сравнение">Сравнение</a>
			</li>
			<li>
				<svg class="nophoto"><use xlink:href='#arrow_tool' /></svg>
				<a href="browsed" title="Просмотренные товары">Просмотренные товары</a>
			</li>
		</ul>
		{/if}
		<ul class="dropdown-menu svg usermenu">
			<li>
				<svg height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
				    <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
				    <path d="M0 0h24v24H0z" fill="none"/>
				</svg>
				<a href="user" title="Личный кабинет">Личный кабинет</a>
			</li>
			{if $settings->purpose == 0 || in_array($module, array('ProductView', 'ProductsView', 'CartView', 'OrderView', 'BrowsedView', 'CompareView', 'WishlistView'))}
			<li>
				<svg height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
				    <path d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1zm16 16c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"/>
				    <path d="M0 0h24v24H0z" fill="none"/>
				</svg>
				<a href="cart" title="Корзина">Корзина</a>
			</li>
			{/if}
		</ul>
	</div>
</div>

<div id="catoverlay" style="display:none;" onclick="hideShowOverlay(this);return false;">
</div>
<!-- incl. toolbar @ -->