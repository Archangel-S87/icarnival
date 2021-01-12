{$meta_title = "Сравнение товаров" scope=root}
{$page_name = "Сравнение товаров" scope=root}

{literal}
<style type="text/css">
#comparebody {
display: table; 
vertical-align: middle;
font-family: "Arial", "Helvetica", "Geneva", sans-serif;
font-size: 12px;
height: 100%;
width: 100%;
padding: 0;
margin: 0;
}
#comparebody table { 
border-collapse: collapse;
border-spacing: 0px;
background: transparent;
border: 0px none currentColor;
margin: 0px;
outline: 0px none currentColor;
padding: 0px;
}
#comparebody #list td {
 margin:1px;
 padding:10px;
 border: 1px solid #C0C0C0;
font-size: 11px;
}
#list td#pricecomp {
 margin:1px;
 padding:5px 2px;
 border: 1px solid #C0C0C0;
font-size: 11px;
}
#pricecomp .buttonred {padding: 3px 10px !important; height: 23px !important; font-size: 13px;} 
#list td.image {
margin:0;
padding:0;
min-width: 120px
}
#variants td {
 border: 0;
}
.variants select {max-width: 120px;}
#comparebody img {border: 0;}
p {margin: 5px 0;}
td#annot p {font-size: 10px; text-align: justify;}
#comparebody {
display: table;
   background-color: #FDFDFD;
   vertical-align: middle;
   padding: 5px;
   width: 100%;
margin-bottom: 0px;
}
a.delete {display:inline-block;}
a.delete svg { 
height:30px; width:30px;
}
.features1 tr:nth-child(odd) {background: #F4F4F4;}
tr, td.image {background-color: #FFFFFF;}
tr.variant {background-color: transparent;}
.hideable h3 {font-size:13px; margin-bottom: 0px;}
.hideable h3 a {text-decoration: none;}
.hideable h2 {margin-top: 15px;}
#brandscomp a {text-decoration: none; font-size:13px;}
.complogo {max-width: 200px;}
#comparebody .image img {
max-width: 90px; 
vertical-align: middle; 
margin-bottom: 10px;
-moz-border-radius: 5px;
-webkit-border-radius: 5px;
border-radius: 5px;
}
#comparebody .image {vertical-align: middle; display: table-cell; height: 100px;}
#bottom_compare { 
overflow: hidden;
padding-bottom: 5px;
padding-top: 10px;
width: 100%;
}
#top_compare {width: 1024px; position: relative; margin: 0px auto; text-align: center;}
#btmenu .selected a, #btmenu a:hover { 
background-color: #F5F5F5;
border: 1px solid #D5D5D5;
border-radius: 20px;
text-decoration: none;
}
#btmenu a { 
line-height: 28px;
padding: 5px 10px 6px;
color: #606060;
font-size: 12px;
padding: 6px 11px;
border: 1px solid transparent;
}
.variant td {padding: 0 0 0px 0 !important; }
#account {right: 20px;}
.compareinner input.variant_radiobutton {margin-right: 5px; margin-top: 2px;} 
.compareinner .variant_name {margin-right: 5px;}
.compareinner .compare_price {font-size: 11px; white-space: nowrap;}
.compareinner .price {font-size: 14px; white-space: nowrap;}
.compareinner .currency {font-size: 11px; white-space: nowrap;}
#comparebody #cart_informer {text-align: left !important;}
#comparebody .price {margin: 6px 0;}
#comparebody .image img {max-height: 90px;}
#top_compare #menu li a {color: #505050;}
#top_compare #account a {color: #505050; line-height: 24px;}
#top_compare #cart_informer { 
background-color: #FFFFFF;
border-radius: 15px;
color: #505050;
float: right;
margin-left: 30px;
margin-top: 0px;
padding: 5px 13px;
}
#menu{
	float: left;
	margin-top: 5px;
	max-width: 700px;
}
#menu li{
	height: 30px;
	display: block;
	float: left;
	list-style: none;
}
#menu li a{
	margin-right: 5px;
	font-size: 12px;
	display: block;
	float: left;
	padding: 6px 11px 6px 11px;
	color: #ffffff;
	text-decoration: none;
}
#menu li.selected a, #menu li:hover a{
	border: 1px solid #d5d5d5;
	background-color: #ffffff;
	padding: 5px 10px 6px 10px;
	-moz-border-radius: 20px;
	-webkit-border-radius: 20px;
	border-radius: 20px;
	text-decoration: none;
	color: #505050;
}
.scroll{
   overflow-x:scroll;
   overflow-y:hidden;
}
.scroll_child{
   width:auto !important;
}
.scroll_child > div{
   float:left;
   text-align:center;
}
</style>

<script language="JavaScript">

function toggleCompareDiffProperties(objCheckbox)
{
	var arrObj = $('table.compareinner > tbody > tr').not('.diff').not('.action');

 	if( $(objCheckbox).prop('checked') )
 	{
  	 	arrObj.hide();
 	}
 	else
 	{
   		arrObj.show();
 	}
}

// Скрываем/отображаем колонки
function showHideCompareColumn(objInTd, needShow)
{
 var td = $(objInTd).parents('td:first');
 var index = th.index();

 $('table.compareinner').find('tr.hideable').each(function(rowIndex)
 {
   var td = $(this).find('td').eq(index);
   if(td.length == 0) td = $(this).find('td').eq(index);

   var content = '';//$(td).find('div.hidden').html();
   if(! needShow) content = '<div class="hidden">' + $(td).html() + '</div>&nbsp;';
   else content = $(td).find('div.hidden').html();

   // Нв верхней строке будет кнопочка, чтобы можно было развернуть (это если мы скрываем колонку)
   if(! rowIndex && ! needShow)
   {
    content = '<center><div class="expand" title="Показать скрытый товар" onclick="showHideCompareColumn(this, true); return false"></div></center>' + content;
   }

   $(td).html(content);
 });
}

</script>

<script type="text/javascript">
	$(document).ready(function(){
		var quqntity=$(".scroll_child div").length;
		var widthScroll=0;
		for (i=0;i<quqntity;i++){
			widthScroll+=$(".scroll_child div:eq("+i+")").width();
		}
		$(".scroll_child").width(widthScroll);
	});
</script>
{/literal}

<div class="page-pg">

	{if !empty($page->body)}{$page->body}{/if}
	
	<div class="scroll">
		 <div class="scroll_child">
	
			<div id="comparebody">
			<table bgcolor="#fff" id="list" class="compareinner">
			<thead>
				<tr class="hideable">
					<td align="center" valign="top" style="border: 0px !important;" height="120">
						{if $compare->total>1}
						<br />
						<label><input type="checkbox" onclick="toggleCompareDiffProperties(this)"> показать только отличия</label><br />
						{/if}
					</td>
				{if $compare->total>0}
	
					{foreach $compare->products as $product}
				   <td align="center" class="image" valign="top" width="{100/$compare->total}%">
					   <div style="position: relative; text-align: right; margin: 0px 0px 3px 0;">
							<a class="delete" href='compare/remove/{$product->id}'>
								<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
									<path d="M0 0h24v24H0z" fill="none"/>
									<path d="M14.59 8L12 10.59 9.41 8 8 9.41 10.59 12 8 14.59 9.41 16 12 13.41 14.59 16 16 14.59 13.41 12 16 9.41 14.59 8zM12 2C6.47 2 2 6.47 2 12s4.47 10 10 10 10-4.47 10-10S17.53 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/>
								</svg>
							</a>
					   </div>
					   <div style="padding: 10px; display: table;">
					   <!-- Фото товара -->
							<div class="image">
								{if !empty($product->image)}
									<img src="{$product->image|resize:100:100}" alt="{$product->name|escape}"/>
								{else}
									<svg class="nophoto"><use xlink:href='#no_photo' /></svg>
								{/if}
							</div>
						<!-- Фото товара (The End) -->
					   </div>
				   </td>
				   {/foreach}
	
				</tr>
	
				<tr class="hideable">
					<td>Название</td>
					{foreach $compare->products as $product}
						<td class=""><h3><a data-product="{$product->id}" href="products/{$product->url}">{$product->name|escape}</a></h3>
						</td>
						{if $compare->total<2}
							{literal}
							<style>
							.compareinner {margin: 0 auto;}
							</style>
							{/literal}
						{/if}
					{/foreach}
				</tr>
	
				<tr class="hideable">
					<td>Производитель</td>
					{foreach $compare->products as $product}
					<td id="brandscomp" class=""><a href="brands/{$product->brand_url}">{$product->brand|escape}</a></td>
					{/foreach}
				</tr>
	
			</thead>
	
			{if $compare->features}
				<tbody class="features1">
				{foreach from=$compare->features key=k item=i}
				<tr {if !empty($i.diff)}class='diff hideable'{/if}>
				<td {if !empty($i.diff)}class='diff'{/if}>{$k|escape}</td>
				{foreach from=$i.items item=ii}
				 <td class="">
				   {$ii}
				 </td>
				{/foreach}
				</tr>
				{/foreach}
				</tbody>
			{/if}
	
			<tfoot>
	
				<tr class="hideable">
				<td>Рейтинг</td>
				{foreach $compare->products as $product}
				{if isset($product->rating) && $product->rating > 0}
					{$prod_rating = $product->rating}
				{else}
					{$prod_rating = $settings->prods_rating|floatval}
				{/if}
				<td class="">
				<!-- rating -->
					<div id="product_{$product->id}">
						<div class="statVal">
							<span class="rater_sm">
								<span class="rater-starsOff_sm" style="width:60px;">
									<span class="rater-starsOn_sm" style="width:{$prod_rating*60/5|string_format:"%.0f"}px"></span>
								</span>
							</span>
						</div>
					</div>
				<!-- rating (The End) -->
				</td>
				{/foreach}
				</tr>
	
				<tr class="hideable">
					<td>Цена</td>
					{foreach $compare->variants as $variant}
						<td id="pricecomp" class="">
							{if !empty($variant)}
							<form class="variants" action="/cart">
									{if $variant|count==1  && !isset($variant->name)}<span style="display: block; height: 23px;"></span>{/if}
									<select class="b1c_option" name="variant" {if $variant|count==1  && !isset($variant->name)}style='display:none;'{/if}>
										{foreach $variant as $v}
											<option value="{$v->id}" {if $v->compare_price > 0}compare_price="{$v->compare_price|convert}"{/if} price="{$v->price|convert}" click="{$v->name}">
											{$v->name}
											</option>
										{/foreach}
									</select>
								
								<div class="price">
									{foreach $variant as $v}{if $v@first}
									<span class="price">{$v->price|convert}</span>
									<span class="currency">{$currency->sign|escape}</span>{/if}{/foreach}
								</div>
							</form>
							{else}
								<div style="margin-top: 21px; margin-bottom: 20px;">Нет в наличии</div>
							</form>
							{/if}
						</td>
					{/foreach}
				</tr>
	
				{else}
				<td width="100%" style="padding:20px; border: 0px !important;" align="center"><h2>Сейчас нет товаров для сравнения</h2></td>
				</tr>
				{/if}
			</tfoot>
			</table>
	
			</div>
	
			</div>
	</div>

</div>

{if !empty($compare->total)}
	<div class="separator" style="height:60px; padding:0 15px 15px 15px;">
		{literal}
		<a name="#" onclick="if (document.referrer) { location.href=document.referrer } else { history.go(-1) }" class="buttonblue">Вернуться</a>
		{/literal}
	</div>
{else}
	<div class="have-no comphaveno separator">
		<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
		    <path d="M0 0h24v24H0zm0 0h24v24H0z" fill="none"/>
		    <path d="M10 6.35V4.26c-.8.21-1.55.54-2.23.96l1.46 1.46c.25-.12.5-.24.77-.33zm-7.14-.94l2.36 2.36C4.45 8.99 4 10.44 4 12c0 2.21.91 4.2 2.36 5.64L4 20h6v-6l-2.24 2.24C6.68 15.15 6 13.66 6 12c0-1 .25-1.94.68-2.77l8.08 8.08c-.25.13-.5.25-.77.34v2.09c.8-.21 1.55-.54 2.23-.96l2.36 2.36 1.27-1.27L4.14 4.14 2.86 5.41zM20 4h-6v6l2.24-2.24C17.32 8.85 18 10.34 18 12c0 1-.25 1.94-.68 2.77l1.46 1.46C19.55 15.01 20 13.56 20 12c0-2.21-.91-4.2-2.36-5.64L20 4z"/>
		</svg>
	</div>
{/if}

{literal}
<script>
	if (document.referrer) {history.replaceState(null, null, document.referrer)} else {history.replaceState(null, null, '/catalog')};

	$(function() {
		adjustCatalogElements2();
		$(window).resize(function() {
			adjustCatalogElements2();
		});
	});
	function adjustCatalogElements2() {
		var bw = $(window).width() - 35;
		$(".scroll").css({"width" : bw});
	}
</script>
{/literal}


