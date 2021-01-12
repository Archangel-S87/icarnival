$(function() {
	$("<a href='fivecms/' class='admin_bookmark'></a>").appendTo('body');
	tooltip = $("<div class='tooltip'><div class='tooltipHeader'></div><div class='tooltipBody'></div><div class='tooltipFooter'></div></div>").appendTo($('body'));		
	$(document).on('mouseleave','.tooltip', function(){tooltipcanclose=true;setTimeout("close_tooltip();", 300);});
	$(document).on('mouseover','.tooltip', function(){tooltipcanclose=false;});
	$(document).on('mouseover','[data-page]', show_tooltip);	
	$(document).on('mouseover','[data-category]', show_tooltip);
	$(document).on('mouseover','[data-articlescategory]', show_tooltip);
	$(document).on('mouseover','[data-blogcategory]', show_tooltip);
	$(document).on('mouseover','[data-servicescategory]', show_tooltip);
	$(document).on('mouseover','[data-brand]', show_tooltip);
	$(document).on('mouseover','[data-product]', show_tooltip);
	$(document).on('mouseover','[data-post]', show_tooltip);
	$(document).on('mouseover','[data-article]', show_tooltip);
	$(document).on('mouseover','[data-feature]', show_tooltip);
	$(document).on('mouseover','[data-survey]', show_tooltip);
	$(document).on('mouseover','[data-surveyscategory]', show_tooltip);
	$(document).on('mouseover','[data-link]', show_tooltip);
});

function show_tooltip()
{
	tooltipcanclose=false;
	tooltip.show();
	$(document).on('mouseleave',this, function(){tooltipcanclose=true;setTimeout("close_tooltip();", 500);});
	
	flip = !($(this).offset().left+tooltip.width()+25 < $('body').width());

	tooltip.css('top',  $(this).height() + 5 + $(this).offset().top + 'px');
	tooltip.css('left', ($(this).offset().left + $(this).outerWidth()*0.5 - (flip ? tooltip.width()-40 : 0)  + 0) + 'px');
	tooltip.find('.tooltipHeader').addClass(flip ? 'tooltipHeaderFlip' : 'tooltipHeaderDirect').removeClass(flip ? 'tooltipHeaderDirect' : 'tooltipHeaderFlip');

	from = encodeURIComponent(window.location);
	tooltipcontent = '';
	
	if(id = $(this).attr('data-page'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=PageAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
		tooltipcontent += "<a href='fivecms/index.php?module=PageAdmin&return="+from+"' class=admin_tooltip_add>Добавить страницу</a>";
	}
		
	if(id = $(this).attr('data-category'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=CategoryAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
		tooltipcontent += "<a href='fivecms/index.php?module=ProductAdmin&category_id="+id+"&return="+from+"' class=admin_tooltip_add>Добавить товар</a>";
	}

	if(id = $(this).attr('data-articlescategory'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=ArticlesCategoryAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
		tooltipcontent += "<a href='fivecms/index.php?module=ArticlesCategoryAdmin&category_id="+id+"&return="+from+"' class=admin_tooltip_add>Добавить категорию</a>";
	}
	
	if(id = $(this).attr('data-blogcategory'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=BlogCategoryAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
		tooltipcontent += "<a href='fivecms/index.php?module=BlogCategoryAdmin&category_id="+id+"&return="+from+"' class=admin_tooltip_add>Добавить раздел</a>";
	}
	
	if(id = $(this).attr('data-servicescategory'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=ServicesCategoryAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
		tooltipcontent += "<a href='fivecms/index.php?module=ServicesCategoryAdmin&category_id="+id+"&return="+from+"' class=admin_tooltip_add>Добавить услугу</a>";
	}

	if(id = $(this).attr('data-surveyscategory'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=SurveysCategoryAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
		tooltipcontent += "<a href='fivecms/index.php?module=SurveysCategoryAdmin&category_id="+id+"&return="+from+"' class=admin_tooltip_add>Добавить категорию</a>";
	}
	
	if(id = $(this).attr('data-brand'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=BrandAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
	}
	
	if(id = $(this).attr('data-product'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=ProductAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
	}
	
	if(id = $(this).attr('data-post'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=PostAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
	}

	if(id = $(this).attr('data-article'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=ArticleAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
	}
	

	if(id = $(this).attr('data-survey'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=SurveyAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
	}

	if(id = $(this).attr('data-feature'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=FeatureAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
	}

	if(id = $(this).attr('data-link'))
	{
		tooltipcontent = "<a href='fivecms/index.php?module=LinkAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать</a>";
	}
	
	$('.tooltipBody').html(tooltipcontent);
}

function close_tooltip()
{
	if(tooltipcanclose)
	{
		tooltipcanclose=false;
		tooltip.hide();
	}
}

function SetTooltips() {
	elements = document.getElementsByTagName("body")[0].getElementsByTagName("*");

	for (i = 0; i <elements.length; i++)
	{
		tooltip = elements[i].getAttribute('tooltip');
		if(tooltip)
		{
		    elements[i].onmouseout = function(e) {tooltipcanclose=true;setTimeout("CloseTooltip();", 1000);};		
			switch(tooltip)
			{	
				case 'product':					   			   
				   elements[i].onmouseover = function(e) {AdminProductTooltip(this,  this.getAttribute('product_id'));tooltipcanclose=false;}
				break;
				case 'hit':					   			   
				   elements[i].onmouseover = function(e) {AdminHitTooltip(this,  this.getAttribute('product_id'));tooltipcanclose=false;tooltipcanclose=false;}
				break;
				case 'category':					   				   
				   elements[i].onmouseover = function(e) {AdminCategoryTooltip(this,  this.getAttribute('category_id'));tooltipcanclose=false;}
				break;
				case 'news':					   				   
				   elements[i].onmouseover = function(e) {AdminNewsTooltip(this,  this.getAttribute('news_id'));tooltipcanclose=false;}
				break;
				case 'article':					   				   
				   elements[i].onmouseover = function(e) {AdminArticleTooltip(this,  this.getAttribute('article_id'));tooltipcanclose=false;}
				break;
				case 'survey':					   				   
				   elements[i].onmouseover = function(e) {AdminArticleTooltip(this,  this.getAttribute('survey_id'));tooltipcanclose=false;}
				break;
				case 'page':					   				   
				   elements[i].onmouseover = function(e) {AdminPageTooltip(this,  this.getAttribute('id')); tooltipcanclose=false;}
				break;
				case 'currency':					   				   
				   elements[i].onmouseover = function(e) {AdminCurrencyTooltip(this); tooltipcanclose=false;}
				break;
			}


		}
		
	}

}


function ShowTooltip(i, content) {

	tooltip = document.getElementById('tooltip');

	document.getElementById('tooltipBody').innerHTML = content;
	tooltip.style.display = 'block';

	var xleft=0;
	var xtop=0;
	o = i;

	do {
		xleft += o.offsetLeft;
		xtop  += o.offsetTop;

	} while (o=o.offsetParent);

	xwidth  = i.offsetWidth  ? i.offsetWidth  : i.style.pixelWidth;
	xheight = i.offsetHeight ? i.offsetHeight : i.style.pixelHeight;

	bwidth =  tooltip.offsetWidth  ? tooltip.offsetWidth  : tooltip.style.pixelWidth;

	w = window;

	xbody  = document.compatMode=='CSS1Compat' ? w.document.documentElement : w.document.body;
	dwidth = xbody.clientWidth  ? xbody.clientWidth   : w.innerWidth;
	bwidth = tooltip.offsetWidth ? tooltip.offsetWidth  : tooltip.style.pixelWidth;

	flip = !( 25 + xleft + bwidth < dwidth);

	tooltip.style.top  = xheight - 3 + xtop + 'px';
	tooltip.style.left = (xleft - (flip ? bwidth : 0)  + 25) + 'px';

	document.getElementById('tooltipHeader').className = flip ? 'tooltipHeaderFlip' : 'tooltipHeaderDirect';

	return false;
}
