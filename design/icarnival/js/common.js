$(function() {

	/*----------  Main slider  ----------*/
	(function mainSlider(){
		var slider = $('.jsMainSlider');

		slider.slick({
			prevArrow: '<button type="button" class="slick-prev"><i class="icon-left-arrow"></i></button>',
			nextArrow: '<button type="button" class="slick-next"><i class="icon-right-arrow"></i></button>'
		});
	})();


	/*----------  product-slider  ----------*/
	(function productSlider(){
		var slider = $('.jsProductSlider');

		slider.slick({
			slidesToShow: 4,
  			slidesToScroll: 1,
			prevArrow: '<button type="button" class="slick-prev"><i class="icon-left-arrow"></i></button>',
			nextArrow: '<button type="button" class="slick-next"><i class="icon-right-arrow"></i></button>',
			responsive: [
			    {
			      	breakpoint: 1300,
			      	settings: {
			        	slidesToShow: 3,
			        	slidesToScroll: 1
			      	}
			    },
			    {
			      	breakpoint: 991,
			      	settings: {
			        	slidesToShow: 2,
			        	slidesToScroll: 1
			      	}
			    },
			    {
			      	breakpoint: 600,
			      	settings: {
			        	slidesToShow: 1,
			      	}
			    }
			]
		});
	})();

	/*----------  product-slider 3  ----------*/
	(function productSlider3(){
		var slider = $('.jsProductSlider3');

		slider.slick({
			slidesToShow: 3,
  			slidesToScroll: 1,
			prevArrow: '<button type="button" class="slick-prev"><i class="icon-left-arrow"></i></button>',
			nextArrow: '<button type="button" class="slick-next"><i class="icon-right-arrow"></i></button>',
			responsive: [
			    {
			      	breakpoint: 1300,
			      	settings: {
			        	slidesToShow: 2,
			        	slidesToScroll: 1
			      	}
			    },
			    {
			      	breakpoint: 600,
			      	settings: {
			        	slidesToShow: 1,
			      	}
			    }
			]
		});
	})();

	/*----------  catlaog menu  ----------*/
	(function catalogMenu(){
		var btn = $('.jsCatalogMenu');

		btn.click(function() {
			$(this).next().slideToggle();
			$('.jsFilterToggleContent').hide();
		});

		$('.jsCatalogMenuTogglebtn').click(function(){
			$(this).next().slideToggle();
			$(this).toggleClass('is--active');
			
		});
	})();


	/*----------  mobile bar ----------*/
	(function mobileBar(){
		var btn = $('.jsMobileBarToggle'),
			content = $('.jsMobileBarContent');

		btn.click(function() {
			if(content.css('display') == 'none') {
				content.slideDown();
				btn.find('i').attr('class', 'icon-close');
				$('.jsFilterToggleContent').hide();
			}
			else{
				content.slideUp();
				btn.find('i').attr('class', 'icon-list-menu');
			}		
			
		});

	})();

	/*---------- Mobile search ------*/
	(function mobileSearch(){
		var btn = $('.jsSearchBtn'),
			content = $('.jsSearchContent'),
			blockout = $('.blockout');

		btn.click(function() {
			content.show();
			blockout.show();
			content.find('input').focus()
		});

		blockout.click(function() {
			content.hide();
			$(this).hide();
		});

	})();

	/*---------- Filter ------*/
	(function filter(){
		var btn = $('.jsFilterToggleSectionBtn'),
			content = $('.jsFilterToggleSection');

		btn.click(function() {
			$(this).toggleClass('is--active').next(content).slideToggle();
		});

	})();


	(function filterMobile(){
		var btn = $('.jsFilterToggleBtn'),
			content = $('.jsFilterToggleContent'),
			body = $('body');

		btn.click(function() {
			content.slideToggle();
			body.toggleClass('is--fixed');
			$('.jsCatalogMenu').next().hide();
		});

	})();

	(function singleProductThumbSlider (){
		var sliderFor = $('.jsProductSingleThumb'),
			sliderNav = $('.jsProductSingleThumbNav');

		sliderFor.slick({
			slidesToShow: 1,
			slidesToScroll: 1,
			arrows: false,
			fade: true,
			asNavFor: '.jsProductSingleThumbNav'
		});
		sliderNav.slick({
			slidesToShow: 4,
			slidesToScroll: 1,
			asNavFor: '.jsProductSingleThumb',
			dots: false,
			arrows: false,
			nav: false,
			focusOnSelect: true,

			responsive: [
			    {
			      	breakpoint: 1200,
			      	settings: {
			        	slidesToShow: 3,
			        	slidesToScroll: 1
			      	}
			    },
			    {
			      	breakpoint: 767,
			      	settings: {
			        	slidesToShow: 4,
			      	}
			    },
			    {
			      	breakpoint: 567,
			      	settings: {
			        	slidesToShow: 3,
			      	}
			    }
			]
		});

	})();

	/*(function singleProductThumbSlider (){

		var btn = $('.jsRefresProductSlider'),
			slider = $('.jsProductSingleThumb');

		btn.click(function() {
		console.log(btn)
		//alert("AAA")
			id = btn.data('id');
			alert(id)
			$('#product_ajax').load('products_ajax/' + id);

			$(window).trigger('resize');
		});	

	})(); */

(function singleProductThumbSlider (){

		var btn = $('.jsRefresProductSlider'),
			slider = $('.jsProductSingleThumb');

		$('.jsRefresProductSlider').click(function() {
		//console.log(btn)
		//alert("AAA")
			id = $(this).data('id');
			//alert(id)
			$('#product_ajax').load('products_ajax/' + id);
		var sliderFor = $('.jsProductSingleThumb'),
			sliderNav = $('.jsProductSingleThumbNav');

		sliderFor.slick({
			slidesToShow: 1,
			slidesToScroll: 1,
			arrows: false,
			fade: true,
			asNavFor: '.jsProductSingleThumbNav'
		});
		sliderNav.slick({
			slidesToShow: 4,
			slidesToScroll: 1,
			asNavFor: '.jsProductSingleThumb',
			dots: false,
			arrows: false,
			nav: false,
			focusOnSelect: true,

			responsive: [
			    {
			      	breakpoint: 1200,
			      	settings: {
			        	slidesToShow: 3,
			        	slidesToScroll: 1
			      	}
			    },
			    {
			      	breakpoint: 767,
			      	settings: {
			        	slidesToShow: 4,
			      	}
			    },
			    {
			      	breakpoint: 567,
			      	settings: {
			        	slidesToShow: 3,
			      	}
			    }
			]
		});
			$(window).trigger('resize');
		});	

	})();

	/*(function singleProductThumbSlider (){

		var stepsSlider = document.getElementById('steps-slider');
		var input0 = document.getElementById('input-with-keypress-0');
		var input1 = document.getElementById('input-with-keypress-1');
		var inputs = [input0, input1];

		noUiSlider.create(stepsSlider, {
		    start: [20, 80],
		    connect: true,
		    range: {
		        'min': 0,
		        'max': 100
		    }
		});

		stepsSlider.noUiSlider.on('update', function (values, handle) {
		    inputs[handle].value = values[handle];
		});

	})();*/

});
// Size-Color
$(document).ready(function(){
	function trysplit(){
		try{
			$(".p0").each(function(n,elem){chpr(elem,0)});
		} catch(e) {window.location.replace(window.location);}
	}
	trysplit();
	$(".p0").change(function(){chpr(this,0)});
	$(".p1").change(function(){chpr(this,1)});
})
function chpr(el,num){
elem=$(el).closest('.variants')
elem.find('button[type="submit"]').html('<span class="btn__icon"><i class="icon-shopping-cart"></i></span><span>В корзину</span>');
if(num==0){
	a=$(elem).find('.p0').val().split(' ')
	$(elem).find('.p1 option').prop('disabled',true)
	for(i=0;i<a.length;i++){$(elem).find('.p1 .'+a[i]).prop('disabled',false)}chpr(el,1)
}else{
sel=$(elem).find('.p1 option:selected').prop('disabled')
if(sel){$(elem).find('.p1 .'+a[i]).prop('selected')
a=$(elem).find('.p0').val().split(' ')
for(i=0;i<a.length;i++){if(!$(elem).find('.p1 .'+a[i]).prop('disabled')){$(elem).find('.p1 .'+a[i]).prop('selected',true);break;}}}z='';a0=$(elem).find('.p0').val().split(' ')
a1=$(elem).find('.p1').val().split(' ')
for(i0=0;i0<a0.length;i0++){for(i1=0;i1<a1.length;i1++){if(a0[i0]==a1[i1])z=a0[i0]}}$(elem).find('.vhidden').val(z.substring(1,z.length))
$(elem).find('.price').html($(elem).find('.pricelist .'+z).html());
$(elem).find('.unit').html($(elem).find('.pricelist .'+z).attr('data-unit'));
$(elem).find('.bonusnum').html($(elem).find('.pricelist .'+z).attr('data-bonus'));
$(elem).find('.sku').html($(elem).find('.pricelist .'+z).attr('data-sku'));
$(elem).find('.stock').html($(elem).find('.pricelist .'+z).attr('data-stock'));
compare_price=$(elem).find('.pricelist2 .'+z).html();if(compare_price==null) compare_price='';
$(elem).find('.compare_price').html(compare_price);
maxamount=parseInt($(elem).find('.pricelist .'+z).attr('data-stock'));$('.productview #amount .amount').attr('data-max',maxamount);if($.isNumeric(maxamount)){oldamount=parseInt($('.productview #amount .amount').val());if(oldamount>maxamount)$('.productview #amount .amount').val(maxamount);}}}
// Clicker
function clicker(that){var pick=that.options[that.selectedIndex].value;location.href=pick;};
// Toggle text
$.fn.extend({toggleText:function(a,b){return this.text(this.text()==b?a:b);}});
// Wish Compare
$(document).ready(function(){$(document).on('click','.towish .basewc',function(){var button=$(this);$.ajax({url:"ajax/wishlist.php",data:{id:$(this).attr('data-wish')},success:function(data){$('#wishlist').html(data);button.parent().find('.basewc').hide();button.parent().find('.activewc').show();}});return false;});
$(document).on('click','#wishlist a.delete', function(){$.ajax({url:"ajax/wishlist.php",data:{id:$(this).attr('data-wish'),action:$(this).attr('delete')},});return false;});});$(document).on('click','.compare .basewc',function(){var val=$(this).attr('data-wish');var bl=$(this).closest('.compare');var button2=$(this);$.ajax({url:"ajax/compare.php",data:{compare:val},dataType:'json',success:function(data){if(data){$('#compare_informer').html(data);button2.parent().find('.basewc').hide();button2.parent().find('.activewc').show();}}});return false;
});
// Change on variant select: price, old price, stock, units, sku, bonus points  
$(function() {
    $(document).on('change', 'select[name=variant]', function() {
elem=$(this).closest('.variants')
elem.find('button[type="submit"]').html('<span class="btn__icon"><i class="icon-shopping-cart"></i></span><span>В корзину</span>');
        price = $(this).find('option:selected').attr('data-varprice');
        sku = '';
        unit = '';
        bonus = '';
        sku = $(this).find('option:selected').attr('data-sku');
        unit = $(this).find('option:selected').attr('data-unit');
        bonus = $(this).find('option:selected').attr('data-bonus');
        stock = $(this).find('option:selected').attr('data-stock');
        compare_price = '';
        if (typeof $(this).find('option:selected').attr('data-cprice') == 'string') compare_price = $(this).find('option:selected').attr('data-cprice');
        $(this).closest('form').find('span.price').html(price);
        $(this).closest('form').find('span.compare_price').html(compare_price);
        $(this).closest('form').find('.sku').html(sku);
        $(this).closest('form').find('.unit').html(unit);
        $(this).closest('form').find('.bonusnum').html(bonus);
        $(this).closest('form').find('.stock').html(stock);
        $(this).closest('form').find('button').html('<span class="btn__icon"><i class="icon-shopping-cart"></i></span><span>В Корзину</span>');
        return false;
    });
});
document.onkeydown = NavigateThrough;

function NavigateThrough(event) {
    if (!document.getElementsByClassName) return;
    if (window.event) event = window.event;
    if (event.ctrlKey) {
        var link = null;
        var href = null;
        switch (event.keyCode ? event.keyCode : event.which ? event.which : null) {
            case 0x25:
                link = document.getElementsByClassName('prev_page_link')[0];
                break;
            case 0x27:
                link = document.getElementsByClassName('next_page_link')[0];
                break;
        }
        if (link && link.href) document.location = link.href;
        if (href) document.location = href;
    }
};
// add to cart
$(document).on('submit', 'form.variants', function(e) {
    e.preventDefault();
    button = $(this).find('button[type="submit"]');
    if ($(this).find('input[name=variant]:checked').length > 0) variant = $(this).find('input[name=variant]:checked').val();
    else if ($(this).find('input[name=variant]').length > 0) variant = $(this).find('input[name=variant]').val();
    if ($(this).find('select[name=variant]').length > 0) variant = $(this).find('select').val();
    //amount = Number($(this).find('input[name="amount"]').val());
    //if (amount == 0) amount = 1;
    amount = 1;
    console.log(variant)
    $.ajax({
        url: "ajax/cart.php",
        data: {
            variant: variant,
            'mode': 'add',
            amount: amount
        },
        dataType: 'json',
        success: function(data) {
        //console.log(data)
            $('#cart_informer').html(data);
            //$('#cart_informer').append(data);
            //if (button.attr('data-result-text')) button.val(button.attr('data-result-text'));
            button.html('<span class="btn__icon"><i class="icon-shopping-cart"></i></span><span>Добавлено</span>');
            //if (popup_cart) 
            $.fancybox({
                'href': '#data',
                'showCloseButton': 'false',
                scrolling: 'no'
            });
        }
    });
    return false;
});

// autocomplete
/**
*  Ajax Autocomplete for jQuery, version 1.2.9
*  (c) Tomas Kirda
*  Ajax Autocomplete for jQuery is freely distributable under the terms of an MIT-style license.
*  For details, see the web site: https://github.com/devbridge/jQuery-Autocomplete
*/
(function(d){"function"===typeof define&&define.amd?define(["jquery"],d):d(jQuery)})(function(d){function g(a,b){var c=function(){},c={autoSelectFirst:!1,appendTo:"body",serviceUrl:null,lookup:null,onSelect:null,width:"auto",minChars:1,maxHeight:300,deferRequestBy:0,params:{},formatResult:g.formatResult,delimiter:null,zIndex:9999,type:"GET",noCache:!1,onSearchStart:c,onSearchComplete:c,onSearchError:c,containerClass:"autocomplete-suggestions",tabDisabled:!1,dataType:"text",currentRequest:null,triggerSelectOnValidInput:!0,
lookupFilter:function(a,b,c){return-1!==a.value.toLowerCase().indexOf(c)},paramName:"query",transformResult:function(a){return"string"===typeof a?d.parseJSON(a):a}};this.element=a;this.el=d(a);this.suggestions=[];this.badQueries=[];this.selectedIndex=-1;this.currentValue=this.element.value;this.intervalId=0;this.cachedResponse={};this.onChange=this.onChangeInterval=null;this.isLocal=!1;this.suggestionsContainer=null;this.options=d.extend({},c,b);this.classes={selected:"autocomplete-selected",suggestion:"autocomplete-suggestion"};
this.hint=null;this.hintValue="";this.selection=null;this.initialize();this.setOptions(b)}var k=function(){return{escapeRegExChars:function(a){return a.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g,"\\$&")},createNode:function(a){var b=document.createElement("div");b.className=a;b.style.position="absolute";b.style.display="none";return b}}}();g.utils=k;d.Autocomplete=g;g.formatResult=function(a,b){var c="("+k.escapeRegExChars(b)+")";return a.value.replace(RegExp(c,"gi"),"<strong>$1</strong>")};g.prototype=
{killerFn:null,initialize:function(){var a=this,b="."+a.classes.suggestion,c=a.classes.selected,e=a.options,f;a.element.setAttribute("autocomplete","off");a.killerFn=function(b){0===d(b.target).closest("."+a.options.containerClass).length&&(a.killSuggestions(),a.disableKillerFn())};a.suggestionsContainer=g.utils.createNode(e.containerClass);f=d(a.suggestionsContainer);f.appendTo(e.appendTo);"auto"!==e.width&&f.width(e.width);f.on("mouseover.autocomplete",b,function(){a.activate(d(this).data("index"))});
f.on("mouseout.autocomplete",function(){a.selectedIndex=-1;f.children("."+c).removeClass(c)});f.on("click.autocomplete",b,function(){a.select(d(this).data("index"))});a.fixPosition();a.fixPositionCapture=function(){a.visible&&a.fixPosition()};d(window).on("resize.autocomplete",a.fixPositionCapture);a.el.on("keydown.autocomplete",function(b){a.onKeyPress(b)});a.el.on("keyup.autocomplete",function(b){a.onKeyUp(b)});a.el.on("blur.autocomplete",function(){a.onBlur()});a.el.on("focus.autocomplete",function(){a.onFocus()});
a.el.on("change.autocomplete",function(b){a.onKeyUp(b)})},onFocus:function(){this.fixPosition();if(this.options.minChars<=this.el.val().length)this.onValueChange()},onBlur:function(){this.enableKillerFn()},setOptions:function(a){var b=this.options;d.extend(b,a);if(this.isLocal=d.isArray(b.lookup))b.lookup=this.verifySuggestionsFormat(b.lookup);d(this.suggestionsContainer).css({"max-height":b.maxHeight+"px",width:b.width+"px","z-index":b.zIndex})},clearCache:function(){this.cachedResponse={};this.badQueries=
[]},clear:function(){this.clearCache();this.currentValue="";this.suggestions=[]},disable:function(){this.disabled=!0;this.currentRequest&&this.currentRequest.abort()},enable:function(){this.disabled=!1},fixPosition:function(){var a;"body"===this.options.appendTo&&(a=this.el.offset(),a={top:a.top+this.el.outerHeight()+"px",left:a.left+"px"},"auto"===this.options.width&&(a.width=this.el.outerWidth()-2+"px"),d(this.suggestionsContainer).css(a))},enableKillerFn:function(){d(document).on("click.autocomplete",
this.killerFn)},disableKillerFn:function(){d(document).off("click.autocomplete",this.killerFn)},killSuggestions:function(){var a=this;a.stopKillSuggestions();a.intervalId=window.setInterval(function(){a.hide();a.stopKillSuggestions()},50)},stopKillSuggestions:function(){window.clearInterval(this.intervalId)},isCursorAtEnd:function(){var a=this.el.val().length,b=this.element.selectionStart;return"number"===typeof b?b===a:document.selection?(b=document.selection.createRange(),b.moveStart("character",
-a),a===b.text.length):!0},onKeyPress:function(a){if(!this.disabled&&!this.visible&&40===a.which&&this.currentValue)this.suggest();else if(!this.disabled&&this.visible){switch(a.which){case 27:this.el.val(this.currentValue);this.hide();break;case 39:if(this.hint&&this.options.onHint&&this.isCursorAtEnd()){this.selectHint();break}return;case 9:if(this.hint&&this.options.onHint){this.selectHint();return}case 13:if(-1===this.selectedIndex){this.hide();return}this.select(this.selectedIndex);if(9===a.which&&
!1===this.options.tabDisabled)return;break;case 38:this.moveUp();break;case 40:this.moveDown();break;default:return}a.stopImmediatePropagation();a.preventDefault()}},onKeyUp:function(a){var b=this;if(!b.disabled){switch(a.which){case 38:case 40:return}clearInterval(b.onChangeInterval);if(b.currentValue!==b.el.val())if(b.findBestHint(),0<b.options.deferRequestBy)b.onChangeInterval=setInterval(function(){b.onValueChange()},b.options.deferRequestBy);else b.onValueChange()}},onValueChange:function(){var a=
this.options,b=this.el.val(),c=this.getQuery(b);this.selection&&(this.selection=null,(a.onInvalidateSelection||d.noop).call(this.element));clearInterval(this.onChangeInterval);this.currentValue=b;this.selectedIndex=-1;if(a.triggerSelectOnValidInput&&(b=this.findSuggestionIndex(c),-1!==b)){this.select(b);return}c.length<a.minChars?this.hide():this.getSuggestions(c)},findSuggestionIndex:function(a){var b=-1,c=a.toLowerCase();d.each(this.suggestions,function(a,d){if(d.value.toLowerCase()===c)return b=
a,!1});return b},getQuery:function(a){var b=this.options.delimiter;if(!b)return a;a=a.split(b);return d.trim(a[a.length-1])},getSuggestionsLocal:function(a){var b=this.options,c=a.toLowerCase(),e=b.lookupFilter,f=parseInt(b.lookupLimit,10),b={suggestions:d.grep(b.lookup,function(b){return e(b,a,c)})};f&&b.suggestions.length>f&&(b.suggestions=b.suggestions.slice(0,f));return b},getSuggestions:function(a){var b,c=this,e=c.options,f=e.serviceUrl,l,g;e.params[e.paramName]=a;l=e.ignoreParams?null:e.params;
c.isLocal?b=c.getSuggestionsLocal(a):(d.isFunction(f)&&(f=f.call(c.element,a)),g=f+"?"+d.param(l||{}),b=c.cachedResponse[g]);b&&d.isArray(b.suggestions)?(c.suggestions=b.suggestions,c.suggest()):c.isBadQuery(a)||!1===e.onSearchStart.call(c.element,e.params)||(c.currentRequest&&c.currentRequest.abort(),c.currentRequest=d.ajax({url:f,data:l,type:e.type,dataType:e.dataType}).done(function(b){c.currentRequest=null;c.processResponse(b,a,g);e.onSearchComplete.call(c.element,a)}).fail(function(b,d,f){e.onSearchError.call(c.element,
a,b,d,f)}))},isBadQuery:function(a){for(var b=this.badQueries,c=b.length;c--;)if(0===a.indexOf(b[c]))return!0;return!1},hide:function(){this.visible=!1;this.selectedIndex=-1;d(this.suggestionsContainer).hide();this.signalHint(null)},suggest:function(){if(0===this.suggestions.length)this.hide();else{var a=this.options,b=a.formatResult,c=this.getQuery(this.currentValue),e=this.classes.suggestion,f=this.classes.selected,g=d(this.suggestionsContainer),k=a.beforeRender,m="",h;if(a.triggerSelectOnValidInput&&
(h=this.findSuggestionIndex(c),-1!==h)){this.select(h);return}d.each(this.suggestions,function(a,d){m+='<div class="'+e+'" data-index="'+a+'">'+b(d,c)+"</div>"});"auto"===a.width&&(h=this.el.outerWidth()-2,g.width(0<h?h:300));g.html(m);a.autoSelectFirst&&(this.selectedIndex=0,g.children().first().addClass(f));d.isFunction(k)&&k.call(this.element,g);g.show();this.visible=!0;this.findBestHint()}},findBestHint:function(){var a=this.el.val().toLowerCase(),b=null;a&&(d.each(this.suggestions,function(c,
d){var f=0===d.value.toLowerCase().indexOf(a);f&&(b=d);return!f}),this.signalHint(b))},signalHint:function(a){var b="";a&&(b=this.currentValue+a.value.substr(this.currentValue.length));this.hintValue!==b&&(this.hintValue=b,this.hint=a,(this.options.onHint||d.noop)(b))},verifySuggestionsFormat:function(a){return a.length&&"string"===typeof a[0]?d.map(a,function(a){return{value:a,data:null}}):a},processResponse:function(a,b,c){var d=this.options;a=d.transformResult(a,b);a.suggestions=this.verifySuggestionsFormat(a.suggestions);
d.noCache||(this.cachedResponse[c]=a,0===a.suggestions.length&&this.badQueries.push(c));b===this.getQuery(this.currentValue)&&(this.suggestions=a.suggestions,this.suggest())},activate:function(a){var b=this.classes.selected,c=d(this.suggestionsContainer),e=c.children();c.children("."+b).removeClass(b);this.selectedIndex=a;return-1!==this.selectedIndex&&e.length>this.selectedIndex?(a=e.get(this.selectedIndex),d(a).addClass(b),a):null},selectHint:function(){var a=d.inArray(this.hint,this.suggestions);
this.select(a)},select:function(a){this.hide();this.onSelect(a)},moveUp:function(){-1!==this.selectedIndex&&(0===this.selectedIndex?(d(this.suggestionsContainer).children().first().removeClass(this.classes.selected),this.selectedIndex=-1,this.el.val(this.currentValue),this.findBestHint()):this.adjustScroll(this.selectedIndex-1))},moveDown:function(){this.selectedIndex!==this.suggestions.length-1&&this.adjustScroll(this.selectedIndex+1)},adjustScroll:function(a){var b=this.activate(a),c,e;b&&(b=b.offsetTop,
c=d(this.suggestionsContainer).scrollTop(),e=c+this.options.maxHeight-25,b<c?d(this.suggestionsContainer).scrollTop(b):b>e&&d(this.suggestionsContainer).scrollTop(b-this.options.maxHeight+25),this.el.val(this.getValue(this.suggestions[a].value)),this.signalHint(null))},onSelect:function(a){var b=this.options.onSelect;a=this.suggestions[a];this.currentValue=this.getValue(a.value);this.el.val(this.currentValue);this.signalHint(null);this.suggestions=[];this.selection=a;d.isFunction(b)&&b.call(this.element,
a)},getValue:function(a){var b=this.options.delimiter,c;if(!b)return a;c=this.currentValue;b=c.split(b);return 1===b.length?a:c.substr(0,c.length-b[b.length-1].length)+a},dispose:function(){this.el.off(".autocomplete").removeData("autocomplete");this.disableKillerFn();d(window).off("resize.autocomplete",this.fixPositionCapture);d(this.suggestionsContainer).remove()}};d.fn.autocomplete=function(a,b){return 0===arguments.length?this.first().data("autocomplete"):this.each(function(){var c=d(this),e=
c.data("autocomplete");if("string"===typeof a){if(e&&"function"===typeof e[a])e[a](b)}else e&&e.dispose&&e.dispose(),e=new g(this,a),c.data("autocomplete",e)})}});


// Search
$(document).ready(function(){ type = $('#search form').attr('action');initSearch() });
function initSearch() {
    if (type == "products") {
        $(".newsearch").autocomplete({
            serviceUrl: 'ajax/search_products.php',
            minChars: 1,
            noCache: false,
            onSelect: function(suggestion) {
            	$(".newsearch").val(suggestion.value);
                $(".newsearch").closest('form').submit();
            },
            formatResult: function(suggestion, currentValue) {
                var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
                var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
                return (suggestion.data.image ? "<span class='sugimage'><img align=absmiddle src='" + suggestion.data.image + "'></span> " : '') + suggestion.value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>');
            }
        });
    }
}
// Features m
var ajax_process_m = false;
$(function() {
    $(document).on("click", '#features input[type="checkbox"]', function(event) {
        ajax_filter_m(event.target);
    });
    $(document).on("change", '#features input[type="text"]', function() {
        ajax_filter_m();
    });
});

function ajax_filter_m(event) {
    if (!ajax_process_m) {
        ajax_process_m = true;
        $('#features').css('opacity', '0.5');
        filter_form = $('#features form');
        price_min = filter_form.find('#minCurrm');
        price_max = filter_form.find('#maxCurrm');
        url = current_url + '?aj_mf=true';
        params = '&';
        inputs = filter_form.find('input[type="checkbox"]:checked');
        inputs.each(function() {
            params += $(this).attr('name') + "=" + encodeURIComponent($(this).val()) + "&";
        });
        diaps = filter_form.find('input.diaps');
        diaps.each(function() {
            params += $(this).attr('name') + "=" + encodeURIComponent($(this).val()) + "&";
        });
        if (!$(price_min).is(":disabled")) params += 'minCurr=' + encodeURIComponent(price_min.val()) + "&";
        if (!$(price_max).is(":disabled")) params += 'maxCurr=' + encodeURIComponent(price_max.val()) + "&";
        url += params;
        $.ajaxPrefilter(function(options, originalOptions, jqXHR) {
            options.async = true;
        });
        $.ajax({
            url: url,
            dataType: 'json',
            success: function(data) {
                if (data.filter_block) {
                    $('#features').html(data.filter_block);
                    ajax_process_m = false;
                    $('#features').css('opacity', '1');
                    var active_feature = $(event).closest('.feature_values').attr('data-f');
                    $('.feature_values[data-f=' + active_feature + ']').after($('.prods_num_flag'));
                }
            },
            error: function(jqXHR, exception) {
                ajax_process_m = false;
                $('#features').css('opacity', '1');
            }
        });
    }
}
// Features c
var ajax_process = false;
$(function() {
    $(document).on("click", '#cfeatures input[type="checkbox"]', function() {
        //ajax_filter();
        //alert("AAA")
        $(this).closest('form').submit();
    });
    $(document).on("change", '#cfeatures input[type="text"]', function() {
        //ajax_filter();
        $(this).closest('form').submit();
    });
});

function ajax_filter() {
$('#cfeatures form').submit();
    /*if (!ajax_process) {
        ajax_process = true;
        $('#cfeatures').css('opacity', '0.5');
        filter_form = $('#cfeatures form');
        price_min = filter_form.find('#minCurr');
        price_max = filter_form.find('#maxCurr');
        url = current_url + '?aj_f=true';
        params = '&';
        inputs = filter_form.find('input[type="checkbox"]:checked');
        inputs.each(function() {
            params += $(this).attr('name') + "=" + encodeURIComponent($(this).val()) + "&";
        });
        diaps = filter_form.find('input.diaps');
        diaps.each(function() {
            params += $(this).attr('name') + "=" + encodeURIComponent($(this).val()) + "&";
        });
        if (!$(price_min).is(":disabled")) params += 'minCurr=' + encodeURIComponent(price_min.val()) + "&";
        if (!$(price_max).is(":disabled")) params += 'maxCurr=' + encodeURIComponent(price_max.val()) + "&";
        url += params;
        $.ajaxPrefilter(function(options, originalOptions, jqXHR) {
            options.async = true;
        });
        $.ajax({
            url: url,
            dataType: 'json',
            success: function(data) {
                if (data.filter_block) {
                    $('#cfeatures').html(data.filter_block);
                    ajax_process = false;
                    $('#cfeatures').css('opacity', '1');
                }
            },
            error: function(jqXHR, exception) {
                ajax_process = false;
                $('#cfeatures').css('opacity', '1');
            }
        });
    }*/
}